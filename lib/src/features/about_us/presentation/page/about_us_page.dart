import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../app_localization/l10n.dart';

class AboutUsPage extends StatefulWidget {
  const AboutUsPage({super.key});

  @override
  State<AboutUsPage> createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(l10n.aboutUs),
          elevation: 5,
        ),
        body: const Column(
          // mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                  'A real-time GPS tracking app designed to monitor school buses, ensuring accurate location updates and enhancing student transportation safety and efficiency.'),
            ),
          ],
        ));
  }
}
