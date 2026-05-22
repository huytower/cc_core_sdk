import 'package:cc_sdk_ui/core/config/tokens/base_colors.dart';
import 'package:flutter/cupertino.dart';

import '../../core/helper/widget_helper.dart';

// Purpose:
// small reusable widgets for loading states and empty API responses
// intended as part of the shared UI library
class LoadingIconWidget extends StatelessWidget {
  const LoadingIconWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Center(
    child: Container(
      height: 60,
      width: 60,
      decoration: BoxDecoration(
        color: BaseColors.neutral40,
        borderRadius: WidgetHelper.getBorderRoundedSmall(),
      ),
      child: getLoadingWidget(),
    ),
  );

  Widget getLoadingWidget() =>
      const CupertinoActivityIndicator(color: BaseColors.white100, radius: 15);
}
