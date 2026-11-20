import 'package:flutter/widgets.dart';

/// Makes a fixed-height layout (typically a bottom sheet's content) scroll
/// when the window is in **landscape**, where there is far less vertical room
/// (a tablet held sideways is ~600–800 dp tall) and the content would
/// otherwise overflow.
///
/// Portrait is returned untouched, so existing sheet layouts and their drag
/// gestures are unchanged there. Use it only around content without vertical
/// `Expanded`/`Flexible` (they need a bounded height); content that already
/// scrolls inside does not need it.
class CcLandscapeScrollable extends StatelessWidget {
  const CcLandscapeScrollable({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.orientationOf(context) != Orientation.landscape) {
      return child;
    }
    return SingleChildScrollView(child: child);
  }
}
