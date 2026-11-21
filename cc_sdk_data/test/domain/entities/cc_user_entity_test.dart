import 'package:cc_sdk_data/export_cc_sdk_data.dart';
import 'package:flutter_test/flutter_test.dart';

CcUserEntity _user({
  String id = 'user-1',
  String email = 'someone@example.com',
  String? phoneNumber,
  List<String> linkedProviderIds = const [],
}) {
  final createdAt = DateTime.utc(2026, 1, 1);
  return CcUserEntity(
    id: id,
    email: email,
    phoneNumber: phoneNumber,
    status: CcUserStatus.active,
    isEmailVerified: true,
    isPhoneVerified: false,
    registeredDeviceIds: const ['device-1'],
    createdAt: createdAt,
    updatedAt: createdAt,
    linkedProviderIds: linkedProviderIds,
  );
}

void main() {
  group('CcUserEntity.displayIdentifier', () {
    test('prefers the email', () {
      final user = _user(phoneNumber: '+10000000000');

      expect(user.displayIdentifier, 'someone@example.com');
    });

    test('falls back to the phone number when the email is empty', () {
      final user = _user(email: '', phoneNumber: '+10000000000');

      expect(user.displayIdentifier, '+10000000000');
    });

    test('falls back to the id when there is no email or phone number', () {
      final user = _user(email: '');

      expect(user.displayIdentifier, 'user-1');
    });
  });

  group('CcUserEntity equality', () {
    test('two users with the same fields are equal', () {
      expect(_user(), _user());
      expect(_user().hashCode, _user().hashCode);
    });

    test('a different linked provider makes the users differ', () {
      expect(
        _user(linkedProviderIds: const ['password']),
        isNot(_user(linkedProviderIds: const ['phone'])),
      );
    });

    test('linkedProviderIds defaults to empty (anonymous account)', () {
      expect(_user().linkedProviderIds, isEmpty);
    });
  });
}
