import 'package:flutter/material.dart';

class ConsoleScreen extends StatefulWidget {
  const ConsoleScreen({Key? key, required this.messages}) : super(key: key);

  final List<String> messages;

  @override
  State<ConsoleScreen> createState() => _ConsoleScreenState();
}

class _ConsoleScreenState extends State<ConsoleScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.black,
      ),
      child: ListView.builder(
        reverse: true,
        itemCount: widget.messages.length,
        itemBuilder: (_, index) {
          return Padding(
            padding: const EdgeInsets.only(left: 8, bottom: 8),
            child: SelectableText(
              widget.messages[widget.messages.length - 1 - index],
              style: const TextStyle(color: Colors.white),
            ),
          );
        },
      ),
    );
  }
}
