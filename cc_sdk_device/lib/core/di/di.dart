import 'package:device_info_plus/device_info_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

final GetIt getIt = GetIt.instance;

/// Registers this package's implementations (e.g. `CcSpeechRecognizer`). Add
/// `ExternalModule(CcSdkDevicePackageModule)` to the app's
/// `externalPackageModulesBefore`, after `CcSdkPackageModule`, which registers
/// the [DeviceInfoPlugin] used here.
@InjectableInit.microPackage(ignoreUnregisteredTypes: [DeviceInfoPlugin])
void initMicroPackage() {}
