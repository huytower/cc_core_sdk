import 'package:app_config/core/enum/layout_status.dart';
import 'package:catcher_2/catcher_2.dart';
import 'package:cc_sdk/core/extensions/export_extensions.dart';
import 'package:cc_sdk/core/helper/network_helper.dart';
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
  SampleCodeFakeApiImpl repository;

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
    final hasInternet = await getIt<NetworkHelper>().hasInternet;

    "fetchNews() :.. "
            "\n hasInternet = $hasInternet"
        .Log();

    try {
      // Create a pagination request with default values
      const paginationRequest = PaginationRequest(
        page: 1, // Start with page 1
        itemsPerPage: 10, // Number of items per page
      );

      final res = await repository.getPaginatedList(
        paginationRequest: paginationRequest,
      );

      // Clear existing data before adding new data
      sampleCodeFakeList.clear();

      // Add new data if available
      if (res.items.isNotEmpty) {
        l = res.items;
        sampleCodeFakeList.addAll(l);
      }

      layoutStatus.value = LayoutStatus.success;
    } catch (e, stackTrace) {
      'catch: e = $e'.Log();
      Catcher2.reportCheckedError(e, stackTrace);
    }
  }

  Future fetchNewsDetailApi(String id) async {
    try {
      final res = await repository.getById(id);

      'res = $res'.Log();

      layoutStatus.value = LayoutStatus.success;
    } catch (e) {
      'e = $e'.Log();
    }
  }

  Future<bool> onLoadMore() async {
    await Future.delayed(const Duration(seconds: 2));

    l.forEach((element) {
      sampleCodeFakeList.add(element);
    });

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
