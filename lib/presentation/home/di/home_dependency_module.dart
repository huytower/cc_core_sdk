import 'package:data/data/datasource/local/home/home_local_datasource.dart';
import 'package:data/data/datasource/local/home/home_local_datasource_impl.dart';
import 'package:data/data/datasource/remote/home/home_remote_datasource.dart';
import 'package:data/data/datasource/remote/home/home_remote_datasource_impl.dart';
import 'package:data/data/repositories/home/home_repository_impl.dart';
import 'package:data/domain/repositories/home/home_repository.dart';
import 'package:data/domain/usecases/home/get_home_data_usecase.dart';
import 'package:data/domain/usecases/home/refresh_home_data_usecase.dart';
import 'package:data/domain/usecases/home/update_home_data_usecase.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Home Infrastructure Module
///
/// This module registers all the dependencies for the home feature
/// using the Injectable package's @module annotation.
@module
abstract class HomeDependencyModule {
  // Data Sources
  @lazySingleton
  HomeLocalDataSource get homeLocalDataSource =>
      HomeLocalDataSourceImpl(GetIt.instance<SharedPreferences>());

  @lazySingleton
  HomeRemoteDataSource get homeRemoteDataSource =>
      const HomeRemoteDataSourceImpl();

  // Repository
  @lazySingleton
  HomeRepository get homeRepository => HomeRepositoryImpl(
    localDataSource: GetIt.instance<HomeLocalDataSource>(),
    remoteDataSource: GetIt.instance<HomeRemoteDataSource>(),
  );

  // Use Cases
  @lazySingleton
  GetHomeDataUseCase get getHomeDataUseCase =>
      GetHomeDataUseCase(GetIt.instance<HomeRepository>());

  @lazySingleton
  UpdateHomeDataUseCase get updateHomeDataUseCase =>
      UpdateHomeDataUseCase(GetIt.instance<HomeRepository>());

  @lazySingleton
  RefreshHomeDataUseCase get refreshHomeDataUseCase =>
      RefreshHomeDataUseCase(GetIt.instance<HomeRepository>());
}
