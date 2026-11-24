import 'package:cc_sdk_ui/export_cc_sdk_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const _items = [
  CcCurvedNavigationItem(
    inactiveIcon: Icons.pie_chart_outline,
    activeIcon: Icons.pie_chart,
    label: 'Budget',
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
  ),
];

void _setWindow(WidgetTester tester, Size size) {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
}

/// A page with its own state, to check it survives bar <-> rail switches.
class _Counter extends StatefulWidget {
  const _Counter();

  @override
  State<_Counter> createState() => _CounterState();
}

class _CounterState extends State<_Counter> {
  int count = 0;

  @override
  Widget build(BuildContext context) => TextButton(
    onPressed: () => setState(() => count++),
    child: Text('count $count'),
  );
}

Widget _app({
  bool hasNavigation = true,
  Widget Function(Widget)? navigationBuilder,
  ValueChanged<int>? onSelect,
  Widget body = const _Counter(),
}) {
  return MaterialApp(
    home: CcAdaptiveNavigationScaffold(
      destinations: _items,
      currentIndex: 1,
      onSelect: onSelect ?? (_) {},
      primaryIndex: 1,
      hasNavigation: hasNavigation,
      navigationBuilder: navigationBuilder,
      body: body,
    ),
  );
}

void main() {
  group('bar or rail by window', () {
    for (final window in CcReferenceWindows.all) {
      testWidgets('$window', (tester) async {
        _setWindow(tester, window.size);
        addTearDown(tester.view.reset);
        await tester.pumpWidget(_app());
        await tester.pump(const Duration(seconds: 1));

        final hasRail = window.size.width >= 840;
        expect(
          find.byType(CcNavigationRail),
          hasRail ? findsOneWidget : findsNothing,
        );
        expect(
          find.byType(CcCurvedNavigationBar),
          hasRail ? findsNothing : findsOneWidget,
        );
        expect(tester.takeException(), isNull);
      });
    }
  });

  testWidgets('rail shows labels only from 1600 dp', (tester) async {
    addTearDown(tester.view.reset);
    bool extendedAt(Size size) =>
        tester.widget<CcNavigationRail>(find.byType(CcNavigationRail)).extended;

    _setWindow(tester, const Size(1280, 800));
    await tester.pumpWidget(_app());
    expect(extendedAt(const Size(1280, 800)), isFalse);

    _setWindow(tester, const Size(1700, 1000));
    await tester.pumpWidget(_app());
    expect(extendedAt(const Size(1700, 1000)), isTrue);
  });

  testWidgets('the page keeps its state when bar switches to rail', (
    tester,
  ) async {
    addTearDown(tester.view.reset);
    _setWindow(tester, const Size(800, 1280));
    await tester.pumpWidget(_app());
    await tester.tap(find.text('count 0'));
    await tester.pump();
    expect(find.text('count 1'), findsOneWidget);

    _setWindow(tester, const Size(1280, 800));
    await tester.pump();
    expect(find.byType(CcNavigationRail), findsOneWidget);
    expect(find.text('count 1'), findsOneWidget);
  });

  testWidgets('rail scope tells the page whether the rail is there', (
    tester,
  ) async {
    addTearDown(tester.view.reset);
    late bool railVisible;
    final probe = Builder(
      builder: (context) {
        railVisible = CcNavigationRailScope.railVisibleOf(context);
        return const SizedBox();
      },
    );

    _setWindow(tester, const Size(390, 844));
    await tester.pumpWidget(_app(body: probe));
    expect(railVisible, isFalse);

    _setWindow(tester, const Size(1280, 800));
    await tester.pumpWidget(_app(body: probe));
    expect(railVisible, isTrue);
  });

  testWidgets('hasNavigation false hides bar and rail', (tester) async {
    addTearDown(tester.view.reset);
    _setWindow(tester, const Size(390, 844));
    await tester.pumpWidget(_app(hasNavigation: false));
    expect(find.byType(CcCurvedNavigationBar), findsNothing);

    _setWindow(tester, const Size(1280, 800));
    await tester.pumpWidget(_app(hasNavigation: false));
    expect(find.byType(CcNavigationRail), findsNothing);
  });

  testWidgets('navigationBuilder wraps the bar and the rail', (tester) async {
    addTearDown(tester.view.reset);
    Widget wrap(Widget navigation) =>
        KeyedSubtree(key: const Key('wrapper'), child: navigation);

    _setWindow(tester, const Size(390, 844));
    await tester.pumpWidget(_app(navigationBuilder: wrap));
    expect(
      find.descendant(
        of: find.byKey(const Key('wrapper')),
        matching: find.byType(CcCurvedNavigationBar),
      ),
      findsOneWidget,
    );

    _setWindow(tester, const Size(1280, 800));
    await tester.pumpWidget(_app(navigationBuilder: wrap));
    expect(
      find.descendant(
        of: find.byKey(const Key('wrapper')),
        matching: find.byType(CcNavigationRail),
      ),
      findsOneWidget,
    );
  });

  testWidgets('tapping a rail destination calls onSelect', (tester) async {
    addTearDown(tester.view.reset);
    int? selected;
    _setWindow(tester, const Size(1280, 800));
    await tester.pumpWidget(_app(onSelect: (i) => selected = i));
    await tester.tap(find.byIcon(Icons.person_outline));
    await tester.pumpAndSettle();
    expect(selected, 2);
  });

  test('gesture insets are capped, 3-button insets kept', () {
    expect(CcAdaptiveNavigationScaffold.bottomPaddingFor(0), 0);
    expect(CcAdaptiveNavigationScaffold.bottomPaddingFor(20), 20);
    // iPhone home indicator (34 dp) -> 22 dp.
    expect(CcAdaptiveNavigationScaffold.bottomPaddingFor(34), 22);
    // Android 3-button bar (48 dp) keeps its whole inset.
    expect(CcAdaptiveNavigationScaffold.bottomPaddingFor(48), 48);
  });
}
