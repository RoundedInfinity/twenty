import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twenty/l10n/l10n.dart';
import 'package:twenty/rule/bloc/rule_bloc.dart';
import 'package:twenty/rule/view/switcher.dart';
import 'package:twenty/rule/view/toast.dart';
import 'package:twenty/sound/jukebox.dart';
import 'package:twenty/util/app_icon.dart';

/// A page that displays the current status of the 20-20-20 rule in a toast.
///
/// See also:
/// - [RuleBloc] which is responsible for the logic.
class RulePage extends StatelessWidget {
  const RulePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Jukebox(
      child: ToastContent(
        child: AnimatedSize(
          duration: const Duration(milliseconds: 500),
          curve: Curves.fastEaseInToSlowEaseOut,
          child: BlocBuilder<RuleBloc, RuleState>(
            buildWhen: (previous, current) =>
                previous.runtimeType != current.runtimeType,
            builder: (context, state) {
              return AnimatedRuleSwitcher(
                child: switch (state.runtimeType) {
                  (RuleShouldLookAway) => const _LookAway(),
                  RuleLookingAway => const _LookingAway(),
                  RuleLookedAway => const _LookedAway(),
                  _ => const _Empty(),
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

class _Empty extends StatelessWidget {
  const _Empty();

  @override
  Widget build(BuildContext context) {
    return const SizedBox();
  }
}

class _LookAway extends StatelessWidget {
  const _LookAway();

  @override
  Widget build(BuildContext context) {
    final t = context.l10n;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            height: 32,
            width: 32,
            child: AppIcon(),
          ),
          const SizedBox(width: 12),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                t.lookAway,
                style:
                    const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
              Text(t.focusOn),
            ],
          ),
        ],
      ),
    );
  }
}

class _LookingAway extends StatelessWidget {
  const _LookingAway();

  /// Formats the given seconds into a MM:SS string.
  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    // ignore: lines_longer_than_80_chars
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final t = context.l10n;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          BlocBuilder<RuleBloc, RuleState>(
            builder: (context, state) {
              if (state is RuleLookingAway) {
                return Text(
                  _formatTime(state.secondsLeft),
                  style: const TextStyle(fontSize: 32),
                );
              }
              return const SizedBox();
            },
          ),
          const SizedBox(width: 12),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                t.remaining,
                style:
                    const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
              Text(t.dontLook),
            ],
          ),
        ],
      ),
    );
  }
}

class _LookedAway extends StatelessWidget {
  const _LookedAway();

  @override
  Widget build(BuildContext context) {
    final t = context.l10n;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            '🏝️',
            style: TextStyle(fontSize: 32),
          ),
          const SizedBox(width: 12),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                t.wellDone,
                style:
                    const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
              Text(t.eyesAreRelaxed),
            ],
          ),
        ],
      ),
    );
  }
}
