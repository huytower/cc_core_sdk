/// Translated texts of a [CcKeypadPanel]'s action row. The clear and copy
/// texts are tooltips; [done] is the visible button label.
///
/// ```dart
/// CcKeypadLabels(clear: tr('clear'), copy: tr('copy'), done: tr('done'))
/// ```
class CcKeypadLabels {
  const CcKeypadLabels({
    required this.clear,
    required this.copy,
    required this.done,
  });

  final String clear;
  final String copy;
  final String done;
}
