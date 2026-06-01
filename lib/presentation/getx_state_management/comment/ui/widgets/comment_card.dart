import 'package:cc_sdk_ui/export_cc_sdk_ui.dart';
import 'package:data/domain/entities/comment/comment_entity.dart';
import 'package:flutter/material.dart';

class CommentCard extends StatelessWidget {
  final CommentEntity comment;

  const CommentCard({super.key, required this.comment});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: context.respPadding(CcPaddingParams.PAGE_XS),
        vertical: context.respPadding(CcPaddingParams.SPACE_SM),
      ),
      padding: EdgeInsets.all(context.respPadding(CcPaddingParams.SPACE_LG)),
      decoration: BoxDecoration(
        color: context.ccColorScheme.surface,
        borderRadius: CcWidgetHelper.getBorderRoundedLarge(),
        boxShadow: CcWidgetHelper.getBoxShadows(context),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CcText(
            comment.name,
            textStyle: context.ccTextTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: context.ccColorScheme.primary,
              fontSize: context.respFontSize(CcTypographyParams.titleMedium),
            ),
          ),
          const CcSpaceXS(),
          CcText(
            comment.email,
            textStyle: context.ccTextTheme.bodySmall?.copyWith(
              color: context.ccColorScheme.onSurfaceVariant,
              fontSize: context.respFontSize(CcTypographyParams.bodySmall),
            ),
          ),
          const CcSpaceSM(),
          CcText(
            comment.body,
            textStyle: context.ccTextTheme.bodyMedium?.copyWith(
              fontSize: context.respFontSize(CcTypographyParams.bodyMedium),
            ),
            maxLines: 10,
            overflow: TextOverflow.visible,
          ),
        ],
      ),
    );
  }
}
