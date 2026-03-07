import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dummyjson/features/compass/provider/kiblah_provider.dart';

class CompassScreen extends ConsumerWidget {
  const CompassScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final direction = ref.watch(directionProvider);
    final headingAsync = ref.watch(headingProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Find Qibla")),
      body: headingAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text("Compass error: $e")),
        data: (headingData) {
          final heading = headingData.heading ?? 0;
          final bearing = direction.bearing ?? 0;

          return _CompassView(
            heading: heading,
            bearing: bearing,
            distance: direction.distance,
          );
        },
      ),
    );
  }
}

class _CompassView extends StatelessWidget {
  final double heading;
  final double bearing;
  final double? distance;

  const _CompassView({
    required this.heading,
    required this.bearing,
    this.distance,
  });

  @override
  Widget build(BuildContext context) {
    const double size = 260;

    final kaabaAngle = (bearing - heading) * pi / 180;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: Stack(
              alignment: Alignment.center,
              children: [
                /// Compass background
                Transform.rotate(
                  angle: -heading * pi / 180,
                  child: Container(
                    width: size,
                    height: size,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(width: 2),
                    ),
                    child: const Stack(
                      alignment: Alignment.center,
                      children: [
                        Positioned(top: 12, child: Text("N", style: TextStyle(fontSize: 20))),
                        Positioned(bottom: 12, child: Text("S", style: TextStyle(fontSize: 20))),
                        Positioned(left: 12, child: Text("W", style: TextStyle(fontSize: 20))),
                        Positioned(right: 12, child: Text("E", style: TextStyle(fontSize: 20))),
                      ],
                    ),
                  ),
                ),

                /// Qibla direction arrow
                Transform.rotate(
                  angle: kaabaAngle,
                  child: const Icon(
                    Icons.location_on,
                    size: 60,
                    color: Colors.green,
                  ),
                ),

                /// Phone direction arrow
                const Icon(
                  Icons.navigation,
                  size: 70,
                  color: Colors.red,
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          Text(
            _getInstruction(heading, bearing),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 10),

          if (distance != null)
            Text(
              "Distance to Qibla: ${(distance! / 1000).toStringAsFixed(2)} km",
              style: const TextStyle(fontSize: 16),
            ),
        ],
      ),
    );
  }

  static String _getInstruction(double heading, double bearing) {
    final diff = (bearing - heading + 360) % 360;

    if (diff < 10 || diff > 350) {
      return "You are facing Qibla";
    } else if (diff < 180) {
      return "Turn right ${diff.toStringAsFixed(0)}°";
    } else {
      return "Turn left ${(360 - diff).toStringAsFixed(0)}°";
    }
  }
}