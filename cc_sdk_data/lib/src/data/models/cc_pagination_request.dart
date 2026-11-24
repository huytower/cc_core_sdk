/// Represents a pagination request with page number and items per page
class CcPaginationRequest {
  /// The page number (1-based index)
  final int page;

  /// Number of items per page
  final int itemsPerPage;

  /// Creates a pagination request
  const CcPaginationRequest({this.page = 1, this.itemsPerPage = 10})
    : assert(page > 0, 'Page must be greater than 0'),
      assert(itemsPerPage > 0, 'Items per page must be greater than 0');

  /// Creates a copy of this pagination request with updated fields
  CcPaginationRequest copyWith({int? page, int? itemsPerPage}) {
    return CcPaginationRequest(
      page: page ?? this.page,
      itemsPerPage: itemsPerPage ?? this.itemsPerPage,
    );
  }

  /// Converts this pagination request to a query parameters map
  Map<String, dynamic> toJson() {
    return {'page': page, 'per_page': itemsPerPage};
  }

  /// Creates a pagination request for the next page
  CcPaginationRequest nextPage() {
    return copyWith(page: page + 1);
  }

  /// Creates a pagination request for the previous page
  CcPaginationRequest previousPage() {
    return page > 1 ? copyWith(page: page - 1) : this;
  }
}
