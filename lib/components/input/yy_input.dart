import 'dart:async';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qypj/theme/default.dart';
import 'package:qypj/utils/common.dart';

class YyInput extends StatefulWidget {
  YyInput(
      {Key key,
      this.type,
      this.isPassword = false,
      this.onSubmit,
      this.hintText, // = '请输入内容',
      this.autofocus = false,
      this.onChangeCountryCode,
      this.isGetCode = false,
      this.controller,
      this.onSendCode,
      this.initTime,
      this.onChange,
      this.bottomLine = true,
      this.textStyle})
      : super(key: key);
  TextInputType type;
  Function onSubmit;
  String hintText;
  bool autofocus;
  Function onChangeCountryCode;
  bool isGetCode;
  String phone;
  String phonePrefix;
  int sendType; //2 绑定  3 找回账号 1登录账号 4交换手机账号 5手机注册 6手机注册登录
  Function onChange;
  TextEditingController controller;
  Function onSendCode;
  Function initTime;
  bool isPassword;
  bool bottomLine; // 底部横线
  TextStyle textStyle;
  @override
  _YyInputState createState() => _YyInputState();
}

class _YyInputState extends State<YyInput> {
  final inputController = TextEditingController();
  FocusNode _commentFocus = FocusNode();
  int codeStatus = 0; //0 获取验证码   1 正在倒计时  2 重新获取验证码
  int timers = 60;
  String codeText; // = '获取验证码';
  Timer timefc;

  @override
  void initState() {
    super.initState();
    if (codeText == null) {
      codeText = CommonUtils.txt('hqyzm');
    }
  }

  @override
  void dispose() {
    super.dispose();
    if (timefc != null) {
      timefc.cancel();
    }
  }

  Function _startTime() {
    timefc = Timer.periodic(Duration(seconds: 1), (timer) {
      timers--;
      if (timers <= 0) {
        //取消定时器，避免无限回调
        codeStatus = 2;
        codeText = CommonUtils.txt('cxhq');
        timers = 60;
        timer.cancel();
        timer = null;
      } else {
        codeStatus = 1;
        codeText = '${timers}S';
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.hintText == null) {
      widget.hintText = CommonUtils.txt('runr');
    }
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusScope.of(context).requestFocus(_commentFocus);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            margin: EdgeInsets.only(top: ScreenUtil().setWidth(10)),
            padding: EdgeInsets.only(bottom: ScreenUtil().setWidth(10)),
            child: Row(
              children: [
                widget.onChangeCountryCode == null
                    ? Container()
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: ScreenUtil().setWidth(40),
                            child: CountryCodePicker(
                              textStyle: GQStyle.black13,
                              onChanged: widget.onChangeCountryCode,
                              padding: EdgeInsets.symmetric(horizontal: 0),
                              initialSelection: 'CN',
                              favorite: ['+86', 'CN'],
                              showFlag: false,
                              enabled: true,
                              showFlagDialog: true,
                              showCountryOnly: false,
                              showOnlyCountryWhenClosed: false,
                              alignLeft: false,
                            ),
                          ),
                          Container(
                            width: ScreenUtil().setWidth(0.5),
                            height: ScreenUtil().setWidth(15),
                            color: Color(0xffededed),
                          )
                        ],
                      ),
                Expanded(
                    child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: ScreenUtil().setWidth(10)),
                  child: TextField(
                      inputFormatters: [
                        FilteringTextInputFormatter(RegExp("[a-zA-Z]|[0-9]"),
                            allow: true),
                        LengthLimitingTextInputFormatter(20)
                      ],
                      obscureText: widget.isPassword,
                      focusNode: _commentFocus,
                      keyboardType: widget.type,
                      autofocus: widget.autofocus,
                      onChanged: (e) {
                        if (widget.onChange != null) {
                          widget.onChange(e);
                        }
                      },
                      onSubmitted: (e) {
                        if (widget.onSubmit != null) {
                          widget.onSubmit(e);
                        }
                      },
                      controller: widget.controller != null
                          ? widget.controller
                          : inputController,
                      style: widget.textStyle ?? GQStyle.black51_14,
                      textInputAction: TextInputAction.done,
                      cursorColor: GQStyle.cyanColor00edfd,
                      decoration: InputDecoration(
                          hintText: widget.hintText,
                          hintStyle: GQStyle.gray180_14,
                          contentPadding: EdgeInsets.zero,
                          isDense: true,
                          disabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              borderSide: BorderSide(
                                  color: Colors.transparent, width: 0)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              borderSide: BorderSide(
                                  color: Colors.transparent, width: 0)),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              borderSide: BorderSide(
                                  color: Colors.transparent, width: 0)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              borderSide: BorderSide(
                                  color: Colors.transparent, width: 0)))),
                )),
                widget.isGetCode
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: ScreenUtil().setWidth(0.5),
                            height: ScreenUtil().setWidth(15),
                            color: Color(0xffededed),
                          ),
                          SizedBox(
                            width: ScreenUtil().setWidth(10),
                          ),
                          GestureDetector(
                            onTap: () {
                              if (widget.onSendCode != null) {
                                if (widget != null) {
                                  widget.initTime(_startTime);
                                }
                                widget.onSendCode();
                              }
                            },
                            child: Container(
                              width: ScreenUtil().setWidth(75),
                              height: ScreenUtil().setWidth(24.5),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      width: ScreenUtil().setWidth(0.5),
                                      color: Color(0xfff53e43)),
                                  borderRadius: BorderRadius.circular(
                                      ScreenUtil().setWidth(12.25))),
                              child: Center(
                                child: Text(
                                  codeText,
                                  style: TextStyle(
                                      color: Color(0xfff53e43),
                                      fontSize: ScreenUtil().setSp(11)),
                                ),
                              ),
                            ),
                          )
                        ],
                      )
                    : Container()
              ],
            ),
          ),
          widget.bottomLine
              ? Container(
                  width: double.infinity,
                  height: ScreenUtil().setWidth(0.5),
                  color: Color(0xffe1e1e1),
                )
              : Container()
        ],
      ),
    );
  }
}
