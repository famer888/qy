/*
 * @Author: Tom
 * @Date: 2021-12-27 16:56:56
 * @LastEditTime: 2021-12-27 17:00:56
 * @LastEditors: Tom
 * @Description: 
 * @FilePath: /flutter2021/lib/components/common/pagetitlebar.dart
 */
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qypj/utils/common.dart';
import 'package:qypj/utils/extensionlibrary.dart';
import 'package:qypj/theme/default.dart';

// ignore: must_be_immutable
class PageTitleBar extends StatefulWidget {
  PageTitleBar(
      {Key key,
      this.title,
      this.rightWidget,
      this.height,
      this.showLine = false})
      : super(key: key);
  String title;
  Widget rightWidget;
  double height;
  bool showLine;
  @override
  _PageTitleBarState createState() => _PageTitleBarState();
}

class _PageTitleBarState extends State<PageTitleBar> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          alignment: Alignment.center,
          width: ScreenUtil().screenWidth,
          height: widget.height ?? GQStyle.navbarHegiht,
          child: Text(
            widget.title != null ? widget.title : '',
            style: GQStyle.white255_18_B,
          ),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: widget.showLine ? Color(0xFF212122) : Colors.transparent,
                width: ScreenUtil().setWidth(0.5),
              ),
            ),
          ),
        ),
        Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            top: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: GQStyle.pagePadding,
                      vertical: ScreenUtil().setWidth(5)),
                  child: GestureDetector(
                    onTap: () {
                      context.pop();
                    },
                    child: LImage(
                      "nav_back_n",
                      width: ScreenUtil().setWidth(20),
                      height: ScreenUtil().setWidth(20),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: GQStyle.pagePadding),
                  child: widget.rightWidget != null
                      ? widget.rightWidget
                      : Container(),
                )
              ],
            ))
      ],
    );
  }
}
