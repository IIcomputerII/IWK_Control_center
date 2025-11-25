import 'package:dart_amqp/dart_amqp.dart';

class RmqService{
  late Client client;


  bool checkCredential = false;

  void checkCredentialRmq(String user, String pass, String vHost) async {
    ConnectionSettings settings = ConnectionSettings(
        host: 'rmq2.pptik.id',
        authProvider: PlainAuthenticator(user, pass),
        virtualHost: vHost
    );
    Client client = Client(settings: settings);
    client.channel().then((Channel channel) {
      return channel.queue("Sensor", durable: true);
    }).then((Queue queue){
      client.close();
    });
  }

  void publish(String message, String host, String user, String pass, String vHost, String queues){
      ConnectionSettings settings = ConnectionSettings(
          host: host,
          authProvider: PlainAuthenticator(user, pass),
          virtualHost: vHost
      );
      Client client = Client(settings: settings);
      client.channel().then((Channel channel) {
        print('[RMQ Service] host $host');
        print('[RMQ Service] usernam $user');
        print('[RMQ Service] password $pass');
        print('[RMQ Service] vHost $vHost');
        return channel.queue(queues, durable: true);
      }).then((Queue queue){
        queue.publish(message);
        client.close();
      });
  }

  void subscribe(Function sensor, String host, String user, String pass, String vHost){
    ConnectionSettings settings = ConnectionSettings(
        host: host,
        authProvider: PlainAuthenticator(user, pass),
        virtualHost: vHost
    );
    client = Client(settings: settings);
    //print("Subscribe Data RMQ Success");
    print('baca user RMQ $user');
    client.connect().then((value) {
      print('[Subscribe Data] $settings');
      checkCredential = true;
      // actuator();
      sensor();
    });
  }

  void publishRmq(String message, Client clientRmq, String queues){
    clientRmq.channel().then((Channel channel) {
      return channel.queue(queues, durable: true);
    }).then((Queue queue){
      queue.publish(message);
      print('RMQ Publish $message');
      clientRmq.close();
    });
  }

  void subscribeRmq(Function sensor, Client clientRmq, String host, String user, String pass, String vHost){
    clientRmq.connect().then((value) {
      checkCredential = true;
      print('RMQ Subscribe $value');
      sensor();
    });
  }

  void dataDevice(String queueRmq, Function value){
    client
        .channel()
        .then((Channel channel) => channel.queue(queueRmq, durable: true))
        .then((Queue queue) => queue.consume())
        .then((Consumer consumer) => consumer.listen((AmqpMessage message){
      value(message.payloadAsString);
    }));
  }

  void dataDeviceRmq(Client clientRmq, String queueRmq, Function value){
    clientRmq
        .channel()
        .then((Channel channel) => channel.queue(queueRmq, durable: true))
        .then((Queue queue) => queue.consume())
        .then((Consumer consumer) => consumer.listen((AmqpMessage message){
      value(message.payloadAsString);
      print(message.payloadAsString);
    }));
  }
}