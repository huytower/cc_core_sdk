import 'package:cc_sdk_data/export_cc_sdk_data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CcPaginationRequest', () {
    test('defaults to page 1 with 10 items per page', () {
      const request = CcPaginationRequest();

      expect(request.page, 1);
      expect(request.itemsPerPage, 10);
    });

    test('toJson uses the page / per_page query keys', () {
      const request = CcPaginationRequest(page: 3, itemsPerPage: 25);

      expect(request.toJson(), {'page': 3, 'per_page': 25});
    });

    test('copyWith keeps the fields it is not given', () {
      const request = CcPaginationRequest(page: 2, itemsPerPage: 15);

      final copy = request.copyWith(page: 4);

      expect(copy.page, 4);
      expect(copy.itemsPerPage, 15);
    });

    test('nextPage moves forward one page and keeps the page size', () {
      const request = CcPaginationRequest(page: 2, itemsPerPage: 30);

      final next = request.nextPage();

      expect(next.page, 3);
      expect(next.itemsPerPage, 30);
    });

    test('previousPage moves back one page', () {
      const request = CcPaginationRequest(page: 3);

      expect(request.previousPage().page, 2);
    });

    test('previousPage on the first page returns the same request', () {
      const request = CcPaginationRequest();

      expect(identical(request.previousPage(), request), isTrue);
    });

    test('rejects a page or page size below 1', () {
      expect(() => CcPaginationRequest(page: 0), throwsAssertionError);
      expect(() => CcPaginationRequest(itemsPerPage: 0), throwsAssertionError);
    });
  });
}
