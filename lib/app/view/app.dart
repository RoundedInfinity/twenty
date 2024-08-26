import 'package:clever_settings_flutter/clever_settings_flutter.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:system_theme/system_theme.dart';
import 'package:twenty/l10n/l10n.dart';
import 'package:twenty/notification/repository/notification_repository.dart';
import 'package:twenty/rule/bloc/rule_bloc.dart';
import 'package:twenty/rule/ticker.dart';
import 'package:twenty/settings/settings.dart';
import 'package:twenty/tray/repository/tray_repository.dart';
import 'package:twenty/tray/view/tray_provider.dart';
import 'package:twenty/window/repository/window_repository.dart';
import 'package:twenty/window/view/window_view.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    // The window repo needs the brightness to apply the mica effect.
    final systemBrightness = MediaQuery.platformBrightnessOf(context);
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => WindowRepository(
            systemBrightness: systemBrightness,
          ),
        ),
        RepositoryProvider(
          create: (context) => TrayRepository(),
        ),
        RepositoryProvider(
          create: (context) => NotificationRepository(),
        ),
      ],
      child: BlocProvider(
        create: (context) => RuleBloc(
          ticker: const Ticker(),
          windowRepository: context.read<WindowRepository>(),
        ),
        child: TrayProvider(
          child: SystemThemeBuilder(
            builder: (context, accent) {
              // Start the timer when starting minimized.
              if (Settings.startMinimized.value &&
                  Settings.completedOnboarding.value) {
                context.read<RuleBloc>().add(const RuleStarted());
              } else {
                context.read<WindowRepository>().applyMicaEffect();
              }

              return SettingsValueBuilder(
                setting: Settings.themeMode,
                builder: (context, value, child) {
                  return FluentApp(
                    themeMode: value,
                    theme: FluentThemeData(
                      scaffoldBackgroundColor: Colors.transparent,
                      accentColor: accent.accent.toAccentColor(),
                    ),
                    darkTheme: FluentThemeData(
                      scaffoldBackgroundColor: Colors.transparent,
                      accentColor: accent.accent.toAccentColor(),
                      brightness: Brightness.dark,
                    ),
                    localizationsDelegates:
                        AppLocalizations.localizationsDelegates,
                    supportedLocales: AppLocalizations.supportedLocales,
                    debugShowCheckedModeBanner: false,
                    home: const WindowView(),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
