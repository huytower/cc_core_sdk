import 'package:flutter/widgets.dart';

import 'cc_orientation_policy.dart';

/// Re-applies [CcOrientationPolicy.apply] whenever the window size changes,
/// for example a foldable switching between its cover screen (phone: portrait
/// only) and its inner screen (tablet: free rotation), or split screen
/// resizing the app.
///
/// Place it above anything that overrides [MediaQuery] (typically in
/// `MaterialApp.builder`) so it sees the real window size. Apply the policy
/// once before `runApp` too, so the first frame already has the right
/// orientation.
///
/// ```dart
/// MaterialApp(
///   builder: (context, child) => CcOrientationPolicyScope(child: child!),
/// )
/// ```
class CcOrientationPolicyScope extends StatefulWidget {
  const CcOrientationPolicyScope({super.key, required this.child});

  final Widget child;

  @override
  State<CcOrientationPolicyScope> createState() =>
      _CcOrientationPolicyScopeState();
}

class _CcOrientationPolicyScopeState extends State<CcOrientationPolicyScope> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    CcOrientationPolicy.apply(MediaQuery.sizeOf(context));
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
