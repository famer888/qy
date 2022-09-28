import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qypj/base/baseWidget.dart';
import 'package:qypj/components/page_status.dart';
import 'package:qypj/global.dart';
import 'package:qypj/theme/default.dart';
import 'package:qypj/utils/api.dart';
import 'package:qypj/utils/common.dart';
import 'package:qypj/utils/extensionlibrary.dart';

class MineCreaterApply extends BaseWidget {
  MineCreaterApply({Key key}) : super(key: key);

  @override
  State<StatefulWidget> cState() {
    // TODO: implement cState
    return _MineCreaterApplyState();
  }
}

class _MineCreaterApplyState extends BaseWidgetState<MineCreaterApply> {
  bool isHud = true;
  List<dynamic> rusList = [];
  bool is_apply = false;

  _getData() {
    cartoonCreateApply().then((res) {
      if (res.status == 1) {
        rusList = res.data["problem"];
        is_apply = res.data["is_apply"] == 1;
        isHud = false;
        setState(() {});
      } else {
        CommonUtils.showText(res.msg);
        context.pop();
      }
    });
  }

  @override
  void onCreate() {
    // TODO: implement onCreate
    setAppTitle(navColor: Colors.transparent);
    _getData();
  }

  @override
  void onDestroy() {
    // TODO: implement onDestroy
  }

  @override
  Widget pageBody(BuildContext context) {
    // TODO: implement pageBody
    return isHud
        ? PageStatus.loading(mounted)
        : Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: ScreenUtil().setWidth(8)),
                        Center(
                          child: Text(CommonUtils.txt("sqcwupz"),
                              style: GQStyle.white255_20_M),
                        ),
                        SizedBox(height: ScreenUtil().setWidth(19)),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: rusList.map((e) {
                            return Padding(
                              padding: EdgeInsets.only(
                                top: ScreenUtil().setWidth(36),
                                left: GQStyle.pagePadding,
                                right: GQStyle.pagePadding,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    e["q"] ?? "",
                                    style: GQStyle.blue80_18_M,
                                  ),
                                  SizedBox(height: ScreenUtil().setWidth(15)),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children:
                                        e["a"].toString().split("#").map((sx) {
                                      return Text(
                                        sx,
                                        style: GQStyle.gray163_13,
                                        maxLines: AppGlobal.maxLines,
                                      );
                                    }).toList(),
                                  )
                                ],
                              ),
                            );
                          }).toList(),
                        )
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    if (is_apply) {
                      //客服
                      context.push(CommonUtils.getRealHash('customerService'));
                    } else {
                      initLoadGIF(tip: CommonUtils.txt("jzz"));
                      cartoonCreateCreator().then((res) {
                        BotToast.closeAllLoading();
                        if (res.status == 1) {
                          is_apply = true;
                          setState(() {});
                        } else {
                          CommonUtils.showText(res.msg);
                        }
                      });
                    }
                  },
                  child: Container(
                    margin:
                        EdgeInsets.symmetric(horizontal: GQStyle.pagePadding),
                    decoration: BoxDecoration(
                      gradient: is_apply
                          ? LinearGradient(
                              colors: [Color(0xFF23262f), Color(0xFF23262f)],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            )
                          : GQStyle.btnGradient_ff00edfd_ffbbe954,
                      borderRadius: BorderRadius.all(
                        Radius.circular(ScreenUtil().setWidth(5)),
                      ),
                    ),
                    height: ScreenUtil().setWidth(40),
                    child: Center(
                      child: Text(
                        is_apply
                            ? CommonUtils.txt("ysqwsh")
                            : CommonUtils.txt("ljsq"),
                        style: GQStyle.white255_15_M,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: ScreenUtil().setWidth(60))
              ],
            ),
          );
  }
}
