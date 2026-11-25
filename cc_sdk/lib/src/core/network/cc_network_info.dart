export 'cc_network_info_impl.dart';

abstract class CcNetworkInfo {
  Future<bool> get hasConnected;
}
