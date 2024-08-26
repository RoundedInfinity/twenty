import 'package:clever_settings_flutter/clever_settings_flutter.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twenty/home/view/home_page.dart';
import 'package:twenty/onboarding/view/onboarding_page.dart';
import 'package:twenty/rule/bloc/rule_bloc.dart';
import 'package:twenty/rule/view/rule_view.dart';
import 'package:twenty/settings/settings.dart';

class WindowView extends StatelessWidget {
  const WindowView({super.key});

  @override
  Widget build(BuildContext context) {
    return const _WindowSwitcher();
  }
}

class _WindowSwitcher extends StatelessWidget {
  const _WindowSwitcher();

  @override
  Widget build(BuildContext context) {
    return SettingsValueBuilder(
      setting: Settings.completedOnboarding,
      builder: (context, value, child) {
        if (value == false) {
          return const OnboardingPage();
        }
        return BlocBuilder<RuleBloc, RuleState>(
          builder: (context, state) {
            return switch (state.runtimeType) {
              (RuleInitial) => const HomePage(),
              _ => const RulePage()
            };
          },
        );
      },
    );
  }
}
