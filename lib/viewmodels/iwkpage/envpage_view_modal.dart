import 'package:dart_amqp/dart_amqp.dart';
import 'package:flutter/foundation.dart';
import 'package:stacked/stacked.dart';
import '../../app/app.locator.dart';
import '../../services/mqtt_sevice.dart';
import '../../model/iwk_data_models.dart';

class EnvPageViewModel extends BaseViewModel {
  final _brokerService = locator<MQTTService>();

  // Current device GUID for filtering
  String? _deviceGuid;

  // Latest parsed data
  EnvData? _currentData;
  EnvData? get currentData => _currentData;

  // List of parsed data for history view
  final List<EnvData> _dataList = [];
  List<EnvData> get dataList => _dataList;

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
      debugPrint('[ENV] Init called with null GUID, skipping subscription');
      return;
    }

    _deviceGuid = guid;
    // Use the topic exactly as entered by user
    final String safeTopic = topic?.isNotEmpty == true ? topic! : 'environment';

    debugPrint('[ENV] Init with GUID: $_deviceGuid, Topic: $safeTopic');

    _isBrokerConnected = true;
    notifyListeners();

    try {
      // Subscribe directly to the topic (no .sensor suffix)
      debugPrint('[ENV] Subscribing to: $safeTopic');
      _sensorConsumer = await _brokerService.subscribe(safeTopic);

      _sensorConsumer!.listen((AmqpMessage message) {
        final payload = message.payloadAsString;
        debugPrint('[ENV] Received payload: $payload');

        // Parse and filter data by GUID
        final envData = EnvData.tryParse(payload, _deviceGuid);

        if (envData != null) {
          debugPrint('[ENV] Parsed data successfully: ${envData.temperature}');

          // Add to list (newest first)
          _dataList.insert(0, envData);
          // Keep list size manageable
          if (_dataList.length > 50) _dataList.removeLast();

          _currentData = envData;
          _lastUpdate = DateTime.now();
          _isDeviceOnline = true;
          notifyListeners();
        } else {
          debugPrint('[ENV] Failed to parse data');
        }
      });
    } catch (e) {
      debugPrint('[ENV ERROR] $e');
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
