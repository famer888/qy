import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qypj/theme/default.dart';
import 'package:qypj/utils/common.dart';
import 'package:qypj/utils/extensionlibrary.dart';

class NvelNavigationBar extends StatelessWidget {
  NvelNavigationBar({Key key}) : super(key: key);
  List<Map> values = [
    {"bg": "nvel_done_n", "title": CommonUtils.txt("wj")},
    {"bg": "nvel_seril_n", "title": CommonUtils.txt("lz")},
    {"bg": "nvel_hot_n", "title": CommonUtils.txt("rm")},
    {"bg": "nvel_class_n", "title": CommonUtils.txt("fl")},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(
          left: GQStyle.pagePadding,
          right: GQStyle.pagePadding,
          bottom: ScreenUtil().setWidth(25),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: values
              .map(
                (e) => GestureDetector(
                  onTap: () {
                    if (e["title"] == CommonUtils.txt("wj")) {
                      print("******* Nvel_navigaiton_bar debug here");
                      context.push("/rank/1/1");
                      // context.push("/more_and_more_nvel/0/finished/0");
                    } else if (e["title"] == CommonUtils.txt("lz")) {
                      context.push("/more_and_more_nvel/0/serial/0");
                    } else if (e["title"] == CommonUtils.txt("rm")) {
                      context.push("/more_and_more_nvel/hot/0/0");
                    } else if (e["title"] == CommonUtils.txt("fl")) {
                      context.push("/more_and_more_nvel/0/0/0");
                    }
                  },
                  child: Column(
                    children: [
                      LImage(e["bg"],
                          width: ScreenUtil().setWidth(40),
                          height: ScreenUtil().setWidth(36)),
                      SizedBox(height: ScreenUtil().setWidth(7)),
                      Text(e["title"], style: GQStyle.white255_14)
                    ],
                  ),
                ),
              )
              .toList(),
        ));
  }
}
