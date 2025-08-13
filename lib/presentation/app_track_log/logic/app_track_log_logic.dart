import 'package:app_config/config/app_config/cc_app_config.dart';
import 'package:app_config/config/app_track_log/cc_app_track_log.dart';
import 'package:cc_library/helper/device_helper.dart';
import 'package:cc_library/util/base_utils.dart';
import 'package:data/model/device/device_model.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

/// WatchItMixin : LOGIC
/// create Logic component, mandatory includes :
/// - boolean value notifier. : to avoid build() called twice issues
/// - Model obj. notifier. : value notifier - notify data set changed
/// - Model value : include meta data, params ...
///
@lazySingleton
class AppTrackLogLogic {
  final ValueNotifier<bool> isReady = ValueNotifier(false);
  final ValueNotifier<String> appVersion = ValueNotifier('');

  // Dependencies
  final CcAppTrackLog _trackLog;

  List<String>? get loggingMessages => _trackLog.msg;
  final DeviceModelNotifier _modelNotifier;

  DeviceModelNotifier get modelNotifier => _modelNotifier;
  final BaseUtils _baseUtils;

  AppTrackLogLogic(
    this._trackLog,
    this._modelNotifier,
    this._baseUtils,
  );

  String get appInfo => '${CcAppName.appName}'
      '/${appVersion.value}'
      '/is release build mode = ${!kDebugMode}';

  Future<void> initialize() async {
    try {
      // Initialize messages list if null
      _trackLog.msg ??= [];

      await Future.wait([
        _loadAppVersion(),
        _loadDeviceInfo(),
      ]);
      isReady.value = true;
    } catch (e) {
      // Log the error
      _trackLog.msg?.add('Error initializing AppTrackLogLogic: $e');
      _trackLog.save(); // Persist the log
      rethrow;
    }
  }

  Future<void> _loadAppVersion() async {
    appVersion.value = await BaseUtils.getAppVersion();
  }

  Future<void> _loadDeviceInfo() async {
    try {
      final deviceInfo = await DeviceHelper.getDeviceInfo();
      _modelNotifier.model = DeviceModelOri(deviceInfo: deviceInfo);
    } catch (e) {
      _trackLog.msg?.add('Error loading device info: $e');
      _trackLog.save(); // Persist the log
      rethrow;
    }
  }

  // Add this method to properly dispose resources
  void dispose() {
    isReady.dispose();
    appVersion.dispose();
  }
}
