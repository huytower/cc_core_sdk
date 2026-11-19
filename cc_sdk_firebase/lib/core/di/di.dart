import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

final GetIt getIt = GetIt.instance;

/// Registers this package's implementations (e.g. `CcAnalytics`). Add
/// `ExternalModule(CcSdkFirebasePackageModule)` to the app's
/// `externalPackageModulesBefore`.
@InjectableInit.microPackage()
void initMicroPackage() {}
