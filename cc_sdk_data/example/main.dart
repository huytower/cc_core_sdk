// Minimal example of cc_sdk_data on its own: no app module, no domain feature.
//
// It pages through a fake user source with PaginationRequest, gets back a
// Result<List<CcUserEntity>, CcFailure>, and shows either the users or the
// failure message.
import 'package:cc_sdk_data/export_cc_sdk_data.dart';
import 'package:flutter/material.dart';
import 'package:multiple_result/multiple_result.dart';

void main() => runApp(const CcSdkDataExampleApp());

/// A data source as an app would write it: it takes a [PaginationRequest] and
/// answers with a [Result], never by throwing.
class ExampleUserSource {
  const ExampleUserSource({this.total = 25, this.failOnPage});

  final int total;

  /// Page that answers with a [NetworkFailure], to show the error path.
  final int? failOnPage;

  Future<Result<List<CcUserEntity>, CcFailure>> fetch(
    PaginationRequest request,
  ) async {
    if (request.page == failOnPage) {
      return const Error(NetworkFailure('No connection'));
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
          isEmailVerified: i.isEven,
          isPhoneVerified: !i.isEven,
          registeredDeviceIds: const [],
          createdAt: createdAt,
          updatedAt: createdAt,
        ),
    ]);
  }
}

class CcSdkDataExampleApp extends StatelessWidget {
  const CcSdkDataExampleApp({
    super.key,
    this.source = const ExampleUserSource(),
  });

  final ExampleUserSource source;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'cc_sdk_data example',
      home: ExampleUserPage(source: source),
    );
  }
}

class ExampleUserPage extends StatefulWidget {
  const ExampleUserPage({super.key, required this.source});

  final ExampleUserSource source;

  @override
  State<ExampleUserPage> createState() => _ExampleUserPageState();
}

class _ExampleUserPageState extends State<ExampleUserPage> {
  PaginationRequest _request = const PaginationRequest();
  List<CcUserEntity> _users = const [];
  CcFailure? _failure;

  @override
  void initState() {
    super.initState();
    _load(_request);
  }

  Future<void> _load(PaginationRequest request) async {
    final result = await widget.source.fetch(request);
    if (!mounted) return;
    setState(() {
      _request = request;
      result.when(
        (users) {
          _users = users;
          _failure = null;
        },
        (failure) => _failure = failure,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final failure = _failure;
    return Scaffold(
      appBar: AppBar(title: Text('Page ${_request.page}')),
      body: failure != null
          ? Center(child: Text(failure.message))
          : ListView(
              children: [
                for (final user in _users)
                  ListTile(
                    title: Text(user.displayIdentifier),
                    subtitle: Text(user.id),
                  ),
              ],
            ),
      bottomNavigationBar: OverflowBar(
        alignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            onPressed: () => _load(_request.previousPage()),
            child: const Text('Previous'),
          ),
          TextButton(
            onPressed: () => _load(_request.nextPage()),
            child: const Text('Next'),
          ),
        ],
      ),
    );
  }
}
