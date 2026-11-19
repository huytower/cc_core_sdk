// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:async' as _i687;

import 'package:cc_sdk/export_cc_sdk.dart' as _i54;
import 'package:cc_sdk_phone/src/cc_lib_phone_number_validator.dart' as _i1000;
import 'package:injectable/injectable.dart' as _i526;

class CcSdkPhonePackageModule extends _i526.MicroPackageModule {
// initializes the registration of main-scope dependencies inside of GetIt
  @override
  _i687.FutureOr<void> init(_i526.GetItHelper gh) {
    gh.lazySingleton<_i54.CcPhoneNumberValidator>(
        () => const _i1000.CcLibPhoneNumberValidator());
  }
}
