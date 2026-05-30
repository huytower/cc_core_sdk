import 'dart:ui';

import 'package:cc_sdk_ui/export_cc_sdk_ui.dart' hide getIt;
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../core/di/di.dart';
import '../../base/structure/getx/cc_get_controller/cc_get_controller.dart';

class WebBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => getIt<WebController>());
  }
}

// @singleton
class WebController extends CcGetController {
  late final WebViewController webViewController;

  @override
  void onInit() {
    super.onInit();

    webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse('https://flutter.dev'));

    layoutStatus.value = CcLayoutStatus.success;
  }
}
