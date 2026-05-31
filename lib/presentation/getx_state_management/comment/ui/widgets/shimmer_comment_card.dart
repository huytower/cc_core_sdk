import 'package:cc_sdk_ui/export_cc_sdk_ui.dart';
import 'package:flutter/material.dart';

class ShimmerCommentCard extends StatelessWidget {
  const ShimmerCommentCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: CcPaddingParams.PAGE_XS,
        vertical: CcPaddingParams.SPACE_SM,
      ),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(CcPaddingParams.SPACE_MD),
        ),
        child: Padding(
          padding: const EdgeInsets.all(CcPaddingParams.SPACE_LG),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CcShimmer(
                width: double.infinity,
                height: 20,
                borderRadius: BorderRadius.circular(CcPaddingParams.SPACE_XS),
              ),
              const CcSpaceSM(),
              CcShimmer(
                width: 200,
                height: 14,
                borderRadius: BorderRadius.circular(CcPaddingParams.SPACE_XS),
              ),
              const CcSpaceSM(),
              CcShimmer(
                width: double.infinity,
                height: 14,
                borderRadius: BorderRadius.circular(CcPaddingParams.SPACE_XS),
              ),
              const CcSpaceXS(),
              CcShimmer(
                width: double.infinity,
                height: 14,
                borderRadius: BorderRadius.circular(CcPaddingParams.SPACE_XS),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
