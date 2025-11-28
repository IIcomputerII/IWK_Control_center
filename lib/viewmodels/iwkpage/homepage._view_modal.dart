import 'package:dart_amqp/dart_amqp.dart';
import 'package:flutter/foundation.dart';
import 'package:stacked/stacked.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../app/app.locator.dart';
import '../../services/mqtt_sevice.dart';
import '../../model/iwk_data_models.dart';

class HomePageViewModel extends BaseViewModel {
  final _brokerService = locator<MQTTService>();

  // Current device GUID for filtering
  String? _deviceGuid;
  String? get deviceGuid => _deviceGuid;

  // Latest parsed data
  HomeData? _currentData;
  HomeData? get currentData => _currentData;

  // Device Name (Topic)
  String _deviceName = 'Home Automation';
  String get deviceName => _deviceName;

  // Log Feed
  final List<String> _logs = [];
  List<String> get logs => _logs;

  // Status Indicators
  bool _isBrokerConnected = false;
  bool get isBrokerConnected => _isBrokerConnected;

  bool _isDeviceOnline = false;
  bool get isDeviceOnline => _isDeviceOnline;

  // Power Meter Getters (from parsed data)
  String get voltage => _currentData?.voltage ?? '0';
  String get current => _currentData?.current ?? '0';
  String get power => _currentData?.power ?? '0';
  String get energy => _currentData?.energy ?? '0';
  String get frequency => _currentData?.frequency ?? '50';

  // Control States (Local source of truth)
  // NOTE: Based on old app - 0 = ON, 1 = OFF (inverted from boolean logic)
  String _saklarStatus = '1'; // Initial: OFF
  String _stekerStatus = '1'; // Initial: OFF

  bool get isSaklarOn => _saklarStatus == '0'; // 0 = ON
  bool get isStekerOn => _stekerStatus == '0'; // 0 = ON

  // Last Update
  DateTime? _lastUpdate;
  String get lastUpdate => _lastUpdate != null
      ? '${_lastUpdate!.hour}:${_lastUpdate!.minute}:${_lastUpdate!.second}'
      : 'Never';

  Consumer? _sensorConsumer;
  Consumer? _logConsumer;
  String? _sensorTopicName; // Store sensor topic for publishing

  void init(String? guid, String? topic) async {
    debugPrint('[HOME] 🏠 Init called');
    debugPrint('[HOME] GUID: $guid');
    debugPrint('[HOME] Topic param: $topic');

    if (guid == null) {
      debugPrint('[HOME] ❌ GUID is null, skipping subscription');
      return;
    }

    _deviceGuid = guid;

    // Load saved state
    await _loadSavedState();

    // Parse combined topics (format: "sensorTopic|logTopic")
    String sensorTopic = 'Sensor'; // Default
    String logTopic = 'Log'; // Default

    if (topic != null && topic.contains('|')) {
      final parts = topic.split('|');
      if (parts.length == 2) {
        sensorTopic = parts[0].trim();
        logTopic = parts[1].trim();
        _deviceName =
            sensorTopic; // Use sensor topic as device name for display
      }
    }

    _sensorTopicName = sensorTopic; // Store for later use in publish

    debugPrint('[HOME] 📡 Sensor Topic: $sensorTopic');
    debugPrint('[HOME] 📡 Log Topic: $logTopic');

    _isBrokerConnected = true;
    notifyListeners();

    try {
      // Subscribe to sensor queue (user input Queue Topic 1)
      debugPrint('[HOME] 📡 Subscribing to SENSOR: $sensorTopic');
      _sensorConsumer = await _brokerService.subscribe(sensorTopic);
      debugPrint('[HOME] ✅ Subscribed to SENSOR successfully');

      _sensorConsumer!.listen((AmqpMessage message) {
        final payload = message.payloadAsString;
        debugPrint('[HOME] 📨 SENSOR message received: $payload');

        // Check if it's sensor data or control status
        final parts = payload.split('#');

        if (parts.length == 2) {
          // Control status format: GUID#STATUS (e.g., "12345#01")
          debugPrint('[HOME] Detected CONTROL STATUS message');
          final controlStatus = HomeData.parseControlStatus(payload);

          // Update control states if GUID matches
          if (controlStatus['guid'] == _deviceGuid) {
            _saklarStatus = controlStatus['saklar'] ?? '1';
            _stekerStatus = controlStatus['steker'] ?? '1';
            _saveState(); // Save new state

            if (_currentData != null) {
              _currentData = _currentData!.copyWith(
                statusSaklar: _saklarStatus,
                statusSteker: _stekerStatus,
              );
            } else {
              // Initialize with default values if no sensor data yet
              final now = DateTime.now();
              _currentData = HomeData(
                date: '${now.day}/${now.month}/${now.year}',
                clock: '${now.hour}:${now.minute}:${now.second}',
                guid: _deviceGuid!,
                voltage: '0',
                current: '0',
                power: '0',
                energy: '0',
                frequency: '50',
                powerFactor: '0',
                statusSaklar: _saklarStatus,
                statusSteker: _stekerStatus,
                deviceId: _deviceGuid!,
              );
            }

            debugPrint(
              '[HOME] Updated control states - Saklar: $_saklarStatus, Steker: $_stekerStatus',
            );
            notifyListeners();
          }
        } else {
          // Sensor data format: GUID#V#C#P#E#F#PF
          final homeData = HomeData.tryParse(payload, _deviceGuid);

          if (homeData != null) {
            // Always overwrite the dummy status in homeData with our local known status
            _currentData = homeData.copyWith(
              statusSaklar: _saklarStatus,
              statusSteker: _stekerStatus,
            );

            _lastUpdate = DateTime.now();
            _isDeviceOnline = true;
            notifyListeners();
            debugPrint('[HOME] ✅ UI updated with sensor data');
            debugPrint(
              '[HOME] Power: ${homeData.power}W, Voltage: ${homeData.voltage}V',
            );
          } else {
            debugPrint(
              '[HOME] ⚠️ Data filtered out (GUID mismatch or parse error)',
            );
          }
        }
      });

      // Subscribe to log queue (user input Queue Topic 2)
      debugPrint('[HOME] 📡 Subscribing to LOG: $logTopic');
      _logConsumer = await _brokerService.subscribe(logTopic);
      debugPrint('[HOME] ✅ Subscribed to LOG successfully');

      _logConsumer!.listen((AmqpMessage message) {
        final payload = message.payloadAsString;
        debugPrint('[HOME] 📨 LOG message received: $payload');

        // Try to parse as sensor data first (Power Meter data might come here)
        final homeData = HomeData.tryParse(payload, _deviceGuid);

        if (homeData != null) {
          // Always overwrite the dummy status in homeData with our local known status
          _currentData = homeData.copyWith(
            statusSaklar: _saklarStatus,
            statusSteker: _stekerStatus,
          );

          _lastUpdate = DateTime.now();
          _isDeviceOnline = true;
          notifyListeners();
          debugPrint('[HOME] ✅ UI updated with sensor data (from LOG topic)');
          debugPrint(
            '[HOME] Power: ${homeData.power}W, Voltage: ${homeData.voltage}V',
          );
        } else {
          // Treat as normal log message
          _logs.insert(
            0,
            '[${DateTime.now().toString().split(' ')[1].split('.')[0]}] $payload',
          );
          if (_logs.length > 50) _logs.removeLast();
          notifyListeners();
        }
      });

      debugPrint('[HOME] ✅ Initialization complete - listening for messages');
    } catch (e) {
      debugPrint('[HOME] ❌ ERROR during subscription: $e');
      _isBrokerConnected = false;
      notifyListeners();
    }
  }

  Future<void> _loadSavedState() async {
    if (_deviceGuid == null) return;
    try {
      final prefs = await SharedPreferences.getInstance();
      _saklarStatus = prefs.getString('${_deviceGuid}_saklar') ?? '1';
      _stekerStatus = prefs.getString('${_deviceGuid}_steker') ?? '1';
      debugPrint(
        '[HOME] 💾 Loaded saved state - Saklar: $_saklarStatus, Steker: $_stekerStatus',
      );
      notifyListeners();
    } catch (e) {
      debugPrint('[HOME] ⚠️ Failed to load saved state: $e');
    }
  }

  Future<void> _saveState() async {
    if (_deviceGuid == null) return;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('${_deviceGuid}_saklar', _saklarStatus);
      await prefs.setString('${_deviceGuid}_steker', _stekerStatus);
      debugPrint('[HOME] 💾 State saved');
    } catch (e) {
      debugPrint('[HOME] ⚠️ Failed to save state: $e');
    }
  }

  // Toggle Saklar - Matches old app format
  // Payload: GUID#SaklarSteker where Saklar=digit[0], Steker=digit[1]
  // Values: 0=ON, 1=OFF
  Future<void> toggleSaklar() async {
    debugPrint('[HOME] 💡 Toggle Saklar clicked');
    debugPrint(
      '[HOME] 🔍 BEFORE - Saklar: $_saklarStatus, Steker: $_stekerStatus',
    );
    final newState = !isSaklarOn;
    debugPrint('[HOME] Target Saklar state: ${newState ? "ON" : "OFF"}');

    // Optimistic Update (0=ON, 1=OFF)
    _saklarStatus = newState ? '0' : '1';
    debugPrint(
      '[HOME] 🔍 AFTER - Saklar: $_saklarStatus, Steker: $_stekerStatus (Steker PRESERVED)',
    );
    _saveState(); // Save new state
    if (_currentData != null) {
      _currentData = _currentData!.copyWith(statusSaklar: _saklarStatus);
      notifyListeners();
    }

    try {
      // Format: GUID#SaklarSteker (matching old app)
      // Example: "12345#01" = Saklar OFF (1), Steker ON (0)
      final payload = '$_deviceGuid#$_saklarStatus$_stekerStatus';

      final topic = _sensorTopicName ?? 'Sensor';
      debugPrint('[HOME] 📤 Publishing to: $topic');
      debugPrint('[HOME] Payload: $payload (GUID#SaklarSteker)');
      debugPrint(
        '[HOME] 📊 Decoding: Saklar=${_saklarStatus == "0" ? "ON" : "OFF"}, Steker=${_stekerStatus == "0" ? "ON" : "OFF"}',
      );

      await _brokerService.publish(topic, payload);
      debugPrint('[HOME] ✅ Published successfully');
      debugPrint('[HOME] ⏳ Waiting for sensor feedback to confirm...');
    } catch (e) {
      debugPrint('[HOME] ❌ ERROR publishing: $e');
      // Revert state on error
      _saklarStatus = !newState ? '0' : '1';
      _saveState();
      if (_currentData != null) {
        _currentData = _currentData!.copyWith(statusSaklar: _saklarStatus);
        notifyListeners();
      }
    }
  }

  // Toggle Steker - Matches old app format
  Future<void> toggleSteker() async {
    debugPrint('[HOME] ⚡ Toggle Steker clicked');
    debugPrint(
      '[HOME] 🔍 BEFORE - Saklar: $_saklarStatus, Steker: $_stekerStatus',
    );
    final newState = !isStekerOn;
    debugPrint('[HOME] Target Steker state: ${newState ? "ON" : "OFF"}');

    // Optimistic Update (0=ON, 1=OFF)
    _stekerStatus = newState ? '0' : '1';
    debugPrint(
      '[HOME] 🔍 AFTER - Saklar: $_saklarStatus (PRESERVED), Steker: $_stekerStatus',
    );
    _saveState(); // Save new state
    if (_currentData != null) {
      _currentData = _currentData!.copyWith(statusSteker: _stekerStatus);
      notifyListeners();
    }

    try {
      // Format: GUID#SaklarSteker (matching old app)
      // Example: "12345#10" = Saklar ON (0), Steker OFF (1)
      final payload = '$_deviceGuid#$_saklarStatus$_stekerStatus';

      final topic = _sensorTopicName ?? 'Sensor';
      debugPrint('[HOME] 📤 Publishing to: $topic');
      debugPrint('[HOME] Payload: $payload (GUID#SaklarSteker)');
      debugPrint(
        '[HOME] 📊 Decoding: Saklar=${_saklarStatus == "0" ? "ON" : "OFF"}, Steker=${_stekerStatus == "0" ? "ON" : "OFF"}',
      );

      await _brokerService.publish(topic, payload);
      debugPrint('[HOME] ✅ Published successfully');
      debugPrint('[HOME] ⏳ Waiting for sensor feedback to confirm...');
    } catch (e) {
      debugPrint('[HOME] ❌ ERROR publishing: $e');
      // Revert state on error
      _stekerStatus = !newState ? '0' : '1';
      _saveState();
      if (_currentData != null) {
        _currentData = _currentData!.copyWith(statusSteker: _stekerStatus);
        notifyListeners();
      }
    }
  }

  @override
  void dispose() {
    debugPrint('[HOME] 🔌 Disposing consumers');
    _sensorConsumer?.cancel();
    _logConsumer?.cancel();
    super.dispose();
  }
}
