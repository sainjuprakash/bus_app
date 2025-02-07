import 'package:bus_app/src/constant/spacing.dart';
import 'package:flutter/material.dart';

class CustomAlertDialogue extends StatelessWidget {
  final String title;
  final String content;
  final VoidCallback onConfirm;

  const CustomAlertDialogue({
    super.key,
    required this.title,
    required this.content,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            onConfirm();
            Navigator.of(context).pop();
          },
          child: const Text('Confirm'),
        ),
      ],
    );
  }
}
