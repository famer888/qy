import 'package:dio/dio.dart';

import '../../../domain/exception.dart';
import '../../../domain/type_def.dart';
import '../../../ui_layer/utils/common_utils.dart';

abstract class BaseService {
  BaseService(this._dio);

  final Dio _dio;

  String get service;

  AsyncJson post(String path, {Object? data}) async {
    // CommonUtils.log('request url: /api/$service$path');
    // CommonUtils.log('params: $data');

    final result = (await _dio.post('/api/$service$path', data: data)).data;

    // CommonUtils.log('$result');

    if (result == null) {
      throw ResponseNullException();
    }
    return result;
  }
}
