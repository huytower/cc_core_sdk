import 'dart:convert';

import 'package:app_config/data/datasource/local/box/app_storage/cc_app_storage.dart';
import 'package:injectable/injectable.dart';

import '../../../../domain/entities/dashboard/dashboard_entity.dart';
import '../../../models/dashboard/dashboard_model.dart';
import 'dashboard_local_datasource.dart';

/// Dashboard Local Data Source Implementation - Data Layer
@LazySingleton(as: DashboardLocalDataSource)
class DashboardLocalDataSourceImpl implements DashboardLocalDataSource {
  final CcAppStorage _appStorage;

  const DashboardLocalDataSourceImpl(this._appStorage);

  @override
  Future<DashboardEntity> getDashboardData() async {
    final jsonStr = _appStorage.dashboardData;

    if (jsonStr != null && jsonStr.isNotEmpty) {
      try {
        final Map<String, dynamic> jsonMap =
            json.decode(jsonStr) as Map<String, dynamic>;
        return DashboardModel.fromJson(jsonMap);
      } catch (e) {
        // If parsing fails, fall back to default
      }
    }

    // Default initial data if nothing is cached
    return DashboardEntity(
      title: 'Initial Dashboard',
      description: 'Please refresh to get latest data.',
      itemCount: 0,
      lastUpdated: DateTime.now().subtract(const Duration(days: 1)),
    );
  }

  @override
  Future<void> saveDashboardData(DashboardEntity dashboardData) async {
    final model = DashboardModel(
      title: dashboardData.title,
      description: dashboardData.description,
      itemCount: dashboardData.itemCount,
      lastUpdated: dashboardData.lastUpdated,
    );
    _appStorage.dashboardData = json.encode(model.toJson());
    await _appStorage.save();
  }

  @override
  Future<void> clearDashboardData() async {
    _appStorage.dashboardData = null;
    await _appStorage.save();
  }
}
