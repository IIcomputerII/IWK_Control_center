import 'dart:async';
import 'package:dart_amqp/dart_amqp.dart';
import 'package:flutter/foundation.dart';
import 'package:stacked/stacked.dart';

class MQTTService with ListenableServiceMixin {
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

      // Listen for connection errors to prevent crash
      _client!.errorListener((Object error) {
        debugPrint('[MQTT ERROR] Connection error: $error');
        _status = 'error: $error';
        notifyListeners();
        _scheduleReconnect();
      });

      _channel = await _client!.channel();

      _status = 'connected';
      notifyListeners();

      _reconnectTimer?.cancel();
    } catch (e) {
      _status = 'error: $e';
      notifyListeners();
      _scheduleReconnect();
      // Don't rethrow, just handle it
      debugPrint('[MQTT ERROR] Initial connection failed: $e');
    }
  }

  void _scheduleReconnect() {
    if (_status == 'connected' || _status == 'connecting') return;

    _status = 'reconnecting';
    notifyListeners();

    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(const Duration(seconds: 5), () async {
      try {
        await _attemptConnection();
      } catch (_) {
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

  // Subscribe to queue and bind to MQTT exchange
  // durable: true for persistent queues (commands, important data)
  // durable: false for ephemeral queues (event streams, logs)
  Future<Consumer> subscribe(String queueName, {bool durable = true}) async {
    if (_channel == null) {
      throw Exception(
        'Cannot subscribe to $queueName: Not connected to MQTT broker',
      );
    }

    try {
      // Declare queue with configurable durability
      Queue queue = await _channel!.queue(
        queueName,
        passive: false,
        durable: durable,
      );

      // Convert topic name for AMQP routing: "topic/name" → "topic.name"
      String routingKey = queueName.replaceAll('/', '.');

      // Bind queue to amq.topic exchange (where MQTT messages arrive)
      Exchange exchange = await _channel!.exchange(
        'amq.topic',
        ExchangeType.TOPIC,
        passive: true,
      );
      queue.bind(exchange, routingKey);

      Consumer consumer = await queue.consume();
      return consumer;
    } catch (e) {
      debugPrint('[MQTT ERROR] Failed to subscribe to $queueName: $e');
      rethrow;
    }
  }

  // Publish a message to a queue
  // durable should match the queue's durability setting
  Future<void> publish(
    String queueName,
    String message, {
    bool durable = true,
  }) async {
    if (_channel == null) {
      throw Exception(
        'Cannot publish to $queueName: Not connected to MQTT broker',
      );
    }

    try {
      Queue queue = await _channel!.queue(queueName, durable: durable);
      queue.publish(message);
    } catch (e) {
      debugPrint('[MQTT ERROR] Failed to publish to $queueName: $e');
      rethrow;
    }
  }
}
