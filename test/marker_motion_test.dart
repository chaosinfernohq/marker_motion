import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:marker_motion/marker_motion.dart';

void main() {
  group('MarkerMotionAnimation tests', () {
    testWidgets('Initializes with single marker', (tester) async {
      final motionMarkers = {
        Marker(markerId: MarkerId('1'), position: LatLng(37.7749, -122.4194)),
      };

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MarkerMotion(
              markers: motionMarkers,
              builder: (markers) {
                expect(markers.length, 1);
                expect(markers.first.markerId, motionMarkers.first.markerId);
                expect(markers.first.position, motionMarkers.first.position);

                return SizedBox();
              },
            ),
          ),
        ),
      );

      await tester.pump();
    });

    testWidgets('Initializes with multiple markers', (tester) async {
      final motionMarkers = {
        Marker(markerId: MarkerId('1'), position: LatLng(37.7749, -122.4194)),
        Marker(markerId: MarkerId('2'), position: LatLng(48.1928, 122.8372)),
      };

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MarkerMotion(
              markers: motionMarkers,
              builder: (markers) {
                expect(markers.length, 2);
                expect(markers.first.markerId, motionMarkers.first.markerId);
                expect(markers.first.position, motionMarkers.first.position);
                expect(markers.last.markerId, motionMarkers.last.markerId);
                expect(markers.last.position, motionMarkers.last.position);

                return SizedBox();
              },
            ),
          ),
        ),
      );

      await tester.pump();
    });

    testWidgets('Markers are successfully animated', (tester) async {
      final initialMarkers = {
        Marker(markerId: MarkerId('1'), position: LatLng(37.7749, -122.4194)),
      };

      late Set<Marker> animatedMarkers;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MarkerMotion(
              markers: initialMarkers,
              builder: (markers) {
                animatedMarkers = markers;
                return Container();
              },
            ),
          ),
        ),
      );

      final updatedMarkers = {
        Marker(markerId: MarkerId('1'), position: LatLng(37.9301, -122.4000)),
      };

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MarkerMotion(
              markers: updatedMarkers,
              builder: (markers) {
                animatedMarkers = markers;
                return Container();
              },
            ),
          ),
        ),
      );

      await tester.pump(const Duration(milliseconds: 1600));
      expect(
        animatedMarkers.first.position.latitude,
        isNot(equals(initialMarkers.first.position.latitude)),
      );
      expect(
        animatedMarkers.first.position.latitude,
        isNot(equals(updatedMarkers.first.position.latitude)),
      );

      await tester.pumpAndSettle();
      expect(animatedMarkers.first.position, updatedMarkers.first.position);
    });
  });

  group('MarkerMotionTimer tests', () {
    testWidgets('Initializes with single marker', (tester) async {
      final motionMarkers = {
        Marker(markerId: MarkerId('1'), position: LatLng(37.7749, -122.4194)),
      };

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MarkerMotion(
              markers: motionMarkers,
              config: MarkerMotionConfig(
                implementation: MotionImplementation.timer,
              ),
              builder: (markers) {
                expect(markers.length, 1);
                expect(markers.first.markerId, motionMarkers.first.markerId);
                expect(markers.first.position, motionMarkers.first.position);

                return SizedBox();
              },
            ),
          ),
        ),
      );

      await tester.pump();
    });

    testWidgets('Initializes with multiple markers', (tester) async {
      final motionMarkers = {
        Marker(markerId: MarkerId('1'), position: LatLng(37.7749, -122.4194)),
        Marker(markerId: MarkerId('2'), position: LatLng(48.1928, 122.8372)),
      };

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MarkerMotion(
              markers: motionMarkers,
              config: MarkerMotionConfig(
                implementation: MotionImplementation.timer,
              ),
              builder: (markers) {
                expect(markers.length, 2);
                expect(markers.first.markerId, motionMarkers.first.markerId);
                expect(markers.first.position, motionMarkers.first.position);
                expect(markers.last.markerId, motionMarkers.last.markerId);
                expect(markers.last.position, motionMarkers.last.position);

                return SizedBox();
              },
            ),
          ),
        ),
      );

      await tester.pump();
    });

    testWidgets('Markers are successfully animated with timer', (tester) async {
      final initialMarkers = {
        Marker(
          markerId: const MarkerId('1'),
          position: const LatLng(37.7749, -122.4194),
        ),
      };

      late Set<Marker> animatedMarkers;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MarkerMotion(
              markers: initialMarkers,
              config: MarkerMotionConfig(
                implementation: MotionImplementation.timer,
                duration: const Duration(milliseconds: 3200),
              ),
              builder: (markers) {
                animatedMarkers = markers;
                return Container();
              },
            ),
          ),
        ),
      );

      final updatedMarkers = {
        Marker(
          markerId: const MarkerId('1'),
          position: const LatLng(37.9301, -122.4000),
        ),
      };

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MarkerMotion(
              markers: updatedMarkers,
              config: MarkerMotionConfig(
                implementation: MotionImplementation.timer,
                duration: const Duration(milliseconds: 3200),
              ),
              builder: (markers) {
                animatedMarkers = markers;
                return Container();
              },
            ),
          ),
        ),
      );

      // Simulate timer ticks incrementally
      const tickInterval = Duration(milliseconds: 16);
      const halfDuration = Duration(milliseconds: 1600);
      const fullDuration = Duration(milliseconds: 3200);

      // Pump to halfway point
      for (
        var elapsed = Duration.zero;
        elapsed < halfDuration;
        elapsed += tickInterval
      ) {
        await tester.pump(tickInterval);
      }
      expect(
        animatedMarkers.first.position.latitude,
        isNot(initialMarkers.first.position.latitude),
        reason: 'Marker should have moved from initial position',
      );
      expect(
        animatedMarkers.first.position.latitude,
        isNot(updatedMarkers.first.position.latitude),
        reason: 'Marker should not yet be at target position',
      );

      // Pump to completion
      for (
        var elapsed = halfDuration;
        elapsed <= fullDuration;
        elapsed += tickInterval
      ) {
        await tester.pump(tickInterval);
      }
      // Add extra pump to ensure final state settles
      await tester.pump(const Duration(milliseconds: 100));

      expect(
        animatedMarkers.first.position,
        updatedMarkers.first.position,
        reason: 'Marker should be at target position after animation completes',
      );
    });
  });
}
