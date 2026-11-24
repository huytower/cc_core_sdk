/// One quick-pick suggestion: the [value] handed back when it is tapped, and
/// the already formatted [label] shown for it (see [CcQuickValueChips]).
///
/// ```dart
/// const CcQuickValue(value: 50000, label: '50K')
/// ```
class CcQuickValue<T> {
  const CcQuickValue({required this.value, required this.label});

  final T value;
  final String label;
}
