import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/helper/widget_helper.dart';
import '../../../core/theme/base_colors.dart';

class PageError extends StatelessWidget {
  final VoidCallback onTapReload;
  final String? assetIcon;

  const PageError({super.key, required this.onTapReload, this.assetIcon});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.maxFinite,
      width: double.maxFinite,
      child: GestureDetector(
        onTap: onTapReload,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: Get.width - 50,
              width: Get.width - 50,
              decoration: BoxDecoration(
                border: Border.all(color: BaseColors.divider, width: 1),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (assetIcon != null)
                    Image.asset(assetIcon!, width: 100, fit: BoxFit.fitWidth),
                  const SizedBox(height: 15),
                  Text(
                    "Đã xảy ra lỗi",
                    style: WidgetHelper.getTextStyleRoboto(
                      fontSize: 20,
                      color: BaseColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Nhấn vào đây để tải lại",
                    style: WidgetHelper.getTextStyleRoboto(
                      fontSize: 20,
                      color: BaseColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
