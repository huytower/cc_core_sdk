import 'package:cc_mixin/export_cc_mixin.dart';
import 'package:cc_sdk_data/export_cc_sdk_data.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:multiple_result/multiple_result.dart';

class _Pager with PaginationMixin {}

Result<List<int>, CcFailure> _page(int count) =>
    Success(List<int>.generate(count, (i) => i));

void main() {
  late _Pager pager;

  setUp(() {
    pager = _Pager()..initPagination(initialItemsPerPage: 3);
  });

  test('starts on the first page with more to fetch', () {
    expect(pager.currentPage, 1);
    expect(pager.itemsPerPage, 3);
    expect(pager.isFirstPage, isTrue);
    expect(pager.hasMore, isTrue);
    expect(pager.canFetchMore, isTrue);
  });

  test('currentPaginationRequest mirrors the current state', () {
    final request = pager.currentPaginationRequest;

    expect(request.page, 1);
    expect(request.itemsPerPage, 3);
  });

  test('a full page moves to the next page and keeps hasMore', () {
    final result = pager.handlePaginationResult(_page(3));

    expect(result.isSuccess(), isTrue);
    expect(pager.currentPage, 2);
    expect(pager.hasMore, isTrue);
    expect(pager.isFirstPage, isFalse);
  });

  test('a short page ends the list and stays on the same page', () {
    pager.handlePaginationResult(_page(2));

    expect(pager.currentPage, 1);
    expect(pager.hasMore, isFalse);
    expect(pager.canFetchMore, isFalse);
  });

  test('an error is passed through and keeps the state', () {
    pager.handlePaginationResult(_page(3));

    final result = pager.handlePaginationResult<int>(
      const Error(NetworkFailure('offline')),
    );

    expect(result.tryGetError(), const NetworkFailure('offline'));
    expect(pager.currentPage, 2);
    expect(pager.hasMore, isTrue);
  });

  test('isRefresh starts again from the first page', () {
    pager
      ..handlePaginationResult(_page(3))
      ..handlePaginationResult(_page(3));
    expect(pager.currentPage, 3);

    pager.handlePaginationResult(_page(3), isRefresh: true);

    expect(pager.currentPage, 2);
    expect(pager.hasMore, isTrue);
  });

  test('loading blocks further fetches until it ends', () {
    pager.setPaginationLoading(true);

    expect(pager.isPaginationLoading, isTrue);
    expect(pager.canFetchMore, isFalse);

    pager.setPaginationLoading(false);

    expect(pager.canFetchMore, isTrue);
  });

  test('resetPagination clears the end of list and the loading flag', () {
    pager
      ..handlePaginationResult(_page(1))
      ..setPaginationLoading(true)
      ..resetPagination();

    expect(pager.currentPage, 1);
    expect(pager.hasMore, isTrue);
    expect(pager.isPaginationLoading, isFalse);
    expect(pager.itemsPerPage, 3);
  });
}
