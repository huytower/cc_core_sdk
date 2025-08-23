import 'package:app_config/config/app_config/cc_app_config.dart';
import 'package:app_config/config/app_track_log/cc_app_track_log.dart';
import 'package:cc_library/helper/device_helper.dart';
import 'package:cc_library/util/common/device_utils.dart';
import 'package:data/model/device/device_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app_track_log_state.dart';

class AppTrackLogCubit extends Cubit<AppTrackLogState> {
  final CcAppTrackLog _trackLog;

  /// Creates a new instance of [AppTrackLogCubit] with the required dependencies
  AppTrackLogCubit(
    this._trackLog,
  ) : super(AppTrackLogState.init());

  String get appInfo => '${CcAppName.appName}'
      '/${state.appVersion}'
      '/is release build mode = ${!kDebugMode}';

  Future<void> initialize() async {
    try {
      _trackLog.msg ??= [];
      await Future.wait([
        _loadAppVersion(),
        _loadDeviceInfo(),
      ]);
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
    try {
      final deviceInfo = await DeviceHelper.getDeviceInfo();
      emit(state.copyWith(
        deviceModel: DeviceModelOri(deviceInfo: deviceInfo),
      ));
    } catch (e) {
      _trackLog.msg?.add('Error loading device info: $e');
      _trackLog.save();
      rethrow;
    }
  }

  void addLogMessage(String message) {
    final updatedLogs = List<String>.from(state.loggingMessages ?? [])..add(message);
    emit(state.copyWith(loggingMessages: updatedLogs));
  }
}
