import 'package:cc_sdk_ui/export_cc_sdk_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> _pump(WidgetTester tester, Widget child) => tester.pumpWidget(
  MaterialApp(
    home: Scaffold(body: Center(child: child)),
  ),
);

void main() {
  testWidgets('unlocked: child is returned as is and receives taps', (
    tester,
  ) async {
    var childTaps = 0;
    await _pump(
      tester,
      CcLockOverlay(
        hasLocked: false,
        child: TextButton(
          onPressed: () => childTaps++,
          child: const Text('Action'),
        ),
      ),
    );

    expect(find.byIcon(Icons.lock_outline_rounded), findsNothing);
    await tester.tap(find.text('Action'));
    expect(childTaps, 1);
  });

  testWidgets('locked: shows the badge, blocks the child, calls onLockedTap', (
    tester,
  ) async {
    var childTaps = 0;
    var lockTaps = 0;
    await _pump(
      tester,
      CcLockOverlay(
        hasLocked: true,
        onLockedTap: () => lockTaps++,
        child: TextButton(
          onPressed: () => childTaps++,
          child: const Text('Action'),
        ),
      ),
    );

    expect(find.byIcon(Icons.lock_outline_rounded), findsOneWidget);
    await tester.tap(find.text('Action'), warnIfMissed: false);
    expect(childTaps, 0);
    expect(lockTaps, 1);
  });

  testWidgets('locked without onLockedTap: taps are swallowed', (
    tester,
  ) async {
    var childTaps = 0;
    await _pump(
      tester,
      CcLockOverlay(
        hasLocked: true,
        icon: Icons.lock_clock_outlined,
        child: TextButton(
          onPressed: () => childTaps++,
          child: const Text('Action'),
        ),
      ),
    );

    expect(find.byIcon(Icons.lock_clock_outlined), findsOneWidget);
    await tester.tap(find.text('Action'), warnIfMissed: false);
    expect(childTaps, 0);
  });
}
