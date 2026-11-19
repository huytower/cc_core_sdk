import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

final GetIt getIt = GetIt.instance;

/// Registers `CcPhoneNumberValidator`. Add
/// `ExternalModule(CcSdkPhonePackageModule)` to the app's
/// `externalPackageModulesBefore`.
@InjectableInit.microPackage()
void initMicroPackage() {}
