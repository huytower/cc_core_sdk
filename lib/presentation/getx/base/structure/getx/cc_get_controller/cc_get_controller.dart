import 'dart:io';

import 'package:app_config/core/enum/layout_status.dart';
import 'package:cc_sdk/core/helper/cc_network_helper.dart';
import 'package:data/core/config/retrofit/response/body/cc_res_body_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../core/di/inject/inject.dart';

abstract class CcGetController extends SuperController {
  Rx<LayoutStatus> layoutStatus = Rx<LayoutStatus>(LayoutStatus.loading);
  RxString errorMessage = RxString('');

  @override
  void onDetached() {}

  @override
  void onHidden() {}

  @override
  void onInactive() {}

  @override
  void onPaused() {}

  @override
  void onResumed() {}

  /// is override? onChangeState?
  Widget multipleLayoutStates({
    Function(LayoutStatus? layoutStatus)? onChangeState,
    required Widget Function() onLoading,
    required Widget Function() onSuccess,
    required Widget Function() onEmpty,
    Function<Widget>()? empty,
    required Widget Function(String code) onError,
  }) {
    // onChangeState?.call(LayoutStatus.loading);
    //
    // if (!initialized) {
    //   return const SizedBox();
    // }
    //
    // if (layoutStatus.value == LayoutStatus.loading) {
    //   return onLoading();
    // } else {
    //   return onSuccess();
    // }

    onChangeState?.call(layoutStatus.value);

    return Obx(
      () {
        switch (layoutStatus.value) {
          case LayoutStatus.loading:
            return onLoading();
          case LayoutStatus.success:
            return onSuccess();
          case LayoutStatus.error:
            final message =
                errorMessage.value != '' ? errorMessage.value : '100';
            return onError(message);
          case LayoutStatus.empty:
            return onEmpty();
          case LayoutStatus.load_more:
            return const SizedBox(); // or handle as needed
        }
        // return when(
        //   variable: layoutStatus,
        //   conditions: {
        //     LayoutStatus.loading: () {
        //       return onLoading();
        //     },
        //     LayoutStatus.success: () {
        //       // return onSuccess(response);
        //       return onSuccess();
        //     }
        //   },
        //   orElse: onError("100"),
        // );
        // if (layoutStatus.value == LayoutStatus.loading || layoutStatus.value == LayoutStatus.loadingLayer) {
        //   return onLoading();
        // } else {
        //   return onSuccess();
        // }
      },
    );
  }

  Future<void> ccFetchData<T>({
    required Future<CcResBodyModel<T>> Function() fetchFunction,
    required RxList<T> targetList,
  }) async {
    layoutStatus.value = LayoutStatus.loading;
    try {
      final hasInternet = await getIt<CcNetworkHelper>().hasInternet;
      if (!hasInternet) {
        throw const SocketException("No internet connection");
      }

      final result = await fetchFunction();
      targetList.assignAll(result.listElements ?? []);
      layoutStatus.value = LayoutStatus.success;

      /// Check if whether targetList is empty or not
      if (targetList.isEmpty) {
        layoutStatus.value = LayoutStatus.empty;
      }
    } catch (e) {
      errorMessage.value = e.toString();
      layoutStatus.value = LayoutStatus.error;
    }
  }
}
