import 'package:auto_route/annotations.dart';
import 'package:cc_mixin/export_cc_mixin.dart';
import 'package:cc_sdk_ui/export_cc_sdk_ui.dart';
import 'package:flutter/material.dart';

import '../../base/getx/cc_get_view.dart';
import '../get_x/comment_controller.dart';

@RoutePage()
class CommentScreen extends CcGetView<CommentController> with CcPullRefreshMixin {
  const CommentScreen({super.key});

  @override
  Widget? buildContent() {
    final comments = controller.comments;
    final isLoading = controller.layoutStatus.value == CcLayoutStatus.loading ||
                      controller.layoutStatus.value == CcLayoutStatus.loadMore;

    print('buildContent - isLoading: $isLoading, layoutStatus: ${controller.layoutStatus.value}, comments length: ${comments.length}');

    return buildPullToRefresh(
      onRefresh: controller.refreshData,
      child: ListView.builder(
        itemCount: isLoading ? 5 : comments.length,
        itemBuilder: (context, index) {
          if (isLoading) {
            print('Building shimmer item at index $index');
            return _buildShimmerComment();
          }

          final comment = comments[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
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
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 4),
                    Text(comment.body),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildShimmerComment() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CcShimmer(
                width: double.infinity,
                height: 20,
                borderRadius: BorderRadius.circular(4),
              ),
              const SizedBox(height: 8),
              CcShimmer(
                width: 200,
                height: 14,
                borderRadius: BorderRadius.circular(4),
              ),
              const SizedBox(height: 8),
              CcShimmer(
                width: double.infinity,
                height: 14,
                borderRadius: BorderRadius.circular(4),
              ),
              const SizedBox(height: 4),
              CcShimmer(
                width: double.infinity,
                height: 14,
                borderRadius: BorderRadius.circular(4),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
