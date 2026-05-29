import '../../../../domain/entities/dashboard/dashboard_entity.dart';

/// Dashboard Local Data Source Interface - Data Layer
abstract class DashboardLocalDataSource {
  /// Retrieves dashboard data from local storage
  Future<DashboardEntity> getDashboardData();

  /// Saves dashboard data to local storage
  Future<void> saveDashboardData(DashboardEntity dashboardData);

  /// Clears dashboard data from local storage
  Future<void> clearDashboardData();
}
