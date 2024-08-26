import 'package:fluent_ui/fluent_ui.dart';

/// A rounded toast widget.
class ToastContent extends StatelessWidget {
  const ToastContent({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final color = FluentTheme.of(context).micaBackgroundColor;
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: const EdgeInsets.only(top: 32),
        child: Container(
          height: 72,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: color,
            border: Border.all(color: Colors.black.withOpacity(0.2)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.14),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}
