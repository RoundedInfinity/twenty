import 'package:fluent_ui/fluent_ui.dart' hide FluentIcons;
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:twenty/l10n/l10n.dart';
import 'package:twenty/onboarding/view/onboarding_page.dart';

class ExplainPage extends StatelessWidget {
  const ExplainPage({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  t.appName,
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  t.twentyRule,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                _Item(
                  icon: FluentIcons.hourglass_three_quarter_24_regular,
                  beforeTwenty: t.explainTimerPrefix,
                  afterTwenty: t.explainTimerSuffix,
                ),
                _Item(
                  icon: FluentIcons.timer_24_regular,
                  beforeTwenty: t.explainBreakPrefix,
                  afterTwenty: t.explainBreakSuffix,
                ),
                _Item(
                  icon: FluentIcons.eye_24_regular,
                  beforeTwenty: t.explainFocusPrefix,
                  afterTwenty: t.explainFocusSuffix,
                ),
                const SizedBox(height: 32),
                Text(t.helpsRelax),
              ],
            ),
          ),
        ),
        const OnboardingNavigationButtons(),
      ],
    );
  }
}

class _Item extends StatelessWidget {
  const _Item({
    required this.icon,
    required this.beforeTwenty,
    required this.afterTwenty,
  });

  final IconData icon;
  final String beforeTwenty;
  final String afterTwenty;

  @override
  Widget build(BuildContext context) {
    final accentColor = FluentTheme.of(context).accentColor;
    final twenty = context.l10n.twenty;
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Row(
        children: [
          Icon(
            icon,
            size: 24,
            color: accentColor,
          ),
          const SizedBox(width: 10),
          Flexible(
            child: RichText(
              text: TextSpan(
                text: beforeTwenty,
                style: FluentTheme.of(context).typography.body,
                children: [
                  TextSpan(
                    text: ' $twenty ',
                    style: TextStyle(
                      color: accentColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(text: afterTwenty),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
