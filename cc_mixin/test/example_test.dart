import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:loadmore/loadmore.dart';

import '../example/main.dart';

// Keeps example/main.dart compiling and working: it uses only SDK packages and
// no state-management library, so this also proves cc_mixin stands alone.

String _footerText(LoadMoreStatus status) =>
    DefaultLoadMoreTextBuilder.english(status);

/// The load-more footer starts a short timer on every build; let the last ones
/// run out before the test ends.
Future<void> _dispose(WidgetTester tester) async {
  await tester.pumpWidget(const SizedBox.shrink());
  await tester.pump(const Duration(milliseconds: 100));
}

void main() {
  testWidgets('loads the first page', (tester) async {
    await tester.pumpWidget(const CcMixinExampleApp());
    await tester.pumpAndSettle();

    expect(find.text('Item 0'), findsOneWidget);
    await _dispose(tester);
  });

  testWidgets('loads the next pages at the list end, then shows "no more"', (
    tester,
  ) async {
    await tester.pumpWidget(
      CcMixinExampleApp(source: ExampleItemSource(total: 15)),
    );
    await tester.pumpAndSettle();

    final noMore = find.text(
      _footerText(LoadMoreStatus.nomore),
      findRichText: true,
    );
    await tester.scrollUntilVisible(noMore, 200);
    await tester.pumpAndSettle();

    // The second page held 5 of 10 items, so the list is finished.
    expect(noMore, findsOneWidget);
    await tester.scrollUntilVisible(find.text('Item 14'), -200);
    expect(find.text('Item 14'), findsOneWidget);
    await _dispose(tester);
  });

  testWidgets('shows the error, then retries', (tester) async {
    await tester.pumpWidget(
      CcMixinExampleApp(source: ExampleItemSource(failFirstLoad: true)),
    );
    await tester.pumpAndSettle();

    expect(find.text('No connection', findRichText: true), findsOneWidget);

    await tester.tap(find.text('Retry', findRichText: true));
    await tester.pumpAndSettle();
    // Let the retry button's debounce timer (600 ms) run out.
    await tester.pump(const Duration(seconds: 1));

    expect(find.text('Item 0'), findsOneWidget);
    await _dispose(tester);
  });
}
