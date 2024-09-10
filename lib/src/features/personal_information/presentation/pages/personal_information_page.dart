import 'package:bus_app/app_localization/l10n.dart';
import 'package:bus_app/src/constant/spacing.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../core/service/shared_preference_service.dart';

class PersonalInformationPage extends StatefulWidget {
  const PersonalInformationPage({super.key});

  @override
  State<PersonalInformationPage> createState() =>
      _PersonalInformationPageState();
}

class _PersonalInformationPageState extends State<PersonalInformationPage> {
  String? driverName;
  String? driverEmail;
  int? busId;

  @override
  void initState() {
    super.initState();
    getSharedPrefsData();
  }

  Future<void> getSharedPrefsData() async {
    final prefs = await PrefsService.getInstance();
    setState(() {
      driverName = prefs.getString(PrefsServiceKeys.driverName);
      driverEmail = prefs.getString(PrefsServiceKeys.driverEmail);
      busId = prefs.getInt(PrefsServiceKeys.busId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        title: Text(l10n.myInformation),
        elevation: 5,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0), // Adjust padding as needed
        child: Card(
          elevation: 5,
          color: Theme.of(context)
              .colorScheme
              .onPrimary, // Optional: adds a shadow to the card
          child: Padding(
            padding: const EdgeInsets.all(12.0), // Padding inside the card
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize:
                  MainAxisSize.min, // Makes the column take only required space
              children: [
                Row(
                  children: [
                    Text(
                      '${l10n.busId}   :   ',
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(busId?.toString() ?? '',
                        style: const TextStyle(fontSize: 20)),
                  ],
                ),
                verticalspace(
                  height: 8,
                ), // Space between rows
                Row(
                  children: [
                    Text(
                      '${l10n.driverName}   :   ',
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(driverName ?? '',
                        style: const TextStyle(fontSize: 17)),
                  ],
                ),
                verticalspace(
                  height: 8,
                ), // Space between rows
                Row(
                  children: [
                    Text(
                      '${l10n.driverEmail}   :   ',
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(driverEmail ?? '',
                        style: const TextStyle(fontSize: 17)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
