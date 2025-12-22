// ignore_for_file: non_constant_identifier_names
import 'package:hive/hive.dart';

import '../../domain/model/girl/girl_option_model.dart';
import 'package:flutter/widgets.dart';
import '/domain/model/home_data_model.dart';
// import 'package:replace_host_ip/replace_host_ip.dart';

class AppGlobal {
  static ReportConfig? reportConfig;
  static String reportAppId = '';

  static String reportTraceId = '';
}
