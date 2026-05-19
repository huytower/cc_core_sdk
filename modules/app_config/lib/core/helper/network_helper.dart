import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class NetworkHelper {
  const NetworkHelper(this.network);

  final InternetConnection network;

  Future<bool> get hasInternet => network.hasInternetAccess;
}
