import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tray_manager/tray_manager.dart';
import 'package:twenty/rule/bloc/rule_bloc.dart';
import 'package:twenty/tray/repository/tray_repository.dart';

/// A widget that provides system tray functionality and listens to rule state
/// changes.
class TrayProvider extends StatefulWidget {
  /// Creates a [TrayProvider] widget.
  ///
  /// The [child] parameter must not be null.
  const TrayProvider({required this.child, super.key});

  /// The widget below this widget in the tree.
  final Widget child;

  @override
  State<TrayProvider> createState() => _TrayProviderState();
}

class _TrayProviderState extends State<TrayProvider> with TrayListener {
  static const String _appName = 'Twenty';

  @override
  void initState() {
    super.initState();
    context.read<TrayRepository>()
      ..addListener(this)
      ..addTrayMenu();
  }

  @override
  void dispose() {
    context.read<TrayRepository>().removeListener(this);
    super.dispose();
  }

  @override
  void onTrayMenuItemClick(MenuItem menuItem) {
    switch (menuItem.key) {
      case 'show_window':
        showWindow();

      case 'exit_app':
        exit(0);
    }
  }

  @override
  void onTrayIconMouseDown() => showWindow();

  @override
  void onTrayIconRightMouseDown() => trayManager.popUpContextMenu();

  /// Shows the application window and stops the current rule.
  void showWindow() {
    if (mounted) {
      context.read<RuleBloc>().add(const RuleStopped());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RuleBloc, RuleState>(
      listener: _handleRuleStateChange,
      child: widget.child,
    );
  }

  /// Handles changes in the [RuleState] and updates the tray tooltip
  /// accordingly.
  void _handleRuleStateChange(BuildContext context, RuleState state) {
    if (state is RuleTimerRunning) {
      final timerString = _formatTime(state.secondsLeft);
      trayManager.setToolTip('$_appName - $timerString');
    } else {
      trayManager.setToolTip(_appName);
    }
  }

  /// Formats the given seconds into a MM:SS string.
  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    // ignore: lines_longer_than_80_chars
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}
