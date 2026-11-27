import 'package:cc_sdk_ui/export_cc_sdk_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Finder _text(String text) => find.text(text, findRichText: true);

Future<void> _pump(WidgetTester tester, Widget tile, {double width = 360}) {
  return tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: Center(
          child: SizedBox(width: width, child: tile),
        ),
      ),
    ),
  );
}

void main() {
  testWidgets('shows every part and reports a tap', (tester) async {
    var taps = 0;
    await _pump(
      tester,
      CcOptionTile(
        leading: const Icon(Icons.flag),
        overline: 'AB',
        title: 'First choice',
        trailingText: '42',
        onTap: () => taps++,
      ),
    );

    expect(find.byIcon(Icons.flag), findsOneWidget);
    expect(_text('AB'), findsOneWidget);
    expect(_text('First choice'), findsOneWidget);
    expect(_text('42'), findsOneWidget);

    await tester.tap(_text('First choice'));
    await tester.pump(const Duration(seconds: 1));
    expect(taps, 1);
  });

  testWidgets('selected state is announced and bold', (tester) async {
    final semantics = tester.ensureSemantics();
    await _pump(tester, const CcOptionTile(title: 'Chosen', hasSelected: true));

    expect(
      tester.getSemantics(find.byType(CcOptionTile)),
      isSemantics(isSelected: true, isButton: true),
    );
    final title = tester.widget<RichText>(_text('Chosen'));
    expect(title.text.style?.fontWeight, CcTypographyParams.bold);
    semantics.dispose();
  });

  testWidgets('long texts fit a narrow tile', (tester) async {
    await _pump(
      tester,
      const CcOptionTile(
        leading: Icon(Icons.flag),
        overline: 'A long overline that cannot fit on one line',
        title: 'A very long title that cannot fit on one line either',
        trailingText: '1,000,000',
      ),
      width: 220,
    );

    expect(tester.takeException(), isNull);
    expect(
      tester.getSize(find.byType(CcOptionTile)).height,
      greaterThanOrEqualTo(48),
    );
  });
}
