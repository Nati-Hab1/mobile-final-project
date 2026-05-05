import 'package:flutter/material.dart';

class Accordion extends StatelessWidget {
  final String title;
  final String text;

  const Accordion({
    super.key,
    required this.title,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(
          color: Colors.black,
          width: 2,
        ),
      ),
      child: ExpansionTile(
        title: Text(title),
        trailing: const Icon(Icons.add),
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(text),
          ),
        ],
      ),
    );
  }
}
