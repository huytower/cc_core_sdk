import 'package:app_config/data/datasource/local/box/app_storage/cc_app_storage.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GetIt getIt = GetIt.instance;

/// Configures dependency injection for the data module.
/// Uses the Micro-Package pattern for injectable.
@InjectableInit.microPackage(
  ignoreUnregisteredTypes: [
    CcAppStorage,
    Dio,
    InternetConnection,
    SharedPreferences,
  ],
)
void initMicroPackage() {}
