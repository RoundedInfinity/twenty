import 'package:flutter/widgets.dart';

class FadeSlideTransition extends StatelessWidget {
  const FadeSlideTransition({
    required this.child,
    required this.animation,
    this.reverse = false,
    super.key,
  });

  final Widget child;
  final Animation<double> animation;

  final bool reverse;

  @override
  Widget build(BuildContext context) {
    return DualTransitionBuilder(
      animation: animation,
      forwardBuilder: (context, animation, child) {
        final offset = 0.4 * (reverse ? -1 : 1);
        final slideAnimation = Tween<Offset>(
          begin: Offset(offset, 0),
          end: Offset.zero,
        ).animate(animation);
        final fadeAnimation = Tween<double>(
          begin: 0,
          end: 1,
        ).animate(animation);
        return SlideTransition(
          position: slideAnimation,
          child: FadeTransition(
            opacity: CurvedAnimation(
              parent: fadeAnimation,
              curve: const Interval(0.6, 1),
            ),
            child: child,
          ),
        );
      },
      reverseBuilder: (context, animation, child) {
        final offset = 0.4 * (reverse ? 1 : -1);
        final slideAnimation = Tween<Offset>(
          begin: Offset.zero,
          end: Offset(offset, 0),
        ).animate(animation);
        final fadeAnimation = Tween<double>(
          begin: 1,
          end: 0,
        ).animate(animation);
        return SlideTransition(
          position: slideAnimation,
          child: FadeTransition(
            opacity: CurvedAnimation(
              parent: fadeAnimation,
              curve: const Interval(0.6, 1),
            ),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}
