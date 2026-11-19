import 'package:cc_sdk/core/config/cc_sdk_config.dart';

/// App identity used in logs and crash reports (from [CcSdkConfig.current]).
abstract final class CcAppTrackName {
  CcAppTrackName._();

  static String get appName {
    final name = CcSdkConfig.current.appName.trim();
    return name.isEmpty ? CcSdkConfig.defaultAppName : name;
  }
}

/// Crash log upload flag and path (from [CcSdkConfig.current]).
abstract final class CcCrashLogEnv {
  CcCrashLogEnv._();

  static const String defaultApiPath = CcSdkConfig.defaultCrashLogApiPath;

  static bool get isUploadEnabled => CcSdkConfig.current.enableCrashLogUpload;

  /// Relative path appended to the API base URL (Retrofit/Dio baseUrl).
  static String get apiPath {
    final path = CcSdkConfig.current.crashLogApiPath.trim();
    return path.isEmpty ? defaultApiPath : path;
  }
}
