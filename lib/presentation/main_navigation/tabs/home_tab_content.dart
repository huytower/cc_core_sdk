import 'package:flutter/material.dart';

import '../../getx_state_management/home/ui/home_page.dart';
import '../../getx_state_management/home/ui/widgets/finance_app_bar.dart';

class HomeTabContent extends StatelessWidget {
  const HomeTabContent({super.key});

  @override
  PreferredSizeWidget? appBar() {
    return const FinanceAppBar();
  }

  @override
  Widget build(BuildContext context) {
    return const HomePage();
  }
}
