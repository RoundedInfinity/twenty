import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart';
import 'package:twenty/settings/settings.dart';
import 'package:window_manager/window_manager.dart';

/// A repository class for managing window-related operations.
class WindowRepository {
  const WindowRepository({
    required this.systemBrightness,
  });

  final Brightness systemBrightness;

  /// Hides the application window.
  ///
  /// Returns a [Future] that completes when the window is hidden.
  Future<void> hideWindow() {
    return windowManager.hide();
  }

  Future<void> applyMicaEffect() async {
    final mode = Settings.themeMode.value!;

    final isDark = switch (mode) {
      ThemeMode.system => systemBrightness == Brightness.dark,
      ThemeMode.light => false,
      ThemeMode.dark => true,
    };

    await Window.setEffect(
      effect: WindowEffect.mica,
      dark: isDark,
    );
  }

  /// Shows and configures the main application window.
  ///
  /// This method sets various window properties such as effect, size, and
  /// position.
  ///
  /// Returns a [Future] that completes when all window configurations are
  /// applied.
  Future<void> showWindow() async {
    await applyMicaEffect();

    await Future.wait([
      windowManager.setAlignment(Alignment.center),
      windowManager.setMinimumSize(const Size(320, 320)),
      windowManager.setSize(const Size(450, 500)),
      windowManager.setAlwaysOnTop(false),
      windowManager.setSkipTaskbar(false),
    ]);

    await windowManager.show();
  }

  /// Shows and configures a toast-style window.
  ///
  /// This method sets up a small, frameless window suitable for displaying
  /// toast notifications.
  ///
  /// Returns a [Future] that completes when all window configurations are
  ///  applied
  Future<void> showToast() async {
    await Window.setEffect(effect: WindowEffect.transparent, dark: false);

    await Future.wait([
      windowManager.setSkipTaskbar(true),
      windowManager.setMinimumSize(const Size(350, 150)),
      windowManager.setSize(const Size(350, 150)),
      windowManager.setAlignment(Alignment.topCenter),
      windowManager.setHasShadow(false),
      windowManager.setAsFrameless(),
      windowManager.setAlwaysOnTop(true),
    ]);

    await windowManager.show();
  }
}
