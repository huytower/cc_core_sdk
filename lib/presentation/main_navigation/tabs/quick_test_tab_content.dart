import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../getx_state_management/comment/get_x/comment_controller.dart';
import '../../getx_state_management/comment/ui/comment_screen.dart';

class QuickTestTabContent extends StatefulWidget {
  static const String routeName = 'COMMENT';

  const QuickTestTabContent({super.key});

  @override
  State<QuickTestTabContent> createState() => _QuickTestTabContentState();
}

class _QuickTestTabContentState extends State<QuickTestTabContent> {
  @override
  void initState() {
    super.initState();
    if (!Get.isRegistered<CommentController>()) {
      CommentBinding().dependencies();
    }
  }

  @override
  Widget build(BuildContext context) {
    return const CommentScreen();
  }
}
