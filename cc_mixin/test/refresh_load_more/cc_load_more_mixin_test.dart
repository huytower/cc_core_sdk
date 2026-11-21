import 'package:cc_mixin/export_cc_mixin.dart';
import 'package:cc_mixin/src/refresh_load_more/cc_load_more_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:loadmore/loadmore.dart';

class _List with CcLoadMoreMixin {}

String _footerText(LoadMoreStatus status) =>
    DefaultLoadMoreTextBuilder.english(status);

Future<int> _pumpList(WidgetTester tester, {required bool isFinish}) async {
  var calls = 0;
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: _List().buildLoadMore(
          isFinish: isFinish,
          onLoadMore: () async {
            calls++;
            return true;
          },
          child: ListView.builder(
            itemCount: 1,
            itemBuilder: (_, i) => ListTile(title: Text('Item $i')),
          ),
        ),
      ),
    ),
  );
  // LoadMore updates its status on the next event-loop turn and asks for more
  // data a short delay after the footer is built.
  await tester.pump(const Duration(milliseconds: 100));
  await tester.pump(const Duration(milliseconds: 100));
  return calls;
}

/// Each footer build starts a short timer; let the last ones run out.
Future<void> _disposeList(WidgetTester tester) async {
  await tester.pumpWidget(const SizedBox.shrink());
  await tester.pump(const Duration(milliseconds: 100));
}

void main() {
  testWidgets('asks for more data while the list is not finished', (
    tester,
  ) async {
    final calls = await _pumpList(tester, isFinish: false);

    expect(calls, greaterThan(0));
    await _disposeList(tester);
  });

  testWidgets('stops asking and shows "no more" once isFinish is true', (
    tester,
  ) async {
    final calls = await _pumpList(tester, isFinish: true);

    expect(calls, 0);
    expect(
      find.text(_footerText(LoadMoreStatus.nomore), findRichText: true),
      findsOneWidget,
    );
    await _disposeList(tester);
  });

  test('the footer draws nothing while scrolled out of view', () {
    final footer = const CcLoadMoreItem().buildChild(LoadMoreStatus.outScreen);

    expect(footer, isA<SizedBox>());
  });
}
