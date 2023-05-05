import 'package:flutter/material.dart';
import 'package:qypj/base/baseWidget.dart';
import 'package:qypj/pages/mine/mine_ncome_detailed_child.dart';
import 'package:qypj/utils/common.dart';

class MineNcomeDetailed extends BaseWidget {
  MineNcomeDetailed({Key key}) : super(key: key);

  @override
  State<StatefulWidget> cState() {
    // TODO: implement cState
    return _MineNcomeDetailedState();
  }
}

class _MineNcomeDetailedState extends BaseWidgetState<MineNcomeDetailed> {
  dynamic topData;

  @override
  void onCreate() {
    // TODO: implement onCreate
    setAppTitle(
      title: CommonUtils.txt("symx"),
      navColor: Colors.transparent,
    );
  }

  @override
  void onDestroy() {
    // TODO: implement onDestroy
  }

  @override
  Widget pageBody(BuildContext context) {
    // TODO: implement pageBody
    return MineNcomeDetailedChild(
      source: "post",
    );
  }
}
