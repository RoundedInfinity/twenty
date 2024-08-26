part of 'onboarding_cubit.dart';

@immutable
class OnboardingState {
  const OnboardingState({
    this.currentIndex = 0,
    this.isReverse = false,
  });

  final bool isReverse;

  final int currentIndex;

  @override
  String toString() {
    // ignore: lines_longer_than_80_chars
    return 'OnboardingState(currentIndex: $currentIndex, isReverse: $isReverse)';
  }
}
