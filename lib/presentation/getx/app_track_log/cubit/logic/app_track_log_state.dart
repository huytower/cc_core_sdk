import 'package:cc_sdk/export_cc_sdk.dart';
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
  final CcDeviceModel deviceModel;
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
      deviceModel: const CcDeviceModel(deviceInfo: ''),
      loggingMessages: null,
    );
  }

  /// Creates a copy of this state with the given fields replaced with new values
  AppTrackLogState copyWith({
    bool? isReady,
    String? appVersion,
    CcDeviceModel? deviceModel,
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
  List<Object?> get props => [
    isReady,
    appVersion,
    deviceModel,
    loggingMessages,
  ];
}
