// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i6;
import 'package:flutter/material.dart' as _i7;
import 'package:mobile_flutter_template/src/presentation/base/sample_code/bloc_simple_page/cubit/simple/simple_cubit_page.dart'
    as _i4;
import 'package:mobile_flutter_template/src/presentation/base/sample_code/bloc_simple_page/origin/advance/advance_bloc_page.dart'
    as _i1;
import 'package:mobile_flutter_template/src/presentation/base/sample_code/getx_simple_page/way_1/ui/get_view_page.dart'
    as _i2;
import 'package:mobile_flutter_template/src/presentation/base/sample_code/getx_simple_page/way_2/ui/get_view_v2_view.dart'
    as _i3;
import 'package:mobile_flutter_template/src/presentation/splash/splash_page.dart' as _i5;

/// generated route for
/// [_i1.AdvanceBlocPage]
class AdvanceBlocRoute extends _i6.PageRouteInfo<void> {
  const AdvanceBlocRoute({List<_i6.PageRouteInfo>? children}) : super(AdvanceBlocRoute.name, initialChildren: children);

  static const String name = 'AdvanceBlocRoute';

  static _i6.PageInfo page = _i6.PageInfo(
    name,
    builder: (data) {
      return const _i1.AdvanceBlocPage();
    },
  );
}

/// generated route for
/// [_i2.GetViewPage]
class GetViewRoute extends _i6.PageRouteInfo<GetViewRouteArgs> {
  GetViewRoute({_i7.Key? key, List<_i6.PageRouteInfo>? children})
      : super(
          GetViewRoute.name,
          args: GetViewRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'GetViewRoute';

  static _i6.PageInfo page = _i6.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<GetViewRouteArgs>(
        orElse: () => const GetViewRouteArgs(),
      );
      return _i2.GetViewPage(key: args.key);
    },
  );
}

class GetViewRouteArgs {
  const GetViewRouteArgs({this.key});

  final _i7.Key? key;

  @override
  String toString() {
    return 'GetViewRouteArgs{key: $key}';
  }
}

/// generated route for
/// [_i3.GetViewV2Page]
class GetViewV2Route extends _i6.PageRouteInfo<GetViewV2RouteArgs> {
  GetViewV2Route({_i7.Key? key, List<_i6.PageRouteInfo>? children})
      : super(
          GetViewV2Route.name,
          args: GetViewV2RouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'GetViewV2Route';

  static _i6.PageInfo page = _i6.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<GetViewV2RouteArgs>(
        orElse: () => const GetViewV2RouteArgs(),
      );
      return _i3.GetViewV2Page(key: args.key);
    },
  );
}

class GetViewV2RouteArgs {
  const GetViewV2RouteArgs({this.key});

  final _i7.Key? key;

  @override
  String toString() {
    return 'GetViewV2RouteArgs{key: $key}';
  }
}

/// generated route for
/// [_i4.SimpleCubitPage]
class SimpleCubitRoute extends _i6.PageRouteInfo<void> {
  const SimpleCubitRoute({List<_i6.PageRouteInfo>? children}) : super(SimpleCubitRoute.name, initialChildren: children);

  static const String name = 'SimpleCubitRoute';

  static _i6.PageInfo page = _i6.PageInfo(
    name,
    builder: (data) {
      return const _i4.SimpleCubitPage();
    },
  );
}

/// generated route for
/// [_i5.SplashPage]
class SplashRoute extends _i6.PageRouteInfo<void> {
  const SplashRoute({List<_i6.PageRouteInfo>? children}) : super(SplashRoute.name, initialChildren: children);

  static const String name = 'SplashRoute';

  static _i6.PageInfo page = _i6.PageInfo(
    name,
    builder: (data) {
      return const _i5.SplashPage();
    },
  );
}
