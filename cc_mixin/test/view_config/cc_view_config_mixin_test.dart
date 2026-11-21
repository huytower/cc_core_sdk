import 'package:cc_mixin/export_cc_mixin.dart';
import 'package:cc_sdk_ui/export_cc_sdk_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class _View extends StatelessWidget with CcViewConfigMixin {
  _View({
    required this.layoutStatus,
    this.enableLoading = true,
    this.enableAppBar = true,
  });

  @override
  final CcLayoutStatus layoutStatus;

  @override
  final bool enableLoading;

  @override
  final bool enableAppBar;

  @override
  String get errorMessage => 'Something failed';

  @override
  Widget? buildContent(BuildContext context) => const Text('content');
}

Future<void> _pump(WidgetTester tester, Widget view) =>
    tester.pumpWidget(MaterialApp(home: view));

void main() {
  testWidgets('success shows the content', (tester) async {
    await _pump(tester, _View(layoutStatus: CcLayoutStatus.success));

    expect(find.text('content'), findsOneWidget);
  });

  testWidgets('loadMore keeps showing the content', (tester) async {
    await _pump(tester, _View(layoutStatus: CcLayoutStatus.loadMore));

    expect(find.text('content'), findsOneWidget);
  });

  for (final status in [CcLayoutStatus.loading, CcLayoutStatus.refresh]) {
    testWidgets('$status shows the loading page', (tester) async {
      await _pump(tester, _View(layoutStatus: status));

      expect(find.byType(LoadingPage), findsOneWidget);
      expect(find.byType(CupertinoActivityIndicator), findsOneWidget);
      expect(find.text('content'), findsNothing);
    });

    testWidgets('$status shows the content when loading is disabled', (
      tester,
    ) async {
      await _pump(tester, _View(layoutStatus: status, enableLoading: false));

      expect(find.byType(LoadingPage), findsNothing);
      expect(find.text('content'), findsOneWidget);
    });
  }

  testWidgets('empty shows the empty page', (tester) async {
    await _pump(tester, _View(layoutStatus: CcLayoutStatus.empty));

    expect(find.byType(EmptyPage), findsOneWidget);
    expect(find.text('content'), findsNothing);
  });

  testWidgets('error shows the error message', (tester) async {
    await _pump(tester, _View(layoutStatus: CcLayoutStatus.error));

    expect(find.byType(ErrorPage), findsOneWidget);
    expect(find.text('Something failed', findRichText: true), findsOneWidget);
  });

  testWidgets('enableAppBar controls the app bar', (tester) async {
    await _pump(tester, _View(layoutStatus: CcLayoutStatus.success));
    expect(find.byType(AppBar), findsOneWidget);

    await _pump(
      tester,
      _View(layoutStatus: CcLayoutStatus.success, enableAppBar: false),
    );
    expect(find.byType(AppBar), findsNothing);
  });
}
