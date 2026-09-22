import 'package:flutter/material.dart';

import '../../core/config/tokens/cc_base_colors.dart';
import '../../core/extensions/cc_context_extension.dart';
import '../../core/extensions/common/cc_responsive_extension.dart';
import '../../widgets/button/cc_base_btn.dart';
import '../../widgets/space/cc_space.dart';

class CcBodyShowMessage extends StatelessWidget {
  final Widget child;
  final String title;
  final VoidCallback? onConfirm;
  final bool isOnlyConfirm;
  final String? cancelText;
  final String? confirmText;

  const CcBodyShowMessage({
    Key? key,
    required this.child,
    this.title = '',
    this.onConfirm,
    this.isOnlyConfirm = false,
    this.cancelText,
    this.confirmText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => SafeArea(
    top: false,
    child: Container(
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
                if (!isOnlyConfirm) ...[
                  Expanded(
                    child: CcBaseBtn.bouncing(
                      onTap: () => Navigator.of(context).pop(false),
                      textColor: CcBaseColors.white100,
                      title: cancelText ?? 'Cancel',
                      bgColor: [
                        context.ccColorScheme.outline,
                        context.ccColorScheme.outline,
                      ],
                    ),
                  ),
                  const CcSpaceSM(),
                ],
                Expanded(
                  child: CcBaseBtn.bouncing(
                    onTap: onConfirm,
                    textColor: CcBaseColors.white100,
                    title: confirmText ?? 'OK',
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
    ),
  );
}
