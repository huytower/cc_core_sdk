import 'package:cc_sdk_ui/export_cc_sdk_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const _labels = CcKeypadLabels(clear: 'Clear', copy: 'Copy', done: 'Done');

Future<void> _pump(WidgetTester tester, Widget child, {Size? size}) async {
  if (size != null) {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
  }
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: Align(alignment: Alignment.bottomCenter, child: child),
      ),
    ),
  );
}

void main() {
  group('CcNumericKeypad', () {
    testWidgets('digits, extra key and backspace call back', (tester) async {
      final pressed = <String>[];
      var deletes = 0;
      await _pump(
        tester,
        CcNumericKeypad(
          onKeyPress: pressed.add,
          onDelete: () => deletes++,
          activeColor: Colors.green,
        ),
      );

      await tester.tap(find.text('7', findRichText: true));
      await tester.tap(find.text('000', findRichText: true));
      await tester.tap(find.byIcon(Icons.backspace_outlined));
      await tester.pumpAndSettle();

      expect(pressed, ['7', '000']);
      expect(deletes, 1);
    });

    testWidgets('extraKey null leaves the cell empty', (tester) async {
      await _pump(
        tester,
        CcNumericKeypad(
          onKeyPress: (_) {},
          onDelete: () {},
          activeColor: Colors.green,
          extraKey: null,
        ),
      );
      expect(find.text('000', findRichText: true), findsNothing);
      expect(find.text('0', findRichText: true), findsOneWidget);
    });

    testWidgets('tablet: capped at 480 dp and centred', (tester) async {
      await _pump(
        tester,
        CcNumericKeypad(
          onKeyPress: (_) {},
          onDelete: () {},
          activeColor: Colors.green,
        ),
        size: const Size(1000, 800),
      );
      final rect = tester.getRect(find.byType(Container).first);
      expect(rect.width, CcNumericKeypad.tabletMaxWidth);
      expect(rect.center.dx, 500);
    });
  });

  group('CcKeypadPanel', () {
    testWidgets('suggestions, clear and done call back', (tester) async {
      int? suggested;
      var clears = 0;
      var dones = 0;
      await _pump(
        tester,
        CcKeypadPanel<int>(
          onKeyPress: (_) {},
          onDelete: () {},
          onClear: () => clears++,
          onDone: () => dones++,
          activeColor: Colors.green,
          labels: _labels,
          suggestions: const [
            CcQuickValue(value: 50000, label: '50K'),
            CcQuickValue(value: 100000, label: '100K'),
          ],
          onSuggestion: (value) => suggested = value,
        ),
      );

      await tester.tap(find.text('100K', findRichText: true));
      await tester.tap(find.byTooltip('Clear'));
      await tester.tap(find.text('Done', findRichText: true));
      await tester.pumpAndSettle();

      expect(suggested, 100000);
      expect(clears, 1);
      expect(dones, 1);
      // Let the buttons' debounce and tooltip timers run out.
      await tester.pump(const Duration(seconds: 2));
    });

    testWidgets('copy button only when onCopy is set', (tester) async {
      Widget panel({VoidCallback? onCopy}) => CcKeypadPanel<int>(
        onKeyPress: (_) {},
        onDelete: () {},
        onClear: () {},
        onDone: () {},
        onCopy: onCopy,
        activeColor: Colors.green,
        labels: _labels,
      );

      await _pump(tester, panel());
      expect(find.byTooltip('Copy'), findsNothing);

      await _pump(tester, panel(onCopy: () {}));
      expect(find.byTooltip('Copy'), findsOneWidget);
    });
  });

  group('CcQuickValueChips', () {
    testWidgets('no items: nothing', (tester) async {
      await _pump(
        tester,
        CcQuickValueChips<int>(
          items: const [],
          onSelected: (_) {},
          activeColor: Colors.green,
        ),
      );
      expect(find.byType(CcHorizontalFadeScrollView), findsNothing);
    });
  });
}
