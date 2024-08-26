import 'package:flutter/widgets.dart';

typedef AnimatedEnterTransitionBuilder = Widget Function(
  Widget child,
  Animation<double> animation,
);

class AnimatedEnter extends StatefulWidget {
  const AnimatedEnter({
    required this.child,
    this.duration = const Duration(milliseconds: 500),
    this.transitionBuilder = AnimatedEnterTransition.fadeScale,
    this.delay = Duration.zero,
    super.key,
  });

  final Widget child;
  final Duration duration;
  final Duration delay;

  final AnimatedEnterTransitionBuilder transitionBuilder;
  @override
  State<AnimatedEnter> createState() => _AnimatedEnterState();
}

class _AnimatedEnterState extends State<AnimatedEnter>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);

    _startAnimation();
  }

  Future<void> _startAnimation() async {
    await Future<void>.delayed(widget.delay);
    if (mounted) return _controller.forward(from: 0);
  }

  @override
  void didChangeDependencies() {
    _controller.duration = widget.duration;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.transitionBuilder(widget.child, _controller);
  }
}

class AnimatedEnterTransition {
  const AnimatedEnterTransition._();

  static Widget fadeScale(Widget child, Animation<double> animation) {
    final fadeAnimation = CurvedAnimation(
      parent: animation,
      curve: Curves.fastEaseInToSlowEaseOut,
    );

    final scaleAnimation =
        Tween<double>(begin: 0.8, end: 1).animate(fadeAnimation);

    return FadeTransition(
      opacity: fadeAnimation,
      child: ScaleTransition(
        scale: scaleAnimation,
        child: child,
      ),
    );
  }

  static Widget scaleIn(Widget child, Animation<double> animation) {
    return ScaleTransition(
      scale: animation,
      child: child,
    );
  }
}
