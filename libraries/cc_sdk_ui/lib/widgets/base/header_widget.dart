import 'package:cc_sdk/core/helper/cc_device_helper.dart';
import 'package:cc_sdk/core/helper/cc_image_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../core/config/tokens/cc_padding_params.dart';
import '../button/cc_back_btn.dart';
import '../padding/cc_padding.dart';
import '../space/cc_space.dart';
import '../text/cc_text.dart';
import 'cc_position.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({
    Key? key,
    this.onTapBack,
    this.onTapAtRightButton,
    this.iconBackAssetRes,
    this.iconPageAssetRes,
    this.isBackButtonVisible = true,
    required this.title,
  }) : super(key: key);

  final VoidCallback? onTapBack, onTapAtRightButton;

  final String? iconBackAssetRes, iconPageAssetRes;

  final bool isBackButtonVisible;

  final String title;

  @override
  Widget build(BuildContext context) => Stack(
    children: [
      /// icon page (ex. : News logo, ...)
      getIconPageWidget(context),

      /// header body
      Row(
        children: [
          const CcSpaceLG(),
          SizedBox(
            height: 76,
            child: Row(
              children: [
                /// Space left
                LayoutBuilder(
                  builder: (context, constraints) {
                    final mediaQuery = MediaQuery.of(context);
                    final screenWidth = mediaQuery.size.width;
                    final bottomPadding = mediaQuery.padding.bottom;
                    final isLarge = CcDeviceHelper.isLargeScreen(
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
          getRightButtonWidget(context),

          /// Space right
          const SizedBox(width: 15),
        ],
      ),
    ],
  );

  Widget getRightButtonWidget(BuildContext context) =>
      onTapAtRightButton != null
      ? Positioned(
          top: 0,
          right: 0,
          bottom: 0,
          child: CcPadding(
            GestureDetector(
              onTap: onTapAtRightButton!,
              behavior: HitTestBehavior.translucent,
              child: SizedBox(
                width: 103,
                height: 76,
                child: Center(
                  child: CcText(
                    'Bỏ qua',
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
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
      CcImageHelper.isSvg(iconPageAssetRes)
      ? SvgPicture.asset(iconPageAssetRes)
      : Image.asset(iconPageAssetRes, height: 35, fit: BoxFit.contain);

  double getSpaceBottom(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final bottomPadding = mediaQuery.padding.bottom;

    if (CcDeviceHelper.isLargeScreen(
      screenWidth: screenWidth,
      bottomPadding: bottomPadding,
    )) {
      return 3;
    } else if (CcDeviceHelper.isSmallScreen(screenWidth)) {
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
