import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qypj/utils/common.dart';
import 'package:qypj/utils/extensionlibrary.dart';
import 'package:qypj/routers.dart';
import 'package:qypj/theme/default.dart';

// ignore: must_be_immutable
class WidgetTitleBar extends StatefulWidget {
  WidgetTitleBar({Key key, this.title, this.hasMore = false, this.moreOnTap})
      : super(key: key);
  String title;
  bool hasMore;
  Function moreOnTap;
  @override
  _WidgetTitleBarState createState() => _WidgetTitleBarState();
}

class _WidgetTitleBarState extends State<WidgetTitleBar> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: ScreenUtil().setWidth(14)),
      child: Row(
        children: [
          Image.asset(
            "assets/images/header_title.png",
            width: ScreenUtil().setWidth(7),
            height: ScreenUtil().setWidth(17),
          ),
          SizedBox(width: ScreenUtil().setWidth(5)),
          Expanded(
              child: Text(
            widget.title,
            style: GQStyle.black1834,
          )),
          widget.hasMore
              ? GestureDetector(
                  onTap: () {
                    if (widget.moreOnTap != null) {
                      widget.moreOnTap();
                    }
                  },
                  child: Row(
                    children: [
                      Container(
                        padding:
                            EdgeInsets.only(left: ScreenUtil().setWidth(10)),
                        child: Text(
                          CommonUtils.txt('gd'),
                          style: GQStyle.red240,
                        ),
                      ),
                      Container(
                        padding:
                            EdgeInsets.only(left: ScreenUtil().setWidth(6.5)),
                        child: Image.asset(
                          'assets/images/more_arrow.png',
                          width: ScreenUtil().setWidth(12),
                          height: ScreenUtil().setWidth(12),
                        ),
                      )
                    ],
                  ),
                )
              : Container()
        ],
      ),
    );
  }
}
