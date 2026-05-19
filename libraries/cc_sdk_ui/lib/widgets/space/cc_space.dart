import 'package:flutter/widgets.dart';

import '../../core/constants/cc_padding_params.dart';

class CcSpace extends StatelessWidget {
  const CcSpace({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => const SizedBox(
        height: CcPaddingParams.SPACE_MD,
        width: CcPaddingParams.SPACE_MD,
      );
}

class CcSpaceFooter extends StatelessWidget {
  const CcSpaceFooter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => const SizedBox(
        height: CcPaddingParams.SPACE_XL * 3,
      );
}

class CcSpaceFooterAppName extends StatelessWidget {
  const CcSpaceFooterAppName({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => const SizedBox(
        height: CcPaddingParams.SPACE_XL,
      );
}

class CcSpaceHeader extends StatelessWidget {
  const CcSpaceHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => const SizedBox(
        height: CcPaddingParams.SPACE_XL * 2,
      );
}

class CcSpaceLarge extends StatelessWidget {
  const CcSpaceLarge({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => const SizedBox(
        height: CcPaddingParams.SPACE_LG,
        width: CcPaddingParams.SPACE_LG,
      );
}

class CcSpaceSmall extends StatelessWidget {
  const CcSpaceSmall({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => const SizedBox(
        height: CcPaddingParams.SPACE_SM,
        width: CcPaddingParams.SPACE_SM,
      );
}

class CcSpaceSmallest extends StatelessWidget {
  const CcSpaceSmallest({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => const SizedBox(
        height: CcPaddingParams.SPACE_XS,
        width: CcPaddingParams.SPACE_XS,
      );
}
