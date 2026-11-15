import 'package:cc_sdk_ui/widgets/navigation/cc_curved_navigation_bar.dart';
import 'package:cc_sdk_ui/widgets/navigation/cc_navigation_rail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const _badge = Key('badge');

final _items = [
  const CcCurvedNavigationItem(
    inactiveIcon: Icons.pie_chart_outline,
    activeIcon: Icons.pie_chart,
    label: 'Budget',
    badgeWidget: SizedBox(key: _badge, width: 8, height: 8),
  ),
  const CcCurvedNavigationItem(
    inactiveIcon: Icons.add,
    activeIcon: Icons.add,
    label: 'Entry',
  ),
  const CcCurvedNavigationItem(
    inactiveIcon: Icons.person_outline,
    activeIcon: Icons.person,
    label: 'Profile',
    badgeText: '3',
  ),
];

Future<int?> _pumpAndTap(
  WidgetTester tester,
  String label, {
  int currentIndex = 1,
  int? primaryIndex,
  bool extended = false,
  List<CcCurvedNavigationItem>? items,
}) async {
  tester.view.physicalSize = const Size(1024, 768);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  int? tapped;
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: Row(
          children: [
            CcNavigationRail(
              items: items ?? _items,
              currentIndex: currentIndex,
              primaryIndex: primaryIndex,
              extended: extended,
              onTap: (index) => tapped = index,
            ),
            const Expanded(child: SizedBox()),
          ],
        ),
      ),
    ),
  );
  await tester.tap(find.text(label));
  await tester.pump();
  return tapped;
}

void main() {
  testWidgets('shows every item label and reports taps by index', (
    tester,
  ) async {
    expect(await _pumpAndTap(tester, 'Profile'), 2);
    expect(find.text('Budget'), findsOneWidget);
    expect(find.text('Entry'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('renders custom badge widgets and text badges', (tester) async {
    await _pumpAndTap(tester, 'Budget');
    expect(find.byKey(_badge), findsOneWidget);
    expect(find.text('3'), findsOneWidget);
  });

  testWidgets('the primary item is a separate action, mapped to its index', (
    tester,
  ) async {
    // "Entry" (index 1) becomes the round action; Budget/Profile stay
    // destinations and keep their original indexes.
    expect(await _pumpAndTap(tester, 'Entry', primaryIndex: 1), 1);
    expect(find.byType(NavigationRailDestination), findsNothing);
    final rail = tester.widget<NavigationRail>(find.byType(NavigationRail));
    expect(rail.destinations, hasLength(2));
    // Entry is open, so no destination is selected.
    expect(rail.selectedIndex, isNull);

    expect(
      await _pumpAndTap(tester, 'Profile', primaryIndex: 1, currentIndex: 0),
      2,
    );
    final railAfter = tester.widget<NavigationRail>(
      find.byType(NavigationRail),
    );
    expect(railAfter.selectedIndex, 0);
  });

  testWidgets('a long label wraps instead of widening the rail', (
    tester,
  ) async {
    await _pumpAndTap(
      tester,
      'Entry',
      items: [
        const CcCurvedNavigationItem(
          inactiveIcon: Icons.pie_chart_outline,
          activeIcon: Icons.pie_chart,
          label: 'A very long budget allocation label',
        ),
        ..._items.skip(1),
      ],
    );
    expect(
      tester.getSize(find.byType(NavigationRail)).width,
      CcNavigationRail.railWidth,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('extended rail shows labels beside icons', (tester) async {
    expect(
      await _pumpAndTap(tester, 'Profile', primaryIndex: 1, extended: true),
      2,
    );
    expect(
      tester.getSize(find.byType(NavigationRail)).width,
      CcNavigationRail.extendedRailWidth,
    );
    expect(tester.takeException(), isNull);
  });
}
