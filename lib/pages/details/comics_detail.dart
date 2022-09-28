import 'dart:convert';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/style.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qypj/base/baseWidget.dart';
import 'package:qypj/utils/extensionlibrary.dart';
import 'package:qypj/views/general_banner.dart';
import 'package:provider/provider.dart';
import 'package:qypj/components/card/newComicsCard.dart';
import 'package:qypj/components/page_status.dart';
import 'package:qypj/components/yy_dialog.dart';
import 'package:qypj/global.dart';
import 'package:qypj/model/comicsDetail.dart';
import 'package:qypj/pages/details/atlas_detail.dart';
import 'package:qypj/routers.dart';
import 'package:qypj/store/homeConfig.dart';
import 'package:qypj/theme/default.dart';
import 'package:qypj/utils/api.dart';
import 'package:qypj/utils/common.dart';
import 'package:qypj/utils/networkImage.dart';

class ComicsDetatl extends BaseWidget {
  ComicsDetatl({Key key, this.id}) : super(key: key);
  final int id;

  @override
  State<StatefulWidget> cState() {
    // TODO: implement cState
    return _ComicsDetatlState();
  }
}

class _ComicsDetatlState extends BaseWidgetState<ComicsDetatl> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool loading = true;
  int watchLog;
  Data data;
  List<String> newestSeries = [];
  int newestSeriesNum = 0;
  List recommendList = [];
  bool isFavorites = false;
  getPageData() {
    newestSeries.clear();
    getComicDetail(id: widget.id).then((res) {
      if (res.status != 0) {
        loading = false;
        AppGlobal.comicThumb = res.data.thumb;
        data = res.data;
        isFavorites = res.data.userFavorites == 1;
        watchLog = data.watchLog;
        newestSeriesNum = res.data.newestSeries;
        if (newestSeriesNum < 9 && newestSeriesNum > 0) {
          for (int x = 1; x <= newestSeriesNum; x++) {
            newestSeries.add(x.toString());
          }
        } else if (newestSeriesNum >= 9) {
          for (int x = 1; x < 5; x++) {
            newestSeries.add(x.toString());
          }
          for (int x = newestSeriesNum - 2; x <= newestSeriesNum; x++) {
            if (x == (newestSeriesNum - 2)) {
              newestSeries.add("・・・");
            }
            newestSeries.add(x.toString());
          }
        }
        comicsEpisode(book_id: data.dataId.toString()).then((value) {
          AppGlobal.blues = value.data;
          getRecommendComicsList(
                  limit: 10, id: widget.id, category: res.data.categories)
              .then((res) {
            recommendList = res.data;
            setState(() {});
          });
        });
      } else {
        CommonUtils.showText(res.msg);
        context.pop();
      }
    });
  }

  Widget _episdItem({bool isAll = false}) {
    List temp = [];
    if (!isAll) {
      if (AppGlobal.blues.length > 3) {
        temp = AppGlobal.blues.sublist(0, 3);
      } else {
        temp = AppGlobal.blues;
      }
    } else {
      temp = AppGlobal.blues;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: GQStyle.pagePadding),
      child: Column(
        children: [
          Column(
            children: temp.map((e) {
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
                      if (isAll) context.pop();
                      swichComic(e["episode"]);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: Color.fromRGBO(25, 25, 25, 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(2.5))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: ScreenUtil().setWidth(34 / 111 * 156),
                            width: ScreenUtil().setWidth(34),
                            child: PlatformAwareNetworkImage(
                                url: e["thumb"],
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(5),
                                    bottomLeft: Radius.circular(5)),
                                fit: BoxFit.fill),
                          ),
                          SizedBox(width: ScreenUtil().setWidth(16)),
                          Expanded(
                              child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                  child: Text(e["episode_title"],
                                      style: GQStyle.gray180_15)),
                              Spacer(),
                              Container(
                                child: Text(str, style: style),
                              ),
                              SizedBox(width: GQStyle.pagePadding)
                            ],
                          ))
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: ScreenUtil().setWidth(18))
                ],
              );
            }).toList(),
          ),
          SizedBox(height: ScreenUtil().setWidth(4)),
          isAll
              ? Container()
              : GestureDetector(
                  onTap: () {
                    _itemAlertBottom();
                  },
                  child: Container(
                    height: ScreenUtil().setWidth(34),
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(25, 25, 25, 1.0),
                        borderRadius: BorderRadius.all(Radius.circular(2.5))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        LImage("episd_ml_n",
                            width: ScreenUtil().setWidth(12),
                            height: ScreenUtil().setWidth(14)),
                        SizedBox(width: ScreenUtil().setWidth(6)),
                        Text(CommonUtils.txt("ckml"),
                            style: GQStyle.white255_14)
                      ],
                    ),
                  ),
                )
        ],
      ),
    );
  }

  // Widget selectItem(String value) {
  //   return GestureDetector(
  //     onTap: () {
  //       if (value != "・・・") {
  //         if (AppGlobal.vipLevel >= 2) {
  //           AppGlobal.currentReaderRouteExtra = {
  //             'id': data.dataId,
  //             'episode': value,
  //             'title': data.title,
  //             'allEpisode': data.newestSeries,
  //             'type': data.finished
  //           };
  //           context.push(CommonUtils.getRealHash('comicReader/$value'));
  //         } else {
  //           YyShowDialog.showdialog(
  //             context,
  //             title: CommonUtils.txt("ts"),
  //             content: (setDialogState) {
  //               return Text(
  //                 CommonUtils.txt("kthycd"),
  //                 style: TextStyle(
  //                     color: Color.fromRGBO(30, 30, 30, 1),
  //                     fontSize: ScreenUtil().setSp(14),
  //                     decoration: TextDecoration.none),
  //               );
  //             },
  //             cancelText: CommonUtils.txt("qx"),
  //             btnText: CommonUtils.txt("ljkt"),
  //             callBack: () {
  //               context.push('/${Routes.vip}');
  //             },
  //           );
  //         }
  //       } else {
  //         _itemAlertBottom();
  //       }
  //     },
  //     child: Container(
  //       width: ScreenUtil().setWidth(84),
  //       height: ScreenUtil().setWidth(34),
  //       decoration: BoxDecoration(
  //           color: value == watchLog.toString()
  //               ? Color.fromRGBO(255, 77, 11, 1.0)
  //               : Color.fromRGBO(25, 25, 25, 1.0),
  //           borderRadius: BorderRadius.circular(ScreenUtil().setWidth(2.5))),
  //       child: Center(
  //         child: Text(value, style: GQStyle.white234_15_M),
  //       ),
  //     ),
  //   );
  // }

  Future _itemAlertBottom() {
    // List<String> all =
    //     List.generate(data.newestSeries, (value) => (value + 1).toString());
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
                      color: Color.fromRGBO(25, 25, 25, 1.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: ScreenUtil().setWidth(15)),
                              SizedBox(
                                  width: ScreenUtil().screenWidth -
                                      ScreenUtil().setWidth(100),
                                  child: Text(data.title,
                                      style: GQStyle.white255_18_B)),
                              SizedBox(height: ScreenUtil().setWidth(9)),
                              Row(
                                children: [
                                  Text(
                                      data.status == 1
                                          ? CommonUtils.txt("ywj")
                                          : CommonUtils.txt("lz"),
                                      style: GQStyle.gray153_13),
                                  SizedBox(width: ScreenUtil().setWidth(10)),
                                  Text(
                                      '${CommonUtils.txt("gxz")}${data.newestSeries}${CommonUtils.txt("hua")}',
                                      style: GQStyle.gray153_13),
                                ],
                              ),
                              SizedBox(height: ScreenUtil().setWidth(16)),
                            ],
                          ),
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
                    child: _episdItem(isAll: true),
                    scrollDirection: Axis.vertical,
                  ))
                  // Expanded(
                  //     child: SingleChildScrollView(
                  //   padding: EdgeInsets.only(bottom: ScreenUtil().setWidth(20)),
                  //   child: Wrap(
                  //     spacing: ScreenUtil().setWidth(10),
                  //     runSpacing: ScreenUtil().setWidth(11.5),
                  //     children: all.map((e) {
                  //       return GestureDetector(
                  //         onTap: () {
                  //           context.pop();
                  //           swichComic(int.parse(e));
                  //         },
                  //         child: Container(
                  //           width: ScreenUtil().setWidth(110),
                  //           height: ScreenUtil().setWidth(38),
                  //           decoration: BoxDecoration(
                  //               borderRadius: BorderRadius.circular(2.5),
                  //               color: Color.fromRGBO(25, 25, 25, 1.0)),
                  //           child: Center(
                  //               child: Text(
                  //             "${CommonUtils.txt("di")}${e}${CommonUtils.txt("hua")}",
                  //             style: TextStyle(
                  //                 color: watchLog.toString() == e
                  //                     ? Color.fromRGBO(103, 102, 102, 1.0)
                  //                     : Colors.white,
                  //                 fontSize: ScreenUtil().setSp(15)),
                  //           )),
                  //         ),
                  //       );
                  //     }).toList(),
                  //   ),
                  // ))
                ],
              ),
            );
          });
        });
  }

  Widget _btnItem({String icon, String name}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        LImage(icon,
            width: ScreenUtil().setWidth(25),
            height: ScreenUtil().setWidth(25)),
        SizedBox(
          width: ScreenUtil().setWidth(7),
        ),
        Text(
          name,
          style: TextStyle(
              color: Color(0xff999999), fontSize: ScreenUtil().setSp(10)),
        )
      ],
    );
  }

  BackButtonBehavior backButtonBehavior = BackButtonBehavior.none;

  swichComic(int episode) {
    dynamic e =
        AppGlobal.blues.where((element) => element["episode"] == episode).first;

    if (e["is_pay"] == 1 || e["is_free"] == 0) {
      context.push(CommonUtils.getRealHash(
          'comicReader/${widget.id}/$episode/${data.title}'));
      return;
    }
    if (e["is_free"] == 1 && AppGlobal.vipLevel > 0) {
      context.push(CommonUtils.getRealHash(
          'comicReader/${widget.id}/$episode/${data.title}'));
      return;
    }
    if (e["is_free"] == 1 && AppGlobal.vipLevel < 1) {
      YyShowDialog.showdPNGDiaog(
        context,
        title: CommonUtils.txt("ts"),
        content: (setDialogState) {
          return Text(
            CommonUtils.txt("kthycd"),
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
      WidgetsBinding.instance.addPostFrameCallback((_) {
        int money =
            Provider.of<HomeConfig>(context, listen: false).member.money;
        bool isInsufficient = money < e["view_money"];
        YyShowDialog.showdialog(context,
            title:
                isInsufficient ? CommonUtils.txt("jbbz") : e["episode_title"],
            btnText: isInsufficient
                ? CommonUtils.txt("qwcz")
                : CommonUtils.txt("gmbzj"), callBack: () {
          if (isInsufficient) {
            context.push('/${Routes.coinRecharge}');
          } else {
            _byComicChapter(episode, e);
          }
        }, content: (setDialogState) {
          return DefaultTextStyle(
              style: GQStyle.gry30_14_M,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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

  _byComicChapter(int episode, dynamic e) async {
    await comicChapterBy(book_id: data.dataId, episode: episode).then((value) {
      if (value.status == 1) {
        e["is_pay"] = 1;
        context.push(CommonUtils.getRealHash(
            'comicReader/${widget.id}/$episode/${data.title}'));
      } else {
        CommonUtils.showText(value.msg);
      }
    });
  }

  List<Map> _getEvaluation() {
    return [
      {
        "bg": "good_lok_n",
        "title": CommonUtils.txt("hkyp"),
        "num": data.userAction["good_look"].toString()
      },
      {
        "bg": "good_lik_n",
        "title": CommonUtils.txt("bxz"),
        "num": data.userAction["must_awesome"].toString()
      },
      {
        "bg": "good_qp_n",
        "title": CommonUtils.txt("smg"),
        "num": data.userAction["what_awesome"].toString()
      },
      {
        "bg": "good_jj_n",
        "title": CommonUtils.txt("bhk"),
        "num": data.userAction["no_awesome"].toString()
      }
    ];
  }

  @override
  void onCreate() {
    // TODO: implement onCreate
    getPageData();
  }

  @override
  void onDestroy() {
    // TODO: implement onDestroy
    AppGlobal.blues = [];
    AppGlobal.isAutoBy = false;
  }

  @override
  Widget pageBody(BuildContext context) {
    // TODO: implement pageBody
    List tags = data == null ? [] : data.tags.split(',');
    return Container(
      child: Column(
        children: [
          Expanded(
              child: loading || data == null
                  ? PageStatus.loading(mounted)
                  : SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: GQStyle.pagePadding),
                              padding: EdgeInsets.all(GQStyle.pagePadding),
                              decoration: BoxDecoration(
                                  color: Color(0xFF191919),
                                  borderRadius: BorderRadius.circular(
                                      ScreenUtil().setWidth(10)),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black12,
                                        offset:
                                            Offset(0, ScreenUtil().setWidth(1)),
                                        blurRadius: ScreenUtil().setWidth(5))
                                  ]),
                              child: Row(children: [
                                Container(
                                    margin: EdgeInsets.only(
                                        right: ScreenUtil().setWidth(15)),
                                    height: ScreenUtil().setWidth(155.5),
                                    width: ScreenUtil().setWidth(110),
                                    child: Stack(children: [
                                      PlatformAwareNetworkImage(
                                          url: data.thumb,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5))),
                                      Positioned(
                                        right: 0,
                                        top: 0,
                                        child: CommonUtils.identiWget(
                                            data.toJson(),
                                            isHideCoin: true),
                                      )
                                    ])),
                                Expanded(
                                  child: Container(
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(data.title,
                                              style: GQStyle.white255_18_B),
                                          SizedBox(
                                              height:
                                                  ScreenUtil().setWidth(12)),
                                          Text(
                                              '${CommonUtils.txt("jj")}：${data.description ?? "loading"}',
                                              style: GQStyle.white254_12,
                                              maxLines: 3),
                                          SizedBox(
                                              height:
                                                  ScreenUtil().setWidth(24)),
                                          Row(children: [
                                            LImage("p_hot_n",
                                                width:
                                                    ScreenUtil().setWidth(11),
                                                height:
                                                    ScreenUtil().setWidth(12)),
                                            SizedBox(
                                                width:
                                                    ScreenUtil().setWidth(4)),
                                            Text(
                                                '${CommonUtils.renderFixedNumber(data.viewsCount)}${CommonUtils.txt("rq")}',
                                                style: GQStyle.gray206_12)
                                          ]),
                                          Row(children: [
                                            LImage("p_like_n",
                                                width:
                                                    ScreenUtil().setWidth(11),
                                                height:
                                                    ScreenUtil().setWidth(12)),
                                            SizedBox(
                                                width:
                                                    ScreenUtil().setWidth(4)),
                                            Text(
                                                '${CommonUtils.renderFixedNumber(data.likesCount)}${CommonUtils.txt("dz")}',
                                                style: GQStyle.gray206_12)
                                          ]),
                                        ]),
                                  ),
                                )
                              ])),
                          Padding(
                            padding: EdgeInsets.only(
                              left: GQStyle.pagePadding,
                              right: GQStyle.pagePadding,
                              top: ScreenUtil().setWidth(25),
                              bottom: ScreenUtil().setWidth(19),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      '${CommonUtils.txt("lz")}',
                                      style: GQStyle.white255_18_B,
                                    ),
                                    SizedBox(
                                      width: ScreenUtil().setWidth(8.5),
                                    ),
                                    Text(
                                      '${CommonUtils.txt("gxz")}$newestSeriesNum${CommonUtils.txt("hua")}',
                                      style: GQStyle.gray153_13,
                                    ),
                                  ],
                                ),
                                GestureDetector(
                                  onTap: () {
                                    _itemAlertBottom();
                                  },
                                  behavior: HitTestBehavior.translucent,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        CommonUtils.txt("qb"),
                                        style: GQStyle.white234_12,
                                      ),
                                      SizedBox(
                                        width: ScreenUtil().setWidth(8.5),
                                      ),
                                      LImage("all_arrow_n",
                                          width: ScreenUtil().setWidth(12),
                                          height: ScreenUtil().setWidth(12))
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                bottom: ScreenUtil().setWidth(45)),
                            child: _episdItem(),
                            // child: Wrap(
                            //   spacing: ScreenUtil().setWidth(3.5),
                            //   runSpacing: ScreenUtil().setWidth(4),
                            //   children:
                            //       newestSeries.map((e) => selectItem(e)).toList(),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: ScreenUtil().setWidth(30),
                                right: ScreenUtil().setWidth(30),
                                bottom: ScreenUtil().setWidth(15)),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: _getEvaluation()
                                    .map((e) => GestureDetector(
                                          onTap: () {
                                            if (['', null, false]
                                                .contains(AppGlobal.apiToken)) {
                                              CommonUtils.showText(
                                                  CommonUtils.txt("zcyhcz"));
                                              return;
                                            }

                                            if (e["bg"] == "good_lok_n") {
                                              getComicEvaluation(
                                                      id: data.dataId,
                                                      evaluation: "good_look")
                                                  .then((res) {
                                                if (res.status == 1) {
                                                  data.userAction["good_look"] =
                                                      data.userAction[
                                                              "good_look"] +
                                                          1;
                                                  setState(() {});
                                                } else {
                                                  CommonUtils.showText(res.msg);
                                                }
                                              });
                                            }
                                            if (e["bg"] == "good_lik_n") {
                                              getComicEvaluation(
                                                      id: data.dataId,
                                                      evaluation:
                                                          "must_awesome")
                                                  .then((res) {
                                                if (res.status == 1) {
                                                  data.userAction[
                                                          "must_awesome"] =
                                                      data.userAction[
                                                              "must_awesome"] +
                                                          1;
                                                  setState(() {});
                                                } else {
                                                  CommonUtils.showText(res.msg);
                                                }
                                              });
                                            }
                                            if (e["bg"] == "good_qp_n") {
                                              getComicEvaluation(
                                                      id: data.dataId,
                                                      evaluation:
                                                          "what_awesome")
                                                  .then((res) {
                                                if (res.status == 1) {
                                                  data.userAction[
                                                          "what_awesome"] =
                                                      data.userAction[
                                                              "what_awesome"] +
                                                          1;
                                                  setState(() {});
                                                } else {
                                                  CommonUtils.showText(res.msg);
                                                }
                                              });
                                            }
                                            if (e["bg"] == "good_jj_n") {
                                              getComicEvaluation(
                                                      id: data.dataId,
                                                      evaluation: "no_awesome")
                                                  .then((res) {
                                                if (res.status == 1) {
                                                  data.userAction[
                                                          "no_awesome"] =
                                                      data.userAction[
                                                              "no_awesome"] +
                                                          1;
                                                  setState(() {});
                                                } else {
                                                  CommonUtils.showText(res.msg);
                                                }
                                              });
                                            }
                                          },
                                          child: Column(
                                            children: [
                                              LImage(e["bg"],
                                                  width:
                                                      ScreenUtil().setWidth(55),
                                                  height: ScreenUtil()
                                                      .setWidth(55)),
                                              SizedBox(
                                                  height:
                                                      ScreenUtil().setWidth(8)),
                                              Text(e["title"],
                                                  style: GQStyle.white255_13),
                                              SizedBox(
                                                  height: ScreenUtil()
                                                      .setWidth(13)),
                                              Text(
                                                  "${e["num"]}${CommonUtils.txt("ren")}",
                                                  style: GQStyle.gray102_13),
                                            ],
                                          ),
                                        ))
                                    .toList()),
                          ),
                          data.ads == null
                              ? Container()
                              : Padding(
                                  padding: EdgeInsets.only(
                                      right: GQStyle.pagePadding,
                                      left: GQStyle.pagePadding,
                                      bottom: ScreenUtil().setWidth(10)),
                                  child: GeneralBanner(
                                    data: data.ads,
                                    // height: 107,
                                    height:
                                        (ScreenUtil().setWidth(350) * 300 / 700)
                                            .ceil(),

                                    radius: 5.0,
                                  ),
                                ),
                          Padding(
                            padding: EdgeInsets.only(
                                right: GQStyle.pagePadding,
                                left: GQStyle.pagePadding,
                                bottom: ScreenUtil().setWidth(15)),
                            child: Text(
                              CommonUtils.txt("jctj"),
                              style: GQStyle.white255_18_B,
                            ),
                          ),
                          Padding(
                              padding: EdgeInsets.only(
                                  right: GQStyle.pagePadding,
                                  left: GQStyle.pagePadding),
                              child: recommendList.length == 0
                                  ? Padding(
                                      padding: EdgeInsets.only(
                                        bottom: ScreenUtil().setWidth(150),
                                      ),
                                      child: PageStatus.noData(
                                          text: CommonUtils.txt("mymhy")),
                                    )
                                  : Column(
                                      children: recommendList
                                          .asMap()
                                          .keys
                                          .map((e) => NewComicsCard(
                                                relace: true,
                                                cardData: recommendList[e],
                                              ))
                                          .toList(),
                                    ))
                        ],
                      ),
                    )),
          loading || data == null
              ? Container()
              : Container(
                  padding: EdgeInsets.only(left: ScreenUtil().setWidth(34)),
                  margin: EdgeInsets.only(
                      bottom: kIsWeb ? 0 : ScreenUtil().bottomBarHeight),
                  height: ScreenUtil().setWidth(50.5),
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          userFavorites(type: 2, id: data.dataId).then((res) {
                            if (res != null && res.status != 0) {
                              isFavorites = !isFavorites;
                              setState(() {});
                            } else {
                              CommonUtils.showText(res.msg);
                            }
                          });
                        },
                        child: _btnItem(
                          icon: isFavorites ? 'gen_like_n' : 'gen_unlike_n',
                          name: CommonUtils.txt("sc"),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          context.push(
                              CommonUtils.getRealHash('kwantsharetousers'));
                        },
                        child: _btnItem(
                            icon: 'gen_share_n', name: CommonUtils.txt("fx")),
                      ),
                      GestureDetector(
                        onTap: () {
                          swichComic(data.watchLog == 0 ? 1 : data.watchLog);
                        },
                        child: Container(
                          width: ScreenUtil().setWidth(153),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color(0xfff36f65),
                                Color(0xffff4d0b),
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              data.watchLog == 0
                                  ? CommonUtils.txt("ksyd")
                                  : '${CommonUtils.txt("jxyd")} ${CommonUtils.txt("di")}${data.watchLog}${CommonUtils.txt("hua")}',
                              style: GQStyle.white255_15,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                )
        ],
      ),
      color: GQStyle.bgColor,
    );
  }
}
