import 'package:cc_sdk/core/extensions/common/cc_when_expression.dart';
import 'package:cc_sdk_ui/widgets/pull_to_refresh/cc_refresh_indicator.dart';
import 'package:cc_sdk_ui/widgets/pull_to_refresh/cc_refresh_indicator_icon.dart';
import 'package:cc_sdk_ui/widgets/space/cc_space.dart';
import 'package:cc_sdk_ui/widgets/text/cc_text.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:theme/data/data_source/asset/assets_data_source.dart';

/// POPULAR MIXIN
/// - Pull to refresh
/// is best for tracking
/// - Firebase Analytics
/// via state
/// - drag, load, complete ...
///
mixin CcPullRefreshMixin {
  /// Get the path to a Lottie animation asset
  ///
  /// [resId] The Lottie asset identifier
  String getAssetIconJson({required LottieAsset resId}) {
    return AssetUtils.getLottie(resId);
  }

  Widget buildIcComplete(Widget? iconCompleteWidget) {
    return iconCompleteWidget ??
        Lottie.asset(getAssetIconJson(resId: LottieAsset.complete), height: 35);
  }

  Column buildIcLoading(Widget? loadingLabelWidget) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const CcSpaceSM(),
        Lottie.asset(getAssetIconJson(resId: LottieAsset.loading), height: 35),
        const CcSpaceXS(),
        loadingLabelWidget ??
            const CcText(
              'Đang cập nhật',
              color: Colors.grey,
              textAlign: TextAlign.center,
              align: Alignment.center,
            ),
      ],
    );
  }

  Widget buildPullToRefresh({
    CcIndicatorController? controller,
    Future<void> Function()? onCancel,
    Widget? icCompleteWidget,
    Widget? icLoadingWidget,
    required Future<void> Function() onRefresh,
    required Widget child,
    double? imageSize,
    double? indicatorSize,
  }) {
    return CcCustomRefreshIndicator(
      completeStateDuration: const Duration(milliseconds: 100),
      controller: controller,
      onCancel: onCancel,
      onRefresh: onRefresh,
      onStateChanged: buildIndicatorChangeStatus,
      builder:
          (
            BuildContext context,
            Widget child,
            CcIndicatorController controller,
          ) => getBuilder(
            child: child,
            controller: controller,
            imageSize: imageSize,
            indicatorSize: indicatorSize,
            icCompleteWidget: icCompleteWidget,
            icLoadingWidget: icLoadingWidget,
          ),
      child: child,
    );
  }

  void buildIndicatorChangeStatus(IndicatorStateChange changeStatus) {
    // 'buildPullRefresh : onStateChanged() = $changeStatus'.Log();

    ccWhen(
      variable: changeStatus,
      conditions: {
        IndicatorState.dragging: () {},
        IndicatorState.loading: () {},
        IndicatorState.complete: () {},
      },
    );
  }

  CcRefreshIndicatorIcon getBuilder({
    Widget? icCompleteWidget,
    Widget? icLoadingWidget,
    double? imageSize,
    double? indicatorSize,
    required CcIndicatorController controller,
    required Widget child,
  }) {
    return CcRefreshIndicatorIcon(
      controller: controller,
      imageSize: imageSize ?? 70,
      indicatorSize: indicatorSize ?? 70,
      icLoadingWidget: buildIcLoading(icLoadingWidget),
      icCompleteWidget: buildIcComplete(icCompleteWidget),
      child: child,
    );
  }
}
