import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:clever_settings_flutter/clever_settings_flutter.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart';
import 'package:launch_at_startup/launch_at_startup.dart';
import 'package:local_notifier/local_notifier.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:system_theme/system_theme.dart';
import 'package:twenty/settings/settings.dart';
import 'package:window_manager/window_manager.dart';

class AppBlocObserver extends BlocObserver {
  const AppBlocObserver();

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    log('onChange(${bloc.runtimeType}, $change)');
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    log('onError(${bloc.runtimeType}, $error, $stackTrace)');
    super.onError(bloc, error, stackTrace);
  }
}

Future<void> bootstrap(FutureOr<Widget> Function() builder) async {
  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  Bloc.observer = const AppBlocObserver();

  WidgetsFlutterBinding.ensureInitialized();

  // init clever settings.
  await CleverSettingsFlutter.init();

  // enable launch at startup.
  final packageInfo = await PackageInfo.fromPlatform();

  launchAtStartup.setup(
    appName: packageInfo.appName,
    appPath: Platform.resolvedExecutable,
    // Set packageName parameter to support MSIX.
    packageName: 'rubengullatz.twenty',
  );

  // setup notifications
  await localNotifier.setup(appName: 'twenty');

  // load accent color
  SystemTheme.fallbackColor = Colors.blue;
  await SystemTheme.accentColor.load();

  // init window controls.
  await windowManager.ensureInitialized();

  await Window.initialize();

  const windowOptions = WindowOptions(
    size: Size(440, 482),
    center: true,
    backgroundColor: Colors.transparent,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.hidden,
  );

  await windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.focus();
    await windowManager.setAsFrameless();

    if (Settings.startMinimized.value && Settings.completedOnboarding.value) {
      await windowManager.hide();
    } else {
      await windowManager.show();
    }
  });

  await Window.setEffect(
    effect: WindowEffect.mica,
    dark: false,
  );
  await Window.hideWindowControls();

  runApp(await builder());
}
