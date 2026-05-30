import 'package:app_config/core/di/di.module.dart';
import 'package:cc_sdk/core/di/di.module.dart';
import 'package:cc_sdk/export_cc_sdk.dart';
import 'package:data/core/di/di.module.dart';
import 'package:data/domain/usecases/dashboard/get_dashboard_data_usecase.dart';
import 'package:data/domain/usecases/dashboard/refresh_dashboard_data_usecase.dart';
import 'package:data/domain/usecases/dashboard/update_dashboard_data_usecase.dart';
import 'package:features/core/di/di.module.dart';
import 'package:injectable/injectable.dart';

/// Configuration for Dependency Injection.
/// Consolidates all types and modules from external packages.
class CcDiModuleConfig {
  /// Types that are registered in Micro-Packages but used as dependencies in lib/
  static const List<Type> ignoreUnregisteredTypes = [
    CcDeviceInfoHelper,
    GetDashboardDataUseCase,
    UpdateDashboardDataUseCase,
    RefreshDashboardDataUseCase,
    CcDeviceEntity,
  ];

  /// The Micro-Package modules that must be initialized before the main app
  static const List<ExternalModule> externalPackageModulesBefore = [
    ExternalModule(CcSdkPackageModule),
    ExternalModule(DataPackageModule),
    ExternalModule(AppConfigPackageModule),
    ExternalModule(FeaturesPackageModule),
  ];
}
