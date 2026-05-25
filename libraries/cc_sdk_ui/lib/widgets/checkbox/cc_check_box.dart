import 'package:flutter/material.dart';

import '../../core/config/tokens/cc_base_colors.dart';

class CcCheckBox extends StatelessWidget {
  const CcCheckBox({
    Key? key,
    required this.isChecked,
    required this.onChanged,
  }) : super(key: key);

  final bool isChecked;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: () => onChanged(!isChecked),
    child: Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: isChecked ? CcBaseColors.info : Colors.transparent,
        border: Border.all(
          color: isChecked ? CcBaseColors.info : Colors.grey,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      child:
          isChecked
              ? const Icon(Icons.check, size: 16, color: Colors.white)
              : null,
    ),
  );
}
