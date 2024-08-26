import 'package:fluent_ui/fluent_ui.dart';
import 'package:twenty/l10n/l10n.dart';
import 'package:twenty/onboarding/view/onboarding_page.dart';
import 'package:twenty/util/animated_enter.dart';
import 'package:twenty/util/animated_text.dart';

class PromptPage extends StatelessWidget {
  const PromptPage({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.l10n;
    final twenty = t.appName;
    final style =
        FluentTheme.of(context).typography.body!.copyWith(fontSize: 16);
    return Column(
      children: [
        Expanded(
          child: Center(
            child: SizedBox(
              width: 350,
              child: AnimatedText(
                duration: const Duration(milliseconds: 40),
                spans: [
                  AnimatedTextSpan(
                    text: '$twenty ',
                    style: style.copyWith(fontWeight: FontWeight.bold),
                  ),
                  AnimatedTextSpan(
                    text: t.twentyPrompt,
                    style: style,
                    transitionBuilder: (child, animation) {
                      final slide = Tween<Offset>(
                        begin: const Offset(0, 0.3),
                        end: Offset.zero,
                      ).animate(animation);
                      return ScaleTransition(
                        scale: animation,
                        child: SlideTransition(
                          position: slide,
                          child: SizeTransition(
                            axis: Axis.horizontal,
                            sizeFactor: animation,
                            child: child,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        const AnimatedEnter(
          delay: Duration(milliseconds: 3800),
          child: OnboardingNavigationButtons(),
        ),
      ],
    );
  }
}
