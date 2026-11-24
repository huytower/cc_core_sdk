// Minimal example of cc_sdk_data on its own: no Flutter, no app module, no
// domain feature.
//
// It pages through a fake user source with CcPaginationRequest, gets back a
// Result<List<CcUserEntity>, CcFailure>, and prints either the users or the
// failure message.
import 'package:cc_sdk_data/export_cc_sdk_data.dart';
import 'package:multiple_result/multiple_result.dart';

Future<void> main() async {
  const source = ExampleUserSource();
  var request = const CcPaginationRequest();
  for (var i = 0; i < 2; i++) {
    // ignore: avoid_print
    describePage(request, await source.fetch(request)).forEach(print);
    request = request.nextPage();
  }
}

/// A data source as an app would write it: it takes a [CcPaginationRequest] and
/// answers with a [Result], never by throwing.
class ExampleUserSource {
  const ExampleUserSource({this.total = 25, this.failOnPage});

  final int total;

  /// Page that answers with a [CcNetworkFailure], to show the error path.
  final int? failOnPage;

  Future<Result<List<CcUserEntity>, CcFailure>> fetch(
    CcPaginationRequest request,
  ) async {
    if (request.page == failOnPage) {
      return const Error(CcNetworkFailure('No connection'));
    }
    final start = (request.page - 1) * request.itemsPerPage;
    final end = (start + request.itemsPerPage).clamp(0, total);
    final createdAt = DateTime.utc(2026, 1, 1);
    return Success([
      for (var i = start; i < end; i++)
        CcUserEntity(
          id: 'user-$i',
          email: i.isEven ? 'user$i@example.com' : '',
          phoneNumber: i.isEven ? null : '+1000000$i',
          status: CcUserStatus.active,
          hasEmailVerified: i.isEven,
          hasPhoneVerified: !i.isEven,
          registeredDeviceIds: const [],
          createdAt: createdAt,
          updatedAt: createdAt,
        ),
    ]);
  }
}

/// The lines shown for one page: a header, then each user or the failure.
List<String> describePage(
  CcPaginationRequest request,
  Result<List<CcUserEntity>, CcFailure> result,
) => [
  'Page ${request.page}',
  ...result.when(
    (users) => [for (final user in users) user.displayIdentifier],
    (failure) => [failure.message],
  ),
];
