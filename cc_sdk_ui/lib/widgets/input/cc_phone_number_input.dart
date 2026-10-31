import 'package:easy_localization/easy_localization.dart' as el;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../export_cc_sdk_ui.dart';

class CcPhoneNumberInput extends StatelessWidget {
  const CcPhoneNumberInput({
    super.key,
    required this.countryCode,
    required this.onCountryCodeTap,
    required this.controller,
    required this.hintText,
    this.labelText,
    this.errorText,
    this.onClear,
    this.keyboardType = TextInputType.phone,
    this.inputFormatters,
  });

  final String countryCode;
  final VoidCallback onCountryCodeTap;
  final TextEditingController controller;
  final String hintText;
  final String? labelText;
  final String? errorText;
  final VoidCallback? onClear;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;

  static final _defaultFormatters = [FilteringTextInputFormatter.digitsOnly];

  @override
  Widget build(BuildContext context) {
    final textStyle = context.ccTextTheme.bodyMedium?.copyWith(
      color: context.ccColorScheme.onSurface,
    );

    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final hasValue = controller.text.isNotEmpty;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                CcCountryCodeSelector(
                  countryCode: countryCode,
                  onTap: onCountryCodeTap,
                ),
                SizedBox(width: context.respPadding(CcPaddingParams.DESC_MD)),
                Expanded(
                  child: TextField(
                    controller: controller,
                    keyboardType: keyboardType,
                    inputFormatters: inputFormatters ?? _defaultFormatters,
                    style: textStyle,
                    cursorColor: context.ccColorScheme.primary,
                    decoration: InputDecoration(
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
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: context.respPadding(
                          CcPaddingParams.DESC_MD,
                        ),
                        vertical: context.respPadding(CcPaddingParams.DESC_MD),
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
                ),
              ],
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
            ],
          ],
        );
      },
    );
  }
}
