import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qypj/base/baseWidget.dart';
import 'package:qypj/global.dart';
import 'package:qypj/theme/default.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:qypj/utils/common.dart';

class MineCreaterIssueRule extends BaseWidget {
  MineCreaterIssueRule({Key key}) : super(key: key);

  @override
  State<StatefulWidget> cState() {
    // TODO: implement cState
    return _MineCreaterIssueRuleState();
  }
}

class _MineCreaterIssueRuleState extends BaseWidgetState<MineCreaterIssueRule> {
  @override
  void onCreate() {
    // TODO: implement onCreate
    setAppTitle(title: CommonUtils.txt("scxz"));
  }

  @override
  void onDestroy() {
    // TODO: implement onDestroy
  }

  @override
  Widget pageBody(BuildContext context) {
    // TODO: implement pageBody
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: GQStyle.pagePadding,
        // vertical: GQStyle.pagePadding,
      ),
      child: SingleChildScrollView(
        child: Html(
          data: AppGlobal.rules,
          style: {
            "b": Style(
                color: Color(0xFF00edfb),
                width: double.infinity,
                padding: EdgeInsets.all(0),
                margin: EdgeInsets.all(0),
                fontSize: FontSize(ScreenUtil().setSp(18)),
                fontWeight: FontWeight.w500,
                lineHeight: LineHeight(1.5)),
            "p": Style(
                color: Color(0xffffffff),
                width: double.infinity,
                padding: EdgeInsets.only(top: ScreenUtil().setWidth(10)),
                margin: EdgeInsets.all(0),
                fontSize: FontSize(ScreenUtil().setSp(13)),
                lineHeight: LineHeight(2.0)),
          },
        ),
      ),
    );
  }
}
