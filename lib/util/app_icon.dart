import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_svg/svg.dart';

class AppIcon extends StatelessWidget {
  const AppIcon({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = FluentTheme.of(context);
    return SvgPicture.asset(
      'assets/icon/icon.svg',
      semanticsLabel: 'App icon',
      // ignore: deprecated_member_use
      color: theme.brightness == Brightness.dark ? Colors.white : null,
    );
  }
}
