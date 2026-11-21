// Minimal example of cc_mixin on its own: no app module, no domain feature,
// no state-management package. A plain State object mixes in:
// - CcViewConfigMixin: scaffold + loading / empty / error / content switch,
// - PaginationMixin: page arithmetic and the "has more" flag,
// - CcPullRefreshMixin: pull-to-refresh around the list,
// - CcLoadMoreMixin: loads the next page when the list end comes into view.
import 'package:cc_mixin/export_cc_mixin.dart';
import 'package:cc_sdk_data/export_cc_sdk_data.dart';
import 'package:cc_sdk_ui/export_cc_sdk_ui.dart';
import 'package:flutter/material.dart';
import 'package:multiple_result/multiple_result.dart';

void main() => runApp(const CcMixinExampleApp());

/// Fake paged source; [failFirstLoad] shows the error state and retry.
class ExampleItemSource {
  ExampleItemSource({this.total = 30, this.failFirstLoad = false});

  final int total;
  bool failFirstLoad;

  Future<Result<List<String>, CcFailure>> fetch(
    PaginationRequest request,
  ) async {
    if (failFirstLoad) {
      failFirstLoad = false;
      return const Error(NetworkFailure('No connection'));
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
    with
        CcViewConfigMixin,
        PaginationMixin,
        CcPullRefreshMixin,
        CcLoadMoreMixin {
  final _items = <String>[];
  CcLayoutStatus _status = CcLayoutStatus.loading;
  String _error = '';

  @override
  void initState() {
    super.initState();
    initPagination(initialItemsPerPage: 10);
    _load(refresh: true);
  }

  @override
  CcLayoutStatus get layoutStatus => _status;

  @override
  String get errorMessage => _error;

  @override
  bool get enableBottomNavigationBar => false;

  @override
  Widget? get floatingActionButton => null;

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) =>
      AppBar(title: const Text('cc_mixin example'));

  @override
  void onRetry(BuildContext context) => _load(refresh: true);

  /// Loads the first page ([refresh]) or the next one. Returns false when the
  /// load failed, which the load-more footer shows as "tap to retry".
  Future<bool> _load({bool refresh = false}) async {
    if (!refresh && !canFetchMore) return true;
    setPaginationLoading(true);
    final request = refresh
        ? PaginationRequest(itemsPerPage: itemsPerPage)
        : currentPaginationRequest;
    final result = handlePaginationResult(
      await widget.source.fetch(request),
      isRefresh: refresh,
    );
    setPaginationLoading(false);
    if (!mounted) return false;
    setState(() {
      result.when(
        (page) {
          if (refresh) _items.clear();
          _items.addAll(page);
          _status = _items.isEmpty
              ? CcLayoutStatus.empty
              : CcLayoutStatus.success;
        },
        (failure) {
          _error = failure.message;
          if (_items.isEmpty) _status = CcLayoutStatus.error;
        },
      );
    });
    return result.isSuccess();
  }

  @override
  Widget? buildContent(BuildContext context) {
    return buildPullToRefresh(
      context: context,
      onRefresh: () => _load(refresh: true),
      child: buildLoadMore(
        isFinish: !hasMore,
        onLoadMore: _load,
        // ListView.builder: LoadMore adds its footer as one more item.
        child: ListView.builder(
          itemCount: _items.length,
          itemBuilder: (_, index) => ListTile(title: Text(_items[index])),
        ),
      ),
    );
  }
}
