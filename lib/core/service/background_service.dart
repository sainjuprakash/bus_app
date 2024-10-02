import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';

Future<void> initializeService() async {
  final service = FlutterBackgroundService();
  await service.configure(
    iosConfiguration: IosConfiguration(
      autoStart: true,
      onForeground: onStart,
      onBackground: onIosBackground,
    ),
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      isForegroundMode: true,
    ),
  );
}

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  return true;
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();

  // Handle Android foreground/background state
  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });

    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }

  // Listen for the stop signal
  service.on('stopService').listen((event) {
    service.stopSelf();
  });

  // Set up a periodic timer, but it will only work when app is minimized
  Timer.periodic(const Duration(seconds: 1), (timer) async {
    if (service is AndroidServiceInstance) {
      // Only run in foreground (when app is minimized)
      if (await service.isForegroundService()) {
        // Send notification that service is running in background
        service.setForegroundNotificationInfo(
          title: 'App Running in Background',
          content: 'Your background service is active.',
        );
        // Example: Invoke some background task every second
        service.invoke('update', {
          'current_date': DateTime.now().toIso8601String(),
        });
      } else {
        // If the app is in the foreground (not minimized), stop the service
        timer.cancel(); // Stop the timer when app is back in the foreground
        service.stopSelf();
      }
    }
    //print("Background service is running");
  });
}
