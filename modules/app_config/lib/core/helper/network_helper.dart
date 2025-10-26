import 'package:internet_connection_checker/internet_connection_checker.dart';

class NetworkHelper {
  const NetworkHelper(this.network);

  final InternetConnectionChecker network;

  Future<bool> get hasInternet => network.hasConnection;
}
