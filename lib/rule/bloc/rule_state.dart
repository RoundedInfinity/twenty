part of 'rule_bloc.dart';

/// A base class for all rule states.
///
/// This class is sealed and cannot be instantiated directly. All specific
/// rule states should extend this class.
@immutable
sealed class RuleState {
  /// Constructs a [RuleState].
  const RuleState();
}

/// Initial state of the rule timer.
///
/// Optionally contains [lastDuration] to indicate the last timer duration
/// before opening the settings window.
final class RuleInitial extends RuleState {
  /// Constructs a [RuleInitial] state.
  ///
  /// The [lastDuration] is optional and indicates the last timer duration
  /// before opening the settings window.
  const RuleInitial({this.lastDuration});

  /// The last duration of the timer, in seconds.
  final int? lastDuration;

  @override
  String toString() {
    return 'RuleInitial(lastDuration: $lastDuration)';
  }
}

/// State representing the running timer.
///
/// Contains the [secondsLeft] to indicate the remaining time.
final class RuleTimerRunning extends RuleState {
  /// Constructs a [RuleTimerRunning] state.
  ///
  /// Requires the [secondsLeft] parameter to indicate the remaining time.
  const RuleTimerRunning({required this.secondsLeft});

  /// The remaining seconds left on the timer.
  final int secondsLeft;

  /// Creates a copy of the current state with optional new values.
  RuleTimerRunning copyWith({int? secondsLeft}) {
    return RuleTimerRunning(secondsLeft: secondsLeft ?? this.secondsLeft);
  }

  @override
  String toString() {
    return 'RuleTimerRunning(secondsLeft: $secondsLeft)';
  }
}

/// State indicating that the user should look away from the screen.
final class RuleShouldLookAway extends RuleState {
  /// Constructs a [RuleShouldLookAway] state.
  const RuleShouldLookAway();
}

/// State representing the look-away timer.
///
/// Contains the [secondsLeft] to indicate the remaining look-away time.
final class RuleLookingAway extends RuleState {
  /// Constructs a [RuleLookingAway] state.
  ///
  /// Requires the [secondsLeft] parameter to indicate the remaining look-away
  /// time.
  const RuleLookingAway({required this.secondsLeft});

  /// The remaining seconds left on the look-away timer.
  final int secondsLeft;

  /// Creates a copy of the current state with optional new values.
  RuleLookingAway copyWith({int? secondsLeft}) {
    return RuleLookingAway(secondsLeft: secondsLeft ?? this.secondsLeft);
  }

  @override
  String toString() {
    return 'RuleLookingAway(secondsLeft: $secondsLeft)';
  }
}

/// State indicating that the user has completed the look-away phase.
final class RuleLookedAway extends RuleState {
  /// Constructs a [RuleLookedAway] state.
  const RuleLookedAway();
}

/// State indicating an error has occurred.
///
/// Contains the [error] message describing the error.
final class RuleError extends RuleState {
  /// Constructs a [RuleError] state.
  ///
  /// Requires the [error] parameter to describe the error.
  const RuleError({required this.error});

  /// The error message describing what went wrong.
  final String error;
}
