import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:twenty/rule/ticker.dart';
import 'package:twenty/settings/settings.dart';
import 'package:twenty/window/repository/window_repository.dart';

part 'rule_event.dart';
part 'rule_state.dart';

/// A bloc that manages the state of a 20-20-20 rule based timer system.
class RuleBloc extends Bloc<RuleEvent, RuleState> {
  /// Creates a [RuleBloc].
  ///
  /// The [ticker] and [windowRepository] parameters must not be null.
  RuleBloc({
    required Ticker ticker,
    required WindowRepository windowRepository,
  })  : _ticker = ticker,
        _windowRepository = windowRepository,
        super(const RuleInitial()) {
    on<RuleStarted>(_onStarted);
    on<RuleTimerTicked>(_onTimerTicked);
    on<RuleLookAwayStarted>(_onLookAwayStarted);
    on<RuleLookAwayTimerTicked>(_onLookAwayTimerTicked);
    on<RuleStopped>(_onStopped);
  }

  final Ticker _ticker;
  final WindowRepository _windowRepository;

  StreamSubscription<int>? _tickerSubscription;

  @override
  Future<void> close() {
    _tickerSubscription?.cancel();
    return super.close();
  }

  /// Handles the [RuleStarted] event.
  ///
  /// This event starts the main timer countdown and hides the window.
  Future<void> _onStarted(RuleStarted event, Emitter<RuleState> emit) async {
    final duration = event.duration ?? Settings.timerDuration.value;

    emit(RuleTimerRunning(secondsLeft: duration));

    await _windowRepository.hideWindow();

    await _tickerSubscription?.cancel();

    _tickerSubscription = _ticker.tick(ticks: duration).listen((seconds) {
      add(RuleTimerTicked(secondsLeft: seconds));
    });
  }

  /// Handles the [RuleTimerTicked] event.
  ///
  /// This event updates the timer countdown or starts the look-away phase when
  /// the timer reaches zero.
  Future<void> _onTimerTicked(
    RuleTimerTicked event,
    Emitter<RuleState> emit,
  ) async {
    if (event.secondsLeft > 0) {
      emit(RuleTimerRunning(secondsLeft: event.secondsLeft));
    } else {
      add(const RuleLookAwayStarted());
    }
  }

  /// Handles the [RuleLookAwayStarted] event.
  ///
  /// This event starts the look-away countdown and shows a toast window to the
  /// user.
  Future<void> _onLookAwayStarted(
    RuleLookAwayStarted event,
    Emitter<RuleState> emit,
  ) async {
    emit(RuleShouldLookAway());
    await _windowRepository.showToast();

    await Future<void>.delayed(Duration(seconds: event.promptDuration));

    // State was changed by user during delay.
    if (state is! RuleShouldLookAway) return;

    emit(RuleLookingAway(secondsLeft: event.duration));

    await _tickerSubscription?.cancel();

    _tickerSubscription = _ticker.tick(ticks: event.duration).listen((seconds) {
      add(
        RuleLookAwayTimerTicked(
          secondsLeft: seconds,
          promptDuration: event.promptDuration,
        ),
      );
    });
  }

  /// Handles the [RuleLookAwayTimerTicked] event.
  ///
  /// This event updates the look-away countdown.
  Future<void> _onLookAwayTimerTicked(
    RuleLookAwayTimerTicked event,
    Emitter<RuleState> emit,
  ) async {
    if (event.secondsLeft > 0) {
      emit(RuleLookingAway(secondsLeft: event.secondsLeft));
    } else {
      emit(RuleLookedAway());
      await _tickerSubscription?.cancel();
      await Future<void>.delayed(Duration(seconds: event.promptDuration));

      // State was changed by user during delay.
      if (state is! RuleLookedAway) return;

      final duration = Settings.timerDuration.value;

      add(RuleStarted(duration: duration));
    }
  }

  /// Handles the [RuleStopped] event.
  ///
  /// This event stops any active timers, shows the window, and resets the state
  /// to initial.
  Future<void> _onStopped(RuleStopped event, Emitter<RuleState> emit) async {
    await _tickerSubscription?.cancel();
    await _windowRepository.showWindow();

    final currentState = state;
    final lastDuration =
        currentState is RuleTimerRunning ? currentState.secondsLeft : null;
    emit(RuleInitial(lastDuration: lastDuration));
  }
}
