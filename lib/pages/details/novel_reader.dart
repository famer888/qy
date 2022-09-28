import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qypj/store/homeConfig.dart';
import 'package:qypj/utils/crypto.dart';
import 'package:qypj/utils/extensionlibrary.dart';
import 'package:qypj/components/page_status.dart';
import 'package:qypj/components/yy_dialog.dart';
import 'package:qypj/global.dart';
import 'package:qypj/mixin/watchRecordMixin.dart';
import 'package:qypj/routers.dart';
import 'package:qypj/theme/default.dart';
import 'package:qypj/utils/api.dart';
import 'package:qypj/utils/common.dart';
import 'package:provider/provider.dart';

class NovelReader extends StatefulWidget {
  NovelReader({Key key, this.id, this.novelInfoData}) : super(key: key);
  final String id;
  final dynamic novelInfoData;
  @override
  _NovelReaderState createState() => _NovelReaderState();
}

class _NovelReaderState extends State<NovelReader> with WatchRecordMixin {
  Duration durationTime = Duration(milliseconds: 300);
  int cureentIndex = 0;
  bool isShow = true;
  Map novelReader;
  String content = "";
  // List<dynamic> seriesList = [];
  double offset = 0;
  ScrollController controller = ScrollController();
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  _getData() async {
    getBookReader(id: widget.id).then((res) {
      if (res.status != 0) {
        novelReader = res.data;
        cureentIndex = AppGlobal.blues.indexWhere((item) {
          return item['id'].toString() == widget.id;
        });
        watchRcordTimer = Timer.periodic(new Duration(seconds: 2), (timer) {
          startWatchRecordTimer(
            AppGlobal.bookWatchRecordBox,
            widget.novelInfoData['id'] ?? novelReader['id'],
            chapterId: novelReader['story_id'],
            offset: offset,
            current: cureentIndex,
            thumb: widget.novelInfoData['thumb'] ?? '',
            title: widget.novelInfoData['title'] ??
                AppGlobal.blues[cureentIndex]['title'],
          );
        });
        WidgetsBinding.instance.addPostFrameCallback((_) {
          getOffset();
        });
        PlatformAwareCrypto.decryptNovel(novelReader["file"] ?? "")
            .then((value) {
          content = value;
          CommonUtils.debugPrint(value);
          setState(() {});
        });
        // PlatformAwareCrypto.decryptNovel(
        //         "https://txt.microservices.vip/20220407/20220407141025085054.txt?v=1")
        //     .then((value) {
        //   content = value;
        //   CommonUtils.debugPrint(value);
        //   setState(() {});
        // });
      } else {
        context.pop();
        CommonUtils.showText(res.msg);
      }
    });
  }

  @override
  void initState() {
    super.initState();

    _getData();
    controller.addListener(() {
      offset = controller.offset;
    });
  }

  getOffset() {
    var boxData = AppGlobal.bookWatchRecordBox.get(novelReader['list']['id']);
    if (boxData == null ||
        boxData[novelReader['list']['story_series_id']] == null) return;
    var coffset = boxData[novelReader['list']['story_series_id']];
    controller.jumpTo(coffset);
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget menuItem({String icon, String text, Color color}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        LImage(icon,
            width: ScreenUtil().setWidth(23),
            height: ScreenUtil().setWidth(21)),
        SizedBox(
          height: ScreenUtil().setWidth(4.5),
        ),
        Text(
          text,
          style: TextStyle(
              color: Colors.white,
              fontSize: ScreenUtil().setSp(12),
              decoration: TextDecoration.none),
        )
      ],
    );
  }

  swichNovel(id, {bool replace = false}) {
    //当前数据返回
    if (id == AppGlobal.blues[cureentIndex]["id"]) return;

    dynamic e = AppGlobal.blues.where((element) => element["id"] == id).first;
    CommonUtils.debugPrint("${e}==${id}");
    if (e["is_pay"] == 1 || e["is_free"] == 0) {
      context.push(
          CommonUtils.getRealHash()
              .replaceAll(RegExp(r"novelReader/.*"), 'novelReader/$id'),
          replace: replace,
          extra: widget.novelInfoData);
      return;
    }
    if (e["is_free"] == 1 && AppGlobal.vipLevel > 0) {
      context.push(
          CommonUtils.getRealHash()
              .replaceAll(RegExp(r"novelReader/.*"), 'novelReader/$id'),
          replace: replace,
          extra: widget.novelInfoData);
      return;
    }
    if (e["is_free"] == 1 && AppGlobal.vipLevel < 1) {
      YyShowDialog.showdPNGDiaog(
        context,
        title: CommonUtils.txt("ts"),
        content: (setDialogState) {
          return Text(
            CommonUtils.txt("kthycdxs"),
            style: TextStyle(
                color: Color.fromRGBO(51, 51, 51, 1),
                fontSize: ScreenUtil().setSp(15),
                decoration: TextDecoration.none),
          );
        },
        cancelText: CommonUtils.txt("qx"),
        btnText: CommonUtils.txt("ljkt"),
        callBack: () {
          context.push('/${Routes.vip}');
        },
      );
      return;
    }
    if (e["is_free"] == 2) {
      //扣币
      if (AppGlobal.isAutoBy) {
        _byNvelChapter(id, replace, e);
        return;
      }
      WidgetsBinding.instance.addPostFrameCallback((_) {
        int money =
            Provider.of<HomeConfig>(context, listen: false).member.money;
        bool isInsufficient = money < e["view_money"];
        YyShowDialog.showdialog(context,
            title: isInsufficient ? CommonUtils.txt("jbbz") : e["title"],
            btnText: isInsufficient
                ? CommonUtils.txt("qwcz")
                : CommonUtils.txt("gmbzj"), callBack: () {
          if (isInsufficient) {
            context.push('/${Routes.coinRecharge}');
          } else {
            _byNvelChapter(id, replace, e);
          }
        }, content: (setDialogState) {
          return DefaultTextStyle(
              style: GQStyle.gry30_14_M,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                      "*${CommonUtils.txt("ny")}${money}${CommonUtils.txt("jb")},${CommonUtils.txt("xyzzdgm")}*",
                      style: GQStyle.gray169_14),
                  SizedBox(height: ScreenUtil().setWidth(5)),
                  Text.rich(
                      TextSpan(text: CommonUtils.txt("bzjxhf"), children: [
                    TextSpan(
                        text: '${e["view_money"]}${CommonUtils.txt("jb")}',
                        style: GQStyle.yellow255_16_B)
                  ]))
                ],
              ));
        });
      });
      setState(() {});
    }
  }

  _byNvelChapter(id, replace, e) async {
    await nvelChapterBy(id: id).then((value) {
      if (value.status == 1) {
        AppGlobal.isAutoBy = true;
        e["is_pay"] = 1;
        context.push(
            CommonUtils.getRealHash()
                .replaceAll(RegExp(r"novelReader/.*"), 'novelReader/$id'),
            replace: replace,
            extra: widget.novelInfoData);
      } else {
        AppGlobal.isAutoBy = false;
        CommonUtils.showText(value.msg);
      }
    });
  }

  Widget _episdItem() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: GQStyle.pagePadding),
      child: Column(
        children: [
          Column(
            children: AppGlobal.blues.map((e) {
              var str = CommonUtils.txt("mf");
              TextStyle style;
              if (e["is_free"] == 0) {
                str = CommonUtils.txt("mf");
                style = TextStyle(
                    fontSize: ScreenUtil().setSp(14), color: Colors.green);
              } else if (e["is_free"] == 1) {
                str = CommonUtils.txt("vvp");
                style = TextStyle(
                    fontSize: ScreenUtil().setSp(14),
                    color: Color.fromRGBO(144, 61, 0, 1.0));
              } else if (e["is_free"] == 2 && e["is_pay"] == 1) {
                str = CommonUtils.txt("yyd");
                style = TextStyle(
                    fontSize: ScreenUtil().setSp(14),
                    color: Color.fromRGBO(102, 102, 102, 1.0));
              } else {
                str = "${e["view_money"]}${CommonUtils.txt("jb")}";
                style = TextStyle(
                    fontSize: ScreenUtil().setSp(14),
                    color: Color.fromRGBO(255, 77, 11, 1.0));
              }
              return Column(
                children: [
                  GestureDetector(
                      onTap: () {
                        context.pop();
                        swichNovel(e['id']);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: ScreenUtil().setWidth(20)),
                        height: ScreenUtil().setWidth(34),
                        decoration: BoxDecoration(
                            color: Color.fromRGBO(25, 25, 25, 1.0),
                            borderRadius:
                                BorderRadius.all(Radius.circular(2.5))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                                child: Text("${e["title"]}",
                                    style: GQStyle.gray180_15)),
                            SizedBox(width: ScreenUtil().setWidth(10)),
                            Container(
                              child: Text(str, style: style),
                            )
                          ],
                        ),
                      )),
                  SizedBox(height: ScreenUtil().setWidth(18))
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Future _itemAlertBottom() {
    return showModalBottomSheet(
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setBottomSheetState) {
            return Container(
              height: ScreenUtil().screenHeight * 0.8,
              color: Color.fromRGBO(0, 2, 9, 1.0),
              child: Column(
                children: [
                  Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: GQStyle.pagePadding),
                      height: ScreenUtil().setWidth(44),
                      color: Color.fromRGBO(25, 25, 25, 1.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(),
                          Text(CommonUtils.txt("mllb"),
                              style: GQStyle.white255_18),
                          GestureDetector(
                            onTap: () {
                              context.pop();
                            },
                            child: Text(
                              CommonUtils.txt("gb"),
                              style: GQStyle.white234_12,
                            ),
                          )
                        ],
                      )),
                  SizedBox(height: ScreenUtil().setWidth(17)),
                  Expanded(
                      child: SingleChildScrollView(
                    child: _episdItem(),
                    scrollDirection: Axis.vertical,
                  ))
                ],
              ),
            );
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromRGBO(0, 2, 9, 1.0),
      child: Stack(
        children: [
          novelReader == null
              ? PageStatus.loading(mounted)
              : GestureDetector(
                  onTap: () {
                    isShow = !isShow;
                    setState(() {});
                  },
                  child: DefaultTextStyle(
                      style: TextStyle(
                          fontSize: ScreenUtil().setSp(18),
                          color: Colors.white),
                      child: LayoutBuilder(
                          builder: (BuildContext context, BoxConstraints box) {
                        double widht = box.maxWidth - GQStyle.pagePadding * 2;
                        return Container(
                          padding: EdgeInsets.only(
                              left: GQStyle.pagePadding,
                              right: GQStyle.pagePadding,
                              top: MediaQuery.of(context).padding.top),
                          child: SingleChildScrollView(
                            controller: controller,
                            child: Html(
                              data: content,
                              style: {
                                "*": Style(
                                    color: Color(0xFF979797),
                                    width: widht,
                                    padding: EdgeInsets.all(0),
                                    margin: EdgeInsets.all(0),
                                    fontSize: FontSize(ScreenUtil().setSp(17)),
                                    lineHeight: LineHeight(1.5)),
                              },
                            ),
                          ),
                        );
                      })),
                ),
          Positioned(
              child: novelReader == null
                  ? Container()
                  : Stack(
                      children: [
                        Positioned(
                          top: 0,
                          right: 0,
                          bottom: 0,
                          left: 0,
                          child: Stack(
                            children: [
                              AnimatedPositioned(
                                  top: isShow
                                      ? 0
                                      : ScreenUtil().setWidth(-GQStyle
                                              .navbarHegiht -
                                          MediaQuery.of(context).padding.top),
                                  left: 0,
                                  right: 0,
                                  child: AnimatedOpacity(
                                    opacity: isShow ? 1 : 0,
                                    duration: durationTime,
                                    child: Container(
                                        height: GQStyle.navbarHegiht +
                                            MediaQuery.of(context).padding.top,
                                        padding: EdgeInsets.only(
                                          left: GQStyle.pagePadding,
                                          right: GQStyle.pagePadding,
                                          top: MediaQuery.of(context)
                                              .padding
                                              .top,
                                        ),
                                        decoration: BoxDecoration(
                                            color: Color.fromRGBO(
                                                25, 25, 25, 1.0)),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                context.pop();
                                              },
                                              child: LImage(
                                                "nav_back_n",
                                                width:
                                                    ScreenUtil().setWidth(22),
                                                height:
                                                    ScreenUtil().setWidth(22),
                                              ),
                                            ),
                                            SizedBox(
                                              height: ScreenUtil().setWidth(22),
                                              width: ScreenUtil().setWidth(300),
                                              child: RichText(
                                                text: TextSpan(
                                                    text: AppGlobal
                                                            .blues[cureentIndex]
                                                        ['title'],
                                                    style:
                                                        GQStyle.white255_16_M),
                                              ),
                                            ),
                                          ],
                                        )),
                                  ),
                                  duration: durationTime),
                              AnimatedPositioned(
                                  bottom: isShow
                                      ? -0.5
                                      : ScreenUtil().setWidth(-64),
                                  left: 0,
                                  right: 0,
                                  child: AnimatedOpacity(
                                    opacity: isShow ? 1 : 0,
                                    duration: durationTime,
                                    child: Container(
                                      height: ScreenUtil().setWidth(70),
                                      color: Color.fromRGBO(25, 25, 25, 1.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          GestureDetector(
                                            behavior:
                                                HitTestBehavior.translucent,
                                            onTap: () {
                                              if (cureentIndex == 0) {
                                                CommonUtils.showText(
                                                    CommonUtils.txt("yjdyz"));
                                              } else {
                                                swichNovel(
                                                    AppGlobal.blues[
                                                        cureentIndex - 1]['id'],
                                                    replace: true);
                                              }
                                            },
                                            child: menuItem(
                                                icon: 'episd_syh_n',
                                                text: CommonUtils.txt("syzng")),
                                          ),
                                          GestureDetector(
                                            behavior:
                                                HitTestBehavior.translucent,
                                            onTap: () {
                                              _itemAlertBottom();
                                            },
                                            child: menuItem(
                                                icon: 'episd_ml_n',
                                                text: CommonUtils.txt("ml")),
                                          ),
                                          GestureDetector(
                                            behavior:
                                                HitTestBehavior.translucent,
                                            onTap: () {
                                              if (cureentIndex ==
                                                  AppGlobal.blues.length - 1) {
                                                CommonUtils.showText(
                                                    CommonUtils.txt("yjzhyz"));
                                              } else {
                                                swichNovel(
                                                    AppGlobal.blues[
                                                        cureentIndex + 1]['id'],
                                                    replace: true);
                                              }
                                            },
                                            child: menuItem(
                                                icon: 'episd_xyh_n',
                                                text: CommonUtils.txt("xyzng")),
                                          ),
                                          // menuItem(icon: 'icon_novel_like', text: '立即收藏'),
                                        ],
                                      ),
                                    ),
                                  ),
                                  duration: durationTime)
                            ],
                          ),
                        )
                      ],
                    ))
        ],
      ),
    );
  }
}
