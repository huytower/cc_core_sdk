import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';

import '../../getx_state_management/comment/get_x/comment_controller.dart';
import '../../getx_state_management/comment/ui/comment_page.dart';

class QuickTestTabContent extends StatefulWidget {
  static const String routeName = 'QUICK_TEST';

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
    // return const DashboardPage();
    return const CommentPage();
  }
}
