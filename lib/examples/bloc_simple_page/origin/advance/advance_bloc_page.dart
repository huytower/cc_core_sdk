import 'package:auto_route/annotations.dart';
import 'package:cc_sdk/core/extensions/export_cc_extensions.dart';
import 'package:cc_sdk_ui/core/config/tokens/cc_typography_params.dart';
import 'package:cc_sdk_ui/widgets/anim/fade_page_wrapper.dart';
import 'package:cc_sdk_ui/widgets/button/cc_close_btn.dart';
import 'package:cc_sdk_ui/widgets/button/cc_debounce_widget.dart';
import 'package:cc_sdk_ui/widgets/flex/cc_flex.dart';
import 'package:cc_sdk_ui/widgets/space/cc_space.dart';
import 'package:cc_sdk_ui/widgets/text/cc_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/di/di.dart';
import 'advance_bloc.dart';
import 'advance_bloc_event.dart';
import 'advance_bloc_state.dart';

@RoutePage()
class AdvanceBlocPage extends StatelessWidget {
  const AdvanceBlocPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FadePageWrapper(
      child: BlocProvider(
        create: (BuildContext context) => getIt<AdvanceBloc>(),
        child: Builder(builder: (context) => buildPage(context)),
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
    ],
  );

  SizedBox buildTitle(context) {
    Widget child = ccWhen(
      variable: getIt<AdvanceBloc>().blocType,
      conditions: {
        BlocType.builder: () => buildBlocBuilder(context),
        BlocType.selector: () => buildBlocBuilder(context),
        BlocType.listener: () => buildBlocBuilder(context),
        BlocType.consumer: () => buildBlocBuilder(context),
      },
    );

    return SizedBox(
      width: double.infinity,
      child: Center(child: child),
    );
  }

  Widget buildBlocBuilder(context) {
    return BlocBuilder<AdvanceBloc, AdvanceBlocState>(
      builder: (context, state) {
        // Toast.show('This is bloc builder', context);

        return buildBlocUI(Colors.blue);
      },
    );
  }

  Widget buildBlocSelector(context) {
    return BlocSelector<AdvanceBloc, AdvanceBlocState, AdvanceBlocStateB>(
      selector: (state) {
        // Toast.show('This is bloc selector', context);

        return AdvanceBlocStateB();
      },
      builder: (context, state) {
        return buildBlocUI(Colors.green);
      },
    );
  }

  Widget buildBlocListener(context) {
    return BlocListener<AdvanceBloc, AdvanceBlocState>(
      listener: (context, state) {
        // Toast.show('This is bloc listener', context);
      },
      child: buildBlocUI(Colors.yellow),
    );
  }

  Widget buildBlocConsumer(context) {
    return BlocConsumer<AdvanceBloc, AdvanceBlocState>(
      listener: (context, state) {},
      builder: (context, state) {
        return buildBlocUI(Colors.red);
      },
    );
  }

  CcText buildBlocUI(color) {
    return CcText(
      getIt<AdvanceBloc>().counter.toString(),
      color: color,
      fontSize: CcTypographyParams.headlineLarge,
    );
  }

  //----------------------------------------------------------------------------
  Widget item(context) {
    return Container(
      height: 100,
      width: double.infinity,
      color: Colors.blueGrey,
      child: CcDebounce(
        onTap: () {
          'DebounceWidget'.Log();
        },
        child: CcCloseBtn(
          onTap: () {
            'CloseButtonWidget() :'.Log();

            getIt<AdvanceBloc>().add(IncreaseEvent());
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
    );
  }
}
