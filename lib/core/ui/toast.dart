import 'package:flutter/material.dart';

class MFToast extends StatefulWidget {
  final Widget child;

  const MFToast({required this.child});

  @override
  MWToastState createState() {
    return MWToastState();
  }

  static MWToastState of(BuildContext context) {
    final MWToastState toastState =
        context.findRootAncestorStateOfType<MWToastState>()!;
    toastState._setCurrentContext(context);
    return toastState;
  }
}

class MWToastState extends State<MFToast> with SingleTickerProviderStateMixin {
  OverlayEntry? _overlayEntry;
  late BuildContext _currentContext;
  late AnimationController controller;
  late Animation<Offset> offset;
  late bool _toastInProgress;
  late bool _dismissInProgress;

  static const double TOAST_CONTAINER_HEIGHT = 75.0;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    _toastInProgress = false;
    _dismissInProgress = false;

    offset = Tween<Offset>(begin: Offset.zero, end: Offset(0.0, 0.1))
        .animate(controller);
  }

  @override
  Widget build(BuildContext context) {
    return _MeoWoofToast(
      child: widget.child,
    );
  }

  Future showToast(
      {required Color color,
      String? message,
      Widget? child,
      Duration? duration,
      VoidCallback? onDismissed}) async {
    if (_toastInProgress) return;
    _toastInProgress = true;
    _overlayEntry = _createOverlayEntryFromTop(
        color: color, message: message, onDismissed: onDismissed, child: child);
    final overlay = Overlay.of(_currentContext);
    if (_overlayEntry != null) {
      WidgetsBinding.instance!
          .addPostFrameCallback((_) => overlay?.insert(_overlayEntry!));
    }
    await controller.forward();

    await _dismissToastAfterDelay(duration ?? const Duration(seconds: 1));
  }

  Future _dismissToastAfterDelay(Duration duration) async {
    await Future.delayed(duration);
    if (_toastInProgress && !_dismissInProgress) {
      await _dismissToast();
    }
  }

  Future _dismissToast() async {
    await controller.reverse();
    _overlayEntry?.remove();
    _overlayEntry = null;
    _dismissInProgress = false;
    _toastInProgress = false;
  }

  OverlayEntry _createOverlayEntryFromTop(
      {required Color color,
      String? message,
      Widget? child,
      VoidCallback? onDismissed}) {
    return OverlayEntry(builder: (context) {
      final MediaQueryData existingMediaQuery = MediaQuery.of(context);
      // 44 is header height
      final double paddingTop = existingMediaQuery.padding.top + 44;

      return Stack(children: [
        Positioned(
            left: 0,
            width: existingMediaQuery.size.width,
            child: GestureDetector(
              onTap: () {
                if (_dismissInProgress) return;
                _dismissInProgress = true;
                if (onDismissed != null) onDismissed();
                _dismissToast();
              },
              child: _buildToast(
                  paddingTop: paddingTop,
                  color: color,
                  message: message,
                  child: child),
            ))
      ]);
    });
  }

  Widget _buildToast(
      {required double paddingTop,
      required Color color,
      String? message,
      Widget? child}) {
    return Material(
      color: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            children: <Widget>[
              Flexible(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: paddingTop),
                      child: SlideTransition(
                        position: offset,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Flexible(
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                    vertical: 20, horizontal: 20),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 10),
                                decoration: BoxDecoration(
                                    color: color,
                                    borderRadius: BorderRadius.circular(50)),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    child ??
                                        Flexible(
                                          child: Text(
                                            message ?? 'Just a toast',
                                            style: const TextStyle(
                                                color: Colors.white),
                                            textAlign: TextAlign.center,
                                          ),
                                        )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  void _setCurrentContext(BuildContext context) {
    setState(() {
      _currentContext = context;
    });
  }
}

class _MeoWoofToast extends InheritedWidget {
  const _MeoWoofToast({Key? key, required Widget child})
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(_MeoWoofToast old) {
    return true;
  }
}
