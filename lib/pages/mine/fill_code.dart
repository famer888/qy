import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qypj/utils/extensionlibrary.dart';
import 'package:provider/provider.dart';
import 'package:universal_html/html.dart' as html;
import 'package:qypj/components/common/pagetitlebar.dart';
import 'package:qypj/components/page_status.dart';
import 'package:qypj/store/homeConfig.dart';
import 'package:qypj/theme/default.dart';
import 'package:qypj/utils/api.dart';
import 'package:qypj/utils/common.dart';

class FillCodePage extends StatefulWidget {
  final Map args;

  FillCodePage({Key key, this.args}) : super(key: key);

  @override
  _FillCodePageState createState() => _FillCodePageState();
}

class _FillCodePageState extends State<FillCodePage> {
  final myController = TextEditingController();
  final FocusNode focusNode = FocusNode();

  void onSubmit() async {
    PageStatus.loading(mounted);
    if (myController.text.isEmpty) {
      CommonUtils.showText(
        CommonUtils.txt('qing') +
            CommonUtils.txt('txi') +
            '${widget?.args['title']}',
      );
    } else {
      var value = myController.text;

      // switch (widget?.args['title']) {
      //   case '昵称':
      //     var resultVi = await validateUsername(username: value);
      //     if (resultVi.status != 1) {
      //       CommonUtils.showText('${resultVi.msg}');
      //     } else {
      //       var result = await updateUserInfo(nickname: value);
      //       Provider.of<HomeConfig>(context, listen: false).setNickname(value);
      //       showText(status: result.status, msg: result.msg);
      //     }
      //     PageStatus.closeLoading();
      //     break;
      //   case '邀请码':
      //     var result = await toInvitation(affCode: value);
      //     if (result.status == 1) {
      //       Provider.of<HomeConfig>(context, listen: false).setInviteBy(value);
      //     }
      //     showText(status: result.status, msg: result.msg, word: '填写');
      //     PageStatus.closeLoading();
      //     break;
      //   case '兑换码':
      //     var result = await onExchange(cdk: value);
      //     showText(status: result.status, msg: result.msg, word: '兑换');
      //     PageStatus.closeLoading();
      //     break;
      //   default:
      // }

      if (widget?.args['title'] ==
          CommonUtils.txt('txi') + CommonUtils.txt('nc')) {
        var resultVi = await validateUsername(username: value);
        if (resultVi.status != 1) {
          CommonUtils.showText('${resultVi.msg}');
        } else {
          var result = await updateUserInfo(nickname: value);
          Provider.of<HomeConfig>(context, listen: false).setNickname(value);
          showText(status: result.status, msg: result.msg);
        }
        PageStatus.closeLoading();
      } else if (widget?.args['title'] == CommonUtils.txt('yqm')) {
        var result = await toInvitation(affCode: value);
        if (result.status == 1) {
          Provider.of<HomeConfig>(context, listen: false).setInviteBy(value);
        }
        showText(
            status: result.status,
            msg: result.msg,
            word: CommonUtils.txt('txi'));
        PageStatus.closeLoading();
      } else if (widget?.args['title'] == CommonUtils.txt('dhm')) {
        var result = await onExchange(cdk: value);
        showText(
            status: result.status,
            msg: result.msg,
            word: CommonUtils.txt('dh'));
        PageStatus.closeLoading();
      } else {
        PageStatus.closeLoading();
      }
    }
  }

  void showText({status, msg, word = 'xg'}) {
    if (word == 'xg') {
      word = CommonUtils.txt('xga');
    }
    if (status == 1) {
      CommonUtils.showText('$word${CommonUtils.txt('cg')} $msg');
      Future.delayed(Duration(seconds: 2), () {
        context.pop();
      });
    } else {
      CommonUtils.showText('$word${CommonUtils.txt('sb')} $msg');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GQStyle.bgColor,
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          focusNode.unfocus();
        },
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PageTitleBar(
                title: widget?.args['title'],
              ),
              Expanded(
                  child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                    horizontal: ScreenUtil().setWidth(25.5),
                    vertical: ScreenUtil().setWidth(21.5)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    widget?.args['title'] == CommonUtils.txt("txyqm")
                        ? Container(
                            height: ScreenUtil().setWidth(21.5),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "*填写邀请你下载用户的推广码",
                                style: GQStyle.hexa3a2a2_11,
                              ),
                            ),
                          )
                        : SizedBox(
                            height: ScreenUtil().setHeight(21.5),
                          ),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: ScreenUtil().setWidth(10)),
                      height: ScreenUtil().setWidth(40),
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Color(0xff2f2f42),
                          borderRadius:
                              BorderRadius.circular(ScreenUtil().setWidth(5))),
                      child: Center(
                        child: TextField(
                            focusNode: focusNode,
                            autofocus: true,
                            // onSubmitted: _onSubmit,
                            controller: myController,
                            style: GQStyle.white255_15_M,
                            cursorColor: Color.fromRGBO(255, 255, 255, 1),
                            textInputAction: TextInputAction.done,
                            decoration: InputDecoration(
                                hoverColor: Colors.white,
                                hintText: CommonUtils.txt('qing') +
                                    CommonUtils.txt('txi') +
                                    '${widget?.args['title']}',
                                hintStyle: TextStyle(
                                  color: Color(0xff999999),
                                  fontFamily: GQStyle.hanyi,
                                  fontWeight: FontWeight.w500,
                                  fontSize: ScreenUtil().setSp(15),
                                ),
                                contentPadding: EdgeInsets.zero,
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
                      ),
                    ),
                    SizedBox(height: ScreenUtil().setWidth(54)),
                    GestureDetector(
                      onTap: onSubmit,
                      child: Container(
                        height: ScreenUtil().setWidth(40),
                        // width: double.infinity,
                        // margin:
                        // EdgeInsets.symmetric(horizontal: GQStyle.pagePadding),
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        child: Stack(
                          children: [
                            // Positioned.fill(
                            //     child: LImage(
                            //   'comic_read_bg',
                            //   fit: BoxFit.fill,
                            //   width: double.infinity,
                            //   height: double.infinity,
                            // )),
                            Positioned.fill(
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                      ScreenUtil().setWidth(5)),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        gradient: GQStyle
                                            .btnGradient_ff00edfd_ffbbe954),
                                  )),
                            ),
                            Center(
                              child: Text(
                                CommonUtils.txt("qr"),
                                style: GQStyle.white255_15_semibold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // GestureDetector(
                    //   onTap: onSubmit,
                    //   child: Container(
                    //     margin: EdgeInsets.only(top: ScreenUtil().setWidth(55)),
                    //     decoration: BoxDecoration(
                    //       color: Color(0xFFff4500),
                    //       borderRadius: BorderRadius.all(Radius.circular(20)),
                    //     ),
                    //     height: ScreenUtil().setWidth(40),
                    //     width: double.infinity,
                    //     child: Center(
                    //       child: Text(
                    //         CommonUtils.txt('qr'),
                    //         style: GQStyle.white255_15_M,
                    //       ),
                    //     ),
                    //   ),
                    // )
                  ],
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }
}
