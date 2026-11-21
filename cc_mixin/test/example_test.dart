import 'package:flutter_test/flutter_test.dart';

import '../example/main.dart';

// Keeps example/main.dart compiling and working: it uses only cc_mixin,
// cc_sdk_data and Flutter, which also proves cc_mixin stands alone.
void main() {
  testWidgets('loads the first page', (tester) async {
    await tester.pumpWidget(const CcMixinExampleApp());
    await tester.pumpAndSettle();

    expect(find.text('Item 0'), findsOneWidget);
  });

  testWidgets('loads the next pages, then shows "no more"', (tester) async {
    await tester.pumpWidget(
      CcMixinExampleApp(source: ExampleItemSource(total: 15)),
    );
    await tester.pumpAndSettle();

    final loadMore = find.text('Load more');
    await tester.scrollUntilVisible(loadMore, 200);
    await tester.tap(loadMore);
    await tester.pumpAndSettle();

    final noMore = find.text('No more items');
    await tester.scrollUntilVisible(noMore, 200);
    // The second page held 5 of 10 items, so the list is finished.
    expect(noMore, findsOneWidget);
    expect(find.text('Item 14'), findsOneWidget);
  });

  testWidgets('shows the error, then retries', (tester) async {
    await tester.pumpWidget(
      CcMixinExampleApp(source: ExampleItemSource(failFirstLoad: true)),
    );
    await tester.pumpAndSettle();

    final retry = find.text('No connection - Retry');
    expect(retry, findsOneWidget);

    await tester.tap(retry);
    await tester.pumpAndSettle();

    expect(find.text('Item 0'), findsOneWidget);
  });
}
