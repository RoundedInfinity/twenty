// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:fluent_ui/fluent_ui.dart';
import 'package:window_manager/window_manager.dart';

class WindowButtons extends StatelessWidget {
  const WindowButtons({required this.onClose, super.key});

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final theme = FluentTheme.of(context);

    return SizedBox(
      height: 48,
      child: CustomWindowCaption(
        brightness: theme.brightness,
        backgroundColor: Colors.transparent,
        onClose: onClose,
      ),
    );
  }
}

class CustomWindowCaption extends StatefulWidget {
  const CustomWindowCaption({
    required this.onClose,
    super.key,
    this.title,
    this.backgroundColor,
    this.brightness,
  });

  final Widget? title;
  final Color? backgroundColor;
  final Brightness? brightness;

  final VoidCallback onClose;

  @override
  State<CustomWindowCaption> createState() => _CustomWindowCaptionState();
}

class _CustomWindowCaptionState extends State<CustomWindowCaption>
    with WindowListener {
  @override
  void initState() {
    windowManager.addListener(this);
    super.initState();
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: widget.backgroundColor ??
            (widget.brightness == Brightness.dark
                ? const Color(0xff1C1C1C)
                : Colors.transparent),
      ),
      child: Row(
        children: [
          Expanded(
            child: DragToMoveArea(
              child: SizedBox(
                height: double.infinity,
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.only(left: 16),
                      child: DefaultTextStyle(
                        style: TextStyle(
                          color: widget.brightness == Brightness.light
                              ? Colors.black.withOpacity(0.8956)
                              : Colors.white,
                          fontSize: 14,
                        ),
                        child: widget.title ?? Container(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          WindowCaptionButton.minimize(
            brightness: widget.brightness,
            onPressed: () async {
              final isMinimized = await windowManager.isMinimized();
              if (isMinimized) {
                await windowManager.restore();
              } else {
                await windowManager.minimize();
              }
            },
          ),
          FutureBuilder<bool>(
            future: windowManager.isMaximized(),
            builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
              if (snapshot.data != null && snapshot.data! == true) {
                return WindowCaptionButton.unmaximize(
                  brightness: widget.brightness,
                  onPressed: windowManager.unmaximize,
                );
              }
              return WindowCaptionButton.maximize(
                brightness: widget.brightness,
                onPressed: windowManager.maximize,
              );
            },
          ),
          WindowCaptionButton.close(
            brightness: widget.brightness,
            onPressed: widget.onClose,
          ),
        ],
      ),
    );
  }

  @override
  void onWindowMaximize() {
    setState(() {});
  }

  @override
  void onWindowUnmaximize() {
    setState(() {});
  }
}
