import 'package:app_config/core/enum/layout_status.dart';
import 'package:cc_sdk/core/helper/cc_network_helper.dart';
import 'package:cc_sdk/domain/failures/cc_failure.dart';
import 'package:easy_localization/easy_localization.dart' as el;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:message/cc_locale_keys.dart';
import 'package:multiple_result/multiple_result.dart';

import '../../../../../../core/di/di.dart';

abstract class CcGetController extends GetxController {
  Rx<LayoutStatus> layoutStatus = Rx<LayoutStatus>(LayoutStatus.loading);
  RxString errorMessage = RxString('');

  /// Handles UI rendering based on the current [layoutStatus].
  ///
  /// This widget automatically reacts to changes in [layoutStatus] and
  /// switches between loading, success, empty, and error states.
  Widget multipleLayoutStates({
    Function(LayoutStatus? layoutStatus)? onChangeState,
    required Widget Function() onLoading,
    required Widget Function() onSuccess,
    required Widget Function() onEmpty,
    Function()? empty,
    required Widget Function(String code) onError,
  }) {
    onChangeState?.call(layoutStatus.value);

    return Obx(() {
      switch (layoutStatus.value) {
        case LayoutStatus.loading:
          return onLoading();
        case LayoutStatus.success:
          return onSuccess();
        case LayoutStatus.error:
          final message = errorMessage.value != '' ? errorMessage.value : '100';
          return onError(message);
        case LayoutStatus.empty:
          return onEmpty();
        case LayoutStatus.load_more:
          return const SizedBox();
      }
    });
  }

  /// A helper method to fetch data and automatically manage the [layoutStatus].
  ///
  /// - [fetchFunction]: The repository call returning a [Result].
  /// - [targetList]: Optional [RxList] to automatically populate on success.
  ///
  /// Returns the [Result] for further processing if needed.
  Future<Result<List<T>, Failure>> ccFetchData<T>({
    required Future<Result<List<T>, Failure>> Function() fetchFunction,
    RxList<T>? targetList,
  }) async {
    layoutStatus.value = LayoutStatus.loading;
    try {
      final hasInternet = await getIt<CcNetworkHelper>().hasInternet;
      if (!hasInternet) {
        final errorMsg = el.tr(CcLocaleKeys.app_error_network);
        errorMessage.value = errorMsg;
        layoutStatus.value = LayoutStatus.error;
        return Error(NetworkFailure(errorMsg));
      }

      final result = await fetchFunction();

      result.when(
        (success) {
          targetList?.assignAll(success);

          if (success.isEmpty) {
            layoutStatus.value = LayoutStatus.empty;
          } else {
            layoutStatus.value = LayoutStatus.success;
          }
        },
        (error) {
          errorMessage.value = error.message;
          layoutStatus.value = LayoutStatus.error;
        },
      );

      return result;
    } catch (e) {
      final errorMsg = e.toString();
      errorMessage.value = errorMsg;
      layoutStatus.value = LayoutStatus.error;
      return Error(ServerFailure(errorMsg));
    }
  }
}
