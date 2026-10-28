import 'package:cc_sdk_ui/export_cc_sdk_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

PreferredSizeWidget buildDomainGradientAppBar(
  BuildContext context, {
  required Widget title,
  List<Widget>? actions,
  Widget? bottom,
  Widget? leading,
  double toolbarHeight = kToolbarHeight,
}) {
  final topPadding = MediaQuery.of(context).padding.top;
  final horizontalPadding = context.respPadding(CcPaddingParams.PAGE_XS);
  final actualToolbarHeight = context.respDim(toolbarHeight);

  return PreferredSize(
    preferredSize: Size.fromHeight(
      actualToolbarHeight +
          topPadding +
          (bottom != null ? context.respDim(52) : 0),
    ),
    child: AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: context.isDarkMode
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
                      context.ccColorScheme.surface.withOpacity(0.28),
                      CcBaseColors.transparent,
                      context.ccColorScheme.onSurface.withOpacity(0.22),
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
                    (bottom != null ? context.respDim(52) : 0),
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
