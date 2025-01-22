import 'package:bus_app/app_localization/l10n.dart';
import 'package:bus_app/src/constant/spacing.dart';
import 'package:bus_app/src/features/personal_information/presentation/widgets/parents_location_map_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';

import '../../../../../core/service/shared_preference_service.dart';
import '../../../map_page/data/repository/map_page_repository_impl.dart';

class PersonalInformationPage extends StatefulWidget {
  const PersonalInformationPage({super.key});

  @override
  State<PersonalInformationPage> createState() =>
      _PersonalInformationPageState();
}

class _PersonalInformationPageState extends State<PersonalInformationPage> {
  MapRepositoryImpl mapRepository = MapRepositoryImpl();
  String? driverName;
  String? driverEmail;
  int? busId;
  String? role;
  LocationData? parentsLocation;

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
      role = prefs.getString(PrefsServiceKeys.role);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        title: Text(l10n.myInformation),
        elevation: 5,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0), // Adjust padding as needed
        child: Column(
          children: [
            Card(
              color: Theme.of(context).colorScheme.primary,
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(12.0), // Padding inside the card
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize
                      .min, // Makes the column take only required space
                  children: [
                    Row(
                      children: [
                        Text(
                          '${l10n.id}   :   ',
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
                          '${l10n.name}   :   ',
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
                          '${l10n.email}   :   ',
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
            role == "parents"
                ? Card(
                    color: Theme.of(context).colorScheme.primary,
                    elevation: 5,
                    child: InkWell(
                      onTap: () async {},
                      child: InkWell(
                        onTap: () async {
                          parentsLocation =
                              await mapRepository.getFirstLocation();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ParentsLocationMapPage(
                                      parentsLocation: parentsLocation)));
                        },
                        child: Container(
                          height: 50,
                          width: double.maxFinite,
                          child: const Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Icon(Icons.location_pin),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      'Update my Location',
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
