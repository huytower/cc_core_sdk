import 'package:flutter/material.dart';

import 'cc_fade_widget.dart';

/// A wrapper widget that applies fade animation to page content.
/// Use this to wrap page content for fade-in effect when page loads.
class CcFadePageWrapper extends StatefulWidget {
  final Widget child;

  const CcFadePageWrapper({super.key, required this.child});

  @override
  State<CcFadePageWrapper> createState() => _CcFadePageWrapperState();
}

class _CcFadePageWrapperState extends State<CcFadePageWrapper>
    with SingleTickerProviderStateMixin {
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    // Trigger fade-in animation after widget is built
    Future.delayed(const Duration(milliseconds: 50), () {
      if (mounted) {
        setState(() {
          _visible = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return CcFadeWidget(visible: _visible, child: widget.child);
  }
}
