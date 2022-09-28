import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qypj/global.dart';
import 'package:qypj/theme/default.dart';
import 'package:qypj/utils/common.dart';
import 'package:qypj/utils/extensionlibrary.dart';
import 'package:qypj/utils/index.dart';
import 'package:qypj/utils/networkImage.dart';

/// TYPE_ =>1102 最近更新 本周最热,
class ListSortSwitch extends StatelessWidget {
  ListSortSwitch({Key key, this.data, this.id, this.chooseFunc})
      : super(key: key);
  dynamic data;
  String id;
  Function chooseFunc;
  @override
  Widget build(BuildContext context) {
    List value = data['value'];

    return Container(
        // height: ScreenUtil().setWidth(30),
        // margin: EdgeInsets.symmetric(vertical: ScreenUtil().setWidth(8.5)),
        child: Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: value
            .asMap()
            .keys
            .map((index) => Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: ScreenUtil().setWidth(5)),
                  child: GestureDetector(
                    onTap: () {
                      if (chooseFunc != null) {
                        chooseFunc(index);
                      }
                    },
                    behavior: HitTestBehavior.translucent,
                    child: Text(
                      value[index]['title'],
                      style: value[index]['selected']
                          ? GQStyle.white15
                          : GQStyle.gray15,
                    ),
                  ),
                ))
            .toList(),
      ),
    ));
  }
}
