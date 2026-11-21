import 'package:cc_sdk/export_cc_sdk.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  tearDown(() => CcSdkConfig.configure(const CcSdkConfig()));

  test('defaults before the app configures anything', () {
    expect(CcAppTrackName.appName, CcSdkConfig.defaultAppName);
    expect(CcCrashLogEnv.apiPath, CcSdkConfig.defaultCrashLogApiPath);
    expect(CcRouteConfig.login, '/login');
    expect(CcRouteConfig.mainNavigation, '/main_navigation');
    expect(CcFeatureFlags.isAnalyticsEnabled, isTrue);
  });

  test('the read-only views follow CcSdkConfig.configure', () {
    CcSdkConfig.configure(
      const CcSdkConfig(
        appName: 'Shop',
        enableLogger: false,
        enableAnalytics: false,
        enableCrashReporting: false,
        enableCertificatePinning: false,
        enableCrashLogUpload: false,
        crashLogApiPath: '/logs',
        mainNavigationPath: '/home',
        loginPath: '/sign-in',
      ),
    );

    expect(CcAppTrackName.appName, 'Shop');
    expect(CcFeatureFlags.isEnableLogger, isFalse);
    expect(CcFeatureFlags.isAnalyticsEnabled, isFalse);
    expect(CcFeatureFlags.isCrashReportingEnabled, isFalse);
    expect(CcFeatureFlags.isCertificatePinningEnabled, isFalse);
    expect(CcCrashLogEnv.isUploadEnabled, isFalse);
    expect(CcCrashLogEnv.apiPath, '/logs');
    expect(CcRouteConfig.mainNavigation, '/home');
    expect(CcRouteConfig.login, '/sign-in');
  });

  test('blank app name and crash-log path fall back to the defaults', () {
    CcSdkConfig.configure(
      const CcSdkConfig(appName: '  ', crashLogApiPath: ' '),
    );

    expect(CcAppTrackName.appName, CcSdkConfig.defaultAppName);
    expect(CcCrashLogEnv.apiPath, CcSdkConfig.defaultCrashLogApiPath);
  });
}
