part of 'dashboard_bloc.dart';

/// Dashboard Events - Presentation Layer
abstract class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object> get props => [];
}

/// Event to load dashboard data
class LoadDashboardDataEvent extends DashboardEvent {
  const LoadDashboardDataEvent();
}

/// Event to refresh dashboard data
class RefreshDashboardDataEvent extends DashboardEvent {
  const RefreshDashboardDataEvent();
}

/// Event to increment item count
class IncrementItemCountEvent extends DashboardEvent {
  const IncrementItemCountEvent();
}

/// Event to decrement item count
class DecrementItemCountEvent extends DashboardEvent {
  const DecrementItemCountEvent();
}
