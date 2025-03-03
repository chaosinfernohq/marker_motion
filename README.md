# Marker Motion

A Flutter package for smoothly animating Google Maps markers between positions.

[![Pub Version](https://img.shields.io/pub/v/marker_motion)](https://pub.dev/packages/marker_motion)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)

## Features

- Smooth animation of markers between positions
- Customize the animation duration
- Simple, drop-in API that works with existing Google Maps implementations
- Performance optimized with Flutter's animation system
- Minimal code footprint
- Option to choose between using native flutter animations or a timer based implementation

## Usage

Using MarkerMotion is as simple as wrapping your Google Maps widget with the `MarkerMotion` widget:

```dart
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:marker_motion/marker_motion.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  // Your markers that might change position
  Set<Marker> _markers = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Animated Map Markers')),
      body: MarkerMotion(
        // Pass your markers that may update position
        markers: _markers,
        // Configure the widget using the config object
        config: MarkerMotionConfig(
          // Control animation duration (default: 3200ms)
          duration: Duration(milliseconds: 5100),
        ),
        // Builder receives the animated markers
        builder: (markers) {
            GoogleMap(
              markers: markers,
            );
        }
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _updateMarkerPositions,
        child: Icon(Icons.refresh),
      ),
    );
  }

  void _updateMarkerPositions() {
    // When you update marker positions, they will animate automatically
    setState(() {
      _markers = {
        Marker(
          markerId: MarkerId('marker1'),
          position: LatLng(
            37.42796 + (Random().nextDouble() - 0.5) * 0.01,
            -122.08574 + (Random().nextDouble() - 0.5) * 0.01,
          ),
        ),
        // Add more markers as needed
      };
    });
  }
}
```

## How It Works

The `MarkerMotion` widget keeps track of marker positions between state changes. When a marker's
position changes, it smoothly animates from the old position to the new position using either 
Flutter's animation system or a timer based animation.

Both of the implementations are stateful widgets that use a builder pattern, allowing you to build 
your Google Map widget with the updated marker positions in the builder.

## Customization

Customizing the `MarkerMotion` widget is as simple as passing a `MarkerMotionConfig` object
as a config to the constructor.

```dart
MarkerMotion(
  markers: _markers,
  config: MarkerMotionConfig(),
)
```

The following config options are available:

### Implementation

Choose whether to use a native animation controller based implementation, or to animate
the markers using a dart Timer.

You can set the implementation to either `MotionImplementation.timer` or 
`MotionImplementation.animation` (which is the default).

```dart
MarkerMotion(
  markers: _markers,
  config: MarkerMotionConfig(
    implementation: MotionImplementation.timer,
  ),
)
```

### Duration

Control how long the animation takes. The default is set to `const Duration(milliseconds: 3200)`.

```dart
MarkerMotion(
  markers: _markers,
  config: MarkerMotionConfig(
    duration: const Duration(milliseconds: 2000),
  ),
)
```

### Animation curve

This can only be set if you're using the `MotionImplementation.animation` implementation. This
chooses which curve you'd like to use for the animation. The default is set to `Curves.linear`.

```dart
MarkerMotion(
  markers: _markers,
  config: MarkerMotionConfig(
    animationCurve: Curves.easeInOut,
  ),
)
```

### Frame rate

This can only be set if you're using the `MotionImplementation.timer` implementation. This
sets the frame rate for the animation. The higher the frame rate the more resource intensive
the animation will be, so don't set this too high if you need to support lower powered devices. 
If you're running into performance issues, this would be a good setting to lower. The default 
frame rate is set to `60`.

```dart
MarkerMotion(
  markers: _markers,
  config: MarkerMotionConfig(
    frameRate: 30,
  ),
)
```

## Roadmap

There's no timeline on any of these features, but I'm open to PRs if you want to implement them
yourself. If you have a suggestion of your own, start a new discussion and we'll talk about adding
it.

- Save past marker positions, so that it smoothly animates between coordinates instead of
  immediately jumping from it's current position to the new destination.
- Add support for specifying a polyline that markers should animate along.
- Support animating marker's rotation and not just position.
- Add a threshold option to the config that specifies a minimum distance updated positions must 
  be from their previous ones in order to animate the marker.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.