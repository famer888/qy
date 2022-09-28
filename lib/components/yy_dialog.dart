import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import 'package:qypj/global.dart';
import 'package:qypj/utils/common.dart';
import 'package:qypj/utils/extensionlibrary.dart';
import 'package:qypj/theme/default.dart';

class YyShowDialog {
  static Future<dynamic> showdialog(BuildContext context,
      {String title,
      Function content,
      Function callBack,
      Function cancelBack,
      String btnText,
      String cancelText,
      Function changeBtnText,
      bool prohibitClose = true,
      Color backgroundColor = const Color.fromRGBO(35, 38, 46, 1),
      bool showUpCloseBtn = false, // 顶部显示 关闭
      Function toPageCallback}) {
    //当content为null时会触发该事件（点击直接触发，不弹框）}) {
    return showDialog<dynamic>(
      context: context,
      barrierDismissible: prohibitClose,
      builder: (context) {
        return StatefulBuilder(builder: (context, setDialogState) {
          if (changeBtnText != null) {
            btnText = changeBtnText();
          }
          return Dialog(
            backgroundColor: Colors.transparent,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                showUpCloseBtn
                    ? Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            onTap: () {
                              context.pop();
                            },
                            child: LImage(
                              'dialog_close',
                              width: ScreenUtil().setWidth(30),
                            ),
                          ),
                          SizedBox(
                            height: ScreenUtil().setWidth(25),
                          )
                        ],
                      )
                    : Container(),
                Container(
                  width: ScreenUtil().setWidth(300),
                  padding: new EdgeInsets.only(
                      left: ScreenUtil().setWidth(24.5),
                      right: ScreenUtil().setWidth(24.5),
                      top: title == null ? 0 : ScreenUtil().setWidth(25),
                      bottom: ScreenUtil().setWidth(33.5)),
                  decoration: BoxDecoration(
                      color: backgroundColor,
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  child: Stack(
                    overflow: Overflow.visible,
                    children: <Widget>[
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Center(
                            child: Text(
                              title ?? '',
                              style: GQStyle.white255_18_M,
                            ),
                          ),
                          Container(
                              margin: title == null
                                  ? EdgeInsets.zero
                                  : new EdgeInsets.only(
                                      top: ScreenUtil().setWidth(26)),
                              child: content(setDialogState)),
                          Row(
                            children: [
                              cancelText != null
                                  ? Expanded(
                                      child: Center(
                                      child: GestureDetector(
                                        onTap: () {
                                          context.pop();
                                          if (cancelBack != null) {
                                            cancelBack();
                                          }
                                        },
                                        child: Container(
                                          margin: EdgeInsets.only(
                                              left: ScreenUtil().setWidth(5),
                                              right: ScreenUtil().setWidth(5),
                                              top: ScreenUtil().setWidth(40)),
                                          width: ScreenUtil().setWidth(163.5),
                                          height: ScreenUtil().setWidth(32),
                                          decoration: BoxDecoration(
                                              gradient: cancelText.contains(
                                                      CommonUtils.txt("qx"))
                                                  ? LinearGradient(
                                                      colors: [
                                                        Color(0xFFA1A1A1),
                                                        Color(0xFFA1A1A1)
                                                      ],
                                                      begin:
                                                          Alignment.centerLeft,
                                                      end:
                                                          Alignment.centerRight,
                                                    )
                                                  : GQStyle
                                                      .btnGradient_ff00edfd_ffbbe954,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(ScreenUtil()
                                                      .setWidth(16)))),
                                          child: Center(
                                            child: Text(
                                              cancelText,
                                              style: GQStyle.white255_12,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ))
                                  : Container(),
                              btnText != null
                                  ? Expanded(
                                      child: Center(
                                      child: GestureDetector(
                                        onTap: () {
                                          context.pop();
                                          if (callBack != null) {
                                            callBack();
                                          }
                                        },
                                        child: Container(
                                          margin: EdgeInsets.only(
                                              left: ScreenUtil().setWidth(5),
                                              right: ScreenUtil().setWidth(5),
                                              top: ScreenUtil().setWidth(40)),
                                          width: ScreenUtil().setWidth(163.5),
                                          height: ScreenUtil().setWidth(32),
                                          decoration: BoxDecoration(
                                              gradient: GQStyle
                                                  .btnGradient_ff00edfd_ffbbe954,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(ScreenUtil()
                                                      .setWidth(16)))),
                                          child: Center(
                                            child: Text(
                                              btnText,
                                              style: GQStyle.white255_12,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ))
                                  : Container()
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                showUpCloseBtn
                    ? AbsorbPointer(
                        absorbing: true,
                        child: SizedBox(
                          height: ScreenUtil().setWidth(55),
                        ),
                      )
                    : Container(),
              ],
            ),
          );
        });
      },
    );
  }

  static Future<dynamic> showdialog_flj(BuildContext context,
      {String title,
      Function content,
      Function callBack,
      Function cancelBack,
      String btnText,
      String cancelText,
      Function changeBtnText,
      bool prohibitClose = true,
      Color backgroundColor = const Color(0xff23262f),
      Function toPageCallback}) {
    //当content为null时会触发该事件（点击直接触发，不弹框）}) {
    return showDialog<dynamic>(
      context: context,
      barrierDismissible: prohibitClose,
      builder: (context) {
        return StatefulBuilder(builder: (context, setDialogState) {
          if (changeBtnText != null) {
            btnText = changeBtnText();
          }
          return Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              width: ScreenUtil().setWidth(300),
              padding: new EdgeInsets.only(
                  left: ScreenUtil().setWidth(24.5),
                  right: ScreenUtil().setWidth(24.5),
                  top: title == null ? 0 : ScreenUtil().setWidth(25),
                  bottom: ScreenUtil().setWidth(33.5)),
              decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: Stack(
                overflow: Overflow.visible,
                children: <Widget>[
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Center(
                        child: Text(
                          title ?? '',
                          style: GQStyle.white20medium,
                        ),
                      ),
                      Container(
                          margin: title == null
                              ? EdgeInsets.zero
                              : new EdgeInsets.only(
                                  top: ScreenUtil().setWidth(26)),
                          child: content(setDialogState)),
                      Row(
                        children: [
                          cancelText != null
                              ? Expanded(
                                  child: Center(
                                  child: GestureDetector(
                                    onTap: () {
                                      context.pop();
                                      if (cancelBack != null) {
                                        cancelBack();
                                      }
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(
                                          left: ScreenUtil().setWidth(5),
                                          right: ScreenUtil().setWidth(5),
                                          top: ScreenUtil().setWidth(40)),
                                      width: ScreenUtil().setWidth(120),
                                      height: ScreenUtil().setWidth(32),
                                      decoration: BoxDecoration(
                                          color:
                                              Color.fromRGBO(59, 61, 68, 1.0),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(
                                                  ScreenUtil().setWidth(16)))),
                                      child: Center(
                                        child: Text(
                                          cancelText,
                                          style: GQStyle.hexa3a2a2_13_M,
                                        ),
                                      ),
                                    ),
                                  ),
                                ))
                              : Container(),
                          cancelText != null
                              ? SizedBox(width: ScreenUtil().setWidth(30))
                              : Container(),
                          btnText != null
                              ? Expanded(
                                  child: Center(
                                  child: GestureDetector(
                                    onTap: () {
                                      context.pop();
                                      if (callBack != null) {
                                        callBack();
                                      }
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(
                                          left: ScreenUtil().setWidth(5),
                                          right: ScreenUtil().setWidth(5),
                                          top: ScreenUtil().setWidth(40)),
                                      width: ScreenUtil().setWidth(120),
                                      height: ScreenUtil().setWidth(32),
                                      decoration: BoxDecoration(
                                          gradient: GQStyle
                                              .btnGradient_ff00edfd_ffbbe954,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(
                                                  ScreenUtil().setWidth(16)))),
                                      child: Center(
                                        child: Text(
                                          btnText,
                                          style: GQStyle.white255_13_M,
                                        ),
                                      ),
                                    ),
                                  ),
                                ))
                              : Container()
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
  }

  static Future<dynamic> showdPNGDiaog(BuildContext context,
      {String title,
      Function content,
      Function callBack,
      Function cancelBack,
      String btnText,
      String cancelText,
      Function changeBtnText,
      bool prohibitClose = true,
      Color backgroundColor = const Color.fromRGBO(35, 38, 46, 1),
      bool showUpCloseBtn = false, // 顶部显示 关闭
      Function toPageCallback}) {
    //当content为null时会触发该事件（点击直接触发，不弹框）}) {
    return showDialog<dynamic>(
      context: context,
      barrierDismissible: prohibitClose,
      builder: (context) {
        return StatefulBuilder(builder: (context, setDialogState) {
          if (changeBtnText != null) {
            btnText = changeBtnText();
          }
          return Dialog(
            backgroundColor: Colors.transparent,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                showUpCloseBtn
                    ? Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            onTap: () {
                              context.pop();
                            },
                            child: LImage(
                              'dialog_close',
                              width: ScreenUtil().setWidth(30),
                            ),
                          ),
                          SizedBox(
                            height: ScreenUtil().setWidth(25),
                          )
                        ],
                      )
                    : Container(),
                Container(
                  child: Stack(
                    children: [
                      Column(
                        children: [
                          SizedBox(
                              height:
                                  ScreenUtil().setWidth(300 / 305 * 114 - 40)),
                          Container(
                            width: ScreenUtil().setWidth(300),
                            padding: new EdgeInsets.only(
                                left: ScreenUtil().setWidth(24.5),
                                right: ScreenUtil().setWidth(24.5),
                                top: title == null
                                    ? 0
                                    : ScreenUtil().setWidth(50),
                                bottom: ScreenUtil().setWidth(33.5)),
                            decoration: BoxDecoration(
                                color: backgroundColor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            child: Stack(
                              overflow: Overflow.visible,
                              children: <Widget>[
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    // Center(
                                    //   child: Text(
                                    //     title ?? '',
                                    //     style: GQStyle.white255_18_M,
                                    //   ),
                                    // ),
                                    Container(
                                        margin: title == null
                                            ? EdgeInsets.zero
                                            : new EdgeInsets.only(
                                                top: ScreenUtil().setWidth(26)),
                                        child: content(setDialogState)),
                                    Row(
                                      children: [
                                        cancelText != null
                                            ? Expanded(
                                                child: Center(
                                                child: GestureDetector(
                                                  onTap: () {
                                                    context.pop();
                                                    if (cancelBack != null) {
                                                      cancelBack();
                                                    }
                                                  },
                                                  child: Container(
                                                    margin: EdgeInsets.only(
                                                        left: ScreenUtil()
                                                            .setWidth(5),
                                                        right: ScreenUtil()
                                                            .setWidth(5),
                                                        top: ScreenUtil()
                                                            .setWidth(40)),
                                                    width: ScreenUtil()
                                                        .setWidth(163.5),
                                                    height: ScreenUtil()
                                                        .setWidth(32),
                                                    decoration: BoxDecoration(
                                                        gradient: cancelText
                                                                .contains(
                                                                    CommonUtils
                                                                        .txt(
                                                                            "qx"))
                                                            ? LinearGradient(
                                                                colors: [
                                                                  Color(
                                                                      0xFFA1A1A1),
                                                                  Color(
                                                                      0xFFA1A1A1)
                                                                ],
                                                                begin: Alignment
                                                                    .centerLeft,
                                                                end: Alignment
                                                                    .centerRight,
                                                              )
                                                            : GQStyle
                                                                .btnGradient_ff00edfd_ffbbe954,
                                                        borderRadius: BorderRadius
                                                            .all(Radius.circular(
                                                                ScreenUtil()
                                                                    .setWidth(
                                                                        16)))),
                                                    child: Center(
                                                      child: Text(
                                                        cancelText,
                                                        style:
                                                            GQStyle.white255_12,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ))
                                            : Container(),
                                        btnText != null
                                            ? Expanded(
                                                child: Center(
                                                child: GestureDetector(
                                                  onTap: () {
                                                    context.pop();
                                                    if (callBack != null) {
                                                      callBack();
                                                    }
                                                  },
                                                  child: Container(
                                                    margin: EdgeInsets.only(
                                                        left: ScreenUtil()
                                                            .setWidth(5),
                                                        right: ScreenUtil()
                                                            .setWidth(5),
                                                        top: ScreenUtil()
                                                            .setWidth(40)),
                                                    width: ScreenUtil()
                                                        .setWidth(163.5),
                                                    height: ScreenUtil()
                                                        .setWidth(32),
                                                    decoration: BoxDecoration(
                                                        gradient: GQStyle
                                                            .btnGradient_ff00edfd_ffbbe954,
                                                        borderRadius: BorderRadius
                                                            .all(Radius.circular(
                                                                ScreenUtil()
                                                                    .setWidth(
                                                                        16)))),
                                                    child: Center(
                                                      child: Text(
                                                        btnText,
                                                        style:
                                                            GQStyle.white255_12,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ))
                                            : Container()
                                      ],
                                    )
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      Container(
                        width: ScreenUtil().setWidth(300),
                        height: ScreenUtil().setWidth(300 / 305 * 114),
                        child: LImage(
                          "alert_png_n",
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                    ],
                  ),
                ),
                showUpCloseBtn
                    ? AbsorbPointer(
                        absorbing: true,
                        child: SizedBox(
                          height: ScreenUtil().setWidth(55),
                        ),
                      )
                    : Container(),
              ],
            ),
          );
        });
      },
    );
  }
}
