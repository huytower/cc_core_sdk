import 'package:equatable/equatable.dart';

/// Base User Entity - Universal user data structure.
/// This is a reusable entity that can be used across different business projects.
class CcUserEntity with EquatableMixin {
  final String id;
  final String email;
  final String? phoneNumber;
  final CcUserStatus status;
  final String? firstName;
  final String? lastName;
  final String? avatarUrl;
  final bool isEmailVerified;
  final bool isPhoneVerified;
  final List<String> registeredDeviceIds;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? lastActiveAt;

  /// Ids of the sign-in methods linked to this account, as reported by the auth
  /// backend (e.g. `'google.com'`, `'apple.com'`, `'phone'`, `'password'`). The
  /// only reliable way to tell which methods are linked, since [email] /
  /// [phoneNumber] alone don't reveal which method set them. Empty for an
  /// anonymous (guest) account.
  final List<String> linkedProviderIds;

  const CcUserEntity({
    required this.id,
    required this.email,
    this.phoneNumber,
    required this.status,
    this.firstName,
    this.lastName,
    this.avatarUrl,
    required this.isEmailVerified,
    required this.isPhoneVerified,
    required this.registeredDeviceIds,
    required this.createdAt,
    required this.updatedAt,
    this.lastActiveAt,
    this.linkedProviderIds = const [],
  });

  /// Display identifier for UI (email or phone)
  String get displayIdentifier {
    if (email.isNotEmpty) return email;
    if (phoneNumber != null) return phoneNumber!;
    return id;
  }

  @override
  List<Object?> get props => [
    id,
    email,
    phoneNumber,
    status,
    firstName,
    lastName,
    avatarUrl,
    isEmailVerified,
    isPhoneVerified,
    registeredDeviceIds,
    createdAt,
    updatedAt,
    lastActiveAt,
    linkedProviderIds,
  ];
}

/// User status enum
enum CcUserStatus { active, inactive, suspended, pendingVerification }
