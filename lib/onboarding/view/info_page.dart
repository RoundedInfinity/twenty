import 'package:fluent_ui/fluent_ui.dart';
import 'package:fluid_animations/fluid_animations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:launch_at_startup/launch_at_startup.dart';
import 'package:twenty/l10n/l10n.dart';
import 'package:twenty/notification/repository/notification_repository.dart';
import 'package:twenty/onboarding/view/onboarding_page.dart';
import 'package:twenty/rule/bloc/rule_bloc.dart';
import 'package:twenty/settings/settings.dart';
import 'package:twenty/util/app_icon.dart';
import 'package:twenty/util/fluid_enter.dart';

class InfoPage extends StatelessWidget {
  const InfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.l10n;
    final twenty = t.appName;
    final style =
        FluentTheme.of(context).typography.body!.copyWith(fontSize: 16);

    void startTwenty() {
      Settings.completedOnboarding.value = true;
      context.read<RuleBloc>().add(const RuleStarted());
      context.read<NotificationRepository>().showInfoNotification();
      launchAtStartup.enable();
    }

    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 54),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const FluidEnter(
                  spring: FluidSpring.bouncy,
                  child: AppIcon(),
                ),
                const SizedBox(height: 24),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: style,
                    children: [
                      TextSpan(
                        text: '$twenty ',
                        style: style.copyWith(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: t.runsInBackground),
                      const TextSpan(text: '\n\n'),
                      TextSpan(text: t.wishToChangeSettings),
                      WidgetSpan(
                        child: Tooltip(
                          useMousePosition: false,
                          style: const TooltipThemeData(
                            waitDuration: Duration.zero,
                            margin: EdgeInsets.symmetric(horizontal: 16),
                          ),
                          richMessage: TextSpan(
                            text: t.systemTrayTooltipPrefix,
                            children: [
                              WidgetSpan(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  child: SizedBox.square(
                                    dimension: 14,
                                    child: SvgPicture.asset(
                                      'assets/icon/icon.svg',
                                      semanticsLabel: 'App icon',
                                    ),
                                  ),
                                ),
                              ),
                              TextSpan(text: t.systemTrayTooltipSuffix),
                            ],
                          ),
                          child: Text(
                            t.systemTray,
                            style: style.copyWith(
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        OnboardingNavigationButtons(
          onContinue: startTwenty,
          continueTitle: t.startTwenty,
        ),
      ],
    );
  }
}
