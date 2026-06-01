import 'package:flutter/material.dart';

import '../../core/helper/cc_widget_helper.dart';
import '../space/cc_space.dart';

class ExpandedCollapseCardWidget extends StatefulWidget {
  const ExpandedCollapseCardWidget({
    Key? key,
    required this.title,
    required this.child,
    this.backgroundColor = Colors.white,
    this.shadowColor,
    this.isExpanded = false,
  }) : super(key: key);

  final String title;
  final Widget child;
  final Color backgroundColor;
  final Color? shadowColor;
  final bool isExpanded;

  @override
  _ExpandedCollapseCardWidgetState createState() =>
      _ExpandedCollapseCardWidgetState();
}

class _ExpandedCollapseCardWidgetState
    extends State<ExpandedCollapseCardWidget> {
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.isExpanded;
  }

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 12),
    decoration: BoxDecoration(
      color: widget.backgroundColor,
      borderRadius: CcWidgetHelper.getBorderRoundedLarge(),
      boxShadow: [
        BoxShadow(
          color:
              (widget.shadowColor ??
                      Theme.of(context).colorScheme.outlineVariant)
                  .withOpacity(0.5),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Column(
      children: [
        InkWell(
          onTap: () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Icon(
                  _isExpanded ? Icons.expand_less : Icons.expand_more,
                  color: Colors.grey,
                ),
              ],
            ),
          ),
        ),
        if (_isExpanded) ...[
          const CcSpaceXS(),
          Padding(padding: const EdgeInsets.all(16), child: widget.child),
        ],
      ],
    ),
  );
}
