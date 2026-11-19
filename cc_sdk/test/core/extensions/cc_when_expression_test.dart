import 'package:cc_sdk/export_cc_sdk.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('returns the value of the branch equal to the variable', () {
    expect(
      ccWhen<int, String>(variable: 2, conditions: {1: 'one', 2: 'two'}),
      'two',
    );
  });

  test('without a variable, takes the branch whose key is true', () {
    expect(
      ccWhen<bool, String>(conditions: {false: 'no', true: 'yes'}),
      'yes',
    );
  });

  test('falls back to orElse when nothing matches', () {
    expect(
      ccWhen<int, String>(variable: 3, conditions: {1: 'one'}, orElse: 'none'),
      'none',
    );
  });

  test('calls a matching function value', () {
    expect(
      ccWhen<String, int Function()>(
        variable: 'b',
        conditions: {'a': () => 1, 'b': () => 2},
      ),
      2,
    );
  });
}
