import 'package:cc_sdk_ui/core/constants/cc_padding_params.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SectionTitleWidget extends StatelessWidget {
  const SectionTitleWidget({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(c) => title.isNotEmpty
      ? Container(
          width: Get.width,
          height: CcPaddingParams.SECTION_SM,
          margin: const EdgeInsets.only(
            bottom: 0,
            left: CcPaddingParams.SECTION_SM,
            right: CcPaddingParams.SECTION_SM,
            top: CcPaddingParams.SECTION_SM,
          ),
          child: RichText(
            text: TextSpan(
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
              text: title,
            ),
            maxLines: 1,
            textAlign: TextAlign.start,
          ),
        )
      : const SizedBox(height: CcPaddingParams.PAGE_MD);
}
