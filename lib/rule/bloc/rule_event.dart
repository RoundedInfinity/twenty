part of 'rule_bloc.dart';

/// A base class for all rule events.
///
/// This class is sealed and cannot be instantiated directly. All specific
/// rule events should extend this class.
@immutable
sealed class RuleEvent {
  const RuleEvent();
}

/// Event to indicate the start of the rule timer.
///
/// Optionally takes a [duration] parameter to set the timer duration.
final class RuleStarted extends RuleEvent {
  /// Constructs a [RuleStarted] event.
  ///
  /// If [duration] is not provided, the default duration will be used.
  const RuleStarted({this.duration});

  /// The optional duration for the timer, in seconds.
  final int? duration;
}

/// Event to indicate the stopping of the rule timer.
final class RuleStopped extends RuleEvent {
  /// Constructs a [RuleStopped] event.
  const RuleStopped();
}

/// Event to indicate a tick of the rule timer.
///
/// Contains the [secondsLeft] to update the timer state.
final class RuleTimerTicked extends RuleEvent {
  /// Constructs a [RuleTimerTicked] event.
  ///
  /// Requires the [secondsLeft] parameter to indicate the remaining time.
  const RuleTimerTicked({required this.secondsLeft});

  /// The remaining seconds left on the timer.
  final int secondsLeft;
}

/// Event to indicate the start of the look-away phase.
///
/// Contains optional [duration] and [promptDuration] parameters.
final class RuleLookAwayStarted extends RuleEvent {
  /// Constructs a [RuleLookAwayStarted] event.
  ///
  /// The [duration] defaults to 20 seconds and the [promptDuration] defaults
  /// to 3 seconds.
  const RuleLookAwayStarted({this.duration = 20, this.promptDuration = 3});

  /// The duration of how long the prompt is visible to the user, in seconds.
  final int promptDuration;

  /// The duration of the look-away phase, in seconds.
  ///
  /// Defaults to 20 seconds to follow the 20-20-20 rule.
  final int duration;
}

/// Event to indicate a tick of the look-away timer.
///
/// Contains the [secondsLeft] and [promptDuration] to update the timer state.
final class RuleLookAwayTimerTicked extends RuleEvent {
  /// Constructs a [RuleLookAwayTimerTicked] event.
  ///
  /// Requires the [secondsLeft] and [promptDuration] parameters.
  const RuleLookAwayTimerTicked({
    required this.secondsLeft,
    required this.promptDuration,
  });

  /// The remaining seconds left on the look-away timer.
  final int secondsLeft;

  /// The duration of the look-away phase, in seconds.
  ///
  /// Defaults to 20 seconds to follow the 20-20-20 rule.
  final int promptDuration;
}
