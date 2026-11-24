import 'package:cc_sdk/export_cc_sdk.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final calls = <List<String>>[];

  setUp(() {
    calls.clear();
    CcOrientationPolicy.reset();
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

  Future<void> pumpAt(WidgetTester tester, Size size) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    await tester.pumpWidget(const CcOrientationPolicyScope(child: SizedBox()));
    await tester.pump();
  }

  testWidgets('phone window: locks to portrait', (tester) async {
    addTearDown(tester.view.reset);
    await pumpAt(tester, const Size(400, 800));
    expect(calls.last, ['DeviceOrientation.portraitUp']);
  });

  testWidgets('re-applies when the window grows to a tablet', (tester) async {
    addTearDown(tester.view.reset);
    await pumpAt(tester, const Size(400, 800));
    await pumpAt(tester, const Size(900, 1200));
    expect(calls, hasLength(2));
    expect(calls.last, hasLength(DeviceOrientation.values.length));
  });
}
