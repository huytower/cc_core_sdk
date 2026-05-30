import 'package:auto_route/auto_route.dart';
import 'package:cc_mixin/export_cc_mixin.dart';
import 'package:cc_sdk_ui/export_cc_sdk_ui.dart' hide getIt;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/di.dart';
import '../bloc/dashboard_bloc.dart';
import '../widgets/dashboard_content.dart';

@RoutePage()
class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          getIt<DashboardBloc>()..add(const LoadDashboardDataEvent()),
      child: BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, state) => DashboardView(state, context),
      ),
    );
  }
}

class DashboardView extends StatelessWidget with CcViewConfigMixin {
  final DashboardState state;
  final BuildContext blocContext;

  const DashboardView(this.state, this.blocContext, {super.key});

  @override
  CcLayoutStatus get layoutStatus {
    if (state is DashboardLoading) return CcLayoutStatus.loading;
    if (state is DashboardError) return CcLayoutStatus.error;
    if (state is DashboardLoaded) return CcLayoutStatus.success;
    return CcLayoutStatus.loading;
  }

  @override
  String get errorMessage => state is DashboardError
      ? (state as DashboardError).message
      : super.errorMessage;

  @override
  PreferredSizeWidget? appBar() => AppBar(
    title: const Text('Dashboard'),
    actions: [
      CcDebounce(
        onTap: () => blocContext.read<DashboardBloc>().add(
          const RefreshDashboardDataEvent(),
        ),
        child: const Icon(Icons.refresh),
      ),
    ],
  );

  @override
  Widget? buildContent() {
    if (state is DashboardLoaded) {
      final s = state as DashboardLoaded;
      return DashboardContent(
        dashboardData: s.dashboardData,
        isRefreshing: state is DashboardRefreshing,
        isUpdating: state is DashboardUpdating,
      );
    }
    return null;
  }
}
