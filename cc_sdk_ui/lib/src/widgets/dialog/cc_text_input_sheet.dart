import 'package:flutter/material.dart';

import '../../../export_cc_sdk_ui.dart';

/// Bottom sheet asking for one line of text (a name, a label, ...): a title,
/// a focused field with a clear button and a save button that is enabled
/// once the text is not blank. It stays above the keyboard. Returns the
/// trimmed text, or `null` when dismissed.
///
/// ```dart
/// final name = await CcTextInputSheet.show(
///   context,
///   title: 'Display name',
///   hint: 'Your name',
///   confirmLabel: 'Save',
///   initialValue: user.name,
///   maxLength: 20,
/// );
/// ```
class CcTextInputSheet extends StatefulWidget {
  const CcTextInputSheet({
    super.key,
    required this.title,
    required this.confirmLabel,
    this.hint,
    this.initialValue = '',
    this.maxLength,
  });

  final String title;
  final String confirmLabel;
  final String? hint;
  final String initialValue;
  final int? maxLength;

  static Future<String?> show(
    BuildContext context, {
    required String title,
    required String confirmLabel,
    String? hint,
    String initialValue = '',
    int? maxLength,
  }) {
    return CcAdaptiveBottomSheet.show<String>(
      context: context,
      builder: (_) => CcTextInputSheet(
        title: title,
        confirmLabel: confirmLabel,
        hint: hint,
        initialValue: initialValue,
        maxLength: maxLength,
      ),
    );
  }

  @override
  State<CcTextInputSheet> createState() => _CcTextInputSheetState();
}

class _CcTextInputSheetState extends State<CcTextInputSheet> {
  late final TextEditingController _controller = TextEditingController(
    text: widget.initialValue,
  )..addListener(() => setState(() {}));

  bool get _hasValue => _controller.text.trim().isNotEmpty;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Lifted by the keyboard height so the field stays visible.
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: CcPickerSheetFrame(
        title: widget.title,
        body: Padding(
          padding: EdgeInsets.all(
            context.respPadding(CcPaddingParams.SPACE_LG),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [_buildField(context), const CcSpaceMD(), _buildSave()],
          ),
        ),
      ),
    );
  }

  Widget _buildField(BuildContext context) {
    final scheme = context.ccColorScheme;
    return TextField(
      controller: _controller,
      maxLength: widget.maxLength,
      autofocus: true,
      decoration: InputDecoration(
        hintText: widget.hint,
        suffixIcon: _controller.text.isEmpty
            ? null
            : IconButton(
                tooltip: MaterialLocalizations.of(context).deleteButtonTooltip,
                icon: Icon(
                  Icons.clear_rounded,
                  color: scheme.onSurfaceVariant,
                  size: context.respIconSize(baseSize: 20),
                ),
                onPressed: _controller.clear,
              ),
        border: context.inputBorderTextField,
      ),
    );
  }

  Widget _buildSave() {
    return CcSaveButton(
      onPressed: _hasValue
          ? () => Navigator.of(context).pop(_controller.text.trim())
          : null,
      label: widget.confirmLabel,
    );
  }
}
