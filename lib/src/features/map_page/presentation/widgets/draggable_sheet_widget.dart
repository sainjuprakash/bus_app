import 'package:flutter/material.dart';

import 'build_compass.dart';

Widget draggableSheet(double totalDistance, double currentSpeed) {
  return DraggableScrollableSheet(
    initialChildSize: 0.06,
    minChildSize: 0.06,
    maxChildSize: 0.5,
    builder: (context, scrollController) {
      return Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 5,
              spreadRadius: 1,
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 8, bottom: 8),
              height: 8,
              width: MediaQuery.of(context).size.width / 2,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onSurface,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            Expanded(
              child: ListView(
                controller: scrollController,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 60,
                    width: double.maxFinite,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Text(
                              (totalDistance / 1000).toStringAsFixed(2),
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 25),
                            ),
                            const Text('Distance (Km)')
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              (currentSpeed * 3.6).toStringAsFixed(2),
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 25),
                            ),
                            const Text('Speed (Km/Hr)'),
                          ],
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  buildCompass(),
                ],
              ),
            ),
          ],
        ),
      );
    },
  );
}
