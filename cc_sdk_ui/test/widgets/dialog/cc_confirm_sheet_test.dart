import 'package:cc_sdk_ui/export_cc_sdk_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Finder _text(String text) => find.text(text, findRichText: true);

Future<bool?> _run(
  WidgetTester tester, {
  CcConfirmTone tone = CcConfirmTone.destructive,
  String? highlight,
  Widget? extra,
  Future<void> Function()? interact,
}) async {
  bool? result;
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: Builder(
          builder: (context) => TextButton(
            onPressed: () async => result = await CcConfirmSheet.show(
              context,
              icon: Icons.delete_outline_rounded,
              title: 'Delete wallet?',
              message: 'This cannot be undone.',
              confirmLabel: 'Delete',
              highlight: highlight,
              extra: extra,
              tone: tone,
            ),
            child: const Text('open'),
          ),
        ),
      ),
    ),
  );
  await tester.tap(find.text('open'));
  await tester.pumpAndSettle();
  if (interact != null) {
    await interact();
    await tester.pumpAndSettle();
    // Let the buttons' debounce timers run out.
    await tester.pump(const Duration(seconds: 2));
  }
  return result;
}

void main() {
  testWidgets('shows title, message, Material Cancel and the confirm label', (
    tester,
  ) async {
    await _run(tester, highlight: 'Cash', extra: const Text('a link'));
    expect(_text('Delete wallet?'), findsOneWidget);
    expect(_text('This cannot be undone.'), findsOneWidget);
    expect(_text('Cash'), findsOneWidget);
    expect(find.text('a link'), findsOneWidget);
    expect(_text('Cancel'), findsOneWidget);
    expect(_text('Delete'), findsOneWidget);
  });

  testWidgets('confirm returns true', (tester) async {
    final result = await _run(
      tester,
      interact: () => tester.tap(_text('Delete')),
    );
    expect(result, isTrue);
  });

  testWidgets('cancel returns false', (tester) async {
    final result = await _run(
      tester,
      interact: () => tester.tap(_text('Cancel')),
    );
    expect(result, isFalse);
  });

  testWidgets('destructive tone paints the icon in the error colour', (
    tester,
  ) async {
    await _run(tester);
    final context = tester.element(find.byType(CcConfirmSheet));
    final icon = tester.widget<Icon>(find.byIcon(Icons.delete_outline_rounded));
    expect(icon.color, Theme.of(context).colorScheme.error);
  });

  testWidgets('primary tone paints the icon in the primary colour', (
    tester,
  ) async {
    await _run(tester, tone: CcConfirmTone.primary);
    final context = tester.element(find.byType(CcConfirmSheet));
    final icon = tester.widget<Icon>(find.byIcon(Icons.delete_outline_rounded));
    expect(icon.color, Theme.of(context).colorScheme.primary);
  });
}
