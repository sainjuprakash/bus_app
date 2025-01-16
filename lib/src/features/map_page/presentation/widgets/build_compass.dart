import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';

Widget buildCompass() {
  return StreamBuilder<CompassEvent>(
    stream: FlutterCompass.events,
    builder: (context, snapshot) {
      if (snapshot.hasError) {
        return Text('Error reading heading: ${snapshot.error}');
      }

      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }

      double? direction = snapshot.data!.heading;

      // if direction is null, then device does not support this sensor
      // show error message
      if (direction == null) {
        return const Center(
          child: Text("Device does not have sensors !"),
        );
      }

      return Material(
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        elevation: 4.0,
        child: Container(
          height: 150,
          width: 150,
          //padding: EdgeInsets.all(16.0),
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
          ),
          child: Transform.rotate(
            angle: (direction * (math.pi / 180) * -1),
            child: Image.asset('assets/icons/compass.jpg'),
          ),
        ),
      );
    },
  );
}
