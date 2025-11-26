import 'package:dart_amqp/dart_amqp.dart';
import 'package:stacked/stacked.dart';
import '../../app/app.locator.dart';
import '../../services/mqtt_sevice.dart';

class SagaPageViewModel extends BaseViewModel {
  final _brokerService = locator<MQTTService>();

  List<String> _logs = [];
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

  Consumer? _logConsumer;

  Consumer? _eventConsumer;

  void init(String? guid, String? topic) async {
    if (guid == null) return;

    final String safeTopic = topic?.isNotEmpty == true ? topic! : 'smart_saga';

    _isBrokerConnected = true;
    notifyListeners();

    try {
      // Subscribe to event topic
      _eventConsumer = await _brokerService.subscribe('$safeTopic.event');
      _eventConsumer!.listen((AmqpMessage message) {
        _logs.insert(
          0,
          '[EVENT] [${DateTime.now().toString().split(' ')[1].split('.')[0]}] ${message.payloadAsString}',
        );
        if (_logs.length > 50) _logs.removeLast();
        _lastUpdate = DateTime.now();
        _isDeviceOnline = true;
        notifyListeners();
      });

      // Subscribe to log topic
      _logConsumer = await _brokerService.subscribe('$safeTopic.log');
      _logConsumer!.listen((AmqpMessage message) {
        _logs.insert(
          0,
          '[LOG] [${DateTime.now().toString().split(' ')[1].split('.')[0]}] ${message.payloadAsString}',
        );
        if (_logs.length > 50) _logs.removeLast();
        notifyListeners();
      });
    } catch (e) {
      _logs.add('Error subscribing: $e');
      _isBrokerConnected = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _logConsumer?.cancel();
    super.dispose();
  }
}
