import 'package:auto_route/annotations.dart';
import 'package:cc_mixin/export_cc_mixin.dart';
import 'package:flutter/material.dart';

import '../../base/getx/cc_get_view.dart';
import '../get_x/comment_controller.dart';

@RoutePage()
class CommentScreen extends CcGetView<CommentController> with CcPullRefreshMixin {
  const CommentScreen({super.key});

  @override
  Widget? buildContent() {
    final comments = controller.comments;

    return buildPullToRefresh(
      onRefresh: controller.refreshData,
      child: ListView.builder(
        itemCount: comments.length,
        itemBuilder: (context, index) {
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
}
