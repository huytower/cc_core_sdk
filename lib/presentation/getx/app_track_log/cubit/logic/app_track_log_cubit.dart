import 'dart:io';

import 'package:app_config/data/datasource/local/box/app_track_log/cc_app_track_log.dart';
import 'package:cc_sdk/export_cc_sdk.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'app_track_log_state.dart';

class AppTrackLogCubit extends Cubit<AppTrackLogState> {
  final CcAppTrackLog _trackLog;

  /// Creates a new instance of [AppTrackLogCubit] with the required dependencies
  AppTrackLogCubit(this._trackLog) : super(AppTrackLogState.init());

  String get appInfo =>
      '${CcAppTrackName.appName}'
      '/${state.appVersion}'
      '/is release build mode = ${!kDebugMode}';

  Future<void> initialize() async {
    try {
      _trackLog.msg ??= [];
      await Future.wait([_loadAppVersion(), _loadDeviceInfo()]);
      emit(state.copyWith(isReady: true));
    } catch (e) {
      _trackLog.msg?.add('Error initializing AppTrackLogCubit: $e');
      _trackLog.save();
      rethrow;
    }
  }

  Future<void> _loadAppVersion() async {
    final version = await DeviceUtils.getAppVersion();
    emit(state.copyWith(appVersion: version));
  }

  Future<void> _loadDeviceInfo() async {
    final deviceInfoPlugin = DeviceInfoPlugin();
    final packageInfo = await PackageInfo.fromPlatform();
    final deviceId = await DeviceUtils.getDeviceId();
    final rawDeviceInfo = await DeviceUtils.getDeviceInfo();

    if (Platform.isAndroid) {
      final android = await deviceInfoPlugin.androidInfo;
      emit(
        state.copyWith(
          deviceModel: CcDeviceModel(
            deviceInfo: rawDeviceInfo,
            deviceName: android.device,
            deviceId: deviceId,
            osName: 'Android',
            osVersion: android.version.release,
            appName: packageInfo.appName,
            appVersion: packageInfo.version,
            packageName: packageInfo.packageName,
            model: android.model,
            brand: android.brand,
            isPhysicalDevice: android.isPhysicalDevice,
          ),
        ),
      );
    } else if (Platform.isIOS) {
      final ios = await deviceInfoPlugin.iosInfo;
      emit(
        state.copyWith(
          deviceModel: CcDeviceModel(
            deviceInfo: rawDeviceInfo,
            deviceName: ios.name,
            deviceId: deviceId,
            osName: 'iOS',
            osVersion: ios.systemVersion,
            appName: packageInfo.appName,
            appVersion: packageInfo.version,
            packageName: packageInfo.packageName,
            model: ios.model,
            brand: 'Apple',
            isPhysicalDevice: ios.isPhysicalDevice,
          ),
        ),
      );
    } else {
      emit(
        state.copyWith(
          deviceModel: CcDeviceModel(
            deviceInfo: rawDeviceInfo,
            deviceId: deviceId,
            appName: packageInfo.appName,
            appVersion: packageInfo.version,
            packageName: packageInfo.packageName,
          ),
        ),
      );
    }
  }

  void addLogMessage(String message) {
    final updatedLogs = List<String>.from(state.loggingMessages ?? [])
      ..add(message);
    emit(state.copyWith(loggingMessages: updatedLogs));
  }
}
