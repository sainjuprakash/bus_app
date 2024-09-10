// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class AppLocalizations {
  AppLocalizations();

  static AppLocalizations? _current;

  static AppLocalizations get current {
    assert(_current != null,
        'No instance of AppLocalizations was loaded. Try to initialize the AppLocalizations delegate before accessing AppLocalizations.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<AppLocalizations> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = AppLocalizations();
      AppLocalizations._current = instance;

      return instance;
    });
  }

  static AppLocalizations of(BuildContext context) {
    final instance = AppLocalizations.maybeOf(context);
    assert(instance != null,
        'No instance of AppLocalizations present in the widget tree. Did you add AppLocalizations.delegate in localizationsDelegates?');
    return instance!;
  }

  static AppLocalizations? maybeOf(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  /// `Bus App`
  String get busApp {
    return Intl.message(
      'Bus App',
      name: 'busApp',
      desc: '',
      args: [],
    );
  }

  /// `Bus No.`
  String get busNo {
    return Intl.message(
      'Bus No.',
      name: 'busNo',
      desc: '',
      args: [],
    );
  }

  /// `Log-In`
  String get login {
    return Intl.message(
      'Log-In',
      name: 'login',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get email {
    return Intl.message(
      'Email',
      name: 'email',
      desc: '',
      args: [],
    );
  }

  /// `Please enter email`
  String get enterEmail {
    return Intl.message(
      'Please enter email',
      name: 'enterEmail',
      desc: '',
      args: [],
    );
  }

  /// `Please enter valid email`
  String get enterValidEmail {
    return Intl.message(
      'Please enter valid email',
      name: 'enterValidEmail',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message(
      'Password',
      name: 'password',
      desc: '',
      args: [],
    );
  }

  /// `Please enter valid password`
  String get enterPassword {
    return Intl.message(
      'Please enter valid password',
      name: 'enterPassword',
      desc: '',
      args: [],
    );
  }

  /// `Server`
  String get server {
    return Intl.message(
      'Server',
      name: 'server',
      desc: '',
      args: [],
    );
  }

  /// `Username`
  String get userName {
    return Intl.message(
      'Username',
      name: 'userName',
      desc: '',
      args: [],
    );
  }

  /// `User Interface`
  String get userInterface {
    return Intl.message(
      'User Interface',
      name: 'userInterface',
      desc: '',
      args: [],
    );
  }

  /// `App Language`
  String get appLanguage {
    return Intl.message(
      'App Language',
      name: 'appLanguage',
      desc: '',
      args: [],
    );
  }

  /// `Theme`
  String get theme {
    return Intl.message(
      'Theme',
      name: 'theme',
      desc: '',
      args: [],
    );
  }

  /// `Font Size`
  String get fontSize {
    return Intl.message(
      'Font Size',
      name: 'fontSize',
      desc: '',
      args: [],
    );
  }

  /// `Set Admin Password`
  String get setAdminPassword {
    return Intl.message(
      'Set Admin Password',
      name: 'setAdminPassword',
      desc: '',
      args: [],
    );
  }

  /// `Log-Out`
  String get logOut {
    return Intl.message(
      'Log-Out',
      name: 'logOut',
      desc: '',
      args: [],
    );
  }

  /// `My Information`
  String get myInformation {
    return Intl.message(
      'My Information',
      name: 'myInformation',
      desc: '',
      args: [],
    );
  }

  /// `Driver Name`
  String get driverName {
    return Intl.message(
      'Driver Name',
      name: 'driverName',
      desc: '',
      args: [],
    );
  }

  /// `Driver Email`
  String get driverEmail {
    return Intl.message(
      'Driver Email',
      name: 'driverEmail',
      desc: '',
      args: [],
    );
  }

  /// `Bus ID`
  String get busId {
    return Intl.message(
      'Bus ID',
      name: 'busId',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ne'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<AppLocalizations> load(Locale locale) => AppLocalizations.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
