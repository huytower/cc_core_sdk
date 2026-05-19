import 'package:cc_sdk_ui/core/theme/base_colors.dart';
import 'package:cc_sdk_ui/widgets/padding/cc_padding.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HorizontalLineWidget extends StatelessWidget {
  const HorizontalLineWidget({Key? key, this.flex, required this.height})
    : super(key: key);

  final int? flex;
  final double height;

  @override
  Flexible build(BuildContext context) => Flexible(
    flex: flex ?? 0,
    child: CcPadding(
      Container(color: BaseColors.neutral5, width: 1, height: height),
      0,
      0,
      10,
      0,
    ),
  );
}
