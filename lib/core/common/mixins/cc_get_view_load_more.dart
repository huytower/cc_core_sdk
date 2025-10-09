// import 'package:cc_sdk/constant/cc_padding_params.dart';
// import 'package:cc_sdk/ui/text/cc_text.dart';
// import 'package:app/enum/layout_status.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get_state_manager/get_state_manager.dart';
//
// /// T extends CcLoadMoreControllerProvider
// mixin LoadMoreProvider {
//   Widget buildLoadMoreWidget(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 20),
//       height: 80,
//       color: Colors.transparent,
//       alignment: Alignment.center,
//       child: Obx(() {
//         switch (
//             (controller as CcLoadMoreControllerProvider).layoutLoading.value) {
//           case LayoutStatus.success:
//             return success(context);
//           case LayoutStatus.error:
//             return const SizedBox();
//           case LayoutStatus.load_more:
//             return loadMore();
//           case LayoutStatus.loading:
//             return const SizedBox();
//           default:
//             return const SizedBox();
//         }
//       }),
//     );
//   }
//
//   Widget loadMore() {
//     return Container(
//       padding: const EdgeInsets.only(top: CcPaddingParams.SPACE_SMALLEST),
//       child: const CupertinoActivityIndicator(
//         color: Colors.pink,
//         radius: 20,
//       ),
//     );
//   }
//
//   Widget success(BuildContext context) {
//     return Container(
//         padding: const EdgeInsets.only(top: CcPaddingParams.SPACE_SMALLEST),
//         child: const CcText(
//           "Hết sản phẩm rồi",
//           fontSize: 18,
//           textAlign: TextAlign.center,
//           align: Alignment.center,
//         ));
//   }
// }
