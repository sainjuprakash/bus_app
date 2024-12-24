import 'dart:ui';

import 'package:bus_app/core/theme/theme.dart';
import 'package:bus_app/nav_page.dart';
import 'package:bus_app/src/features/home_page/data/repository/bus_location_repository_impl.dart';
import 'package:bus_app/src/features/login_page/data/repository/login_repository_impl.dart';
import 'package:bus_app/src/features/login_page/presentation/bloc/login_bloc.dart';
import 'package:bus_app/src/features/login_page/presentation/page/login_page.dart';
import 'package:bus_app/src/features/login_page/presentation/widgets/languge_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:workmanager/workmanager.dart';

import 'app_localization/generated/l10n.dart';
import 'core/service/background_service.dart';
import 'core/service/shared_preference_service.dart';

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) {
    return Future.value(true);
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Permission.notification.isDenied.then((value) {
    if (value) {
      Permission.notification.request();
    }
  });
  await initializeService();
  Workmanager().initialize(callbackDispatcher);
  final LifecycleEventHandler lifecycleEventHandler = LifecycleEventHandler(
    detachedCallBack: () async {
      final service = FlutterBackgroundService();
      service.invoke('stopService');
    },
  );

  WidgetsBinding.instance.addObserver(lifecycleEventHandler);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();

  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState? state = context.findRootAncestorStateOfType<_MyAppState>();
    state?.setLocale(newLocale);
  }
}

class _MyAppState extends State<MyApp> {
  bool isUserLoggedIn = false;
  Locale? _locale;

  setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Future<void> didChangeDependencies() async {
    Locale local = await getLocale();
    setLocale(local);
    super.didChangeDependencies();
  }

  checkUser() async {
    final prefs = await PrefsService.getInstance();
    final aToken = prefs.getString(PrefsServiceKeys.accessTokem);

    setState(() {
      if (aToken != null) {
        isUserLoggedIn = aToken.isEmpty ? false : true;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    checkUser();
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => ImplLoginRepository(),
        ),
        RepositoryProvider(
          create: (context) => BusLocationRepositoryImpl(),
        ),
      ],
      child: BlocProvider(
        create: (context) => LoginBloc(
          loginRepository: RepositoryProvider.of<ImplLoginRepository>(context),
        ),
        child: MaterialApp(
          theme: lightMode,
          darkTheme: darkMode,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('ne', ''),
            Locale('en', ''),
          ],
          locale: _locale,
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          home: !isUserLoggedIn ? const LoginPage() : const NavPage(),
        ),
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
