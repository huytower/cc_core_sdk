import 'package:app_config/core/enum/layout_status.dart';
import 'package:catcher_2/catcher_2.dart';
import 'package:cc_sdk/core/extensions/export_cc_extensions.dart';
import 'package:cc_sdk/core/helper/cc_network_helper.dart';
import 'package:data/core/models/pagination_request.dart';
import 'package:data/domain/entities/sample_code_fake_api/res_sample_code_fake_model.dart';
import 'package:data/domain/repositories/sample_code_fake_api/sample_code_fake_api_repositories.dart';
import 'package:get/get.dart';
import 'package:injectable/injectable.dart';

import '../../../../../../core/di/inject/inject.dart';
import '../../../../presentation/getx/base/structure/getx/cc_get_controller/cc_get_controller.dart';

/// GETX : BINDINGS + CONTROLLER
/// Step 1 : create Binding + Controller
/// - .obs vars. : declare in the controller
///
/// or
/// convert from old bloc structure to `getX structure`(ex. ProfilePageBloc, ...)
/// created these sample classes :
///   a. `class ProfileBinding extends Bindings` (target: put multiple controller in here)
///   b. `class ProfileController extends CcGetController` :
///     (target: put all logics in here, include UI logic .v.v)
///     ex . `isLoading ? showLoading() : hideLoading` => `controller.onLoading()`
class GetViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => getIt<GetViewController>());
  }
}

@lazySingleton
class GetViewController extends CcGetController {
  final SampleCodeFakeApiRepositories repository;

  @factoryMethod
  GetViewController({required this.repository});

  final RxList<ResSampleCodeFakeModel> sampleCodeFakeList =
      <ResSampleCodeFakeModel>[].obs; // init: data observable

  // SampleCodeFakeApiImpl repositories = getIt<SampleCodeFakeApiImpl>();

  @override
  void onInit() {
    super.onInit();

    layoutStatus.value = LayoutStatus.success;
  }

  @override
  void onReady() {
    super.onReady();

    // fetchNewsApi();
  }

  var l = <ResSampleCodeFakeModel>[];

  Future fetchNewsApi() async {
    final hasInternet = await getIt<CcNetworkHelper>().hasInternet;

    "fetchNews() :.. "
            "\n hasInternet = $hasInternet"
        .Log();

    try {
      layoutStatus.value = LayoutStatus.loading;

      // Create a pagination request with default values
      const paginationRequest = PaginationRequest(
        page: 1, // Start with page 1
        itemsPerPage: 10, // Number of items per page
      );

      final res = await repository.getPaginatedList(
        paginationRequest: paginationRequest,
      );

      res.when(
        (success) {
          // Clear existing data before adding new data
          sampleCodeFakeList.clear();

          // Add new data if available
          if (success.items.isNotEmpty) {
            l = List.from(success.items);
            sampleCodeFakeList.addAll(l);
          }

          layoutStatus.value = LayoutStatus.success;
        },
        (error) {
          'Error fetching news: ${error.message}'.Log();
          layoutStatus.value = LayoutStatus.error;
        },
      );
    } catch (e, stackTrace) {
      'catch: e = $e'.Log();
      Catcher2.reportCheckedError(e, stackTrace);
      layoutStatus.value = LayoutStatus.error;
    }
  }

  Future fetchNewsDetailApi(String id) async {
    try {
      layoutStatus.value = LayoutStatus.loading;

      final res = await repository.getById(id);

      res.when(
        (success) {
          'res detail = $success'.Log();
          layoutStatus.value = LayoutStatus.success;
        },
        (error) {
          'Error fetching news detail: ${error.message}'.Log();
          layoutStatus.value = LayoutStatus.error;
        },
      );
    } catch (e) {
      'e = $e'.Log();
      layoutStatus.value = LayoutStatus.error;
    }
  }

  Future<bool> onLoadMore() async {
    await Future.delayed(const Duration(seconds: 2));

    for (var element in l) {
      sampleCodeFakeList.add(element);
    }

    return true;
  }

  Future onRefresh() async {
    await Future.delayed(const Duration(seconds: 1));

    sampleCodeFakeList.clear();

    fetchNewsApi();
  }

  @override
  @disposeMethod
  void onClose() {
    super.onClose();
  }
}
