import 'package:cc_mixin/export_cc_mixin.dart';
import 'package:cc_sdk_ui/export_cc_sdk_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class _Navigation with CcCurvedNavigationMixin {
  int index = 0;

  @override
  int get currentIndex => index;

  @override
  void setIndex(int index) => this.index = index;
}

class _RenamedNavigation extends _Navigation {
  @override
  String get dashboardLabel => 'Home';
}

void main() {
  test('provides three default items with neutral labels', () {
    final labels = _Navigation().navigationItems.map((item) => item.label);

    expect(labels, ['Dashboard', 'Notification', 'Profile']);
  });

  test('labels can be overridden, e.g. with translated text', () {
    final labels = _RenamedNavigation().navigationItems.map((i) => i.label);

    expect(labels.first, 'Home');
  });

  testWidgets('the rail reports taps through setIndex', (tester) async {
    final navigation = _Navigation();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Row(children: [navigation.buildNavigationRail()]),
        ),
      ),
    );
    await tester.tap(find.byIcon(Icons.person_outline_rounded));

    expect(navigation.currentIndex, 2);
  });

  testWidgets('the bottom bar builds from the same items', (tester) async {
    final navigation = _Navigation();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(bottomNavigationBar: navigation.buildCurvedNavigationBar()),
      ),
    );

    expect(find.byType(CcCurvedNavigationBar), findsOneWidget);
  });
}
