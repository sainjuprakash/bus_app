import 'package:bus_app/main.dart';
import 'package:bus_app/src/features/login_page/presentation/widgets/languge_constant.dart';
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
                    leading: const Text("🇺🇸"),
                    title: const Text('English'),
                    trailing: selectedLanguage == 'English'
                        ? const Icon(Icons.check, color: Colors.green)
                        : null,
                    onTap: () async {
                      Locale _locale = await setLocale('en');
                      MyApp.setLocale(context, _locale);
                      setState(() {
                        selectedLanguage =
                            'English'; // Update selected language
                      });
                    },
                  ),
                  ListTile(
                    leading: const Text("🇳🇵"),
                    title: const Text('Nepali'),
                    trailing: selectedLanguage == 'Nepali'
                        ? const Icon(Icons.check, color: Colors.green)
                        : null,
                    onTap: () async {
                      Locale _locale = await setLocale('ne');
                      MyApp.setLocale(context, _locale);
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
