import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/home_bloc.dart';

/// Home Content Widget - Presentation Layer
/// 
/// This widget handles the main content display and user interactions.
/// It follows the BLoC pattern for state management and the Single
/// Responsibility Principle by focusing only on UI rendering.
class HomeContent extends StatelessWidget {
  const HomeContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state is HomeLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is HomeLoaded) {
          return _buildHomeContent(context, state.homeData);
        } else if (state is HomeRefreshing) {
          return Stack(
            children: [
              _buildHomeContent(context, state.homeData),
              const Positioned(
                top: 16,
                right: 16,
                child: CircularProgressIndicator(),
              ),
            ],
          );
        } else if (state is HomeUpdating) {
          return Stack(
            children: [
              _buildHomeContent(context, state.homeData),
              const Positioned.fill(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ],
          );
        } else if (state is HomeError) {
          return _buildErrorContent(context, state.message);
        } else {
          return const Center(
            child: Text('Welcome to Home!'),
          );
        }
      },
    );
  }

  /// Builds the main home content when data is loaded
  Widget _buildHomeContent(BuildContext context, homeData) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title Section
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    homeData.title,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    homeData.description,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Item Count Section
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
                      IconButton(
                        onPressed: () {
                          context.read<HomeBloc>().add(const DecrementItemCountEvent());
                        },
                        icon: const Icon(Icons.remove_circle_outline),
                        iconSize: 32,
                        color: Colors.red,
                      ),
                      const SizedBox(width: 24),
                      Text(
                        '${homeData.itemCount}',
                        style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 24),
                      IconButton(
                        onPressed: () {
                          context.read<HomeBloc>().add(const IncrementItemCountEvent());
                        },
                        icon: const Icon(Icons.add_circle_outline),
                        iconSize: 32,
                        color: Colors.green,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Last Updated Section
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
                    _formatDateTime(homeData.lastUpdated),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          const Spacer(),
          
          // Action Buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    context.read<HomeBloc>().add(const RefreshHomeDataEvent());
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Refresh Data'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Builds error content when something goes wrong
  Widget _buildErrorContent(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red,
          ),
          const SizedBox(height: 16),
          Text(
            'Error',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              context.read<HomeBloc>().add(const LoadHomeDataEvent());
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  /// Formats the date time for display
  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
    } else {
      return 'Just now';
    }
  }
}
