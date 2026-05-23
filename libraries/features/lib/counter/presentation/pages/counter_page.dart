import 'package:cc_sdk_ui/widgets/button/cc_close_btn.dart';
import 'package:cc_sdk_ui/widgets/button/cc_debounce_widget.dart';
import 'package:cc_sdk_ui/widgets/flex/cc_flex.dart';
import 'package:cc_sdk_ui/widgets/space/cc_space.dart';
import 'package:cc_sdk_ui/widgets/text/cc_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/di/di.dart';
import '../bloc/counter_bloc.dart';

class CounterPage extends StatelessWidget {
  const CounterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<CounterBloc>()..add(const LoadCounterEvent()),
      child: const CounterView(),
    );
  }
}

class CounterView extends StatelessWidget {
  const CounterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Counter Example')),
      body: const CcColCenter(
        children: [CounterDisplay(), CcSpaceSM(), IncrementButton()],
      ),
    );
  }
}

class CounterDisplay extends StatelessWidget {
  const CounterDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CounterBloc, CounterState>(
      builder: (context, state) {
        if (state is CounterLoading) {
          return const CircularProgressIndicator();
        } else if (state is CounterLoaded) {
          return CcText(
            '${state.counter.value}',
            fontSize: 32,
            color: Colors.blue,
          );
        } else if (state is CounterError) {
          return Text('Error: ${state.message}');
        }
        return const Text('Press the button to start!');
      },
    );
  }
}

class IncrementButton extends StatelessWidget {
  const IncrementButton({super.key});

  @override
  Widget build(BuildContext context) {
    return CcDebounce(
      onTap: () {
        context.read<CounterBloc>().add(const IncrementCounterEvent());
      },
      child: CcCloseBtn(
        onTap: () {
          context.read<CounterBloc>().add(const IncrementCounterEvent());
        },
        icon: const Icon(
          Icons.add_circle_outline,
          color: Colors.blue,
          size: 48,
        ),
        width: 120,
        bgColor: Colors.blue.withOpacity(0.1),
      ),
    );
  }
}
