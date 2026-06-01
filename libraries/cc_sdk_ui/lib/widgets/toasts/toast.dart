import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/extensions/cc_context_extension.dart';

class Toast {
  static const int LENGTH_SHORT = 1;
  static const int LENGTH_LONG = 2;
  static const int BOTTOM = 0;
  static const int CENTER = 1;
  static const int TOP = 2;

  static void show(
    String? msg,
    BuildContext context, {
    int duration = 1,
    int gravity = 0,
    Color? backgroundColor,
    Color? textColor,
    double backgroundRadius = 20,
    Border? border,
  }) {
    ToastView.dismiss();
    ToastView.createView(
      msg,
      context,
      duration,
      gravity,
      backgroundColor ?? context.ccColorScheme.surface.withOpacity(0.9),
      textColor ?? context.ccColorScheme.onSurface,
      backgroundRadius,
      border,
    );
  }
}

class ToastView {
  static final ToastView _singleton = ToastView._internal();
  factory ToastView() => _singleton;
  ToastView._internal();

  static OverlayState? overlayState;
  static OverlayEntry? _overlayEntry;
  static bool _isVisible = false;
  static int currentTime = 0;
  static Timer? timer;

  static void createView(
    String? msg,
    BuildContext context,
    int duration,
    int gravity,
    Color background,
    Color textColor,
    double backgroundRadius,
    Border? border,
  ) async {
    overlayState = Overlay.of(context);

    _overlayEntry = OverlayEntry(
      builder: (BuildContext context) => ToastWidget(
        widget: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: GestureDetector(
            onTap: () {
              dismiss();
              timer?.cancel();
            },
            child: Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width,
              child: Container(
                decoration: BoxDecoration(
                  color: background,
                  borderRadius: BorderRadius.circular(backgroundRadius),
                  border: border,
                ),
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                child: Text(
                  msg ?? '',
                  softWrap: true,
                  style: context.ccTextTheme.bodyMedium?.copyWith(color: textColor),
                ),
              ),
            ),
          ),
        ),
        gravity: gravity,
      ),
    );
    _isVisible = true;
    overlayState!.insert(_overlayEntry!);
    currentTime = duration;
    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 1), (timerCb) {
      currentTime--;
      if (currentTime <= 0) {
        timer!.cancel();
        dismiss();
      }
    });
  }

  static dismiss() async {
    if (!_isVisible) return;
    _isVisible = false;
    _overlayEntry?.remove();
  }
}

class ToastWidget extends StatelessWidget {
  const ToastWidget({Key? key, this.widget, this.gravity}) : super(key: key);

  final Widget? widget;
  final int? gravity;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 100,
      child: Material(color: Colors.transparent, child: widget),
    );
  }
}
