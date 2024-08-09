import 'package:bus_app/src/features/user_interface/presentation/pages/user_interface_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 5,
        title: const Text('My Maps'),
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
                left: 20.0, right: 20.00, top: 10.00, bottom: 5),
            child: InkWell(
              onTap: () {},
              child: Container(
                height: 70,
                width: double.maxFinite / 5,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(30)),
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Icon(Icons.cloud_outlined),
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Sever",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                          Text("URL,username,password")
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
                Navigator.push(context, MaterialPageRoute(builder: (context) => const UserInterfacePage()));
              },
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
                      Icon(Icons.color_lens_outlined),
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("User interface",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                          Text("App language,theme,font size")
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
          ),
          const Divider(
            color: Colors.black, //color of divider
            height: 20, //height spacing of divider
            thickness: 2, //thickness of divider line
            indent: 10, //spacing at the start of divider
            endIndent: 10, //spacing at the end of divider
          ),
          Padding(
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
                      Icon(Icons.key_outlined),
                      SizedBox(
                        width: 10,
                      ),
                      Text("Set admin password",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
