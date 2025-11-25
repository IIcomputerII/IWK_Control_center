import 'dart:io';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MqttService {
  MqttServerClient? client;
  var pongCount = 0;
  late String _identifier;

  void subscribe(String host, String user, String pass, String vHost, String topic, Function data) async {
    _identifier = '';
    client = MqttServerClient(host, _identifier);
    client!.port = 1883;
    client!.keepAlivePeriod = 20;
    client!.onDisconnected = onDisconnected;
    client!.secure = false;
    client!.logging(on: true);
    client!.onConnected = onConnected;
    client!.onSubscribed = onSubscribed;

    try {
      await client?.connect('$vHost:$user', pass);
      subScribeTo(topic);
      data();
    } on NoConnectionException catch (e) {
      print('EXAMPLE::client exception - $e');
      client!.disconnect();
    } on SocketException catch (e) {
      print('EXAMPLE::socket exception - $e');
      client!.disconnect();
    }
  }

  void subscribeMqtt(MqttServerClient clientMqtt, String host, String user, String pass, String vHost, String topic, Function data) async {
    clientMqtt.port = 1883;
    clientMqtt.keepAlivePeriod = 20;
    clientMqtt.onDisconnected = onDisconnectedMqtt(clientMqtt);
    clientMqtt.secure = false;
    clientMqtt.logging(on: true);
    clientMqtt.onConnected = onConnected;
    clientMqtt.onSubscribed = onSubscribed;

    try {
      await clientMqtt.connect('$vHost:$user', pass);
      subScribeToMqtt(clientMqtt, topic);
      clientMqtt.updates!.listen((List<MqttReceivedMessage<MqttMessage>> c) async {
        final MqttPublishMessage recMess = c[0].payload as MqttPublishMessage;
        final String result = MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
        print("SUBSCRIBE MQTT $result");
        data(result);
      });
      // data();
    } on NoConnectionException catch (e) {
      print('EXAMPLE::client exception - $e');
      clientMqtt.disconnect();
    } on SocketException catch (e) {
      print('EXAMPLE::socket exception - $e');
      clientMqtt.disconnect();
    }
  }

  Future<void> publish(String host, String user, String pass, String vHost, String topic, String data) async {
    _identifier = '';
    client = MqttServerClient(host, _identifier);
    client!.port = 1883;
    client!.keepAlivePeriod = 20;
    client!.onDisconnected = onDisconnected;
    client!.secure = false;
    client!.logging(on: true);
    client!.onConnected = onConnected;

    try {
      await client?.connect('$vHost:$user', pass);
      publishTo(topic, data);
    } on NoConnectionException catch (e) {
      print('EXAMPLE::client exception - $e');
      client?.disconnect();
    } on SocketException catch (e) {
      print('EXAMPLE::socket exception - $e');
      client?.disconnect();
    }
  }

  Future<void> publishMqtt(MqttServerClient clientMqtt, String host, String user, String pass, String vHost, String topic, String data) async {
    clientMqtt.port = 1883;
    clientMqtt.keepAlivePeriod = 20;
    clientMqtt.onDisconnected = onDisconnectedMqtt(clientMqtt);
    clientMqtt.secure = false;
    clientMqtt.logging(on: true);
    clientMqtt.onConnected = onConnected;

    try {
      await clientMqtt.connect('$vHost:$user', pass);
      publishToMqtt(clientMqtt, topic, data);
    } on NoConnectionException catch (e) {
      print('EXAMPLE::client exception - $e');
      clientMqtt.disconnect();
    } on SocketException catch (e) {
      print('EXAMPLE::socket exception - $e');
      clientMqtt.disconnect();
    }
  }


  void onConnected() {
    print('EXAMPLE::OnConnected client callback - Client connection was successful');
  }

  void onSubscribed(String topic) {
    print('EXAMPLE::Subscription confirmed for topic $topic');
  }

  void onDisconnected() {
    if (client!.connectionStatus!.disconnectionOrigin == MqttDisconnectionOrigin.solicited) {
    } else {
      exit(-1);
    }
  }

  onDisconnectedMqtt(MqttServerClient clientMqtt) {
    if (clientMqtt.connectionStatus!.disconnectionOrigin == MqttDisconnectionOrigin.solicited) {
    } else {
      exit(-1);
    }
  }

  void subScribeTo(String topic) {
    client!.subscribe(topic, MqttQos.atLeastOnce);
  }

  void subScribeToMqtt(MqttServerClient clientMqtt, String topic) {
    clientMqtt.subscribe(topic, MqttQos.atLeastOnce);
  }

  void publishTo(String topic, String data) {
    final builder = MqttClientPayloadBuilder();
    builder.addString(data);
    client?.publishMessage(topic, MqttQos.atLeastOnce, builder.payload!);
    print(data);
  }

  void publishToMqtt(MqttServerClient clientMqtt, String topic, String data) {
    final builder = MqttClientPayloadBuilder();
    builder.addString(data);
    clientMqtt.publishMessage(topic, MqttQos.atLeastOnce, builder.payload!);
    print(data);
  }
}
