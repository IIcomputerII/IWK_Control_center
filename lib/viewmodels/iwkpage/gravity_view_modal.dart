import 'package:dart_amqp/dart_amqp.dart';
import 'package:stacked/stacked.dart';
import '../../app/app.locator.dart';
import '../../services/mqtt_sevice.dart';

class GravityViewModel extends BaseViewModel {
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
      print('[GRAVITY] Init called with null GUID, skipping subscription');
      return;
    }

    final String safeTopic = topic?.isNotEmpty == true ? topic! : 'cog';
    print('[GRAVITY] Initializing with GUID: $guid, Topic: $safeTopic');

    _isBrokerConnected = true;
    notifyListeners();

    try {
      // Subscribe to sensor queue
      final sensorTopic = '$safeTopic.sensor';
      print('[GRAVITY] Subscribing to sensor topic: $sensorTopic');
      _sensorConsumer = await _brokerService.subscribe(sensorTopic);
      print('[GRAVITY] Successfully subscribed to: $sensorTopic');

      _sensorConsumer!.listen((AmqpMessage message) {
        final payload = message.payloadAsString;
        print('[GRAVITY] Received SENSOR message: $payload');

        _data = payload;
        _lastUpdate = DateTime.now();
        _isDeviceOnline = true;
        notifyListeners();
      });

      // Subscribe to log queue
      final logTopic = '$safeTopic.log';
      print('[GRAVITY] Subscribing to log topic: $logTopic');
      _logConsumer = await _brokerService.subscribe(logTopic);
      print('[GRAVITY] Successfully subscribed to: $logTopic');

      _logConsumer!.listen((AmqpMessage message) {
        final payload = message.payloadAsString;
        print('[GRAVITY] Received LOG message: $payload');

        _logs.insert(
          0,
          '[${DateTime.now().toString().split(' ')[1].split('.')[0]}] $payload',
        );
        if (_logs.length > 50) _logs.removeLast();
        notifyListeners();
      });

      print('[GRAVITY] Initialization complete - listening for messages');
    } catch (e) {
      final errorMsg = 'Error subscribing to Gravity topics: $e';
      print('[GRAVITY ERROR] $errorMsg');
      _data = errorMsg;
      _isBrokerConnected = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    print('[GRAVITY] Disposing consumers');
    _sensorConsumer?.cancel();
    _logConsumer?.cancel();
    super.dispose();
  }
}
