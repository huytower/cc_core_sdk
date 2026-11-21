// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:async' as _i687;

import 'package:cc_sdk/export_cc_sdk.dart' as _i54;
import 'package:cc_sdk_device/src/cc_device_module.dart' as _i13;
import 'package:cc_sdk_device/src/device/cc_udid_device_id_provider.dart'
    as _i579;
import 'package:cc_sdk_device/src/location/cc_device_location_service.dart'
    as _i174;
import 'package:cc_sdk_device/src/speech/cc_speech_to_text_recognizer.dart'
    as _i930;
import 'package:device_info_plus/device_info_plus.dart' as _i833;
import 'package:injectable/injectable.dart' as _i526;
import 'package:speech_to_text/speech_to_text.dart' as _i941;

class CcSdkDevicePackageModule extends _i526.MicroPackageModule {
// initializes the registration of main-scope dependencies inside of GetIt
  @override
  _i687.FutureOr<void> init(_i526.GetItHelper gh) {
    final ccDeviceModule = _$CcDeviceModule();
    gh.lazySingleton<_i941.SpeechToText>(() => ccDeviceModule.speechToText);
    gh.lazySingleton<_i54.CcLocationService>(
        () => _i174.CcDeviceLocationService());
    gh.lazySingleton<_i54.CcSpeechRecognizer>(
        () => _i930.CcSpeechToTextRecognizer(gh<_i941.SpeechToText>()));
    gh.lazySingleton<_i54.CcDeviceIdProvider>(
        () => _i579.CcUdidDeviceIdProvider(gh<_i833.DeviceInfoPlugin>()));
  }
}

class _$CcDeviceModule extends _i13.CcDeviceModule {}
