import 'package:cc_sdk_ui/export_cc_sdk_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Cancel stays readable in a dark theme with a light outline', (
    tester,
  ) async {
    // The case that hid the label: a dark scheme whose `outline` is light.
    final scheme = const ColorScheme.dark().copyWith(
      outline: const Color(0xFFE0E0E0),
    );
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(colorScheme: scheme),
        home: Scaffold(
          body: Builder(
            builder: (context) => TextButton(
              onPressed: () => CcDialogHelper.showMessageBottomSheet(
                context: context,
                title: 'Restart?',
                content: 'Progress is reset.',
              ),
              child: const Text('open'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    final cancel = find.byWidgetPredicate(
      (widget) => widget is CcBaseButton && widget.title == 'Cancel',
    );
    expect(cancel, findsOneWidget);
    final button = tester.widget<CcBaseButton>(cancel);
    expect(button.textColor, scheme.onSurface);
    expect(button.backgroundColor, [
      scheme.surfaceContainerHighest,
      scheme.surfaceContainerHighest,
    ]);
    expect(button.textColor, isNot(button.backgroundColor!.first));
  });
}
