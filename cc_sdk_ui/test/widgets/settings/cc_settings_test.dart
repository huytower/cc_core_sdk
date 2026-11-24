import 'package:cc_sdk_ui/export_cc_sdk_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Finder _text(String text) => find.text(text, findRichText: true);

Future<void> _pump(WidgetTester tester, Widget child) =>
    tester.pumpWidget(MaterialApp(home: Scaffold(body: child)));

void main() {
  testWidgets('tile: label, subtitle, trailing label, chevron, tap', (
    tester,
  ) async {
    var taps = 0;
    await _pump(
      tester,
      CcSettingsTile(
        icon: Icons.language,
        label: 'Language',
        subtitle: 'App language',
        trailingLabel: 'English',
        onTap: () => taps++,
      ),
    );

    expect(_text('Language'), findsOneWidget);
    expect(_text('App language'), findsOneWidget);
    expect(_text('English'), findsOneWidget);
    expect(find.byIcon(Icons.chevron_right_rounded), findsOneWidget);

    await tester.tap(_text('Language'));
    await tester.pump(const Duration(seconds: 1));
    expect(taps, 1);
  });

  testWidgets('tile: trailing widget replaces label and chevron', (
    tester,
  ) async {
    await _pump(
      tester,
      const CcSettingsTile(
        icon: Icons.dark_mode,
        label: 'Dark mode',
        trailingLabel: 'Off',
        trailingWidget: Switch(value: false, onChanged: null),
      ),
    );
    expect(find.byType(Switch), findsOneWidget);
    expect(_text('Off'), findsNothing);
    expect(find.byIcon(Icons.chevron_right_rounded), findsNothing);
  });

  testWidgets('tile: no chevron when hasChevron is false', (tester) async {
    await _pump(
      tester,
      const CcSettingsTile(
        icon: Icons.info,
        label: 'Version',
        hasChevron: false,
      ),
    );
    expect(find.byIcon(Icons.chevron_right_rounded), findsNothing);
  });

  testWidgets('group: one divider between each pair of rows', (tester) async {
    await _pump(
      tester,
      const CcSettingsGroup(items: [Text('a'), Text('b'), Text('c')]),
    );
    expect(find.byType(CcDividerHorizontalLine), findsNWidgets(2));
  });
}
