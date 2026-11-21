import 'dart:io';

import 'package:catcher_2/catcher_2.dart';
import 'package:cc_sdk/export_cc_sdk.dart';
import 'package:cc_sdk_catcher/export_cc_sdk_catcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../example/main.dart';

// Keeps example/main.dart compiling, and checks the options it relies on.
void main() {
  final logFile = File('${Directory.systemTemp.path}/cc_sdk_catcher_test.log');
  const reporter = CcNoopCrashReporter();

  testWidgets('example app builds', (tester) async {
    await tester.pumpWidget(const CcSdkCatcherExampleApp());

    expect(find.byType(ElevatedButton), findsOneWidget);
  });

  test('release options forward to the crash reporter and remote handlers', () {
    final remote = ConsoleHandler();
    final options = CcCatcherBootstrap.releaseOptions(
      logFile,
      crashReporter: reporter,
      remoteHandlers: [remote],
    );

    expect(options.handlers.whereType<CcCrashReporterHandler>(), hasLength(1));
    expect(options.handlers.last, same(remote));
  });

  test('debug options send no remote alert', () {
    final options = CcCatcherBootstrap.debugOptions(
      logFile,
      crashReporter: reporter,
    );

    expect(options.handlers.whereType<CcCrashReporterHandler>(), hasLength(1));
    expect(options.handlers, hasLength(3));
  });
}
