import 'package:auto_route/annotations.dart';
import 'package:cc_mixin/export_cc_mixin.dart';
import 'package:cc_sdk_ui/export_cc_sdk_ui.dart';
import 'package:flutter/material.dart';
import 'package:theme/data/data_source/color/prj_color.dart';

import '../../base/getx/cc_get_view.dart';
import '../get_x/comment_controller.dart';
import 'widgets/finance_app_bar.dart';
import 'widgets/shimmer_comment_card.dart';

@RoutePage()
class CommentPage extends CcGetView<CommentController> with CcPullRefreshMixin {
  const CommentPage({super.key});

  @override
  PreferredSizeWidget? appBar() {
    return const FinanceAppBar();
  }

  @override
  Widget? buildContent() {
    final comments = controller.comments;
    final isLoading =
        controller.layoutStatus.value == CcLayoutStatus.loading ||
        controller.layoutStatus.value == CcLayoutStatus.loadMore;

    print(
      'buildContent - isLoading: $isLoading, layoutStatus: ${controller.layoutStatus.value}, comments length: ${comments.length}',
    );

    return FadePageWrapper(
      child: buildPullToRefresh(
        onRefresh: controller.refreshData,
        child: ListView.builder(
          itemCount: isLoading ? 5 : comments.length,
          itemBuilder: (context, index) {
            if (isLoading) {
              return const ShimmerCommentCard();
            }

            final comment = comments[index];
            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: CcPaddingParams.PAGE_XS,
                vertical: CcPaddingParams.SPACE_SM,
              ),
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(CcPaddingParams.SPACE_MD),
                ),
                child: ListTile(
                  title: Text(
                    comment.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        comment.email,
                        style: const TextStyle(color: PrjColors.mediumEmphasis),
                      ),
                      const CcSpaceXS(),
                      Text(comment.body),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
