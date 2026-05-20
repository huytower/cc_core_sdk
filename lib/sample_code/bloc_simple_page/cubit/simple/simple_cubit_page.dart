import 'package:auto_route/annotations.dart';
import 'package:cc_sdk/core/extensions/export_extensions.dart';
import 'package:cc_sdk_ui/core/helper/open_dialog.dart';
import 'package:cc_sdk_ui/widgets/button/cc_base_btn.dart';
import 'package:cc_sdk_ui/widgets/button/cc_close_btn.dart';
import 'package:cc_sdk_ui/widgets/button/cc_debounce_widget.dart';
import 'package:cc_sdk_ui/widgets/flex/cc_flex.dart';
import 'package:cc_sdk_ui/widgets/space/cc_space.dart';
import 'package:cc_sdk_ui/widgets/text/cc_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/di/inject/inject.dart';
import '../../../../presentation/getx/app_track_log/cubit/ui/app_track_log_page.dart';
import 'simple_cubit.dart';
import 'simple_cubit_interface.dart';
import 'simple_cubit_state.dart';

/// CUBIT : UI
/// Step 3 : create UI presentation||page
/// - BlocProvider : init Controller
/// - BlocBuilder : notify data set changed, depends on state
///
@RoutePage()
class SimpleCubitPage extends StatelessWidget {
  const SimpleCubitPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: BlocProvider<SimpleCubitInterface>(
          create: (BuildContext context) => getIt<SimpleCubitInterface>(),
          child: Builder(builder: (context) => buildPage(context)),
        ),
      ),
    );
  }

  Widget buildPage(BuildContext context) {
    return buildContainer(context);
  }

  Widget buildContainer(context) => CcColCenter(
    children: [
      buildTitle(context),
      const CcSpaceSM(),
      item(context),
      const CcSpaceSM(),
      item(context),
      const CcSpaceSM(),
      buildShowAppTrackLogBtn(context),
    ],
  );

  CcNextBtn buildShowAppTrackLogBtn(context) {
    return CcNextBtn(() {
      OpenDialog.showBottomSheet(context, const AppTrackLogPage());
    }, 'Show Track Log');
  }

  SizedBox buildTitle(context) {
    return SizedBox(
      width: double.infinity,
      child: Center(
        child: BlocBuilder<SimpleCubit, SimpleCubitState>(
          builder: (context, state) {
            return CcText(
              state.counter.toString(),
              color: Colors.red,
              fontSize: 32,
            );
          },
        ),
      ),
    );
  }

  //----------------------------------------------------------------------------
  Widget item(context) {
    final cubit = context.read<SimpleCubitInterface>();

    return GestureDetector(
      onTap: () {},
      child: Container(
        height: 100,
        width: double.infinity,
        color: Colors.blueGrey,
        child: CcDebounce(
          onTap: () {
            'DebounceWidget'.Log();
          },
          child: CcCloseBtn(
            onTap: () {
              'cubit : close() :'.Log();

              cubit.increase();
            },
            icon: const Icon(
              Icons.access_alarm,
              color: Colors.blueGrey,
              size: 80,
            ),
            width: 120,
            bgColor: Colors.blue,
          ),
        ),
      ),
    );
  }
}
