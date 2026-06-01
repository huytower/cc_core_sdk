import 'package:auto_route/annotations.dart';
import 'package:cc_mixin/export_cc_mixin.dart';
import 'package:cc_sdk_ui/export_cc_sdk_ui.dart';
import 'package:flutter/material.dart';

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
            return Container(
              margin: const EdgeInsets.symmetric(
                horizontal: CcPaddingParams.PAGE_XS,
                vertical: CcPaddingParams.SPACE_SM,
              ),
              padding: const EdgeInsets.all(CcPaddingParams.SPACE_LG),
              decoration: BoxDecoration(
                color: context.ccColorScheme.surface,
                borderRadius: CcWidgetHelper.getBorderRoundedLarge(),
                boxShadow: CcWidgetHelper.getBoxShadows(context),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CcText(
                    comment.name,
                    textStyle: context.ccTextTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: context.ccColorScheme.primary,
                    ),
                  ),
                  const CcSpaceXS(),
                  CcText(
                    comment.email,
                    textStyle: context.ccTextTheme.bodySmall?.copyWith(
                      color: context.ccColorScheme.onSurfaceVariant,
                    ),
                  ),
                  const CcSpaceSM(),
                  CcText(
                    comment.body,
                    textStyle: context.ccTextTheme.bodyMedium,
                    maxLines: 10,
                    overflow: TextOverflow.visible,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
