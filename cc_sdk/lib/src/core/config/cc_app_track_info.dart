import 'package:cc_sdk/src/core/config/cc_sdk_config.dart';

/// App identity used in logs and crash reports (from [CcSdkConfig.current]).
abstract final class CcAppTrackName {
  CcAppTrackName._();

  /// The configured app name, or [CcSdkConfig.defaultAppName] when blank.
  static String get appName {
    final name = CcSdkConfig.current.appName.trim();
    return name.isEmpty ? CcSdkConfig.defaultAppName : name;
  }
}
