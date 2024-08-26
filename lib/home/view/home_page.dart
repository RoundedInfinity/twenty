import 'package:clever_settings/clever_settings.dart';
import 'package:clever_settings_flutter/clever_settings_flutter.dart';
import 'package:fluent_ui/fluent_ui.dart' hide FluentIcons;
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:launch_at_startup/launch_at_startup.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:twenty/home/view/custom_window_caption.dart';
import 'package:twenty/home/view/settings_tile.dart';
import 'package:twenty/l10n/l10n.dart';
import 'package:twenty/rule/bloc/rule_bloc.dart';
import 'package:twenty/settings/settings.dart';
import 'package:twenty/window/repository/window_repository.dart';
import 'package:window_manager/window_manager.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.l10n;
    return DragToResizeArea(
      child: ScaffoldPage(
        padding: EdgeInsets.zero,
        header: WindowButtons(
          onClose: () {
            if (Settings.isActive.value) {
              // Continue with saved duration.
              final duration =
                  (context.read<RuleBloc>().state as RuleInitial).lastDuration;

              context.read<RuleBloc>().add(RuleStarted(duration: duration));
            } else {
              context.read<WindowRepository>().hideWindow();
            }
          },
        ),
        content: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          children: [
            PageHeader(
              title: Text(t.appName),
              padding: 0,
            ),
            InfoBar(
              title: Text(t.runInfo),
            ),
            const _RunSettings(),
            const _SoundSettings(),
            const _AppDesignSettings(),
            const SizedBox(height: 32),
            const _InfoTile(),
          ],
        ),
      ),
    );
  }
}

class _AppDesignSettings extends StatelessWidget {
  const _AppDesignSettings();

  @override
  Widget build(BuildContext context) {
    final t = context.l10n;

    return SettingsValueBuilder(
      setting: Settings.themeMode,
      builder: (context, value, child) {
        final mode = value ?? ThemeMode.system;

        return Expander(
          leading: const Icon(FluentIcons.paint_brush_24_regular),
          header: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(t.appDesign),
                Text(
                  t.appDesignInfo,
                  style: FluentTheme.of(context).typography.caption,
                ),
              ],
            ),
          ),
          content: Column(
            children: [
              _ChangeThemeTile(
                title: t.light,
                mode: ThemeMode.light,
                selectedMode: mode,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: _ChangeThemeTile(
                  title: t.dark,
                  mode: ThemeMode.dark,
                  selectedMode: mode,
                ),
              ),
              _ChangeThemeTile(
                title: t.system,
                mode: ThemeMode.system,
                selectedMode: mode,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ChangeThemeTile extends StatelessWidget {
  const _ChangeThemeTile({
    required this.title,
    required this.mode,
    required this.selectedMode,
  });

  final String title;
  final ThemeMode mode;
  final ThemeMode selectedMode;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(title),
        const Spacer(),
        RadioButton(
          checked: mode == selectedMode,
          onChanged: (val) {
            Settings.themeMode.value = mode;
            context.read<WindowRepository>().applyMicaEffect();
          },
        ),
      ],
    );
  }
}

class _OnboardingButton extends StatelessWidget {
  const _OnboardingButton();

  @override
  Widget build(BuildContext context) {
    final t = context.l10n;

    return Align(
      alignment: Alignment.topLeft,
      child: HyperlinkButton(
        onPressed: () {
          Settings.completedOnboarding.value = false;
          context.read<RuleBloc>().add(const RuleStopped());
        },
        child: Text(t.showOnboarding),
      ),
    );
  }
}

class _RunSettings extends StatelessWidget {
  const _RunSettings();

  @override
  Widget build(BuildContext context) {
    final t = context.l10n;
    return Expander(
      header: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(t.runTwenty),
            Text(
              t.runTwentyInfo,
              style: FluentTheme.of(context).typography.caption,
            ),
          ],
        ),
      ),
      leading: const Icon(FluentIcons.power_24_regular),
      trailing: SettingsValueBuilder(
        setting: Settings.isActive,
        builder: (context, value, child) {
          return ToggleSwitch(
            checked: value!,
            onChanged: (value) {
              Settings.isActive.value = value;
            },
          );
        },
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SettingsTile(
            setting: Settings.startMinimized,
            title: Text(t.startMinimized),
          ),
          const SizedBox(height: 16),
          const _LaunchAtStartupTile(),
        ],
      ),
    );
  }
}

class _LaunchAtStartupTile extends StatefulWidget {
  const _LaunchAtStartupTile();

  @override
  State<_LaunchAtStartupTile> createState() => _LaunchAtStartupTileState();
}

class _LaunchAtStartupTileState extends State<_LaunchAtStartupTile> {
  @override
  Widget build(BuildContext context) {
    final t = context.l10n;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        DefaultTextStyle(
          style: FluentTheme.of(context).typography.body!,
          child: Text(t.launchAtStartup),
        ),
        FutureBuilder(
          future: launchAtStartup.isEnabled(),
          builder: (context, snapshot) {
            final enabled = snapshot.data ?? false;

            return ToggleSwitch(
              checked: enabled,
              onChanged: snapshot.hasData
                  ? (value) async {
                      if (value) {
                        await launchAtStartup.enable();
                      } else {
                        await launchAtStartup.disable();
                      }
                      setState(() {});
                    }
                  : null,
            );
          },
        ),
      ],
    );
  }
}

class _SoundSettings extends StatelessWidget {
  const _SoundSettings();

  @override
  Widget build(BuildContext context) {
    final t = context.l10n;
    return Expander(
      header: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(t.sounds),
            Text(
              t.soundsInfo,
              style: FluentTheme.of(context).typography.caption,
            ),
          ],
        ),
      ),
      leading: const Icon(FluentIcons.speaker_2_20_regular),
      trailing: SettingsValueBuilder(
        setting: Settings.useSound,
        builder: (context, useSound, child) {
          return ToggleSwitch(
            checked: useSound!,
            onChanged: (value) {
              Settings.useSound.value = value;
            },
          );
        },
      ),
      content: SettingsTile(
        setting: Settings.useTimerSound,
        title: Text(t.useTimerSound),
      ),
    );
  }
}

class _DevTile extends StatelessWidget {
  const _DevTile();

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text('DEV: Shorten duration'),
      trailing: SettingsValueBuilder(
        setting: Settings.timerDuration,
        builder: (context, value, child) {
          return ToggleSwitch(
            checked: value != 1200,
            onChanged: (value) {
              if (value) {
                Settings.timerDuration.value = 5;
              } else {
                Settings.timerDuration.value = 1200;
              }
            },
          );
        },
      ),
    );
  }
}

class _InfoTile extends StatefulWidget {
  const _InfoTile();

  @override
  State<_InfoTile> createState() => _InfoTileState();
}

class _InfoTileState extends State<_InfoTile> {
  int taps = 0;

  bool showDebugOptions = false;
  @override
  Widget build(BuildContext context) {
    final infos = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const _OnboardingButton(),
        _VersionInfo(
          onTap: () {
            taps++;
            if (taps > 7) {
              setState(() {
                showDebugOptions = true;
              });
            }
          },
        ),
      ],
    );

    if (showDebugOptions) {
      return Column(
        children: [
          infos,
          const _DevTile(),
          const ListTile(
            title: Text('Reset settings'),
            onPressed: CleverSettings.resetSettings,
          ),
        ],
      );
    }

    return infos;
  }
}

class _VersionInfo extends StatelessWidget {
  const _VersionInfo({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final style = FluentTheme.of(context).typography.caption;
    return FutureBuilder(
      future: PackageInfo.fromPlatform(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Text.rich(
            TextSpan(
              text: snapshot.data!.version,
              recognizer: TapGestureRecognizer()..onTap = onTap,
            ),
            style: style,
          );
        }

        return Text('Unknown', style: style);
      },
    );
  }
}
