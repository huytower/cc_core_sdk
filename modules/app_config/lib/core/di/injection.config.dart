// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import '../../data/datasource/remote/app_version_api.dart' as _i3;

// ignore_for_file: unnecessary_lambdas
// ignore_for_file: lines_longer_than_80_chars
// ignore: constant_identifier_names
const String _dev = 'dev';
// ignore: constant_identifier_names
const String _prod = 'prod';

// initializes the registration of main-scope dependencies inside of GetIt
_i1.GetIt $initAppConfigDependencies(
  _i1.GetIt getIt, {
  String? environment,
  _i2.EnvironmentFilter? environmentFilter,
}) {
  final gh = _i2.GetItHelper(getIt, environment, environmentFilter);

  // Register services
  gh.lazySingleton<_i3.AppVersionAPI>(
    () => _i3.AppVersionAPI(),
    registerFor: {_dev, _prod},
  );

  return getIt;
}
