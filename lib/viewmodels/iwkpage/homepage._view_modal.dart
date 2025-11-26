import 'package:dart_amqp/dart_amqp.dart';
import 'package:stacked/stacked.dart';
import '../../app/app.locator.dart';
import '../../services/mqtt_sevice.dart';

class HomePageViewModel extends BaseViewModel {
  final _brokerService = locator<MQTTService>();

  String _data = 'Waiting for data...';
  String get data => _data;

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

  // Toggle States
  bool _isSaklarOn = false;
  bool get isSaklarOn => _isSaklarOn;

  bool _isStekerOn = false;
  bool get isStekerOn => _isStekerOn;

  // Last Update
  DateTime? _lastUpdate;
  String get lastUpdate => _lastUpdate != null
      ? '${_lastUpdate!.hour}:${_lastUpdate!.minute}:${_lastUpdate!.second}'
      : 'Never';

  Consumer? _sensorConsumer;
  Consumer? _logConsumer;

  void init(String? guid, String? topic) async {
    if (guid == null) return;

    // Use topic as Device Name
    if (topic != null && topic.isNotEmpty) {
      _deviceName = topic;
    }

    _isBrokerConnected = true;
    notifyListeners();

    try {
      // Subscribe to sensor queue: [DeviceName].sensor
      _sensorConsumer = await _brokerService.subscribe('$_deviceName.sensor');
      _sensorConsumer!.listen((AmqpMessage message) {
        _data = message.payloadAsString;
        _lastUpdate = DateTime.now();
        _isDeviceOnline = true;
        notifyListeners();
      });

      // Subscribe to log queue: [DeviceName].log
      _logConsumer = await _brokerService.subscribe('$_deviceName.log');
      _logConsumer!.listen((AmqpMessage message) {
        _logs.insert(
          0,
          '[${DateTime.now().toString().split(' ')[1].split('.')[0]}] ${message.payloadAsString}',
        );
        if (_logs.length > 50) _logs.removeLast();
        notifyListeners();
      });
    } catch (e) {
      _data = 'Error subscribing: $e';
      _isBrokerConnected = false;
      notifyListeners();
    }
  }

  // Toggle Saklar
  Future<void> toggleSaklar() async {
    _isSaklarOn = !_isSaklarOn;
    notifyListeners();

    try {
      // Publish to [DeviceName].saklar
      // Payload: 1 for ON, 0 for OFF
      final payload = _isSaklarOn ? '1' : '0';
      await _brokerService.publish('$_deviceName.saklar', payload);
    } catch (e) {
      // Revert state on error
      _isSaklarOn = !_isSaklarOn;
      notifyListeners();
    }
  }

  // Toggle Steker
  Future<void> toggleSteker() async {
    _isStekerOn = !_isStekerOn;
    notifyListeners();

    try {
      // Publish to [DeviceName].steker
      // Payload: 1 for ON, 0 for OFF
      final payload = _isStekerOn ? '1' : '0';
      await _brokerService.publish('$_deviceName.steker', payload);
    } catch (e) {
      // Revert state on error
      _isStekerOn = !_isStekerOn;
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
