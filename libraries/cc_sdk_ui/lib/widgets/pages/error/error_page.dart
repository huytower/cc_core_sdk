import 'package:flutter/material.dart';

import '../../../core/config/tokens/cc_base_colors.dart';
import '../../../core/helper/cc_widget_helper.dart';
import '../../button/cc_back_btn.dart';
import '../../button/cc_debounce_widget.dart';
import '../../flex/cc_flex.dart';
import '../../space/cc_space.dart';
import '../../text/cc_text.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({Key? key, this.message = 'An error occurred', this.onRetry})
    : super(key: key);

  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      leading: CcBackBtn(
        onPress: () => Navigator.of(context).pop(),
        icon: Icons.arrow_back,
      ),
      title: const CcText('Error'),
    ),
    body: CcColCenter(
      children: [
        const Icon(Icons.error_outline, size: 80, color: CcBaseColors.errorRed),
        const CcSpaceLG(),
        CcText(
          message,
          fontSize: 16,
          color: CcBaseColors.textSecondary,
          textAlign: TextAlign.center,
        ),
        const CcSpaceLG(),
        if (onRetry != null)
          CcDebounce(
            onTap: onRetry!,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: CcBaseColors.brand500,
                borderRadius: CcWidgetHelper.getBorderRoundedSmall(),
              ),
              child: const CcText(
                'Retry',
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
      ],
    ),
  );
}
