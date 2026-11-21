import 'package:cc_sdk_firebase/src/ai/cc_firebase_ai_config.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

final GetIt getIt = GetIt.instance;

/// Registers this package's implementations (e.g. `CcAnalytics`). Add
/// `ExternalModule(CcSdkFirebasePackageModule)` to the app's
/// `externalPackageModulesBefore`.
///
/// The app registers the settings this package reads but cannot know:
/// [CcFirebaseAiConfig] (needed only when `CcAiClient` is used).
@InjectableInit.microPackage(ignoreUnregisteredTypes: [CcFirebaseAiConfig])
void initMicroPackage() {}
