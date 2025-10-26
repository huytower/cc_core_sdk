import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../base/structure/getx/cc_get_view/cc_get_view.dart';
import '../get_x/comment_controller.dart';

class CommentScreen extends CcGetView<CommentController> {
  const CommentScreen({Key? key}) : super(key: key, isEnableAppBar: true);

  @override
  PreferredSizeWidget? appBar() => AppBar(
        title: const Text('Comments'),
      );

  @override
  Widget? content() => Obx(() {
        final comments = controller.comments;

        return ListView.builder(
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
                  title: Text(comment.name,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(comment.email,
                          style: const TextStyle(color: Colors.grey)),
                      const SizedBox(height: 4),
                      Text(comment.body),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      });
}
