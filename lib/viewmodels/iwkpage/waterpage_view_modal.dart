import 'package:dart_amqp/dart_amqp.dart';
import 'package:flutter/foundation.dart';
import 'package:stacked/stacked.dart';
import '../../app/app.locator.dart';
import '../../services/mqtt_sevice.dart';
import '../../model/iwk_data_models.dart';

class WaterPageViewModel extends BaseViewModel {
  final _brokerService = locator<MQTTService>();

  // Current device GUID for filtering
  String? _deviceGuid;

  // Latest parsed data (kept for compatibility if needed, but we use list mainly)
  WaterData? _currentData;
  WaterData? get currentData => _currentData;

  // List of parsed data for history view
  final List<WaterData> _dataList = [];
  List<WaterData> get dataList => _dataList;

  // Log Feed
  final List<String> _logs = [];
  List<String> get logs => _logs;

  // Status Indicators
  bool _isBrokerConnected = false;
  bool get isBrokerConnected => _isBrokerConnected;

  bool _isDeviceOnline = false;
  bool get isDeviceOnline => _isDeviceOnline;

  // Last Update
  DateTime? _lastUpdate;
  String get lastUpdate => _lastUpdate != null
      ? '${_lastUpdate!.hour}:${_lastUpdate!.minute}:${_lastUpdate!.second}'
      : 'Never';

  Consumer? _sensorConsumer;
  Consumer? _logConsumer;

  void init(String? guid, String? topic) async {
    if (guid == null) {
      debugPrint('[WATER] Init called with null GUID, skipping subscription');
      return;
    }

    _deviceGuid = guid;
    // Use the topic exactly as entered by user, or default to 'smart_watering'
    final String safeTopic = topic?.isNotEmpty == true
        ? topic!
        : 'smart_watering';

    debugPrint('[WATER] Init with GUID: $_deviceGuid, Topic: $safeTopic');

    _isBrokerConnected = true;
    notifyListeners();

    try {
      // Subscribe directly to the topic (no .sensor suffix)
      debugPrint('[WATER] Subscribing to: $safeTopic');
      _sensorConsumer = await _brokerService.subscribe(safeTopic);

      _sensorConsumer!.listen((AmqpMessage message) {
        final payload = message.payloadAsString;
        debugPrint('[WATER] Received payload: $payload');

        // Parse and filter data by GUID
        final waterData = WaterData.tryParse(payload, _deviceGuid);

        if (waterData != null) {
          debugPrint(
            '[WATER] Parsed data successfully: ${waterData.kelembaban}',
          );

          // Add to list (newest first)
          _dataList.insert(0, waterData);
          // Keep list size manageable
          if (_dataList.length > 50) _dataList.removeLast();

          _currentData = waterData;
          _lastUpdate = DateTime.now();
          _isDeviceOnline = true;
          notifyListeners();
        } else {
          debugPrint('[WATER] Failed to parse data');
        }
      });
    } catch (e) {
      debugPrint('[WATER ERROR] $e');
      _isBrokerConnected = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _sensorConsumer?.cancel();
    _logConsumer?.cancel();
    super.dispose();
  }
}
