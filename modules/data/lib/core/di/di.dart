import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GetIt getIt = GetIt.instance;

/// Configures dependency injection for the data module.
/// Uses the Micro-Package pattern for injectable.
@InjectableInit.microPackage(ignoreUnregisteredTypes: [SharedPreferences, Dio])
void initMicroPackage() {}
