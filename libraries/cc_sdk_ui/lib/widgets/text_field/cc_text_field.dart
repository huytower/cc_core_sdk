import 'package:flutter/material.dart';

import '../../core/config/tokens/cc_base_colors.dart';
import '../../core/config/tokens/cc_padding_params.dart';

class CcTextField extends StatelessWidget {
  const CcTextField({
    super.key,
    required this.controller,
    this.hintText,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.prefixIcon,
    this.suffixIcon,
    this.onChanged,
    this.validator,
  });

  final TextEditingController controller;
  final String? hintText;
  final bool obscureText;
  final TextInputType keyboardType;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: CcPaddingParams.PAGE_MD),
      decoration: BoxDecoration(
        color: CcBaseColors.white100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: CcBaseColors.neutral10),
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        onChanged: onChanged,
        validator: validator,
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: CcPaddingParams.PAGE_MD,
            vertical: 12,
          ),
          border: InputBorder.none,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      ),
    );
  }
}
