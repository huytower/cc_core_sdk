/// A stable identifier for this device, independent of any plugin.
///
/// The SDK core only defines this contract, because a long-lived device id is
/// a privacy decision each app makes (store policies, consent). An
/// implementation comes from a capability package (`CcUdidDeviceIdProvider` in
/// `cc_sdk_device`), registered in DI as `CcDeviceIdProvider`.
///
/// ```dart
/// final id = await deviceIds.deviceId();
/// final header = await deviceInfo.getRawDeviceInfo(deviceId: id);
/// ```
abstract interface class CcDeviceIdProvider {
  /// The device id, or an empty string when the platform gives none.
  Future<String> deviceId();
}
