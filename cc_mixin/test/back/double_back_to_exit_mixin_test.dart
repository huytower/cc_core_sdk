import 'dart:io';

import 'package:cc_mixin/export_cc_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class _BackHandler with DoubleBackToExitMixin {
  _BackHandler({this.customNavigation = false});

  final bool customNavigation;

  @override
  String get backPressMessage => 'Press again';

  @override
  bool handleCustomNavigation() => customNavigation;
}

Future<BuildContext> _pumpHost(WidgetTester tester) async {
  late BuildContext context;
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: Builder(
          builder: (ctx) {
            context = ctx;
            return const SizedBox.shrink();
          },
        ),
      ),
    ),
  );
  return context;
}

void main() {
  // On iOS the mixin defers to the system swipe gesture; the cases below cover
  // the double-press path used on the other platforms.
  final skip = Platform.isIOS || Platform.isAndroid;

  testWidgets('the first back press shows the message', (tester) async {
    final context = await _pumpHost(tester);

    _BackHandler().onPopInvokedWithResult(context, false, null);
    await tester.pump();

    expect(find.text('Press again'), findsOneWidget);
  }, skip: skip);

  testWidgets('a pop that already happened is ignored', (tester) async {
    final context = await _pumpHost(tester);

    _BackHandler().onPopInvokedWithResult(context, true, null);
    await tester.pump();

    expect(find.text('Press again'), findsNothing);
  }, skip: skip);

  testWidgets('custom navigation takes over the back press', (tester) async {
    final context = await _pumpHost(tester);

    _BackHandler(
      customNavigation: true,
    ).onPopInvokedWithResult(context, false, null);
    await tester.pump();

    expect(find.text('Press again'), findsNothing);
  }, skip: skip);

  test('the route can pop only on iOS without double back', () {
    expect(_BackHandler().canPop, Platform.isIOS);
  });
}
