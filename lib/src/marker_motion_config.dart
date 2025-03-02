import 'package:flutter/material.dart';
import 'package:marker_motion/marker_motion.dart';

class MarkerMotionConfig {
  const MarkerMotionConfig({
    this.implementation = MotionImplementation.animation,
    this.duration = const Duration(milliseconds: 3200),
    this.animationCurve = Curves.linear,
    this.frameRate = 60,
  }) : assert(
         implementation == MotionImplementation.timer || frameRate == 60,
         'frameRate should only be set when using MotionImplementation.timer',
       ),
       assert(
         implementation == MotionImplementation.animation ||
             animationCurve == Curves.linear,
         'animationCurve should only be set when using MotionImplementation.animation',
       );

  /// The implementation the widget should use for animating markers.
  ///
  /// Defaults to [MotionImplementation.animation] which uses an [AnimationController]
  /// and can be set to [MotionImplementation.timer] to switch to using a [Timer]
  /// object for animating markers.
  final MotionImplementation implementation;

  /// The duration of the marker movement animation.
  ///
  /// Defaults to 3200 milliseconds (3.2 seconds). Adjust this to control how long the
  /// animation takes to complete.
  final Duration duration;

  /// The animation curve applied to marker movements.
  ///
  /// Defaults to [Curves.linear] for a constant speed. Use other curves (e.g.,
  /// [Curves.easeInOut]) for different animation effects.
  final Curve animationCurve;

  /// The target frame rate for the timer-based animation, in frames per second (FPS).
  ///
  /// This determines how frequently the marker positions are updated during the animation.
  /// A higher frame rate results in smoother motion but may increase performance overhead.
  /// For example, a value of 60 FPS updates the animation roughly every 16.67 milliseconds.
  /// The default is 60 FPS, which balances smoothness and efficiency for most use cases.
  ///
  /// Must be a positive integer greater than 0.
  final int frameRate;
}
