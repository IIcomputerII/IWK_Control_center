import 'package:dart_amqp/dart_amqp.dart';
import 'package:flutter/foundation.dart';
import 'package:stacked/stacked.dart';
import '../../app/app.locator.dart';
import '../../services/mqtt_sevice.dart';
import '../../model/iwk_data_models.dart';

class GravityViewModel extends BaseViewModel {
  final _brokerService = locator<MQTTService>();

  // Current device GUID for filtering
  String? _deviceGuid;

  // Latest parsed data
  GravityData? _currentData;
  GravityData? get currentData => _currentData;

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
      debugPrint('[GRAVITY] Init called with null GUID, skipping subscription');
      return;
    }

    _deviceGuid = guid;
    final String safeTopic = topic?.isNotEmpty == true ? topic! : 'cog';

    _isBrokerConnected = true;
    notifyListeners();

    try {
      // Subscribe directly to the topic (e.g., "Timbangan")
      // No .sensor or .log suffix to match MQTT broker exactly
      debugPrint('[GRAVITY] Subscribing to topic: $safeTopic');
      _sensorConsumer = await _brokerService.subscribe(safeTopic);

      _sensorConsumer!.listen((AmqpMessage message) {
        final payload = message.payloadAsString;
        debugPrint('[GRAVITY] Received: $payload');

        // Add to logs for display (this is what the View shows)
        _logs.insert(
          0,
          '[${DateTime.now().toString().split(' ')[1].split('.')[0]}] $payload',
        );
        if (_logs.length > 50) _logs.removeLast();

        // Also parse and filter data by GUID for future use
        final gravityData = GravityData.tryParse(payload, _deviceGuid);
        if (gravityData != null) {
          _currentData = gravityData;
          _lastUpdate = DateTime.now();
          _isDeviceOnline = true;
          debugPrint('[GRAVITY] Parsed weight: ${gravityData.weight}');
        } else {
          debugPrint('[GRAVITY] Failed to parse or GUID mismatch');
        }

        notifyListeners();
      });

      debugPrint('[GRAVITY] Subscription successful');
    } catch (e) {
      debugPrint('[GRAVITY ERROR] $e');
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
