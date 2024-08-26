import 'package:clever_settings/clever_settings.dart';
import 'package:clever_settings_flutter/clever_settings_flutter.dart';
import 'package:fluent_ui/fluent_ui.dart';

class SettingsTile extends StatelessWidget {
  const SettingsTile({required this.setting, required this.title, super.key});

  final SettingsValue<bool> setting;

  final Widget title;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        DefaultTextStyle(
          style: FluentTheme.of(context).typography.body!,
          child: title,
        ),
        SettingsValueBuilder(
          setting: setting,
          builder: (context, value, child) {
            return ToggleSwitch(
              checked: value!,
              onChanged: (value) {
                setting.value = value;
              },
            );
          },
        ),
      ],
    );
  }
}
