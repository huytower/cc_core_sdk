import 'package:cc_sdk/export_cc_sdk.dart';
import 'package:flutter_test/flutter_test.dart';

class _NotSerializable {
  @override
  String toString() => 'not serializable';
}

void main() {
  tearDown(() => CcSdkConfig.configure(const CcSdkConfig()));

  group('Log', () {
    test('returns the same value for every kind of input', () {
      final object = _NotSerializable();
      final map = {'a': 1};

      expect('text'.Log('tag'), 'text');
      expect(map.Log(), same(map));
      expect(object.Log('tag'), same(object));
      expect(null.Log(), isNull);
      expect(42.Log('tag', true), 42);
    });

    test('returns the value when logging is disabled', () {
      CcSdkConfig.configure(const CcSdkConfig(enableLogger: false));
      final map = {'a': 1};

      expect(map.Log('tag'), same(map));
    });
  });
}
