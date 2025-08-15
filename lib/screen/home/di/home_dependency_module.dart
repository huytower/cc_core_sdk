import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/datasources/home_local_datasource.dart';
import '../data/datasources/home_local_datasource_impl.dart';
import '../data/datasources/home_remote_datasource.dart';
import '../data/datasources/home_remote_datasource_impl.dart';
import '../data/repositories/home_repository_impl.dart';
import '../domain/repositories/home_repository.dart';
import '../domain/usecases/get_home_data_usecase.dart';
import '../domain/usecases/refresh_home_data_usecase.dart';
import '../domain/usecases/update_home_data_usecase.dart';

/// Home Infrastructure Module
///
/// This module registers all the dependencies for the home feature
/// using the Injectable package's @module annotation.
@module
abstract class HomeDependencyModule {
  // Data Sources
  @lazySingleton
  HomeLocalDataSource get homeLocalDataSource => HomeLocalDataSourceImpl(
        GetIt.instance<SharedPreferences>(),
      );

  @lazySingleton
  HomeRemoteDataSource get homeRemoteDataSource => const HomeRemoteDataSourceImpl();

  // Repository
  @lazySingleton
  HomeRepository get homeRepository => HomeRepositoryImpl(
        localDataSource: GetIt.instance<HomeLocalDataSource>(),
        remoteDataSource: GetIt.instance<HomeRemoteDataSource>(),
      );

  // Use Cases
  @lazySingleton
  GetHomeDataUseCase get getHomeDataUseCase => GetHomeDataUseCase(
        GetIt.instance<HomeRepository>(),
      );

  @lazySingleton
  UpdateHomeDataUseCase get updateHomeDataUseCase => UpdateHomeDataUseCase(
        GetIt.instance<HomeRepository>(),
      );

  @lazySingleton
  RefreshHomeDataUseCase get refreshHomeDataUseCase => RefreshHomeDataUseCase(
        GetIt.instance<HomeRepository>(),
      );
}
