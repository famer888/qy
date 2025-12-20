import 'package:flutter/widgets.dart';
import '/domain/model/home_data_model.dart';
import 'domain/model/girl/girl_option_model.dart';

class AppGlobal {
  static String m3u8Encrypt = '0';

  // 约炮gilr class 类型
  static List<GirlOptionItemModel> girlClassList = [];

  static BuildContext? context;
  static ReportConfig? reportConfig;
  static String reportAppId = '';

  static String reportTraceId = '';
}
