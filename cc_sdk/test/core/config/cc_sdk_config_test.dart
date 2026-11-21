import 'package:cc_sdk/export_cc_sdk.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  tearDown(() => CcSdkConfig.configure(const CcSdkConfig()));

  test('defaults before the app configures anything', () {
    expect(CcAppTrackName.appName, CcSdkConfig.defaultAppName);
    expect(CcSdkConfig.current.enableLogger, !kReleaseMode);
  });

  test('the read-only views follow CcSdkConfig.configure', () {
    CcSdkConfig.configure(
      const CcSdkConfig(appName: 'Shop', enableLogger: false),
    );

    expect(CcAppTrackName.appName, 'Shop');
    expect(CcSdkConfig.current.enableLogger, isFalse);
  });

  test('a blank app name falls back to the default', () {
    CcSdkConfig.configure(const CcSdkConfig(appName: '  '));

    expect(CcAppTrackName.appName, CcSdkConfig.defaultAppName);
  });
}
