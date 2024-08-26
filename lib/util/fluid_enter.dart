import 'package:fluid_animations/fluid_animations.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/widgets.dart';
import 'package:twenty/util/animated_enter.dart';

class FluidEnter extends StatefulWidget {
  const FluidEnter({
    required this.child,
    this.spring = FluidSpring.defaultSpring,
    this.transitionBuilder = AnimatedEnterTransition.scaleIn,
    this.delay = Duration.zero,
    super.key,
  });

  final Widget child;
  final SpringDescription spring;
  final Duration delay;

  final AnimatedEnterTransitionBuilder transitionBuilder;
  @override
  State<FluidEnter> createState() => _FluidEnterState();
}

class _FluidEnterState extends State<FluidEnter>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController.unbounded(vsync: this);

    _startAnimation();
  }

  Future<void> _startAnimation() async {
    await Future<void>.delayed(widget.delay);

    if (mounted) {
      final sim = SpringSimulation(widget.spring, 0, 1, 0);
      return _controller.animateWith(sim);
    }
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
