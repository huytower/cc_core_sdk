import 'package:injectable/injectable.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

@module
abstract class InfrastructureModule {
  @singleton
  InternetConnection get connectionChecker =>
      InternetConnection();
}
