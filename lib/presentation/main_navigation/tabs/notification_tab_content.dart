import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';

import '../../getx_state_management/comment/get_x/comment_controller.dart';
import '../../getx_state_management/comment/ui/comment_page.dart';

class NotificationTabContent extends StatefulWidget {
  const NotificationTabContent({super.key});

  @override
  State<NotificationTabContent> createState() => _NotificationTabContentState();
}

class _NotificationTabContentState extends State<NotificationTabContent> {
  @override
  void initState() {
    super.initState();
    if (!Get.isRegistered<CommentController>()) {
      CommentBinding().dependencies();
    }
  }

  @override
  Widget build(BuildContext context) {
    return const CommentPage();
  }
}
