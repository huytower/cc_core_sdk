// Minimal example of cc_mixin on its own: no design system, no app module,
// no state-management package. A plain State object mixes in:
// - CcPaginationMixin: page arithmetic and the "has more" flag,
// - CcDoubleBackToExitMixin: "press back again to exit" on Android.
// The widget-building mixins (CcViewConfigMixin, CcPullToRefreshMixin,
// CcLoadMoreMixin, CcCurvedNavigationMixin) live in cc_sdk_ui.
import 'package:cc_mixin/export_cc_mixin.dart';
import 'package:cc_sdk_data/export_cc_sdk_data.dart';
import 'package:flutter/material.dart';
import 'package:multiple_result/multiple_result.dart';

void main() => runApp(const CcMixinExampleApp());

/// Fake paged source; [failFirstLoad] shows the error and retry.
class ExampleItemSource {
  ExampleItemSource({this.total = 30, this.failFirstLoad = false});

  final int total;
  bool failFirstLoad;

  Future<Result<List<String>, CcFailure>> fetch(
    CcPaginationRequest request,
  ) async {
    if (failFirstLoad) {
      failFirstLoad = false;
      return const Error(CcNetworkFailure('No connection'));
    }
    final start = (request.page - 1) * request.itemsPerPage;
    final end = (start + request.itemsPerPage).clamp(0, total);
    return Success([for (var i = start; i < end; i++) 'Item $i']);
  }
}

class CcMixinExampleApp extends StatelessWidget {
  const CcMixinExampleApp({super.key, this.source});

  final ExampleItemSource? source;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'cc_mixin example',
      home: ExampleListPage(source: source ?? ExampleItemSource()),
    );
  }
}

class ExampleListPage extends StatefulWidget {
  const ExampleListPage({super.key, required this.source});

  final ExampleItemSource source;

  @override
  State<ExampleListPage> createState() => _ExampleListPageState();
}

class _ExampleListPageState extends State<ExampleListPage>
    with CcPaginationMixin, CcDoubleBackToExitMixin {
  final _items = <String>[];
  String? _error;

  @override
  void initState() {
    super.initState();
    initPagination(initialItemsPerPage: 10);
    _load(refresh: true);
  }

  /// Loads the first page ([refresh]) or the next one.
  Future<void> _load({bool refresh = false}) async {
    if (!refresh && !canFetchMore) return;
    setPaginationLoading(true);
    final request = refresh
        ? CcPaginationRequest(itemsPerPage: itemsPerPage)
        : currentPaginationRequest;
    final result = handlePaginationResult(
      await widget.source.fetch(request),
      hasRefresh: refresh,
    );
    setPaginationLoading(false);
    if (!mounted) return;
    setState(() {
      result.when(
        (page) {
          if (refresh) _items.clear();
          _items.addAll(page);
          _error = null;
        },
        (failure) => _error = failure.message,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: canPop,
      onPopInvokedWithResult: (didPop, result) =>
          onPopInvokedWithResult(context, didPop, result),
      child: Scaffold(
        appBar: AppBar(title: const Text('cc_mixin example')),
        body: ListView.builder(
          itemCount: _items.length + 1,
          itemBuilder: (_, index) => index < _items.length
              ? ListTile(title: Text(_items[index]))
              : _buildFooter(),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    if (_error != null) {
      return TextButton(
        onPressed: () => _load(refresh: _items.isEmpty),
        child: Text('$_error - Retry'),
      );
    }
    if (!hasMore) return const ListTile(title: Text('No more items'));
    return TextButton(onPressed: _load, child: const Text('Load more'));
  }
}
