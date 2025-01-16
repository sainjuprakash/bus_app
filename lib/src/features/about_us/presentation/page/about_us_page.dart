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
            Text('This app is build on the date : 2025 Jan 8'),
            Center(child: Text('Version 2.0.0801')),
          ],
        ));
  }
}
