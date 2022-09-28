import 'package:fluro/fluro.dart';
import 'package:qypj/pages/search.dart';
import 'package:qypj/pages/welcome.dart';
import 'package:qypj/utils/common.dart';

class FluroRoutes {
  //配置页面
  static var _welcome = Handler(handlerFunc: (context, params) {
    return Welcome();
  });
  static var _search = Handler(handlerFunc: (context, params) {
    return Search();
  });
  //页面标识
  static String root = "/";
  static String search = "/search";
  static configureRoutes(FluroRouter router) {
    router.notFoundHandler = Handler(handlerFunc: (context, params) {
      CommonUtils.debugPrint("not found page");
    });
    router.define(root, handler: _welcome);
    router.define(search, handler: _search);
  }
}
