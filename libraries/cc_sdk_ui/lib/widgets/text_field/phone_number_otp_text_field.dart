import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/config/tokens/cc_base_colors.dart';

class PhoneNumberOtpTextField extends StatelessWidget {
  const PhoneNumberOtpTextField({
    super.key,
    required this.controller,
    this.onChanged,
    this.colorDivider,
  });

  final TextEditingController controller;
  final Function(String)? onChanged;
  final Color? colorDivider;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: controller,
          onChanged: onChanged,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(6),
          ],
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: 8,
          ),
          decoration: const InputDecoration(
            border: InputBorder.none,
            hintText: '******',
            hintStyle: TextStyle(color: Colors.grey),
          ),
        ),
        Container(
          height: 1,
          width: double.infinity,
          color: colorDivider ?? CcBaseColors.surfaceVariant,
        ),
      ],
    );
  }
}
