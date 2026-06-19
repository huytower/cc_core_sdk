import 'package:flutter/material.dart';

import '../../core/extensions/cc_context_extension.dart';
import '../../core/extensions/common/cc_responsive_extension.dart';
import '../../core/helper/cc_widget_helper.dart';
import '../container/cc_containers.dart';

class AvatarUser extends StatelessWidget {
  final String? imageUrl;
  final String? pathDefault;
  final double width;
  final VoidCallback? onError;

  const AvatarUser({
    super.key,
    this.imageUrl,
    this.pathDefault,
    this.width = 50,
    this.onError,
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null && pathDefault == null) {
      return const SizedBox();
    }

    final double respWidth = context.respDim(width);

    return CcContainerCircle(
      bgColor: Colors.transparent,
      strokeColor: Colors.transparent,
      strokeWidth: 2,
      width: respWidth,
      child: ClipOval(
        child: Container(
          height: respWidth,
          width: respWidth,
          decoration: BoxDecoration(
            color: context.ccColorScheme.surfaceVariant,
            borderRadius: CcWidgetHelper.getCircleBorderRadius(),
          ),
          child: _buildImage(respWidth),
        ),
      ),
    );
  }

  Widget _buildImage(double respWidth) {
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return Image.network(
        imageUrl!,
        width: respWidth,
        height: respWidth,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          onError?.call();
          return _buildDefaultImage(respWidth);
        },
      );
    }
    return _buildDefaultImage(respWidth);
  }

  Widget _buildDefaultImage(double respWidth) {
    if (pathDefault != null && pathDefault!.isNotEmpty) {
      return Image.asset(
        pathDefault!,
        width: respWidth,
        height: respWidth,
        fit: BoxFit.cover,
      );
    }
    return Icon(Icons.person, size: respWidth * 0.6);
  }
}
