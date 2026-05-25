import 'package:flutter/cupertino.dart';

import '../../core/config/tokens/cc_base_colors.dart';
import '../../core/helper/cc_widget_helper.dart';

// Purpose:
// small reusable widgets for loading states and empty API responses
// intended as part of the shared UI library
class CcLoadingIconWidget extends StatelessWidget {
  const CcLoadingIconWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Center(
    child: Container(
      height: 60,
      width: 60,
      decoration: BoxDecoration(
        color: CcBaseColors.neutral40,
        borderRadius: CcWidgetHelper.getBorderRoundedSmall(),
      ),
      child: getLoadingWidget(),
    ),
  );

  Widget getLoadingWidget() =>
      const CupertinoActivityIndicator(color: CcBaseColors.white100, radius: 15);
}
