import 'package:features/export_features.dart';
import 'package:flutter/material.dart';

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
    // if (!Get.isRegistered<CommentController>()) {
    //   CommentBinding().dependencies();
    // }
  }

  @override
  Widget build(BuildContext context) {
    return const DashboardPage();
    // return CommentPage();
  }
}
