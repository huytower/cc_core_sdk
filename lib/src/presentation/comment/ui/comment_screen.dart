import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/di/inject/app_inject.dart';
import '../../base/structure/getx/cc_get_view/cc_get_view.dart';
import '../get_x/comment_controller.dart';

@RoutePage()
class CommentScreen extends CcGetView<CommentController> {
  const CommentScreen({Key? key}) : super(key: key, isEnableAppBar: true);

  @override
  CommentController get controller => getIt<CommentController>();

  @override
  PreferredSizeWidget? appBar() => AppBar(
    title: const Text('Comments'),
  );

  @override
  Widget? content() => ListView.builder(
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
          child: Obx(() {
            return ListTile(
              title: Text(comment.name, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(comment.email, style: const TextStyle(color: Colors.grey)),
                  const SizedBox(height: 4),
                  Text(comment.body),
                ],
              ),
            );
          })
        ),
      );
    },
  );
}
