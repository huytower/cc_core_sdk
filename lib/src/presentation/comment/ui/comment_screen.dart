import 'package:app_config/enum/layout_status.dart';
import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/di/inject/app_inject.dart';
import '../get_x/comment_controller.dart';

@RoutePage()
class CommentScreen extends StatelessWidget {
  const CommentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = getIt<CommentController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Comments'),
      ),
      body: Obx(() {
        if (controller.layoutStatus.value == LayoutStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        } else if (controller.layoutStatus.value == LayoutStatus.error) {
          return const Center(child: Text('Failed to load comments'));
        } else if (controller.comments.isEmpty) {
          return const Center(child: Text('No comments found'));
        }

        return ListView.builder(
          itemCount: controller.comments.length,
          itemBuilder: (context, index) {
            final comment = controller.comments[index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  title: Text(comment.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(comment.email, style: const TextStyle(color: Colors.grey)),
                      const SizedBox(height: 4),
                      Text(comment.body),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
