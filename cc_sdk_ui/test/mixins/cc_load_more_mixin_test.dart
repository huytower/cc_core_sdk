import 'package:cc_sdk_ui/export_cc_sdk_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class _List with CcLoadMoreMixin {}

const _labels = CcLoadMoreLabels();

Future<void> _pumpList(
  WidgetTester tester, {
  required int itemCount,
  required bool isFinish,
  required Future<bool> Function() onLoadMore,
}) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: _List().buildLoadMore(
          itemCount: itemCount,
          itemBuilder: (_, i) => ListTile(title: Text('Item $i')),
          isFinish: isFinish,
          onLoadMore: onLoadMore,
        ),
      ),
    ),
  );
}

void main() {
  testWidgets('asks for more data when the footer comes into view', (
    tester,
  ) async {
    var calls = 0;
    await _pumpList(
      tester,
      itemCount: 1,
      isFinish: false,
      onLoadMore: () async {
        calls++;
        return true;
      },
    );
    await tester.pump();

    expect(calls, greaterThan(0));
  });

  testWidgets('stops asking and shows "no more" once isFinish is true', (
    tester,
  ) async {
    var calls = 0;
    await _pumpList(
      tester,
      itemCount: 1,
      isFinish: true,
      onLoadMore: () async {
        calls++;
        return true;
      },
    );
    await tester.pump();

    expect(calls, 0);
    expect(find.text(_labels.noMore, findRichText: true), findsOneWidget);
  });

  testWidgets('a failed load offers a retry, which loads again', (
    tester,
  ) async {
    var calls = 0;
    await _pumpList(
      tester,
      itemCount: 1,
      isFinish: false,
      onLoadMore: () async => ++calls > 1,
    );
    await tester.pump();
    await tester.pump();

    final retry = find.text(_labels.failed, findRichText: true);
    expect(retry, findsOneWidget);
    expect(calls, 1);

    await tester.tap(retry);
    await tester.pump();
    await tester.pump();

    expect(calls, greaterThan(1));
  });

  testWidgets('does not load while the footer is out of view', (tester) async {
    var calls = 0;
    await _pumpList(
      tester,
      itemCount: 200,
      isFinish: false,
      onLoadMore: () async {
        calls++;
        return true;
      },
    );
    await tester.pump();

    expect(calls, 0);
  });
}
