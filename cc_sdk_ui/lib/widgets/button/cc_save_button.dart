import 'package:flutter/material.dart';

import '../../export_cc_sdk_ui.dart';

class CcSaveButton extends StatelessWidget {
  const CcSaveButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.isLoading = false,
    this.widthFactor = 0.6,
  });

  final VoidCallback? onPressed;
  final String label;
  final bool isLoading;
  final double widthFactor;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FractionallySizedBox(
        widthFactor: widthFactor,
        child: SizedBox(
          height: context.respDim(40),
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: context.ccColorScheme.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: isLoading
                ? SizedBox(
                    width: context.respDim(20),
                    height: context.respDim(20),
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: context.ccColorScheme.onPrimary,
                    ),
                  )
                : CcText(
                    label,
                    align: Alignment.center,
                    textAlign: TextAlign.center,
                    textStyle: context.ccTextTheme.titleMedium?.copyWith(
                      color: context.ccColorScheme.onPrimary,
                      fontWeight: CcTypographyParams.bold,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
