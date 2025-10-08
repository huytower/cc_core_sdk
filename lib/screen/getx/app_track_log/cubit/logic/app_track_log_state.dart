import 'package:data/model/device/device_model.dart';
import 'package:equatable/equatable.dart';

/// State class for AppTrackLog feature
///
/// Uses Equatable for value equality and immutability, which is the recommended
/// approach for state management in Flutter BLoC/Cubit.
///
/// Also includes an [init()] method to maintain consistency with the project's
/// existing patterns, even though we're using Equatable for state comparison.
class AppTrackLogState extends Equatable {
  final bool isReady;
  final String appVersion;
  final DeviceModelOri deviceModel;
  final List<String>? loggingMessages;

  const AppTrackLogState({
    this.isReady = false,
    this.appVersion = '',
    required this.deviceModel,
    this.loggingMessages,
  });

  /// Creates an initial state with default values
  ///
  /// This method is provided for consistency with the project's existing patterns,
  /// even though we're using Equatable for state management.
  static AppTrackLogState init() {
    return AppTrackLogState(
      isReady: false,
      appVersion: '',
      deviceModel: DeviceModelOri(deviceInfo: ''),
      loggingMessages: null,
    );
  }

  /// Creates a copy of this state with the given fields replaced with new values
  AppTrackLogState copyWith({
    bool? isReady,
    String? appVersion,
    DeviceModelOri? deviceModel,
    List<String>? loggingMessages,
  }) {
    return AppTrackLogState(
      isReady: isReady ?? this.isReady,
      appVersion: appVersion ?? this.appVersion,
      deviceModel: deviceModel ?? this.deviceModel,
      loggingMessages: loggingMessages ?? this.loggingMessages,
    );
  }

  @override
  List<Object?> get props =>
      [isReady, appVersion, deviceModel, loggingMessages];
}
