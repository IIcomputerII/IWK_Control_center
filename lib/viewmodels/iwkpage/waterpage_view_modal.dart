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

  // Latest parsed data
  WaterData? _currentData;
  WaterData? get currentData => _currentData;

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
    final String safeTopic = topic?.isNotEmpty == true
        ? topic!
        : 'smart_watering';

    _isBrokerConnected = true;
    notifyListeners();

    try {
      // Subscribe to sensor queue
      final sensorTopic = '$safeTopic.sensor';
      _sensorConsumer = await _brokerService.subscribe(sensorTopic);

      _sensorConsumer!.listen((AmqpMessage message) {
        final payload = message.payloadAsString;

        // Parse and filter data by GUID
        final waterData = WaterData.tryParse(payload, _deviceGuid);

        if (waterData != null) {
          _currentData = waterData;
          _lastUpdate = DateTime.now();
          _isDeviceOnline = true;
          notifyListeners();
        }
      });

      // Subscribe to log queue
      final logTopic = '$safeTopic.log';
      _logConsumer = await _brokerService.subscribe(logTopic);

      _logConsumer!.listen((AmqpMessage message) {
        final payload = message.payloadAsString;

        _logs.insert(
          0,
          '[${DateTime.now().toString().split(' ')[1].split('.')[0]}] $payload',
        );
        if (_logs.length > 50) _logs.removeLast();
        notifyListeners();
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
