import 'package:dart_amqp/dart_amqp.dart';
import 'package:stacked/stacked.dart';
import '../../app/app.locator.dart';
import '../../services/mqtt_sevice.dart';

class EnvPageViewModel extends BaseViewModel {
  final _brokerService = locator<MQTTService>();

  String _data = 'Waiting for data...';
  String get data => _data;

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
      print('[ENV] Init called with null GUID, skipping subscription');
      return;
    }

    final String safeTopic = topic?.isNotEmpty == true ? topic! : 'environment';
    print('[ENV] Initializing with GUID: $guid, Topic: $safeTopic');

    _isBrokerConnected = true;
    notifyListeners();

    try {
      // Subscribe to sensor queue
      final sensorTopic = '$safeTopic.sensor';
      print('[ENV] Subscribing to sensor topic: $sensorTopic');
      _sensorConsumer = await _brokerService.subscribe(sensorTopic);
      print('[ENV] Successfully subscribed to: $sensorTopic');

      _sensorConsumer!.listen((AmqpMessage message) {
        final payload = message.payloadAsString;
        print('[ENV] Received SENSOR message: $payload');

        _data = payload;
        _lastUpdate = DateTime.now();
        _isDeviceOnline = true;
        notifyListeners();
      });

      // Subscribe to log queue
      final logTopic = '$safeTopic.log';
      print('[ENV] Subscribing to log topic: $logTopic');
      _logConsumer = await _brokerService.subscribe(logTopic);
      print('[ENV] Successfully subscribed to: $logTopic');

      _logConsumer!.listen((AmqpMessage message) {
        final payload = message.payloadAsString;
        print('[ENV] Received LOG message: $payload');

        _logs.insert(
          0,
          '[${DateTime.now().toString().split(' ')[1].split('.')[0]}] $payload',
        );
        if (_logs.length > 50) _logs.removeLast();
        notifyListeners();
      });

      print('[ENV] Initialization complete - listening for messages');
    } catch (e) {
      final errorMsg = 'Error subscribing to Environmental topics: $e';
      print('[ENV ERROR] $errorMsg');
      _data = errorMsg;
      _isBrokerConnected = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    print('[ENV] Disposing consumers');
    _sensorConsumer?.cancel();
    _logConsumer?.cancel();
    super.dispose();
  }
}
