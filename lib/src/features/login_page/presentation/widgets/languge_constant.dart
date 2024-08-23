import 'dart:ui';

import '../../../../../core/service/shared_preference_service.dart';

const String LANGUAGE_CODE = 'language_code';

const String ENGLISH = 'en';
const String NEPALI = 'ne';

Future<Locale> setLocale(String languageCode) async {
  final prefs = await PrefsService.getInstance();
  await prefs.setString(LANGUAGE_CODE, languageCode);
  return _locale(languageCode);
}

Future<Locale> getLocale() async {
  final prefs = await PrefsService.getInstance();
  String languageCode = prefs.getString(LANGUAGE_CODE) ?? ENGLISH;
  return Locale(languageCode);
}

Locale _locale(String languageCode) {
  switch (languageCode) {
    case ENGLISH:
      return const Locale(ENGLISH, 'en');
    case NEPALI:
      return const Locale(NEPALI, 'ne');
    default:
      return const Locale(ENGLISH, 'en');
  }
}
