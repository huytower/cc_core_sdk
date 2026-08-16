import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/config/tokens/cc_base_colors.dart';
import '../../core/extensions/cc_context_extension.dart';
import '../../core/extensions/common/cc_responsive_extension.dart';
import '../../widgets/button/cc_base_btn.dart';
import '../../widgets/space/cc_space.dart';

class CcBodyShowMessage extends StatelessWidget {
  final Widget child;
  final String title;
  final String content;
  final VoidCallback? onTabOK;
  final bool isExistOK;
  final String? cancelText;
  final String? okText;

  const CcBodyShowMessage({
    Key? key,
    required this.child,
    this.content = '',
    this.title = '',
    this.onTabOK,
    this.isExistOK = false,
    this.cancelText,
    this.okText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.symmetric(
      vertical: context.respPadding(20.0),
      horizontal: context.respPadding(25.0),
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        title.isNotEmpty
            ? Container(
                margin: EdgeInsets.only(bottom: context.respPadding(15.0)),
                child: Text(
                  title,
                  style: context.ccTextTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              )
            : const SizedBox(),
        child,
        const CcSpaceLG(),
        SizedBox(
          height: context.respIconSize(baseSize: 40.0),
          child: Row(
            children: [
              !isExistOK
                  ? Expanded(
                      child: CcBaseBtn.bouncing(
                        onTap: () => Get.back(),
                        textColor: CcBaseColors.white100,
                        title: cancelText ?? 'Cancel',
                        bgColor: [
                          context.ccColorScheme.outline,
                          context.ccColorScheme.outline,
                        ],
                      ),
                    )
                  : const SizedBox(),
              if (!isExistOK) const CcSpaceSM(),
              Expanded(
                child: CcBaseBtn.bouncing(
                  onTap: onTabOK,
                  textColor: CcBaseColors.white100,
                  title: okText ?? 'OK',
                  bgColor: [
                    context.ccColorScheme.primary,
                    context.ccColorScheme.primary,
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
