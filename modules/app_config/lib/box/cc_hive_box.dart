/// Holds all Hive box configurations and type IDs used throughout the application.
/// This class provides a centralized place for all Hive-related constants and enums.
class CcHiveBox {
  /// Default key used when no specific key is provided
  static const keyDefault = 'key_default';

  // Legacy constants (kept for backward compatibility)
  static const int test_type_id = 1;
  static const int app_storage_id = 2;
  static const int device_type_id = 3;
  static const int app_track_log_type_id = 4;

  static const String application_box_name = 'application';
  static const String device_info_box_name = 'device';
  static const String app_track_log_box_name = 'track_log';
}
