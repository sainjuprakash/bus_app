import 'package:bus_app/app_localization/l10n.dart';
import 'package:bus_app/src/features/map_page/data/repository/map_page_repository_impl.dart';
import 'package:bus_app/src/features/map_page/presentation/pages/map_page.dart';
import 'package:bus_app/src/features/home_page/presentation/page/home_page.dart';
import 'package:bus_app/src/features/profile/presentation/page/profile_page.dart';
import 'package:flutter/material.dart';

import 'core/service/shared_preference_service.dart';

class NavPage extends StatefulWidget {
  NavPage({super.key});

  @override
  State<NavPage> createState() => _NavPageState();
}

class _NavPageState extends State<NavPage> {
  int _selectedIndex = 1;
  bool isTracking = false;
  @override
  void initState() {
    super.initState();
    getDataFromSharedPrefs();
  }

  Future<void> getDataFromSharedPrefs() async {
    final _prefs = await PrefsService.getInstance();
    isTracking = _prefs.getBool(PrefsServiceKeys.isTracking)!;
    print('---------------------------------');
    print(isTracking);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _widgetOptions = <Widget>[
      const HomePage(),
      MapPage(
        mapRepository: MapRepositoryImpl(),
      ),
      const ProfilePage(),
    ];

    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      // Conditionally show/hide the BottomNavigationBar
      bottomNavigationBar: isTracking
          ? null // Hide the bottom navigation bar when isTracking is true
          : BottomNavigationBar(
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: const Icon(Icons.home),
                  label: l10n.home,
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.map_rounded),
                  label: l10n.maps,
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.person),
                  label: l10n.profile,
                ),
              ],
              currentIndex: _selectedIndex,
              selectedItemColor: Colors.blue,
              onTap: _onItemTapped,
              backgroundColor: Theme.of(context).colorScheme.primary,
              elevation: 10,
            ),
    );
  }
}
