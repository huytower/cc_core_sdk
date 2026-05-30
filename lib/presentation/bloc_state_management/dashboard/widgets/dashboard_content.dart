import 'package:cc_sdk_ui/export_cc_sdk_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/dashboard_bloc.dart';

/// Dashboard Content Widget - Presentation Layer
class DashboardContent extends StatelessWidget {
  final dynamic dashboardData;
  final bool isRefreshing;
  final bool isUpdating;

  const DashboardContent({
    Key? key,
    required this.dashboardData,
    this.isRefreshing = false,
    this.isUpdating = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        dashboardData.title,
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        dashboardData.description,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        'Item Count',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CcDebounce(
                            onTap: () {
                              context.read<DashboardBloc>().add(
                                const DecrementItemCountEvent(),
                              );
                            },
                            child: const Icon(
                              Icons.remove_circle_outline,
                              size: 32,
                              color: Colors.red,
                            ),
                          ),
                          const SizedBox(width: 24),
                          Text(
                            '${dashboardData.itemCount}',
                            style: Theme.of(context).textTheme.headlineLarge
                                ?.copyWith(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(width: 24),
                          CcDebounce(
                            onTap: () {
                              context.read<DashboardBloc>().add(
                                const IncrementItemCountEvent(),
                              );
                            },
                            child: const Icon(
                              Icons.add_circle_outline,
                              size: 32,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Last Updated',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _formatDateTime(dashboardData.lastUpdated),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        context.read<DashboardBloc>().add(
                          const RefreshDashboardDataEvent(),
                        );
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Refresh Data'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        if (isRefreshing)
          const Positioned(
            top: 16,
            right: 16,
            child: CircularProgressIndicator(),
          ),
        if (isUpdating)
          const Positioned.fill(
            child: Center(child: CircularProgressIndicator()),
          ),
      ],
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    if (difference.inDays > 0)
      return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
    if (difference.inHours > 0)
      return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
    if (difference.inMinutes > 0)
      return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
    return 'Just now';
  }
}
