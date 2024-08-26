import 'dart:ui';

import 'package:flutter/widgets.dart';

class BlurTransition extends AnimatedWidget {
  const BlurTransition({
    required this.child,
    required this.blurStrength,
    required Animation<double> animation,
  }) : super(key: null, listenable: animation);

  final Widget child;

  final double blurStrength;

  @override
  Widget build(BuildContext context) {
    final animation = listenable as Animation<double>;
    return ImageFiltered(
      imageFilter: ImageFilter.blur(
          sigmaX: animation.value * blurStrength,
          sigmaY: animation.value * blurStrength),
      child: child,
    );
  }
}
