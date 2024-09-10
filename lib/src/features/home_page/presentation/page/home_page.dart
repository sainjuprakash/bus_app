import 'package:bus_app/app_localization/l10n.dart';
import 'package:bus_app/src/features/individual_bus/presentation/page/individual_bus_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title:  Text(l10n.busApp),
        elevation: 5,
      ),
      body: ListView.builder(
        itemCount: 6,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => IndividualBusPage()));
            },
            child: Card(
              elevation: 3,
              color: Theme.of(context).colorScheme.primary,
              child: Column(
                children: [
                  SizedBox(
                    height: 80,
                    width: double.maxFinite,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(l10n.busNo),
                        ),
                        const Row(
                          children: [],
                        )
                      ],
                    ),
                  ),
                  Container(
                    height: 50,
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                        color:Theme.of(context).colorScheme.onPrimary,
                        borderRadius: BorderRadius.circular(8)),
                    child: const Padding(
                      padding: EdgeInsets.all(15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Row(
                            children: [Icon(Icons.bus_alert), Text('15 stops')],
                          ),
                          Row(
                            children: [
                              Icon(Icons.social_distance_rounded),
                              Text('20 km')
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
