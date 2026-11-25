/// Data model for items displayed within [CcCategoryGroupSection].
///
/// [label] is shown as is — pass already-translated text.
class CcCategoryGroupItem {
  final String label;
  final int iconCode;
  final String? iconFamily;
  final dynamic originalData;

  const CcCategoryGroupItem({
    required this.label,
    required this.iconCode,
    this.iconFamily,
    this.originalData,
  });
}

