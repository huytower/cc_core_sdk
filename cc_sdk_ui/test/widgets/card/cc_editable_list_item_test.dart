import 'package:cc_sdk_ui/export_cc_sdk_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> _pump(
  WidgetTester tester, {
  bool hasEditMode = false,
  bool hasDeletable = true,
  VoidCallback? onEdit,
  VoidCallback? onDelete,
}) => tester.pumpWidget(
  MaterialApp(
    home: Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: CcEditableListItem(
          header: const Text('Gold'),
          stats: const [
            CcStatRow(label: 'Value', value: '10', color: Colors.amber),
          ],
          hasEditMode: hasEditMode,
          hasDeletable: hasDeletable,
          onEdit: onEdit ?? () {},
          onDelete: onDelete ?? () {},
        ),
      ),
    ),
  ),
);

void main() {
  testWidgets('not editing: no badges, shows header and stats', (tester) async {
    await _pump(tester);
    expect(find.text('Gold'), findsOneWidget);
    expect(find.text('Value: ', findRichText: true), findsOneWidget);
    expect(find.byType(CcEditBadge), findsNothing);
  });

  testWidgets('editing: delete and edit badges call back', (tester) async {
    var edits = 0;
    var deletes = 0;
    await _pump(
      tester,
      hasEditMode: true,
      onEdit: () => edits++,
      onDelete: () => deletes++,
    );
    expect(find.byType(CcEditBadge), findsNWidgets(2));

    await tester.tap(find.byIcon(Icons.edit));
    await tester.tap(find.byIcon(Icons.remove));
    await tester.pump(const Duration(seconds: 1));
    expect(edits, 1);
    expect(deletes, 1);
  });

  testWidgets('editing, not deletable: edit badge only', (tester) async {
    await _pump(tester, hasEditMode: true, hasDeletable: false);
    expect(find.byIcon(Icons.remove), findsNothing);
    expect(find.byIcon(Icons.edit), findsOneWidget);
  });
}
