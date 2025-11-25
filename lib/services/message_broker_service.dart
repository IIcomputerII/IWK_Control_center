import 'dart:async';
import 'package:dart_amqp/dart_amqp.dart';
import 'package:stacked/stacked.dart';

class MessageBrokerService with ListenableServiceMixin {
  Client? _client;
  Channel? _channel;

  ConnectionSettings? _lastSettings;
  Timer? _reconnectTimer;

  String _status = 'idle';
  String get status => _status;

  // Connect to RabbitMQ
  Future<void> connect({
    required String host,
    required String user,
    required String password,
    required String vhost,
    int port = 5672,
  }) async {
    _lastSettings = ConnectionSettings(
      host: host,
      authProvider: PlainAuthenticator(user, password),
      virtualHost: vhost,
      port: port,
    );

    await _attemptConnection();
  }

  Future<void> _attemptConnection() async {
    if (_lastSettings == null) return;

    _status = 'connecting';
    notifyListeners();

    try {
      _client = Client(settings: _lastSettings!);
      _channel = await _client!.channel();

      _status = 'connected';
      notifyListeners();

      _reconnectTimer?.cancel();
    } catch (e) {
      _status = 'error: $e';
      notifyListeners();
      _scheduleReconnect();
      rethrow; // Rethrow for the initial caller to know
    }
  }

  void _scheduleReconnect() {
    if (_status == 'connected' || _status == 'connecting') return;

    _status = 'reconnecting';
    notifyListeners();

    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(const Duration(seconds: 5), () async {
      print('Attempting to reconnect...');
      try {
        await _attemptConnection();
      } catch (_) {
        // Ignore error on retry, just schedule next
        _scheduleReconnect();
      }
    });
  }

  Future<void> disconnect() async {
    _reconnectTimer?.cancel();
    await _client?.close();
    _client = null;
    _channel = null;
    _status = 'disconnected';
    notifyListeners();
  }

  // Subscribe to a queue
  Future<Consumer> subscribe(String queueName) async {
    if (_channel == null) throw Exception('Not connected');
    Queue queue = await _channel!.queue(queueName);
    return queue.consume();
  }

  // Publish a message to a queue
  Future<void> publish(String queueName, String message) async {
    if (_channel == null) throw Exception('Not connected');
    Queue queue = await _channel!.queue(queueName);
    queue.publish(message);
  }
}
