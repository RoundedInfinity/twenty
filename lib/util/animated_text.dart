import 'package:flutter/widgets.dart';

class AnimatedTextSpan {
  AnimatedTextSpan({
    required this.text,
    required this.style,
    this.transitionBuilder = AnimatedTextSpan.defaultTransition,
  });
  final String text;
  final TextStyle style;

  final Widget Function(Widget child, Animation<double> animation)
      transitionBuilder;

  static Widget defaultTransition(Widget child, Animation<double> animation) {
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }
}

class AnimatedText extends StatefulWidget {
  const AnimatedText({
    required this.spans,
    this.curve = Curves.linear,
    super.key,
    this.duration = const Duration(milliseconds: 60),
    this.textAlign = TextAlign.start,
  });

  final List<AnimatedTextSpan> spans;
  final Duration duration;
  final Curve curve;
  final TextAlign textAlign;

  @override
  State<AnimatedText> createState() => _AnimatedTextState();
}

class _AnimatedTextState extends State<AnimatedText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  int spanIndex = 0;
  int letterIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    startAnimation();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> startAnimation() async {
    spanIndex = 0;
    for (final span in widget.spans) {
      spanIndex++;

      for (final letter in span.text.characters.indexed) {
        letterIndex = letter.$1;

        if (mounted) {
          setState(() {});
          if (letter.$2.isEmpty) return;
          await _controller.forward(from: 0);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: widget.textAlign,
      text: TextSpan(
        children: [
          for (int i = 0; i <= spanIndex - 1; i++)
            if (spanIndex - 1 == i)
              for (int j = 0; j <= letterIndex; j++)
                if (j == letterIndex)
                  WidgetSpan(
                    child: widget.spans[i].transitionBuilder(
                      Text(
                        widget.spans[i].text[j],
                        style: widget.spans[i].style,
                      ),
                      CurvedAnimation(parent: _controller, curve: widget.curve),
                    ),
                  )
                else
                  TextSpan(
                    text: widget.spans[i].text[j],
                    style: widget.spans[i].style,
                  )
            else
              TextSpan(
                text: widget.spans[i].text,
                style: widget.spans[i].style,
              ),
        ],
      ),
    );
  }
}
