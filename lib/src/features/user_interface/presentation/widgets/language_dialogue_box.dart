import 'package:flutter/material.dart';

Future<String?> showLanguageSelectionDialog(
    BuildContext context, String currentLanguage) async {
  String selectedLanguage = currentLanguage;

  return showDialog<String>(
    context: context,
    barrierDismissible: true, // Allow dismissing by tapping outside the dialog
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            title: const Text('Select Language'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  ListTile(
                    title: const Text('English'),
                    trailing: selectedLanguage == 'English'
                        ? const Icon(Icons.check, color: Colors.green)
                        : null,
                    onTap: () {
                      setState(() {
                        selectedLanguage =
                            'English'; // Update selected language
                      });
                    },
                  ),
                  ListTile(
                    title: const Text('Nepali'),
                    trailing: selectedLanguage == 'Nepali'
                        ? const Icon(Icons.check, color: Colors.green)
                        : null,
                    onTap: () {
                      setState(() {
                        selectedLanguage = 'Nepali'; // Update selected language
                      });
                    },
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context)
                      .pop(); // Close dialog without returning a value
                },
              ),
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context)
                      .pop(selectedLanguage); // Return the selected language
                },
              ),
            ],
          );
        },
      );
    },
  );
}
