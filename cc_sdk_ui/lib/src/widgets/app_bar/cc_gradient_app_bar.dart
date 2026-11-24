import 'package:cc_sdk_ui/export_cc_sdk_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// The primary-gradient app bar of pages: [leading], an expanding [title] and
/// [actions] in one row, an optional [bottom] widget under it, drawn behind
/// the status bar (light status-bar icons).
///
/// Sizes scale with the window, so the bar is built from a [BuildContext]:
///
/// ```dart
/// Scaffold(
///   appBar: CcGradientAppBar.create(context, title: const Text('Wallets')),
/// )
/// ```
abstract final class CcGradientAppBar {
  /// Height added under the toolbar when [bottom] is given (design size).
  static const double bottomHeight = 52;

  static PreferredSizeWidget create(
    BuildContext context, {
    required Widget title,
    List<Widget>? actions,
    Widget? bottom,
    Widget? leading,
    double toolbarHeight = kToolbarHeight,
  }) {
    final topPadding = MediaQuery.paddingOf(context).top;
    final horizontalPadding = context.respPadding(CcPaddingParams.PAGE_XS);
    final actualToolbarHeight = context.respDim(toolbarHeight);

    return PreferredSize(
      preferredSize: Size.fromHeight(
        actualToolbarHeight +
            topPadding +
            (bottom != null ? context.respDim(bottomHeight) : 0),
      ),
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light.copyWith(
          statusBarColor: Colors.transparent,
          systemNavigationBarColor: Colors.transparent,
          systemNavigationBarIconBrightness: context.hasDarkMode
              ? Brightness.light
              : Brightness.dark,
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                context.ccColorScheme.primary,
                context.ccColorScheme.primaryContainer,
              ],
            ),
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        context.ccColorScheme.surface.withValues(alpha: 0.28),
                        CcBaseColors.transparent,
                        context.ccColorScheme.onSurface.withValues(alpha: 0.22),
                      ],
                      stops: const [0.0, 0.5, 1.0],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: topPadding,
                  left: horizontalPadding,
                  right: horizontalPadding,
                ),
                child: SizedBox(
                  height:
                      actualToolbarHeight +
                      (bottom != null ? context.respDim(bottomHeight) : 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          if (leading != null) ...[
                            leading,
                            SizedBox(
                              width: context.respPadding(
                                CcPaddingParams.SPACE_XS,
                              ),
                            ),
                          ],
                          Expanded(child: title),
                          ...?actions,
                        ],
                      ),
                      if (bottom != null) ...[const CcSpaceXS(), bottom],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
