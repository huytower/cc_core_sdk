import 'package:data/helper/data_helper.dart';

class LoggerHelper {
  static void printCustom(dynamic str) {
    if (CcAppConfig.instance is AppConfigProd) {
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
