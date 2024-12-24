import 'package:bus_app/src/features/map_page/data/repository/map_page_repository_impl.dart';
import 'package:bus_app/src/features/map_page/presentation/pages/map_page.dart';
import 'package:bus_app/src/features/home_page/presentation/page/home_page.dart';
import 'package:bus_app/src/features/profile/presentation/page/profile_page.dart';
import 'package:bus_app/src/test_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';

class NavPage extends StatefulWidget {
  const NavPage({super.key});

  @override
  State<NavPage> createState() => _NavPageState();
}

class _NavPageState extends State<NavPage> {
  int _selectedIndex = 1;

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

  final FlutterBackgroundService service = FlutterBackgroundService();

  @override
  void initState() {
    super.initState();

    // Monitor the app lifecycle to stop the service on app termination
    WidgetsBinding.instance.addObserver(LifecycleEventHandler(
      detachedCallBack: () async {
        service.invoke('stopService');
      },
    ));
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
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
    );
  }
}

class LifecycleEventHandler extends WidgetsBindingObserver {
  final Future<void> Function() detachedCallBack;

  LifecycleEventHandler({required this.detachedCallBack});

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.detached) {
      detachedCallBack();
    }
  }
}
