import 'package:cc_sdk_ui/core/theme/base_colors.dart';
import 'package:cc_sdk_ui/widgets/text/cc_text.dart';
import 'package:easy_localization/easy_localization.dart' as el;
import 'package:flutter/cupertino.dart';

// Purpose:
// small reusable widgets for loading states and empty API responses
// intended as part of the shared UI library
class NoDataResponseWidget extends StatelessWidget {
  const NoDataResponseWidget({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  SizedBox build(c) => SizedBox(
    height: 50,
    child: CcText(
      title ?? el.tr('common.no_data'),
      align: Alignment.center,
      color: BaseColors.textPrimary,
      fontStyle: FontStyle.italic,
      fontWeight: FontWeight.w300,
      textAlign: TextAlign.center,
    ),
  );
}
