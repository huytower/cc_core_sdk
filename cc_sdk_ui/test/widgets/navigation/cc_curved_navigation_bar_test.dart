import 'package:cc_sdk_ui/export_cc_sdk_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const _badge = Key('badge');

const _items = [
  CcCurvedNavigationItem(
    inactiveIcon: Icons.home_outlined,
    activeIcon: Icons.home,
    label: 'Home',
  ),
  CcCurvedNavigationItem(
    inactiveIcon: Icons.add,
    activeIcon: Icons.add,
    label: 'Add',
  ),
  CcCurvedNavigationItem(
    inactiveIcon: Icons.person_outline,
    activeIcon: Icons.person,
    label: 'Profile',
    badgeWidget: SizedBox(key: _badge, width: 8, height: 8),
  ),
];

Future<List<int>> _pumpBar(WidgetTester tester, {int index = 0}) async {
  final taps = <int>[];
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        bottomNavigationBar: CcCurvedNavigationBar(
          items: _items,
          currentIndex: index,
          onTap: taps.add,
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
  return taps;
}

void main() {
  testWidgets('shows every label, the selected icon in the bubble', (
    tester,
  ) async {
    await _pumpBar(tester);

    for (final item in _items) {
      expect(find.text(item.label), findsOneWidget);
    }
    expect(find.byIcon(Icons.home), findsOneWidget);
    expect(find.byKey(_badge), findsOneWidget);
  });

  testWidgets('reports taps by index', (tester) async {
    final taps = await _pumpBar(tester);

    await tester.tap(find.text('Profile'));
    await tester.tap(find.text('Add'));

    expect(taps, [2, 1]);
  });

  testWidgets('the bubble moves to a new selection without errors', (
    tester,
  ) async {
    await _pumpBar(tester);
    await _pumpBar(tester, index: 2);

    expect(find.byIcon(Icons.person), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
