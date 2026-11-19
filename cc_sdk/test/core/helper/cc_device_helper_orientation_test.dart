import 'package:cc_sdk/src/core/helper/cc_device_helper.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final calls = <List<String>>[];

  setUp(() {
    calls.clear();
    CcDeviceHelper.resetOrientationPolicy();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform, (call) async {
          if (call.method == 'SystemChrome.setPreferredOrientations') {
            calls.add(List<String>.from(call.arguments as List));
          }
          return null;
        });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform, null);
  });

  group('orientationsFor', () {
    const cases = <String, (Size, bool)>{
      'small phone': (Size(320, 640), true),
      'phone held sideways': (Size(844, 390), true),
      'fold cover screen': (Size(344, 882), true),
      'fold inner screen': (Size(673, 841), false),
      '7in tablet': (Size(600, 960), false),
      '10in tablet landscape': (Size(1280, 800), false),
    };
    cases.forEach((name, testCase) {
      final (size, isPhone) = testCase;
      test('$name -> ${isPhone ? 'portrait only' : 'free'}', () {
        expect(
          CcDeviceHelper.orientationsFor(size),
          isPhone
              ? CcDeviceHelper.phoneOrientations
              : CcDeviceHelper.largeScreenOrientations,
        );
      });
    });
  });

  test('locks a phone to portrait up', () async {
    await CcDeviceHelper.applyOrientationPolicy(const Size(390, 844));
    expect(calls, [
      ['DeviceOrientation.portraitUp'],
    ]);
  });

  test('only calls the platform when the policy flips', () async {
    await CcDeviceHelper.applyOrientationPolicy(const Size(390, 844));
    await CcDeviceHelper.applyOrientationPolicy(const Size(844, 390));
    expect(calls, hasLength(1));

    // Foldable opens: inner screen is tablet-sized, rotation is released.
    await CcDeviceHelper.applyOrientationPolicy(const Size(673, 841));
    expect(calls, hasLength(2));
    expect(calls.last, hasLength(DeviceOrientation.values.length));
  });

  test('ignores an empty size', () async {
    await CcDeviceHelper.applyOrientationPolicy(Size.zero);
    expect(calls, isEmpty);
  });
}
