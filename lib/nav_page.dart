import 'package:bus_app/socket.dart';
import 'package:bus_app/src/features/map_page/data/repository/map_page_repository_impl.dart';
import 'package:bus_app/src/features/map_page/presentation/pages/map_page.dart';
import 'package:bus_app/src/features/home_page/presentation/page/home_page.dart';
import 'package:bus_app/src/features/profile/presentation/page/profile_page.dart';
import 'package:bus_app/src/map_libre/presentation/map_libre_page.dart';
import 'package:bus_app/src/test_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';

class NavPage extends StatefulWidget {
  const NavPage({super.key});

  @override
  State<NavPage> createState() => _NavPageState();
}

class _NavPageState extends State<NavPage> {
  int _selectedIndex = 2;

  static final List<Widget> _widgetOptions = <Widget>[
    const HomePage(),
    MapPage(
      mapRepository: MapRepositoryImpl(),
    ),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map_rounded),
            label: 'My Map',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
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
