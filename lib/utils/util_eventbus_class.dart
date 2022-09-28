import 'package:event_bus/event_bus.dart';

class UtilEventbusClass {
  Map arg; //{"name":事件名，"data": 数据}
  UtilEventbusClass(this.arg);
}

class UtilEventbus extends EventBus {
  static UtilEventbus _instance;
  UtilEventbus._internal() {
    _instance = this;
  }
  factory UtilEventbus() => _instance ?? UtilEventbus._internal();
}
