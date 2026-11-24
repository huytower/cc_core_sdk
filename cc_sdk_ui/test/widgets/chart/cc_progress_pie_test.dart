import 'package:cc_sdk_ui/export_cc_sdk_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('takes the given size; sheet header shows its texts', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              Center(
                child: CcProgressPie(
                  key: Key('pie'),
                  progress: 1.7,
                  color: Colors.orange,
                  size: 30,
                ),
              ),
              CcSheetHeader(
                title: 'Review',
                subtitle: '3 items',
                trailing: Icon(Icons.close),
              ),
            ],
          ),
        ),
      ),
    );

    expect(tester.getSize(find.byKey(const Key('pie'))), const Size(30, 30));
    expect(find.text('Review', findRichText: true), findsOneWidget);
    expect(find.text('3 items', findRichText: true), findsOneWidget);
    expect(find.byIcon(Icons.close), findsOneWidget);
  });
}
