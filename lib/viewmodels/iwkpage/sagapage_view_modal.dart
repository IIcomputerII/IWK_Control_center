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

  Consumer? _eventConsumer;

  void init(String? guid, String? topic) async {
    final String safeTopic = topic?.isNotEmpty == true ? topic! : 'smart_saga';

    _isBrokerConnected = true;
    notifyListeners();

    try {
      _eventConsumer = await _brokerService.subscribe(safeTopic);

      _eventConsumer!.listen((AmqpMessage message) {
        final payload = message.payloadAsString;

        _logs.insert(
          0,
          '[${DateTime.now().toString().split(' ')[1].split('.')[0]}] $payload',
        );
        if (_logs.length > 50) _logs.removeLast();

        _lastUpdate = DateTime.now();
        _isDeviceOnline = true;

        notifyListeners();
      });
    } catch (e) {
      final errorMsg = 'Error subscribing to SAGA topic: $e';
      _logs.add(errorMsg);
      _isBrokerConnected = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _eventConsumer?.cancel();
    super.dispose();
  }
}
