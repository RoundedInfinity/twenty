import 'package:flutter/widgets.dart';
import 'package:twenty/util/blur_transition.dart';

class AnimatedRuleSwitcher extends StatelessWidget {
  const AnimatedRuleSwitcher({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      switchInCurve: Curves.fastEaseInToSlowEaseOut,
      transitionBuilder: (child, animation) {
        final blurAnimation =
            Tween<double>(begin: 1, end: 0).animate(animation);

        final scaleAnimation =
            Tween<double>(begin: 0.8, end: 1).animate(animation);

        return ScaleTransition(
          scale: scaleAnimation,
          child: FadeTransition(
            opacity: animation,
            child: BlurTransition(
              animation: blurAnimation,
              blurStrength: 10,
              child: child,
            ),
          ),
        );
      },
      child: child,
    );
  }
}
