import 'package:flutter/widgets.dart';

import '../../core/constants/cc_padding_params.dart';

/// Extra Small Space (4pt)
class CcSpaceXS extends StatelessWidget {
  const CcSpaceXS({super.key});
  @override
  Widget build(BuildContext context) => const SizedBox(
    height: CcPaddingParams.SPACE_XS,
    width: CcPaddingParams.SPACE_XS,
  );
}

/// Small Space (8pt)
class CcSpaceSM extends StatelessWidget {
  const CcSpaceSM({super.key});
  @override
  Widget build(BuildContext context) => const SizedBox(
    height: CcPaddingParams.SPACE_SM,
    width: CcPaddingParams.SPACE_SM,
  );
}

/// Medium/Default Space (12pt)
class CcSpace extends StatelessWidget {
  const CcSpace({super.key});
  @override
  Widget build(BuildContext context) => const SizedBox(
    height: CcPaddingParams.SPACE_MD,
    width: CcPaddingParams.SPACE_MD,
  );
}

/// Large Space (16pt)
class CcSpaceLG extends StatelessWidget {
  const CcSpaceLG({super.key});
  @override
  Widget build(BuildContext context) => const SizedBox(
    height: CcPaddingParams.SPACE_LG,
    width: CcPaddingParams.SPACE_LG,
  );
}

/// Extra Large Space (24pt)
class CcSpaceXL extends StatelessWidget {
  const CcSpaceXL({super.key});
  @override
  Widget build(BuildContext context) => const SizedBox(
    height: CcPaddingParams.SPACE_XL,
    width: CcPaddingParams.SPACE_XL,
  );
}

/// Specialized Header Space
class CcSpaceHeader extends StatelessWidget {
  const CcSpaceHeader({super.key});
  @override
  Widget build(BuildContext context) =>
      const SizedBox(height: CcPaddingParams.SPACE_XL * 2);
}

/// Specialized Footer Space
class CcSpaceFooter extends StatelessWidget {
  const CcSpaceFooter({super.key});
  @override
  Widget build(BuildContext context) =>
      const SizedBox(height: CcPaddingParams.SPACE_XL * 3);
}
