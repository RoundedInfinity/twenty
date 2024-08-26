import 'package:clever_settings/clever_settings.dart';
import 'package:fluent_ui/fluent_ui.dart';

class Settings {
  const Settings._();

  /// Wether the app should run in the background and remind the user to
  /// take breaks.
  static final isActive = DefaultSettingsValue(
    name: 'isActive',
    defaultValue: true,
  );

  /// The apps theme mode.
  ///
  /// Defaults to [ThemeMode.system].
  static final themeMode = SerializableSettingsValue<ThemeMode>(
    name: 'themeMode',
    fromJson: ThemeModeConverter.fromJson,
    toJson: (value) => value.toJson(),
    defaultValue: ThemeMode.system,
  );

  /// Wether the user has completed the onboarding.
  ///
  /// Changing this setting toggles between the showing the
  /// HomePage or OnboardingPage.
  static final completedOnboarding = DefaultSettingsValue(
    name: 'completedOnboarding',
    defaultValue: false,
  );

  /// Whether the app should start minimized.
  static final startMinimized = DefaultSettingsValue(
    name: 'startMinimized',
    defaultValue: true,
  );

  /// The duration of the timer until the user is reminded.
  ///
  /// Defaults to 20 minutes.
  static final timerDuration = DefaultSettingsValue(
    name: 'timerDuration',
    defaultValue: 1200, // 20 min
  );

  /// Wether to use a notification sound to remind the user.
  static final useSound = DefaultSettingsValue(
    name: 'useSound',
    defaultValue: true,
  );

  /// Wether to use a tick sound for each second that passes
  /// on the relaxation timer.
  static final useTimerSound = DefaultSettingsValue(
    name: 'useTimerSound',
    defaultValue: true,
  );
}

extension ThemeModeConverter on ThemeMode {
  // From json
  static ThemeMode fromJson(Map<String, dynamic> json) {
    switch (json['value']) {
      case 'system':
        return ThemeMode.system;
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  // To json
  Map<String, dynamic> toJson() {
    switch (this) {
      case ThemeMode.system:
        return {'value': 'system'};
      case ThemeMode.light:
        return {'value': 'light'};
      case ThemeMode.dark:
        return {'value': 'dark'};
    }
  }
}
