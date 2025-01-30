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
    return Dialog(
      backgroundColor: Theme.of(context).colorScheme.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              content,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.onSurface,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: const Text("Cancel"),
                ),
                horizontalspace(
                  width: 5,
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.onSurface,
                  ),
                  onPressed: () {
                    onConfirm();
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: const Text("Confirm"),
                ),
                // ElevatedButton(style: ElevatedButton.styleFrom(
                //   backgroundColor: Theme.of(context).colorScheme.onPrimary,
                //   elevation: 5,
                // ),
                //   onPressed: () {
                //     onConfirm();
                //     Navigator.of(context).pop(); // Close the dialog
                //    // Call the confirmation callback
                //   },
                //   child: const Text("Confirm"),
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
