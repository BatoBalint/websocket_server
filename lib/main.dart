import 'package:flutter/material.dart';
import 'package:desktop_window/desktop_window.dart';
import 'package:websocket_server/models/server.dart';
import 'package:websocket_server/widgets/console_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController controller = TextEditingController();
  List<String> messages = [];
  FocusNode fn = FocusNode();
  late Server server;

  @override
  void initState() {
    server = Server(output: (data) {
      setState(() {
        if (data.runtimeType != String) data = data.toString();
        messages.add('[Server] $data');
      });
    });
    windowInit();
    super.initState();
  }

  void windowInit() async {
    await DesktopWindow.setMinWindowSize(const Size(300, 570));
  }

  @override
  void dispose() {
    fn.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ConsoleScreen(messages: messages),
              TextField(
                controller: controller,
                onSubmitted: textSubmitted,
                focusNode: fn,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        server.start();
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(20),
                        primary: Colors.green,
                      ),
                      child: const Text('Start server'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        server.stop();
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(20),
                        primary: Colors.red,
                      ),
                      child: const Text('Stop server'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void textSubmitted(value) {
    if (value.toString().isNotEmpty) {
      if (value == '--clear') {
        setState(() {
          messages.clear();
        });
      } else {
        addToConsoleScreen(value);
      }
      controller.text = '';
    }
    fn.requestFocus();
  }

  void addToConsoleScreen(String text) {
    setState(() {
      messages.add(text);
    });
  }

  void test(value) {
    showDialog(
      context: context,
      builder: ((context) {
        return AlertDialog(
          title: const Text('Test'),
          content: Text(value),
        );
      }),
    );
  }
}
