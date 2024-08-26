import 'package:audioplayers/audioplayers.dart';
import 'package:clever_settings_flutter/clever_settings_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twenty/rule/bloc/rule_bloc.dart';
import 'package:twenty/settings/settings.dart';

class Jukebox extends StatefulWidget {
  const Jukebox({required this.child, super.key});

  final Widget child;

  @override
  State<Jukebox> createState() => _JukeboxState();
}

class _JukeboxState extends State<Jukebox> {
  late final AudioPlayer _notifyPlayer;
  late final AudioPlayer _stepPlayer;
  late final AudioPlayer _finishedPlayer;

  @override
  void initState() {
    super.initState();

    _notifyPlayer = AudioPlayer();

    _notifyPlayer
      ..setSource(AssetSource('audio/playful.mp3'))
      ..setReleaseMode(ReleaseMode.stop);

    _stepPlayer = AudioPlayer();

    _stepPlayer
      ..setSource(AssetSource('audio/maybe.mp3'))
      ..setReleaseMode(ReleaseMode.stop);

    _finishedPlayer = AudioPlayer();

    _finishedPlayer
      ..setSource(AssetSource('audio/accomplished.mp3'))
      ..setReleaseMode(ReleaseMode.stop);
  }

  @override
  void dispose() {
    _notifyPlayer.dispose();
    _stepPlayer.dispose();
    _finishedPlayer.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiSettingsValueBuilder(
      settings: [Settings.useSound, Settings.useTimerSound],
      builder: (context, child) {
        if (Settings.useSound.value) {
          return BlocListener<RuleBloc, RuleState>(
            listener: (context, state) {
              switch (state.runtimeType) {
                case RuleShouldLookAway:
                  _notifyPlayer.resume();
                case RuleLookingAway:
                  if (Settings.useTimerSound.value) _stepPlayer.resume();
                case RuleLookedAway:
                  _finishedPlayer.resume();
              }
            },
            child: widget.child,
          );
        }

        return widget.child;
      },
    );
  }
}
