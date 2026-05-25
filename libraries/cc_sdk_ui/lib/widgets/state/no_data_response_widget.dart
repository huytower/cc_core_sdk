import 'package:flutter/material.dart';

import '../../core/config/tokens/cc_base_colors.dart';
import '../space/cc_space.dart';
import '../text/cc_text.dart';

// Purpose:
// small reusable widgets for loading states and empty API responses
// intended as part of the shared UI library
class NoDataResponseWidget extends StatelessWidget {
  const NoDataResponseWidget({Key? key, this.onRefresh}) : super(key: key);

  final Future<void> Function()? onRefresh;

  @override
  Widget build(BuildContext context) => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.folder_open, size: 48, color: Colors.grey),
        const CcSpaceSM(),
        const CcText(
          'Không có dữ liệu',
          color: Colors.grey,
          textAlign: TextAlign.center,
          align: Alignment.center,
        ),
        if (onRefresh != null) ...[
          const CcSpaceLG(),
          ElevatedButton(
            onPressed: onRefresh,
            style: ElevatedButton.styleFrom(
              backgroundColor: CcBaseColors.brand500,
            ),
            child: const CcText(
              'Tải lại',
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ],
    ),
  );
}
