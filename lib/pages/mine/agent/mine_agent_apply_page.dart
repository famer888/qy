import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qypj/base/baseWidget.dart';
import 'package:qypj/components/yy_dialog.dart';
import 'package:qypj/model/basic.dart';
import 'package:qypj/model/homedata.dart';
import 'package:qypj/routers.dart';
import 'package:qypj/store/homeConfig.dart';
import 'package:qypj/theme/default.dart';
import 'package:qypj/utils/api.dart';
import 'package:qypj/utils/common.dart';
import 'package:qypj/utils/networkImage.dart';
import 'package:qypj/utils/extensionlibrary.dart';
import 'package:provider/provider.dart';

class MineAgentApplyPage extends StatefulWidget {
  MineAgentApplyPage({Key key, this.applySuccess}) : super(key: key);
  final Function applySuccess;

  @override
  State<MineAgentApplyPage> createState() => _MineAgentApplyPageState();
}

class _MineAgentApplyPageState extends State<MineAgentApplyPage> {
  TextEditingController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = TextEditingController();
  }

  _applyAgent() async {
    String contack = _controller.text;

    BotToast.showWidget(toastBuilder: (
      CancelFunc cancelFunc,
    ) {
      return Center(
        child: CircularProgressIndicator(
          color: GQStyle.jellyCyanColor103224185,
        ),
      );
    });
    // BotToast.closeAllLoading();

    Basic res = await applyProxyWithContact(contack);
    if (res.status != 1) {
      CommonUtils.showText(res.msg);
    } else {
      CommonUtils.showText(res.msg);

      await getUserInfo(context);
      if (widget.applySuccess != null) {
        widget.applySuccess();
      }
    }

    BotToast.removeAll();
  }

  _askApplyAgent() {
    String contack = _controller.text;
    if (contack.length == 0) {
      CommonUtils.showText(CommonUtils.txt('srnr'));
      return;
    }
    YyShowDialog.showdialog_flj(
      context,
      title: CommonUtils.txt('ts'),
      btnText: CommonUtils.txt('qd'),
      callBack: _applyAgent,
      cancelText: CommonUtils.txt('qx'),
      content: (ss) {
        return Text(
          CommonUtils.txt('sqdlm'),
          style: GQStyle.white13,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    HomeConfig config = Provider.of<HomeConfig>(context, listen: false);

    return Container(
        padding: EdgeInsets.symmetric(horizontal: GQStyle.pagePadding),
        child: GestureDetector(
            onTap: () {
              FocusScopeNode currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus &&
                  currentFocus.focusedChild != null) {
                FocusManager.instance.primaryFocus.unfocus();
              }
            },
            child: Column(
              children: [
                SizedBox(height: ScreenUtil().setWidth(10)),
                ClipRRect(
                  borderRadius: BorderRadius.circular(ScreenUtil().setWidth(5)),
                  child: Container(
                    child: LImage(
                      'dlsq',
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  padding:
                      EdgeInsets.symmetric(vertical: ScreenUtil().setWidth(20)),
                  child: RichText(
                      text: TextSpan(children: [
                    TextSpan(
                      text: CommonUtils.txt('yy'),
                      style: GQStyle.white255_14,
                    ),
                    TextSpan(
                      text: config.config.proxy_join_num ?? '',
                      style: GQStyle.hexfbe099_13_M,
                    ),
                    TextSpan(
                      text: CommonUtils.txt('re'),
                      style: GQStyle.white255_14,
                    ),
                    TextSpan(
                      text: CommonUtils.txt('sqcw'),
                      style: GQStyle.white255_14,
                    ),
                  ])),
                ),
                // SizedBox(
                //   height: ScreenUtil().setWidth(24.5),
                // ),
                Container(
                  decoration: BoxDecoration(
                      // color: Color(0xff23262f),
                      borderRadius:
                          BorderRadius.circular(ScreenUtil().setWidth(5))),
                  // padding: EdgeInsets.symmetric(
                  //     vertical: ScreenUtil().setWidth(29.5)),
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        child: Text(
                          CommonUtils.txt('sqcw'),
                          style: GQStyle.white255_20_M,
                        ),
                      ),
                      SizedBox(
                        height: ScreenUtil().setWidth(32),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: ScreenUtil().setWidth(38)),
                        height: ScreenUtil().setWidth(38.5),
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Color.fromARGB(66, 163, 162, 162),
                                width: 0.5),
                            borderRadius: BorderRadius.circular(
                                ScreenUtil().setWidth(5))),
                        alignment: Alignment.center,
                        child: TextField(
                          controller: _controller,
                          textAlign: TextAlign.center,
                          style: GQStyle.white255_14,
                          cursorColor: GQStyle.cyanColor00edfd,
                          decoration: InputDecoration(
                            hintText: CommonUtils.txt('txlx'),
                            hintStyle: GQStyle.gray123_14,
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.transparent),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.transparent),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: ScreenUtil().setWidth(38.5),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: GestureDetector(
                          onTap: _askApplyAgent,
                          child: Container(
                            alignment: Alignment.center,
                            width: ScreenUtil().setWidth(264),
                            height: ScreenUtil().setWidth(38),
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    colors: [
                                      Color(0xfffaddbd),
                                      Color(0xfff2c380)
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter),
                                borderRadius: BorderRadius.circular(
                                    ScreenUtil().setWidth(38 / 2))),
                            child: Text(
                              CommonUtils.txt('tj'),
                              style: GQStyle.hexaa5000_18_S,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            )));
  }
}
