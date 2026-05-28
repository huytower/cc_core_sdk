import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

final GetIt getIt = GetIt.instance;

/// Configures dependency injection for the data module.
/// Uses the Micro-Package pattern for injectable.
@InjectableInit.microPackage(ignoreUnregisteredTypes: [InternetConnection])
void initMicroPackage() {}
