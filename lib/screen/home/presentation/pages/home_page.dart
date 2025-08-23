import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/inject/inject.dart';
import '../bloc/home_bloc.dart';
import '../widgets/home_content.dart';

/// Home Page - Presentation Layer
///
/// This page displays the home screen and manages the BLoC lifecycle.
/// It follows the BLoC pattern and Clean Architecture principles.
@RoutePage()
class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<HomeBloc>()..add(const LoadHomeDataEvent()),
      child: const HomeView(),
    );
  }
}

/// Home View - Presentation Layer
///
/// This ui handles the main UI structure and delegates content
/// rendering to the HomeContent ui.
class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<HomeBloc>().add(const RefreshHomeDataEvent());
            },
          ),
        ],
      ),
      body: const HomeContent(),
    );
  }
}
