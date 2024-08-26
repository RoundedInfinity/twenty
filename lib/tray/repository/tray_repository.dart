import 'dart:io';
import 'package:tray_manager/tray_manager.dart';

/// A repository class for managing system tray-related operations.
class TrayRepository {
  /// The path to the tray icon asset.
  static const String _iconPath = 'assets/icon/Icon';

  /// Adds a tray menu with predefined options.
  ///
  /// Sets the tray icon, tooltip, and context menu.
  /// Returns a [Future] that completes when all tray configurations are
  /// applied.
  Future<void> addTrayMenu() async {
    final iconAsset = Platform.isWindows ? '$_iconPath.ico' : '$_iconPath.png';

    final menu = Menu(
      items: [
        MenuItem(key: 'show_window', label: 'Show Window'),
        MenuItem.separator(),
        MenuItem(key: 'exit_app', label: 'Exit App'),
      ],
    );

    await Future.wait([
      trayManager.setIcon(iconAsset),
      trayManager.setToolTip('Twenty'),
      trayManager.setContextMenu(menu),
    ]);
  }

  /// Adds a listener for tray events.
  ///
  /// [listener] is the [TrayListener] to be added.
  void addListener(TrayListener listener) {
    trayManager.addListener(listener);
  }

  /// Removes a previously added tray event listener.
  ///
  /// [listener] is the [TrayListener] to be removed.
  void removeListener(TrayListener listener) {
    trayManager.removeListener(listener);
  }
}
