import 'package:bus_app/nav_page.dart';
import 'package:bus_app/src/features/login_page/data/repository/login_repository_impl.dart';
import 'package:bus_app/src/features/login_page/presentation/bloc/login_bloc.dart';
import 'package:bus_app/src/features/login_page/presentation/page/login_page.dart';
import 'package:bus_app/src/features/login_page/presentation/widgets/languge_constant.dart';
import 'package:bus_app/src/features/map_page/presentation/pages/map_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:workmanager/workmanager.dart';

import 'app_localization/generated/l10n.dart';
import 'core/service/shared_preference_service.dart';

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) {
    return Future.value(true);
  });
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Workmanager().initialize(callbackDispatcher);
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
    return RepositoryProvider(
      create: (context) => ImplLoginRepository(),
      child: BlocProvider(
        create: (context) => LoginBloc(
          loginRepository: RepositoryProvider.of<ImplLoginRepository>(context),
        ),
        child: MaterialApp(
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
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: !isUserLoggedIn ? const LoginPage() : const NavPage(),
        ),
      ),
    );
  }
}
