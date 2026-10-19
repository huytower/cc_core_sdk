import 'package:easy_localization/easy_localization.dart' as el;
import 'package:flutter/material.dart';

import '../../export_cc_sdk_ui.dart';

class CcNameInputField extends StatelessWidget {
  const CcNameInputField({
    super.key,
    required this.controller,
    this.labelText,
    required this.hintText,
    this.errorText,
    this.onClear,
    this.onTap,
    this.maxLength = 30,
    this.showMaxLengthWarning = true,
  });

  final TextEditingController controller;
  final String? labelText;
  final String hintText;
  final String? errorText;
  final VoidCallback? onClear;
  final VoidCallback? onTap;
  final int maxLength;
  final bool showMaxLengthWarning;

  @override
  Widget build(BuildContext context) {
    final textStyle = context.ccTextTheme.bodyMedium?.copyWith(
      color: context.ccColorScheme.onSurface,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        ListenableBuilder(
          listenable: controller,
          builder: (context, _) {
            final hasValue = controller.text.isNotEmpty;
            final isAtMax = controller.text.length >= maxLength;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: controller,
                  maxLength: maxLength,
                  style: textStyle,
                  cursorColor: context.ccColorScheme.primary,
                  onTap: onTap,
                  decoration: InputDecoration(
                    counterText: '',
                    labelText: labelText,
                    hintText: hintText,
                    hintStyle: context.ccTextTheme.labelSmall?.copyWith(
                      color: context.ccColorScheme.onSurfaceVariant.withAlpha(
                        120,
                      ),
                    ),
                    labelStyle: context.ccTextTheme.labelSmall?.copyWith(
                      color: context.ccColorScheme.onSurfaceVariant.withAlpha(
                        120,
                      ),
                    ),
                    filled: true,
                    fillColor: context.ccColorScheme.surfaceVariant.withAlpha(
                      80,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: context.brMd,
                      borderSide: BorderSide(
                        color: context.ccColorScheme.outlineVariant.withAlpha(
                          20,
                        ),
                        width: 0.5,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: context.brMd,
                      borderSide: BorderSide(
                        color: context.ccColorScheme.outlineVariant.withAlpha(
                          20,
                        ),
                        width: 0.5,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: context.brMd,
                      borderSide: BorderSide(
                        color: context.ccColorScheme.primary.withOpacity(0.5),
                        width: context.respDim(1),
                      ),
                    ),
                    suffixIcon: hasValue
                        ? CcIconButton.bouncing(
                            width: context.respDim(20),
                            height: context.respDim(20),
                            icon: Icon(
                              Icons.close_rounded,
                              color: context.ccColorScheme.onSurfaceVariant
                                  .withAlpha(120),
                              size: context.respIconSize(baseSize: 14),
                            ),
                            onTap: () {
                              controller.clear();
                              onClear?.call();
                            },
                            tooltip: el.tr(CcLocaleKeys.common_clear),
                          )
                        : null,
                  ),
                ),
                if (errorText != null) ...[
                  const CcSpaceXS(),
                  Padding(
                    padding: EdgeInsets.only(left: context.respPadding(4)),
                    child: CcText(
                      errorText!,
                      textStyle: context.ccTextTheme.labelSmall?.copyWith(
                        color: context.ccColorScheme.error,
                      ),
                    ),
                  ),
                ] else if (showMaxLengthWarning && isAtMax) ...[
                  const CcSpaceXS(),
                  Padding(
                    padding: EdgeInsets.only(left: context.respPadding(4)),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.warning_amber_rounded,
                          size: context.respIconSize(baseSize: 14),
                          color: context.ccColorScheme.tertiary,
                        ),
                        const CcSpaceXS(),
                        CcText(
                          el.tr(
                            CcLocaleKeys.validation_max_length_reached,
                            namedArgs: {'count': '$maxLength'},
                          ),
                          textStyle: context.ccTextTheme.labelSmall?.copyWith(
                            color: context.ccColorScheme.tertiary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            );
          },
        ),
      ],
    );
  }
}
