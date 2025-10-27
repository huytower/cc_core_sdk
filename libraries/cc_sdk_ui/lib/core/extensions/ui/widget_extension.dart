import 'package:flutter/material.dart';

extension WidgetExtension on Widget {
  Widget visibleWhen(bool condition()) {
    return Visibility(
      visible: condition(),
      child: this,
    );
  }
}
