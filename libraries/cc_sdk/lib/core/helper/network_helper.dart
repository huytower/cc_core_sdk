import 'package:injectable/injectable.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

/// Connectivity helper backed by [InternetConnection].
@singleton
class NetworkHelper {
  const NetworkHelper(this._connection);

  final InternetConnection _connection;

  Future<bool> get hasInternet => _connection.hasInternetAccess;
}
