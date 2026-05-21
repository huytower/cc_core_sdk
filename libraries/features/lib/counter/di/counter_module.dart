import 'package:injectable/injectable.dart';

@module
abstract class CounterModule {
  // We don't necessarily need manual registration here anymore
  // if we use @injectable on the implementation classes.
  // This module can be used to provide third-party dependencies if needed.
}
