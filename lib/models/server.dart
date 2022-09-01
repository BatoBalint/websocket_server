import 'dart:io';

class Server {
  final ip = InternetAddress.anyIPv4;
  final port = 3000;
  Function write;
  late ServerSocket server;
  bool serverIsRunning = false;

  Server({required this.write});

  Future<void> start() async {
    if (!serverIsRunning) {
      server = await ServerSocket.bind(ip, port);
      server.listen(handleConnection);
      serverIsRunning = true;

      final n = await NetworkInterface.list();

      write(
          'Server started on: ${n.toList()[0].addresses.first.address}:$port');
    }
  }

  void close() {
    if (serverIsRunning) {
      server.close();
      serverIsRunning = false;

      write('Server closed.');
    }
  }

  List<Socket> clients = [];

  void handleConnection(Socket client) {
    client.listen(
      (data) {
        final message = String.fromCharCodes(data);

        List<String> args = message.split(':');

        if (args.length > 1) {
          switch (args[0]) {
            case 'color':
              client.write(args[1]);
              write('Message (${args[1]}) sent');
              break;
            default:
              write(
                  'New client joined. (${client.remoteAddress.address}:${client.remotePort}) Sent data: $message');
              break;
          }
        } else {
          write('Sent data: $message');
        }
        clients.add(client);
      },
      onDone: () {
        client.close();
        clients.remove(client);
      },
      onError: (error) {
        client.close();
        write('${client.remotePort} closed.');
        clients.remove(client);
      },
    );
  }
}
