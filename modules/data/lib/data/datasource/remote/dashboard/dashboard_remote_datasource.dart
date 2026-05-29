import '../../../../domain/entities/dashboard/dashboard_entity.dart';

/// Dashboard Remote Data Source Interface - Data Layer
abstract class DashboardRemoteDataSource {
  /// Fetches dashboard data from remote API
  Future<DashboardEntity> fetchDashboardData();

  /// Updates dashboard data on remote API
  Future<DashboardEntity> updateDashboardData(DashboardEntity dashboardData);
}
