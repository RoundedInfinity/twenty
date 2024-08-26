import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit({required this.maxPages}) : super(const OnboardingState());

  final int maxPages;

  void nextPage() {
    if (state.currentIndex == maxPages - 1) return;

    emit(OnboardingState(currentIndex: state.currentIndex + 1));
  }

  void previousPage() {
    if (state.currentIndex == 0) return;

    emit(
      OnboardingState(currentIndex: state.currentIndex - 1, isReverse: true),
    );
  }
}
