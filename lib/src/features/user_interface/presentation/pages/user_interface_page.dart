import 'package:bus_app/app_localization/l10n.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../core/service/shared_preference_service.dart';
import '../widgets/language_dialogue_box.dart';

class UserInterfacePage extends StatefulWidget {
  const UserInterfacePage({super.key});

  @override
  State<UserInterfacePage> createState() => _UserInterfacePageState();
}

class _UserInterfacePageState extends State<UserInterfacePage> {
  String _selectedLanguage = 'English';

  @override
  void initState() {
    super.initState();
    _loadSelectedLanguage();
  }

  Future<void> _loadSelectedLanguage() async {
    final prefs = await PrefsService.getInstance();
    setState(() {
      _selectedLanguage =
          prefs.getString(PrefsServiceKeys.isEnglishSelected) ?? 'English';
    });
  }

  Future<void> _updateLanguage(String newLanguage) async {
    final prefs = await PrefsService.getInstance();
    await prefs.setString(PrefsServiceKeys.isEnglishSelected, newLanguage);
    setState(() {
      _selectedLanguage = newLanguage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 5,
        title: Text(l10n.userInterface),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 18.0, top: 20),
        child: Column(
          children: [
            InkWell(
              onTap: () async {
                final selectedLang = await showLanguageSelectionDialog(
                    context, _selectedLanguage);
                if (selectedLang != null) {
                  _updateLanguage(selectedLang);
                }
              },
              child: Container(
                height: 70,
                width: double.maxFinite,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 18.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.appLanguage,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(_selectedLanguage),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              height: 70,
              width: double.maxFinite,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.theme,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    const Text('Bright'),
                  ],
                ),
              ),
            ),
            /*   Container(
              height: 70,
              width: double.maxFinite,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
              ),
              child:  Padding(
                padding: EdgeInsets.only(left: 18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.fontSize,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    const Text('Medium'),
                  ],
                ),
              ),
            ),*/
          ],
        ),
      ),
    );
  }
}
