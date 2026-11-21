import 'package:cc_sdk_ui/export_cc_sdk_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../example/main.dart';

Future<void> _pumpAt(WidgetTester tester, Size size) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(const CcSdkUiExampleApp());
}

Finder _richText(String text) => find.text(text, findRichText: true);

/// Taps a debounced SDK button and lets its debounce timer run out.
Future<void> _tapDebounced(WidgetTester tester, Finder finder) async {
  await tester.tap(finder);
  await tester.pumpAndSettle();
  await tester.pump(const Duration(seconds: 1));
}

// Keeps example/main.dart compiling and working: it uses only cc_sdk_ui with a
// plain Material theme, so this also proves the design system stands alone.
void main() {
  testWidgets('phone: one column, no overflow', (tester) async {
    await _pumpAt(tester, const Size(360, 800));

    // Single column: the state sits below the controls.
    final controls = tester.getCenter(_richText('Saved items'));
    final state = tester.getCenter(_richText('Content loaded'));
    expect(state.dy, greaterThan(controls.dy));
    expect(tester.takeException(), isNull);
  });

  testWidgets('desktop: controls and state side by side', (tester) async {
    await _pumpAt(tester, const Size(1280, 800));

    final controls = tester.getCenter(_richText('Saved items'));
    final state = tester.getCenter(_richText('Content loaded'));
    expect(state.dx, greaterThan(controls.dx));
    expect(tester.takeException(), isNull);
  });

  testWidgets('Save counts up and shows a snackbar', (tester) async {
    await _pumpAt(tester, const Size(360, 800));

    await _tapDebounced(tester, _richText('Save'));

    expect(_richText('1'), findsOneWidget);
    expect(find.byType(SnackBar), findsOneWidget);
  });

  testWidgets('switches between the layout states', (tester) async {
    await _pumpAt(tester, const Size(360, 800));

    await tester.tap(find.text('Loading'));
    await tester.pump();
    expect(find.byType(CupertinoActivityIndicator), findsOneWidget);

    await tester.tap(find.text('Empty'));
    await tester.pump();
    expect(_richText('Nothing here yet'), findsOneWidget);

    await tester.tap(find.text('Error'));
    await tester.pumpAndSettle();
    expect(_richText('Something went wrong'), findsOneWidget);

    await _tapDebounced(tester, _richText('Retry'));
    expect(_richText('Content loaded'), findsOneWidget);
    expect(find.byType(ErrorPage), findsNothing);
  });
}
