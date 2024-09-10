import 'package:bus_app/app_localization/l10n.dart';
import 'package:bus_app/src/features/login_page/presentation/page/login_page.dart';
import 'package:bus_app/src/features/personal_information/presentation/pages/personal_information_page.dart';
import 'package:bus_app/src/features/user_interface/presentation/pages/user_interface_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../core/network/endpoints.dart';
import '../../../../../core/service/shared_preference_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? driverName = '';

  @override
  void initState() {
    super.initState();
    getSharedPrefsData();
  }

  Future<void> getSharedPrefsData() async {
    final prefs = await PrefsService.getInstance();
    setState(() {
      driverName = prefs.getString(PrefsServiceKeys.driverName);
    });
  }

  void logout() async {
    final prefs = await PrefsService.getInstance();
    await prefs.remove(PrefsServiceKeys.accessTokem);
    Endpoints.api_token = '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        title: const Text('My Maps'),
        elevation: 5,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
                left: 20.0, right: 20.00, top: 10.00, bottom: 5),
            child: InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const PersonalInformationPage()));
              },
              child: Container(
                height: 70,
                width: double.maxFinite / 5,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(30)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      const Icon(Icons.supervised_user_circle_outlined),
                      const SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(l10n.myInformation,
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                          Text(driverName!)
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 20.0, right: 20.00, top: 10.00, bottom: 5),
            child: InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const UserInterfacePage()));
              },
              child: Container(
                height: 70,
                width: double.maxFinite / 5,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      const Icon(Icons.color_lens_outlined),
                      const SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(l10n.userInterface,
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                          Text(
                              "${l10n.appLanguage},${l10n.theme},${l10n.fontSize}")
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          /*   Padding(
            padding: const EdgeInsets.only(
                left: 20.0, right: 20.00, top: 10.00, bottom: 5),
            child: InkWell(
              onTap: () {},
              child: Container(
                height: 70,
                width: double.maxFinite / 5,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Icon(Icons.manage_accounts_outlined),
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("User and device identity",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                          Text("Username,phone number,device ID")
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),*/
           Divider(
            color: Theme.of(context).colorScheme.surface, //color of divider
            height: 20, //height spacing of divider
            thickness: 2, //thickness of divider line
            indent: 10, //spacing at the start of divider
            endIndent: 10, //spacing at the end of divider
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 20.0, right: 20.00, top: 10.00, bottom: 5),
            child: Column(
              children: [
                /* InkWell(
                  onTap: () {},
                  child: Container(
                    height: 70,
                    width: double.maxFinite / 5,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          const Icon(Icons.key_outlined),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(l10n.setAdminPassword,
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                ),*/
                InkWell(
                  onTap: () {
                    logout();
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => const LoginPage()),
                        (route) => false);
                  },
                  child: Container(
                    height: 70,
                    width: double.maxFinite / 5,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          const Icon(Icons.logout),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(l10n.logOut,
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
