import 'package:cc_sdk/core/extensions/export_cc_extensions.dart';
import 'package:cc_sdk_ui/core/extensions/cc_context_extension.dart';
import 'package:cc_sdk_ui/widgets/button/cc_close_btn.dart';
import 'package:cc_sdk_ui/widgets/button/cc_debounce_widget.dart';
import 'package:flutter/material.dart';

import '../simple_cubit_interface.dart';

/// Counter item widget with increment functionality
class SimpleCounterItem extends StatelessWidget {
  final SimpleCubitInterface cubit;

  const SimpleCounterItem({
    super.key,
    required this.cubit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: double.infinity,
      color: context.ccColorScheme.surfaceContainerHighest,
      child: CcDebounce(
        onTap: () {
          'DebounceWidget'.Log();
        },
        child: CcCloseBtn(
          onTap: () {
            'cubit : close() :'.Log();
            cubit.increase();
          },
          icon: Icon(
            Icons.access_alarm,
            color: context.ccColorScheme.onSurface,
            size: 80,
          ),
          width: 120,
          bgColor: context.ccColorScheme.primary,
        ),
      ),
    );
  }
}
