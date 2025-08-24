import 'package:app_config/config/http/http_client/http_client_config.dart';
import 'package:app_config/constant/cc_constants.dart';
import 'package:data/helper/data_helper.dart';

class LoggerHelper {
  static void printCustom(dynamic str) {
    if (HttpClientConfig.isProduction) {
      return;
    }
    if (str is String) {
      var dtm = DateTime.now();
      print("$str ${DataHelper.convertDatetimeToString(
        dtm: dtm,
        pattern: CcConstantsDateTime.datetimeFormatPattern2Encode,
      )} ${dtm.millisecond} ${dtm.microsecond}");
    }
  }
}
