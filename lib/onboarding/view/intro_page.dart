import 'dart:io';
import 'dart:math';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:fluid_animations/fluid_animations.dart';
import 'package:twenty/l10n/l10n.dart';
import 'package:twenty/onboarding/view/onboarding_page.dart';
import 'package:twenty/util/fluid_enter.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.l10n;
    return Column(
      children: [
        Expanded(
          child: Stack(
            children: [
              const _Emoji(
                alignment: Alignment(0.1, -0.5),
                angle: 0,
                emoji: '🏝️',
              ),
              const _Emoji(
                alignment: Alignment(0.6, -0.2),
                angle: 0.4,
                emoji: '🏝️',
              ),
              const _Emoji(
                alignment: Alignment(0.7, 0.3),
                angle: 0.4,
                emoji: '👀',
              ),
              const _Emoji(
                alignment: Alignment(0.3, 0.6),
                angle: 0.1,
                emoji: '🏝️',
              ),
              const _Emoji(
                alignment: Alignment(-0.5, 0.5),
                angle: 2.7,
                emoji: '👀',
              ),
              const _Emoji(
                alignment: Alignment(-0.6, -0.1),
                angle: -0.2,
                emoji: '🏝️',
              ),
              const _Emoji(
                alignment: Alignment(-0.4, -0.5),
                angle: -2.2,
                emoji: '👀',
              ),
              Align(
                child: FluidEnter(
                  spring: FluidSpring.bouncy,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        t.appName,
                        style: const TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        t.slogan,
                        style: const TextStyle(fontSize: 15),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        OnboardingNavigationButtons(
          backTitle: t.cancel,
          continueTitle: t.getStarted,
          onBack: () {
            showDialog(
              context: context,
              builder: (context) {
                return ContentDialog(
                  title: Text(t.exitSetup),
                  content: Text(t.exitSetupInfo),
                  actions: [
                    Button(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(t.cancel),
                    ),
                    FilledButton(
                      onPressed: () {
                        exit(0);
                      },
                      child: Text(t.exit),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ],
    );
  }
}

class _Emoji extends StatelessWidget {
  const _Emoji({
    required this.alignment,
    required this.emoji,
    required this.angle,
  });

  final Alignment alignment;
  final String emoji;
  final double angle;

  @override
  Widget build(BuildContext context) {
    final delay = Random().nextInt(3);
    return Align(
      alignment: alignment,
      child: FluidEnter(
        spring: FluidSpring.bouncy,
        delay: Duration(milliseconds: 260 + delay * 100),
        child: Transform.rotate(
          angle: angle,
          child: Text(
            emoji,
            style: const TextStyle(fontSize: 34),
          ),
        ),
      ),
    );
  }
}
