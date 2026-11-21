import 'package:cc_sdk_data/export_cc_sdk_data.dart';
import 'package:flutter_test/flutter_test.dart';

import '../example/main.dart';

// Keeps example/main.dart compiling and working: it uses only cc_sdk_data
// (no Flutter), so this also proves the package stands alone.
void main() {
  const source = ExampleUserSource();

  test('describes the first page of users', () async {
    const request = PaginationRequest();
    final lines = describePage(request, await source.fetch(request));

    expect(lines.first, 'Page 1');
    expect(lines, contains('user0@example.com'));
    // An odd user has no email, so it is shown by phone number.
    expect(lines, contains('+10000001'));
  });

  test('pages forward and back', () async {
    final next = const PaginationRequest().nextPage();
    final lines = describePage(next, await source.fetch(next));
    expect(lines.first, 'Page 2');
    expect(lines, contains('user10@example.com'));
    expect(next.previousPage().page, 1);
  });

  test('describes the failure', () async {
    const failing = ExampleUserSource(failOnPage: 1);
    const request = PaginationRequest();
    final lines = describePage(request, await failing.fetch(request));

    expect(lines, ['Page 1', 'No connection']);
  });
}
