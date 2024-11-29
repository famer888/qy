import 'package:dio/dio.dart';

import '../../../domain/exception.dart';
import '../../../domain/type_def.dart';

class DynamicService {
  DynamicService(this._dio);

  final Dio _dio;

  AsyncJson post(String path, {Object? data}) async {
    final result = (await _dio.post(path, data: data)).data;
    if (result == null) {
      throw ResponseNullException();
    }
    return result;
  }

  AsyncJson getConstructByApiLink({
    required String apiLink,
    required Map params,
  }) =>
      post(apiLink, data: params);
}
