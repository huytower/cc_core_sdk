import 'package:flutter/widgets.dart';

import 'cc_reference_window.dart';

/// Representative windows, in dp, that every screen built on this design
/// system should lay out on without overflow: each Material 3 width class,
/// phones, foldables, Android 7"/10" tablets, the iPad range and a desktop
/// window. Shared so every app tests against the same matrix.
///
/// Notes on the sizes:
/// - There is no 7" iPad; the smallest is the iPad mini (744 dp wide), which
///   sits above the 720 dp "small tablet" bound of `CcTwoColumn`.
/// - 10–11" tablets held upright (800–834 dp) are a *medium* window; only a
///   12.9–13" iPad is *expanded* in portrait.
abstract final class CcReferenceWindows {
  static const smallPhone = CcReferenceWindow('small phone', Size(320, 640));
  static const phone = CcReferenceWindow('phone', Size(390, 844));
  static const largePhone = CcReferenceWindow('large phone', Size(430, 932));
  static const foldCover = CcReferenceWindow('fold cover', Size(344, 882));
  static const foldInner = CcReferenceWindow('fold inner', Size(673, 841));
  static const tablet7 = CcReferenceWindow('7in tablet', Size(600, 960));
  static const tablet10 = CcReferenceWindow('10in tablet', Size(800, 1280));
  static const iPadMini = CcReferenceWindow('iPad mini', Size(744, 1133));
  static const iPad11 = CcReferenceWindow('iPad 11in', Size(834, 1194));
  static const iPad13 = CcReferenceWindow('iPad 13in', Size(1024, 1366));

  /// iPad Split View, one app on a third of a landscape 11" iPad.
  static const iPadSplitThird = CcReferenceWindow(
    'iPad split view 1/3',
    Size(375, 834),
  );
  static const webDesktop = CcReferenceWindow('web desktop', Size(1440, 900));

  /// Upright windows.
  static const portrait = [
    smallPhone,
    phone,
    largePhone,
    foldCover,
    foldInner,
    tablet7,
    tablet10,
    iPadMini,
    iPad11,
    iPad13,
    iPadSplitThird,
  ];

  /// Sideways windows: tablets and unfolded foldables rotate; phones are
  /// included because an app may not lock them to portrait.
  static final landscape = [
    tablet7.landscape,
    tablet10.landscape,
    iPadMini.landscape,
    iPad11.landscape,
    iPad13.landscape,
    foldInner.landscape,
    phone.landscape,
  ];

  /// Everything, including a desktop / web window.
  static final all = [...portrait, ...landscape, webDesktop];
}
