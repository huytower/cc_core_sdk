import 'package:auto_route/annotations.dart';
import 'package:cc_library/core/helper/open_dialog.dart';
import 'package:cc_library/widgets/text/cc_text.dart';
import 'package:features/counter/counter_export.dart';
import 'package:flutter/material.dart';

/// Features Counter Example Page
///
/// This page demonstrates how to use the counter feature from the features package.
@RoutePage()
class FeaturesCounterPage extends StatelessWidget {
  const FeaturesCounterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const CcText('Features Counter Example'),
        actions: [
          // Add a button to view the source code or documentation
          InkWell(
            onTap: () {
              // Show dialog with information about the counter feature
              OpenDialog.showDialogMessage(
                content:
                    'This page demonstrates the use of the counter feature from the features package. It includes a simple counter that can be incremented or decremented.',
                title: 'Features Counter',
              );
            },
            child: const Icon(Icons.info_outline),
          ),
        ],
      ),
      body:
          const CounterPage(), // Using the CounterPage from the features package
    );
  }
}
