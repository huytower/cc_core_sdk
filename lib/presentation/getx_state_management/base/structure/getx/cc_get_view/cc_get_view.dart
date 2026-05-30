import 'package:cc_sdk_ui/export_cc_sdk_ui.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../cc_get_controller/cc_get_controller.dart';

abstract class CcGetView<T extends CcGetController> extends GetView<T> {
  //----------------------------------------------------------------------------
  const CcGetView({
    super.key,
    this.isEnableAppBar = true,
    this.isEnableBottomNavigation = true,
    this.isEnableTabBar = true,
    this.layoutStatus = CcLayoutStatus.success,
  });

  final bool isEnableAppBar;
  final bool isEnableBottomNavigation;
  final bool isEnableTabBar;
  final CcLayoutStatus layoutStatus;

  //----------------------------------------------------------------------------
  PreferredSizeWidget? appBar() {
    return _appBarDefault();
  }

  //----------------------------------------------------------------------------
  Widget? content();

  //----------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _contentLayout(),
      appBar: isEnableAppBar ? appBar() : _appBarDefault(),
      bottomNavigationBar: bottomNavigationBar(),
    );
  }

  //----------------------------------------------------------------------------
  Widget _contentLayout() {
    return Container(
      child: controller.multipleLayoutStates(
        onLoading: () {
          return loadingLayout();
        },
        onSuccess: () {
          return content.call() ?? _emptyWidget();
        },
        onEmpty: () {
          return _emptyWidget();
        },
        onError: (String code) {
          return errorLayout(code);
        },
      ),
    );
  }

  //----------------------------------------------------------------------------
  Widget? bottomNavigationBar() {
    return _emptyWidget();
  }

  //----------------------------------------------------------------------------
  Widget errorLayout(String code) {
    return Container(
      height: 200,
      width: 200,
      color: Colors.red,
      child: Center(child: Text(code)),
    );
  }

  //----------------------------------------------------------------------------
  Widget loadingLayout() {
    return Container(
      height: 200,
      width: 200,
      color: Colors.transparent,
      child: const Center(child: Text("Loading...")),
    );
  }

  //----------------------------------------------------------------------------
  PreferredSizeWidget _appBarDefault() {
    return AppBar(title: _emptyWidget());
  }

  //----------------------------------------------------------------------------
  Widget _emptyWidget() {
    return const SizedBox.shrink();
  }
}
