import 'package:dart_amqp/dart_amqp.dart';
import 'package:stacked/stacked.dart';
import '../../app/app.locator.dart';
import '../../services/mqtt_sevice.dart';

class WaterPageViewModel extends BaseViewModel {
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
    if (guid == null) return;

    final String safeTopic = topic?.isNotEmpty == true
        ? topic!
        : 'smart_watering';

    _isBrokerConnected = true; // Assume connected if we got here from login
    notifyListeners();

    try {
      // Subscribe to sensor queue
      _sensorConsumer = await _brokerService.subscribe('$safeTopic.sensor');
      _sensorConsumer!.listen((AmqpMessage message) {
        _data = message.payloadAsString;
        _lastUpdate = DateTime.now();
        _isDeviceOnline = true;
        notifyListeners();
      });

      // Subscribe to log queue
      _logConsumer = await _brokerService.subscribe('$safeTopic.log');
      _logConsumer!.listen((AmqpMessage message) {
        _logs.insert(
          0,
          '[${DateTime.now().toString().split(' ')[1].split('.')[0]}] ${message.payloadAsString}',
        );
        if (_logs.length > 50) _logs.removeLast(); // Keep last 50 logs
        notifyListeners();
      });
    } catch (e) {
      _data = 'Error subscribing: $e';
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
