import 'dart:io';
import 'package:socket_io/socket_io.dart' as socket_io;

class Server {
  Function output;
  int port = 3000;
  String ip = '';
  socket_io.Server io = socket_io.Server();
  bool serverIsRunning = false;

  Server({required this.output}) {
    init();
  }

  init() async {
    var interface = await NetworkInterface.list();
    ip = interface.first.addresses.first.address;
    start();
  }

  start() {
    if (!serverIsRunning) {
      io.on('connection', (client) {
        attachEventListeners(client);
        output('Client joined: ${client.toString()}');
      });
      io.listen(port);
      serverIsRunning = true;
    }
    output('Websocket server started on $ip:$port');
  }

  attachEventListeners(client) {
    client.on('test', (data) {
      client.emit('testBack', data.toString());
    });
    client.on('laute', (data) {
      client.emit('laute', 'HALOOOOOO');
    });
  }

  stop() {
    if (serverIsRunning) {
      io.close();
      output('Server closed');
      serverIsRunning = false;
    }
  }
}
