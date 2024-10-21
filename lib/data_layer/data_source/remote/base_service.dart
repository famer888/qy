import 'package:dio/dio.dart';

import '../../../domain/exception.dart';
import '../../../domain/type_def.dart';

abstract class BaseService {
  BaseService(this._dio);

  final Dio _dio;

  String get service;

  AsyncJson post(String path, {Object? data}) async {
    final result = (await _dio.post('/api/$service$path', data: data)).data;
    if (result == null) {
      throw ResponseNullException();
    }
    return result;
  }
}
