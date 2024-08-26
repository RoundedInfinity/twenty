import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twenty/l10n/l10n.dart';
import 'package:twenty/onboarding/cubit/onboarding_cubit.dart';
import 'package:twenty/onboarding/view/explain_page.dart';
import 'package:twenty/onboarding/view/info_page.dart';
import 'package:twenty/onboarding/view/intro_page.dart';
import 'package:twenty/onboarding/view/prompt_page.dart';
import 'package:twenty/util/fade_slide_transition.dart';
import 'package:window_manager/window_manager.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  @override
  void initState() {
    super.initState();
    windowManager
      ..setSize(const Size(440, 482))
      ..center();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OnboardingCubit(maxPages: 4),
      child: const OnboardingView(),
    );
  }
}

class OnboardingView extends StatelessWidget {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    const pages = [
      IntroPage(),
      ExplainPage(),
      PromptPage(),
      InfoPage(),
    ];

    return Stack(
      children: [
        ScaffoldPage(
          content: BlocBuilder<OnboardingCubit, OnboardingState>(
            builder: (context, state) {
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                switchInCurve: Curves.fastEaseInToSlowEaseOut,
                transitionBuilder: (child, animation) {
                  return FadeSlideTransition(
                    animation: animation,
                    reverse: state.isReverse,
                    child: child,
                  );
                },
                child: pages[state.currentIndex],
              );
            },
          ),
        ),
        // Onboarding page can be moved by dragging
        DragToMoveArea(
          child: Container(
            height: 50,
          ),
        ),
      ],
    );
  }
}

class OnboardingNavigationButtons extends StatelessWidget {
  const OnboardingNavigationButtons({
    this.continueTitle,
    this.backTitle,
    this.onContinue,
    this.onBack,
    super.key,
  });

  final String? continueTitle;
  final String? backTitle;
  final VoidCallback? onContinue;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    final t = context.l10n;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Button(
            onPressed: onBack ??
                () {
                  context.read<OnboardingCubit>().previousPage();
                },
            child: Text(backTitle ?? t.back),
          ),
          const SizedBox(width: 8),
          FilledButton(
            onPressed: onContinue ??
                () {
                  context.read<OnboardingCubit>().nextPage();
                },
            child: Text(continueTitle ?? t.continueAction),
          ),
        ],
      ),
    );
  }
}
