import 'package:cc_sdk/core/utils/common/cc_device_utils.dart';
import 'package:cc_sdk/core/utils/common/cc_image_utils.dart';
import '../../core/config/tokens/cc_padding_params.dart';
import '../../core/config/tokens/base_colors.dart';
import 'cc_position.dart';
import '../button/cc_back_btn.dart';
import '../padding/cc_padding.dart';
import '../space/cc_space.dart';
import '../text/cc_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../flex/cc_flex.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({
    Key? key,
    this.onTapBack,
    this.onTapAtRightButton,
    this.bgAssetRes,
    required this.iconBackAssetRes,
    this.iconPageAssetRes,
    this.isBackButtonVisible = true,
    this.isRightButtonVisible = false,
    this.title = '',
    this.spaceHeader,
  }) : super(key: key);

  final VoidCallback? onTapBack, onTapAtRightButton;

  final String? bgAssetRes, iconBackAssetRes, iconPageAssetRes;

  final String title;

  final double? spaceHeader;

  final bool isBackButtonVisible, isRightButtonVisible;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /// Section : Background
        getBackgroundWidget(),

        /// Section : Title
        _buildHeaderContent(context),

        /// Section : Space
        const CcSpace(),
      ],
    );
  }

  Widget getBackgroundWidget() => bgAssetRes != null
      ? Image.asset(
          bgAssetRes!,
          height: 120,
          width: double.infinity,
          fit: BoxFit.fitWidth,
        )
      : const SizedBox();

  Widget _buildHeaderContent(BuildContext context) {
    return Stack(
      children: [
        /// Section : Icon Page, show at middle side
        getIconPageWidget(context),

        /// Section : Content
        CcRowStart(
          children: [
            /// Left side: Back button and title
            Expanded(
              child: CcRowStart(
                children: [
                  /// Space left
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final mediaQuery = MediaQuery.of(context);
                      final screenWidth = mediaQuery.size.width;
                      final bottomPadding = mediaQuery.padding.bottom;
                      final isLarge = DeviceUtils.isLargeScreen(
                        screenWidth: screenWidth,
                        bottomPadding: bottomPadding,
                      );
                      return SizedBox(width: isLarge ? 16.5 : 12.0);
                    },
                  ),

                  /// Back button
                  Opacity(
                    opacity: isBackButtonVisible ? 1.0 : 0.0,
                    child: CcBackAssetBtn(iconBackAssetRes!, onTap: onTapBack!),
                  ),

                  /// Title
                  Expanded(child: getTitlePageWidget()),
                ],
              ),
            ),

            /// Right side: Skip button
            getRightButtonWidget(),

            /// Space right
            const SizedBox(width: 15),
          ],
        ),
      ],
    );
  }

  Widget getRightButtonWidget() => onTapAtRightButton != null
      ? Positioned(
          top: 0,
          right: 0,
          bottom: 0,
          child: CcPadding(
            GestureDetector(
              onTap: onTapAtRightButton!,
              behavior: HitTestBehavior.translucent,
              child: const SizedBox(
                width: 103,
                height: 76,
                // color: Colors.red,
                child: Center(
                  child: CcText(
                    'Bỏ qua',
                    color: BaseColors.surfaceVariant,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    textAlign: TextAlign.center,
                    align: Alignment.center,
                  ),
                ),
              ),
            ),
            0,
            CcPaddingParams.PAGE_LG,
            0,
            0,
          ),
        )
      : const SizedBox();

  Widget getIconPageWidget(BuildContext context) => CcPositionBottom(
    bottom: getSpaceBottom(context),
    child: iconPageAssetRes != null
        ? getImageResWidget(iconPageAssetRes!)
        : const SizedBox(),
  );

  Widget getImageResWidget(String iconPageAssetRes) =>
      CcImageUtils.isSvg(iconPageAssetRes)
      ? SvgPicture.asset(iconPageAssetRes)
      : Image.asset(iconPageAssetRes, height: 35, fit: BoxFit.contain);

  double getSpaceBottom(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final bottomPadding = mediaQuery.padding.bottom;

    if (DeviceUtils.isLargeScreen(
      screenWidth: screenWidth,
      bottomPadding: bottomPadding,
    )) {
      return 3;
    } else if (DeviceUtils.isSmallScreen(screenWidth)) {
      return 6;
    } else {
      return 12;
    }
  }

  Widget getTitlePageWidget() => CcText(
    title,
    fontSize: 24,
    align: Alignment.center,
    textAlign: TextAlign.center,
    fontWeight: FontWeight.w500,
  );
}
