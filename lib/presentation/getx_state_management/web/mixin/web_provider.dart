import 'package:cc_sdk_ui/widgets/pages/loading/loading_page.dart';
import 'package:flutter/material.dart';

import '../../base/structure/getx/cc_get_view/cc_get_view.dart';
import '../get_x/web_controller.dart';

mixin WebRedirectProvider<T extends WebController> on CcGetView<T> {
  //----------------------------------------------------------------------------
  @override
  PreferredSizeWidget? appBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(20),
      child: AppBar(
        elevation: 0,
        backgroundColor: Colors.pink,
        foregroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        toolbarHeight: 0,
        leading: const SizedBox.shrink(),
        leadingWidth: 0,
      ),
    );
  }

  //----------------------------------------------------------------------------
  @override
  Widget? bottomNavigationBar() {
    return Container(
      height: 70,
      color: Colors.blue,
      child: const Center(
        child: Text(
          "Bottom Navigation Bar..",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  //----------------------------------------------------------------------------
  @override
  Widget errorLayout(String code) => const SizedBox();

  //----------------------------------------------------------------------------
  @override
  Widget loadingLayout() => const LoadingPage();
  //----------------------------------------------------------------------------
}
