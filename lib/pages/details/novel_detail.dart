import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qypj/base/baseWidget.dart';
import 'package:qypj/utils/extensionlibrary.dart';
import 'package:qypj/views/general_banner.dart';
import 'package:provider/provider.dart';
import 'package:qypj/components/page_status.dart';
import 'package:qypj/components/yy_dialog.dart';
import 'package:qypj/global.dart';
import 'package:qypj/pages/details/atlas_detail.dart';
import 'package:qypj/routers.dart';
import 'package:qypj/store/homeConfig.dart';
import 'package:qypj/theme/default.dart';
import 'package:qypj/utils/api.dart';
import 'package:qypj/utils/common.dart';
import 'package:qypj/utils/networkImage.dart';

class NovelDetail extends BaseWidget {
  NovelDetail({Key key, this.id}) : super(key: key);
  final dynamic id;

  @override
  State<StatefulWidget> cState() {
    // TODO: implement cState
    return _NovelDetailState();
  }
}

class _NovelDetailState extends BaseWidgetState<NovelDetail> {
  Map novelDetail;
  bool isLike = false;
  // List seriesesList = [];
  int cureentIndex = -1;
  int money = 0;
  List recommendList = [];
  bool isLook = false;
  double _w = (ScreenUtil().screenWidth -
          GQStyle.pagePadding * 2 -
          ScreenUtil().setWidth(20)) /
      3;

  getCureentIndex() async {
    var box = AppGlobal.bookWatchRecordBox.get(novelDetail['id']);
    if (box == null || box[novelDetail['id']] == null) return;
    var index = box['current'].toInt();
    cureentIndex = index;
    isLook = true;
    setState(() {});
  }

  @override
  void onCreate() {
    getBookDetail(id: widget.id).then((res) {
      CommonUtils.debugPrint(res);
      if (res['status'] != 0) {
        novelDetail = res['data'];
        isLike = novelDetail['userFavorites'] == 1;
        recommendList = novelDetail['recommendList'];
        nvelEpisode(id: widget.id.toString()).then((value) {
          AppGlobal.blues = value.data['serieses'];
          getCureentIndex();
          setState(() {});
        });
        // getBookRecommendList(limit: 15, page: 1, type: 1).then((res) {
        //   if (res['status'] != 0) {
        //     recommendList = res['data'] == null ? [] : res['data'];
        //   }
        // });
      } else {
        context.pop();
        CommonUtils.showText(res['msg']);
      }
    });
  }

  Widget _btnItem({String icon, String name}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        LImage(
          icon,
          width: ScreenUtil().setWidth(25),
          height: ScreenUtil().setWidth(25),
        ),
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

  swichNovel(id) {
    dynamic e = AppGlobal.blues.where((element) => element["id"] == id).first;
    CommonUtils.debugPrint(e);
    if (e["is_pay"] == 1 || e["is_free"] == 0) {
      context.push(CommonUtils.getRealHash('novelReader/$id'),
          extra: novelDetail);
      return;
    }
    if (e["is_free"] == 1 && AppGlobal.vipLevel > 0) {
      context.push(CommonUtils.getRealHash('novelReader/$id'),
          extra: novelDetail);
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
            _byNvelChapter(id, e);
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

  _byNvelChapter(id, e) async {
    await nvelChapterBy(id: id).then((value) {
      if (value.status == 1) {
        e["is_pay"] = 1;
        context.push(CommonUtils.getRealHash('novelReader/$id'),
            extra: novelDetail);
      } else {
        CommonUtils.showText(value.msg);
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
                                  child: Text(novelDetail['title'] ?? 'loading',
                                      style: GQStyle.white255_18_B)),
                              SizedBox(height: ScreenUtil().setWidth(9)),
                              Row(
                                children: [
                                  Text(
                                      novelDetail['status'] == 1
                                          ? CommonUtils.txt("ywj")
                                          : CommonUtils.txt("lz"),
                                      style: GQStyle.gray153_13),
                                  SizedBox(width: ScreenUtil().setWidth(10)),
                                  Text(
                                      '${CommonUtils.txt("gxz")}${AppGlobal.blues.length}${CommonUtils.txt("zang")}',
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
                ],
              ),
            );
          });
        });
  }

  List<Map> _getEvaluation() {
    return [
      {
        "bg": "good_lok_n",
        "title": CommonUtils.txt("hkyp"),
        "num": novelDetail["userAction"]["good_look"].toString()
      },
      {
        "bg": "good_lik_n",
        "title": CommonUtils.txt("bxz"),
        "num": novelDetail["userAction"]["must_awesome"].toString()
      },
      {
        "bg": "good_qp_n",
        "title": CommonUtils.txt("smg"),
        "num": novelDetail["userAction"]["what_awesome"].toString()
      },
      {
        "bg": "good_jj_n",
        "title": CommonUtils.txt("bhk"),
        "num": novelDetail["userAction"]["no_awesome"].toString()
      }
    ];
  }

  @override
  Widget pageBody(BuildContext context) {
    List tags = novelDetail == null ||
            novelDetail['tags'] == '' ||
            novelDetail['tags'] == null
        ? []
        : novelDetail['tags'].split(',');
    if (tags.length > 3) {
      tags = tags.sublist(0, 2);
    }
    return Column(
      children: [
        Expanded(
            child: novelDetail == null
                ? PageStatus.loading(mounted)
                : SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Container(
                            width: ScreenUtil().setWidth(350),
                            height: ScreenUtil().setWidth(185.5),
                            padding:
                                EdgeInsets.all(ScreenUtil().setWidth(13.5)),
                            decoration: BoxDecoration(
                                color: Color.fromRGBO(25, 25, 25, 1.0),
                                borderRadius: BorderRadius.circular(
                                    ScreenUtil().setWidth(10)),
                                boxShadow: [
                                  BoxShadow(
                                      color: Color.fromRGBO(0, 0, 0, 0.05),
                                      offset:
                                          Offset(0, ScreenUtil().setWidth(1)),
                                      blurRadius: ScreenUtil().setWidth(5))
                                ]),
                            child: Row(
                              children: [
                                Container(
                                  height: double.infinity,
                                  width: ScreenUtil().setWidth(110),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                        ScreenUtil().setWidth(10)),
                                    child: PlatformAwareNetworkImage(
                                        fit: BoxFit.fitHeight,
                                        url: novelDetail['thumb']),
                                  ),
                                ),
                                SizedBox(
                                  width: ScreenUtil().setWidth(14.5),
                                ),
                                Expanded(
                                    child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      novelDetail['title'] ?? 'loading',
                                      style: GQStyle.white255_18_B,
                                    ),
                                    SizedBox(height: ScreenUtil().setWidth(4)),
                                    Text(
                                      '${CommonUtils.txt("zuoz")}：${novelDetail['author'] ?? 'loading'}',
                                      style: GQStyle.yellow255_12,
                                    ),
                                    SizedBox(height: ScreenUtil().setWidth(5)),
                                    Wrap(
                                        spacing: ScreenUtil().setWidth(4),
                                        runSpacing: ScreenUtil().setWidth(4),
                                        children: tags
                                            .asMap()
                                            .keys
                                            .map((e) => YyTap(text: tags[e]))
                                            .toList()),
                                    SizedBox(height: ScreenUtil().setWidth(7)),
                                    Text(
                                      '${novelDetail['views_count'] ?? '0'}${CommonUtils.txt("ryd")}',
                                      style: GQStyle.gray198_13,
                                    ),
                                    SizedBox(height: ScreenUtil().setWidth(7)),
                                    Text(
                                      novelDetail['desc'] ?? 'loading',
                                      style: GQStyle.gray102_12,
                                      maxLines: 3,
                                    ),
                                  ],
                                ))
                              ],
                            ),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: GQStyle.pagePadding,
                                  vertical: ScreenUtil().setWidth(16)),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        CommonUtils.txt("zxzj"),
                                        style: GQStyle.white255_18_B,
                                      ),
                                      SizedBox(
                                        width: ScreenUtil().setWidth(8.5),
                                      ),
                                      Text(
                                        '${CommonUtils.txt("gxz")}${AppGlobal.blues.length}${CommonUtils.txt("zang")}',
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
                                  bottom: ScreenUtil().setWidth(30)),
                              child: _episdItem(),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: ScreenUtil().setWidth(30),
                                  right: ScreenUtil().setWidth(30),
                                  bottom: ScreenUtil().setWidth(25)),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: _getEvaluation()
                                      .map((e) => GestureDetector(
                                            onTap: () {
                                              if ([
                                                '',
                                                null,
                                                false
                                              ].contains(AppGlobal.apiToken)) {
                                                CommonUtils.showText(
                                                    CommonUtils.txt("zcyhcz"));
                                                return;
                                              }
                                              if (e["bg"] == "good_lok_n") {
                                                getNvelEvaluation(
                                                        id: novelDetail["id"],
                                                        evaluation: "good_look")
                                                    .then((res) {
                                                  if (res.status == 1) {
                                                    novelDetail["userAction"]
                                                            ["good_look"] =
                                                        novelDetail["userAction"]
                                                                ["good_look"] +
                                                            1;
                                                    setState(() {});
                                                  } else {
                                                    CommonUtils.showText(
                                                        res.msg);
                                                  }
                                                });
                                              }
                                              if (e["bg"] == "good_lik_n") {
                                                getNvelEvaluation(
                                                        id: novelDetail["id"],
                                                        evaluation:
                                                            "must_awesome")
                                                    .then((res) {
                                                  if (res.status == 1) {
                                                    novelDetail["userAction"]
                                                            ["must_awesome"] =
                                                        novelDetail["userAction"]
                                                                [
                                                                "must_awesome"] +
                                                            1;
                                                    setState(() {});
                                                  } else {
                                                    CommonUtils.showText(
                                                        res.msg);
                                                  }
                                                });
                                              }
                                              if (e["bg"] == "good_qp_n") {
                                                getNvelEvaluation(
                                                        id: novelDetail["id"],
                                                        evaluation:
                                                            "what_awesome")
                                                    .then((res) {
                                                  if (res.status == 1) {
                                                    novelDetail["userAction"]
                                                            ["what_awesome"] =
                                                        novelDetail["userAction"]
                                                                [
                                                                "what_awesome"] +
                                                            1;
                                                    setState(() {});
                                                  } else {
                                                    CommonUtils.showText(
                                                        res.msg);
                                                  }
                                                });
                                              }
                                              if (e["bg"] == "good_jj_n") {
                                                getNvelEvaluation(
                                                        id: novelDetail["id"],
                                                        evaluation:
                                                            "no_awesome")
                                                    .then((res) {
                                                  if (res.status == 1) {
                                                    novelDetail["userAction"]
                                                            ["no_awesome"] =
                                                        novelDetail["userAction"]
                                                                ["no_awesome"] +
                                                            1;
                                                    setState(() {});
                                                  } else {
                                                    CommonUtils.showText(
                                                        res.msg);
                                                  }
                                                });
                                              }
                                            },
                                            child: Column(
                                              children: [
                                                LImage(e["bg"],
                                                    width: ScreenUtil()
                                                        .setWidth(55),
                                                    height: ScreenUtil()
                                                        .setWidth(55)),
                                                SizedBox(
                                                    height: ScreenUtil()
                                                        .setWidth(8)),
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
                            novelDetail["banner"] == null ||
                                    novelDetail["banner"].length == 0
                                ? Container()
                                : Padding(
                                    padding: EdgeInsets.only(
                                        right: GQStyle.pagePadding,
                                        left: GQStyle.pagePadding,
                                        bottom: ScreenUtil().setWidth(25)),
                                    child: GeneralBanner(
                                      data: (novelDetail["banner"]
                                          as List<dynamic>),
                                      // height: 107,
                                      height: (ScreenUtil().setWidth(350) *
                                              300 /
                                              700)
                                          .ceil(),
                                      radius: 5.0,
                                    ),
                                  ),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: GQStyle.pagePadding,
                                  right: GQStyle.pagePadding,
                                  bottom: ScreenUtil().setWidth(15)),
                              child: Text(
                                CommonUtils.txt("zptj"),
                                style: GQStyle.white255_18_B,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: GQStyle.pagePadding,
                                  right: GQStyle.pagePadding,
                                  bottom: ScreenUtil().setWidth(10)),
                              child: recommendList.length == 0
                                  ? PageStatus.noData()
                                  : GridView.count(
                                      padding: EdgeInsets.zero,
                                      shrinkWrap: true,
                                      crossAxisCount: 3,
                                      mainAxisSpacing:
                                          ScreenUtil().setWidth(10),
                                      crossAxisSpacing:
                                          ScreenUtil().setWidth(10),
                                      childAspectRatio: 110 / 194,
                                      scrollDirection: Axis.vertical,
                                      physics: NeverScrollableScrollPhysics(),
                                      children: recommendList
                                          .map((e) => GestureDetector(
                                                onTap: () {
                                                  context.push(
                                                      CommonUtils.getRealHash()
                                                          .replaceAll(
                                                              RegExp(
                                                                  r"novelDetail/.*"),
                                                              'novelDetail/${e["id"] ?? "0"}'),
                                                      replace: true);
                                                },
                                                child: Stack(children: [
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      SizedBox(
                                                        height: _w / 110 * 147,
                                                        child: PlatformAwareNetworkImage(
                                                            url: clipImageUrl(
                                                                CommonUtils
                                                                    .getThumb(
                                                                        e),
                                                                inputWidth:
                                                                    ScreenUtil()
                                                                        .setWidth(
                                                                            110)),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            5))),
                                                      ),
                                                      SizedBox(
                                                          height: ScreenUtil()
                                                              .setWidth(3.5)),
                                                      Text(
                                                          e["title"] ??
                                                              "loading",
                                                          style: GQStyle
                                                              .white255_14),
                                                      SizedBox(
                                                          height: ScreenUtil()
                                                              .setWidth(3.5)),
                                                      Text(
                                                        e["finished"] == 1
                                                            ? "${CommonUtils.txt("wj")} ${CommonUtils.txt("gng")}${e["series"]}${CommonUtils.txt("hua")}"
                                                            : "${CommonUtils.txt("gxz")}${e["series"]}${CommonUtils.txt("hua")}",
                                                        style:
                                                            GQStyle.gray128_11,
                                                      )
                                                    ],
                                                  ),
                                                  Positioned(
                                                      right: 0,
                                                      top: 0,
                                                      child: CommonUtils
                                                          .identiWget(e,
                                                              isHideCoin: true))
                                                ]),
                                              ))
                                          .toList(),
                                    ),
                            )
                          ],
                        ),
                      ],
                    ),
                  )),
        Container(
          padding: EdgeInsets.only(left: ScreenUtil().setWidth(34)),
          height: ScreenUtil().setWidth(50.5),
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  userFavorites(type: 3, id: novelDetail['id']).then((res) {
                    if (res != null && res.status != 0) {
                      isLike = !isLike;
                      setState(() {});
                    } else {
                      CommonUtils.showText(res.msg);
                    }
                  });
                },
                child: _btnItem(
                  icon: isLike ? 'gen_like_n' : 'gen_unlike_n',
                  name: isLike ? CommonUtils.txt("ysc") : CommonUtils.txt("sc"),
                ),
              ),
              GestureDetector(
                onTap: () {
                  context.push(CommonUtils.getRealHash('kwantsharetousers'));
                },
                child:
                    _btnItem(icon: 'gen_share_n', name: CommonUtils.txt("fx")),
              ),
              GestureDetector(
                onTap: () {
                  swichNovel(isLook
                      ? AppGlobal.blues[cureentIndex]['id']
                      : AppGlobal.blues[0]['id']);
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
                      isLook
                          ? CommonUtils.txt("jxyd")
                          : CommonUtils.txt("ksyd"),
                      style: GQStyle.white255_14_M,
                    ),
                  ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  @override
  void onDestroy() {
    // TODO: implement onDestroy
    AppGlobal.blues = [];
    AppGlobal.isAutoBy = false;
  }
}

class Seiyuu extends StatefulWidget {
  Seiyuu({Key key, this.thumbUrl, this.name}) : super(key: key);
  String thumbUrl;
  String name;
  @override
  _SeiyuuState createState() => _SeiyuuState();
}

class _SeiyuuState extends State<Seiyuu> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          margin: EdgeInsets.only(right: ScreenUtil().setWidth(9)),
          width: ScreenUtil().setWidth(25),
          height: ScreenUtil().setWidth(25),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(ScreenUtil().setWidth(12.5)),
            child: PlatformAwareNetworkImage(url: widget.thumbUrl),
          ),
        ),
        Text(
          widget.name,
          style: GQStyle.gray14,
        )
      ],
    );
  }
}
