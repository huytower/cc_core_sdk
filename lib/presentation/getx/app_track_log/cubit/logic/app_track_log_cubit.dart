import 'package:app_config/data/datasource/local/box/app_track_log/cc_app_track_log.dart';
import 'package:cc_sdk/export_cc_sdk.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app_track_log_state.dart';

class AppTrackLogCubit extends Cubit<AppTrackLogState> {
  final CcAppTrackLog _trackLog;
  final CcDeviceEntity _deviceModel;

  /// Creates a new instance of [AppTrackLogCubit] with the required dependencies
  AppTrackLogCubit(this._trackLog, this._deviceModel)
    : super(AppTrackLogState.init(_deviceModel));

  String get appInfo =>
      '${CcAppTrackName.appName}'
      '/${_deviceModel.appVersion}'
      '/is release build mode = ${!kDebugMode}';

  Future<void> initialize() async {
    try {
      _trackLog.msg ??= [];
      emit(state.copyWith(isReady: true, appVersion: _deviceModel.appVersion));
    } catch (e) {
      _trackLog.msg?.add('Error initializing AppTrackLogCubit: $e');
      _trackLog.save();
      rethrow;
    }
  }

  void addLogMessage(String message) {
    final updatedLogs = List<String>.from(state.loggingMessages ?? [])
      ..add(message);
    emit(state.copyWith(loggingMessages: updatedLogs));
  }
}
