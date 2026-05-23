import 'dart:io';

import 'package:cc_sdk/core/helper/device_helper.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../config/tokens/base_colors.dart';

/// Widget utilities
class WidgetHelper {
  /// MUST set these orders, to avoid transparent with drop shadow issue
  static List<BoxShadow> getBoxShadows({
    Color? shadowColor,
    double? x,
    double? y,
    double? blurRadius,
    double? spreadRadius,
    Color? bgColor,
  }) => [
    /// 2 - drop background of child widget
    BoxShadow(
      color: shadowColor ?? BaseColors.textDisabled,
      spreadRadius: spreadRadius ?? 0.0,
      blurRadius: blurRadius ?? 3.0,
      offset: Offset(x ?? 2.0, y ?? 2.0),
    ),

    /// 1 - below background of child widget,
    BoxShadow(
      color: bgColor ?? Colors.white,
      spreadRadius: 0,
      blurRadius: 0,
      offset: Offset.zero,
    ),
  ];

  static BorderRadius getCircleBorderRadius() => BorderRadius.circular(45);

  /// Determines the appropriate BoxFit based on presentation dimensions
  ///
  /// [screenWidth] - The width of the presentation in logical pixels
  /// [bottomPadding] - The bottom padding from MediaQuery
  static BoxFit getBoxFitType({
    required double screenWidth,
    required double bottomPadding,
  }) {
    if (DeviceHelper.isLargeScreen(
      screenWidth: screenWidth,
      bottomPadding: bottomPadding,
    )) {
      return BoxFit.fill;
    }
    return BoxFit.cover;
  }

  static Widget getInkResponse(
    VoidCallback onTap, {
    VoidCallback? onTapUp,
    VoidCallback? onTapDown,
    VoidCallback? onLongPress,
    BorderRadius? borderRadius,
  }) {
    try {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          /// clipped splash
          onTap: onTap,
          // splashColor: BaseColors.white_30,
          splashColor: Platform.isAndroid
              ? BaseColors.neutral5
              : Colors.transparent,
          borderRadius: borderRadius ?? getCircleBorderRadius(),

          /// MUST define to avoid bug can not focus first item in list
          canRequestFocus: false,
          onTapDown: onTapDown != null ? (_) => onTapDown() : null,
          onTapCancel: onTapUp != null ? () => onTapUp() : null,
          onLongPress: onLongPress,
        ),
      );
    } catch (e) {
      // Return empty container on error to prevent crashes
      return const SizedBox.shrink();
    }
  }

  static Widget getInkResponsePadding(
    VoidCallback onTap, {
    BorderRadius? borderRadius,
    double? aspectRatio,
  }) {
    try {
      return AspectRatio(
        aspectRatio: aspectRatio ?? 16 / 9,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            /// clipped splash
            onTap: onTap,
            splashColor: Platform.isAndroid
                ? BaseColors.neutral5
                : Colors.transparent,
            // splashColor: BaseColors.black_5,
            borderRadius: borderRadius ?? getCircleBorderRadius(),

            /// MUST define to avoid bug can not focus first item in list
            canRequestFocus: false,
          ),
        ),
      );
    } catch (e) {
      // Return empty container on error to prevent crashes
      return const SizedBox.shrink();
    }
  }

  static BorderRadius getBorderRoundedLarge() => BorderRadius.circular(12);

  static BorderRadius getBorderRoundedSmall() => BorderRadius.circular(8);

  static BorderRadius getBorderRoundedSquareTopLeftRight() =>
      const BorderRadius.only(
        topLeft: Radius.circular(9),
        topRight: Radius.circular(9),
      );

  /// Light text span
  static TextSpan getTextSpanMontserrat(
    String text, {
    Color? color,
    double? fontSize,
    FontStyle? fontStyle,
    FontWeight? fontWeight,
    double? heightLine,
    GestureRecognizer? recognizer,
  }) => TextSpan(
    recognizer: recognizer,
    style: getTextStyleMontserrat(
      color: color,
      heightLine: heightLine,
      fontWeight: fontWeight,
      fontSize: fontSize,
      fontStyle: fontStyle,
    ),
    text: text,
  );

  /// Light text style
  static TextStyle getTextStyleMontserrat({
    Color? color,
    double? heightLine,
    FontWeight? fontWeight,
    double? fontSize,
    FontStyle? fontStyle,
  }) => GoogleFonts.montserrat(
    color: color ?? Colors.white,
    height: heightLine ?? 1.2,
    fontWeight: fontWeight ?? FontWeight.w400,
    fontSize: fontSize ?? 14.0,
    fontStyle: fontStyle ?? FontStyle.normal,
  );

  /// Special text span
  static TextSpan getTextSpanPacifico(
    String text, {
    Color? color,
    double? fontSize,
    FontStyle? fontStyle,
    FontWeight? fontWeight,
    double? heightLine,
    GestureRecognizer? recognizer,
  }) => TextSpan(
    recognizer: recognizer,
    style: getTextStylePacifico(
      color: color,
      heightLine: heightLine,
      fontWeight: fontWeight,
      fontSize: fontSize,
      fontStyle: fontStyle,
    ),
    text: text,
  );

  /// Special text style
  static TextStyle getTextStylePacifico({
    Color? color,
    double? heightLine,
    FontWeight? fontWeight,
    double? fontSize,
    FontStyle? fontStyle,
  }) => GoogleFonts.pacifico(
    color: color ?? Colors.white,
    height: heightLine ?? 1.2,
    fontWeight: fontWeight ?? FontWeight.w400,
    fontSize: fontSize ?? 14.0,
    fontStyle: fontStyle ?? FontStyle.normal,
  );

  /// Normal text span
  static TextSpan getTextSpanRoboto(
    String text, {
    Color? color,
    double? fontSize,
    FontStyle? fontStyle,
    FontWeight? fontWeight,
    double? heightLine,
    GestureRecognizer? recognizer,
  }) => TextSpan(
    recognizer: recognizer,
    style: getTextStyleRoboto(
      fontWeight: fontWeight,
      heightLine: heightLine,
      color: color,
      fontSize: fontSize,
      fontStyle: fontStyle,
    ),
    text: text,
  );

  static TextSpan getTextSpanMali(
    String text, {
    Color? color,
    double? fontSize,
    FontStyle? fontStyle,
    FontWeight? fontWeight,
    double? heightLine,
    GestureRecognizer? recognizer,
  }) => TextSpan(
    recognizer: recognizer,
    style: getTextStyleMali(
      fontWeight: fontWeight,
      heightLine: heightLine,
      color: color,
      fontSize: fontSize,
      fontStyle: fontStyle,
    ),
    text: text,
  );

  /// Normal text style
  static TextStyle getTextStyleRoboto({
    Color? color,
    double? heightLine,
    FontWeight? fontWeight,
    double? fontSize,
    FontStyle? fontStyle,
  }) => GoogleFonts.roboto(
    fontWeight: fontWeight ?? FontWeight.w400,
    height: heightLine ?? 1.2,
    color: color ?? Colors.white,
    fontSize: fontSize ?? 14,
    fontStyle: fontStyle ?? FontStyle.normal,
  );

  static TextStyle getTextStyleMali({
    Color? color,
    double? heightLine,
    FontWeight? fontWeight,
    double? fontSize,
    FontStyle? fontStyle,
  }) => GoogleFonts.mali(
    fontWeight: fontWeight ?? FontWeight.w400,
    height: heightLine ?? 1.2,
    color: color ?? Colors.white,
    fontSize: fontSize ?? 14,
    fontStyle: fontStyle ?? FontStyle.normal,
  );

  /// Check orientation is portrait|landscape?
  /// Returns null if context is not available
  static RxBool? isPortraitScreenMode() {
    try {
      final context = Get.context;
      if (context == null) return null;
      return context.isPortrait.obs;
    } catch (e) {
      return null;
    }
  }

  /// Check device has Notch
  /// ex. iphone x and above ...
  static bool isSafeScreenExisted(double paddingBottom, double viewPaddingTop) {
    return paddingBottom >= 20.0 || viewPaddingTop >= 40.0;
  }

  /// Scroll notification method, click
  static bool isScrollingClickEnd(ScrollNotification scrollState) =>
      scrollState is ScrollEndNotification;

  /// Scroll notification method, click
  static bool isScrollingClickStart(ScrollNotification scrollState) =>
      scrollState is ScrollStartNotification;

  /// Scroll notification method, while scrolling
  static bool isScrollingToEnd(ScrollNotification scrollState) =>
      scrollState is UserScrollNotification &&
      scrollState.direction == ScrollDirection.idle;

  /// Safely mark widget for rebuild after current frame
  /// Returns true if callback was scheduled successfully
  static bool markNeedsBuild(VoidCallback callback) {
    try {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        try {
          callback();
        } catch (e) {
          // Log error but don't crash
          debugPrint('Error in post frame callback: $e');
        }
      });
      return true;
    } catch (e) {
      debugPrint('Error scheduling post frame callback: $e');
      return false;
    }
  }

  /*
  * Logic : Must check Audio player is running or not, pause it if has
  * for video player can play as normal (avoid duplicate sound)
  * */
  static void pauseAudioPlayer(BuildContext context) {
    try {
      markNeedsBuild(() {
        try {
          // Pause existed Audio Player
          // Constants().getAudioPlayer().pause();

          // Then update Playing state on UI
          // AudioPlayerProvider a =
          //     Provider.of<AudioPlayerProvider>(context, listen: false);
          //
          // if (a != null && a.hasPlayingItem()) a.setPlayingStatus(false);
        } catch (e) {
          debugPrint('Error pausing audio player: $e');
        }
      });
    } catch (e) {
      debugPrint('Error in pauseAudioPlayer: $e');
    }
  }

  /*
  * Logic : Must check Video player is running or not, pause it if has
  * for Audio player can play as normal (avoid duplicate sound)
  * */
  static void pauseVideoPlayer() {
    try {
      // Notify Videos page about this modify
      markNeedsBuild(() {
        try {
          // if (videoPlayerProvider != null && videoPlayerProvider.hasBloc()) {
          //   videoPlayerProvider.bloc.seekToEnd();
          //
          //   videoPlayerProvider.bloc.pause();
          // }
        } catch (e) {
          debugPrint('Error pausing video player: $e');
        }
      });
    } catch (e) {
      debugPrint('Error in pauseVideoPlayer: $e');
    }
  }

  /// Set orientation : landscape || full-presentation mode
  /// Returns Future that completes when orientation is set
  static Future<void> setLandscape() async {
    try {
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    } catch (e) {
      debugPrint('Error setting landscape orientation: $e');
    }
  }

  /// Set orientation : [portrait || landscape] switching mode
  /// Returns Future that completes when orientation is set
  static Future<void> setOrientationDefault() async {
    try {
      await SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    } catch (e) {
      debugPrint('Error setting default orientation: $e');
    }
  }

  /// Set orientation : portrait || normal mode
  /// Returns Future that completes when orientation is set
  static Future<void> setPortrait() async {
    try {
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    } catch (e) {
      debugPrint('Error setting portrait orientation: $e');
    }
  }

  /// Make input scroll controller scroll to top
  /// Returns true if scroll was successful, false otherwise
  static bool scrollToTop(ScrollController scrollController) {
    try {
      if (scrollController.hasClients &&
          scrollController.position.hasContentDimensions) {
        scrollController.animateTo(
          0,
          curve: Curves.easeOut,
          duration: const Duration(milliseconds: 300),
        );
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}
