import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

final GetIt getIt = GetIt.instance;

/// Configures dependency injection for the app_config module.
/// Uses the Micro-Package pattern for injectable.
@InjectableInit.microPackage()
void initMicroPackage() {}
