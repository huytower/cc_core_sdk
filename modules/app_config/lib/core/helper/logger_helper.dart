import 'package:app_config/core/config/http/http_client/http_client_config.dart';
import 'package:cc_sdk/core/constants/cc_constants.dart';
import 'package:intl/intl.dart';

class LoggerHelper {
  static void printCustom(dynamic str) {
    if (HttpClientConfig.isProduction) {
      return;
    }
    if (str is String) {
      final now = DateTime.now();
      final timestamp = DateFormat(
        CcConstantsDateTime.datetimeFormatPattern2Encode,
      ).format(now);
      print("$str $timestamp ${now.millisecond} ${now.microsecond}");
    }
  }
}
