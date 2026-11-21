import 'package:cc_sdk_data/export_cc_sdk_data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CcMessageEntity', () {
    test('data defaults to an empty map', () {
      const message = CcMessageEntity(title: 'Hello');

      expect(message.data, isEmpty);
    });

    test('compares by value, including the data payload', () {
      const a = CcMessageEntity(messageId: '1', data: {'route': '/home'});
      const b = CcMessageEntity(messageId: '1', data: {'route': '/home'});
      const c = CcMessageEntity(messageId: '1', data: {'route': '/other'});

      expect(a, b);
      expect(a, isNot(c));
    });
  });
}
