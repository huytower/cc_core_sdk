import 'package:cc_sdk/core/helper/cc_scale.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // The approved table (dp -> factor), to 2 decimals.
  final widths = [360.0, 390.0, 430.0, 600.0, 673.0, 800.0, 840.0, 1024.0];

  test('dimension factor matches the approved table', () {
    expect(widths.map((w) => CcScale.dimension(w)).toList(), [
      1.0,
      closeTo(1.083, 0.005),
      closeTo(1.194, 0.005),
      closeTo(1.32, 0.01),
      closeTo(1.38, 0.01),
      closeTo(1.47, 0.01),
      1.5,
      1.5,
    ]);
  });

  test('padding factor matches the approved table', () {
    expect(widths.map((w) => CcScale.padding(w)).toList(), [
      1.0,
      closeTo(1.083, 0.005),
      closeTo(1.194, 0.005),
      closeTo(1.53, 0.01),
      closeTo(1.67, 0.01),
      closeTo(1.92, 0.01),
      2.0,
      2.0,
    ]);
  });

  test('text factor matches the approved table', () {
    expect(widths.map((w) => CcScale.text(w)).toList(), [
      1.0,
      1.0,
      1.0,
      closeTo(1.07, 0.01),
      closeTo(1.11, 0.01),
      closeTo(1.18, 0.01),
      1.2,
      1.2,
    ]);
  });

  test('phones keep the original width / 360 scaling', () {
    for (var w = 300.0; w <= CcScale.phoneMaxWidth; w += 4) {
      expect(CcScale.dimension(w), (w / 360).clamp(1.0, 1.5));
      expect(CcScale.padding(w), (w / 360).clamp(1.0, 2.0));
    }
  });

  test('every curve is continuous and never decreases', () {
    double previousDim = 0, previousPad = 0, previousText = 0;
    for (var w = 300.0; w <= 1300; w += 1) {
      final dim = CcScale.dimension(w);
      final pad = CcScale.padding(w);
      final text = CcScale.text(w);
      expect(dim, greaterThanOrEqualTo(previousDim));
      expect(pad, greaterThanOrEqualTo(previousPad));
      expect(text, greaterThanOrEqualTo(previousText));
      if (w > 300) {
        expect(dim - previousDim, lessThan(0.01), reason: 'jump at $w');
        expect(pad - previousPad, lessThan(0.01), reason: 'jump at $w');
        expect(text - previousText, lessThan(0.01), reason: 'jump at $w');
      }
      previousDim = dim;
      previousPad = pad;
      previousText = text;
    }
  });
}
