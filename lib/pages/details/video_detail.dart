import 'dart:async';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qypj/components/updateModel.dart';
import 'package:qypj/model/basic.dart';
import 'package:qypj/model/homedata.dart';
import 'package:qypj/model/videolist.dart';
import 'package:qypj/pages/cartoon/cartoon_review.dart';
import 'package:qypj/pages/details/video_comment_page.dart';
import 'package:qypj/utils/app_route_observer.dart';
import 'package:qypj/utils/extensionlibrary.dart';
import 'package:qypj/utils/flick_video_normal.dart';
import 'package:qypj/utils/pageviewmixin.dart';
import 'package:qypj/views/general_banner.dart';
import 'package:qypj/views/yyq/cards/ad_double_colume_card.dart';
import 'package:qypj/views/yyq/cards/ad_single_colume_card.dart';
import 'package:qypj/views/yyq/cards/video_single_colume_card.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:qypj/components/page_status.dart';
import 'package:qypj/components/yy_dialog.dart';
import 'package:qypj/global.dart';
import 'package:qypj/model/animationDetail.dart';
import 'package:qypj/routers.dart';
import 'package:qypj/store/homeConfig.dart';
import 'package:qypj/theme/default.dart';
import 'package:qypj/utils/api.dart';
import 'package:qypj/utils/common.dart';
import 'package:qypj/utils/networkImage.dart';
import 'package:qypj/utils/download_video.dart';
import 'package:flutter/foundation.dart';
import 'package:qypj/views/yyq/cards/video_double_colume_card.dart';
//ijk
import 'package:fijkplayer/fijkplayer.dart';
import 'package:qypj/ijktool/fijkplayer_skin.dart';

// 这里实现一个皮肤显示配置项
class PlayerShowConfig implements ShowConfigAbs {
  @override
  bool speedBtn = true;
  @override
  bool topBar = true;
  @override
  bool lockBtn = true;
  @override
  bool bottomPro = true;
  @override
  bool stateAuto = true;
  @override
  bool isAutoPlay = true;
}

class VideoDetail extends StatefulWidget {
  VideoDetail({Key key, this.id}) : super(key: key);
  final dynamic id;

  @override
  _VideoDetailState createState() => _VideoDetailState();
}

class _VideoDetailState extends State<VideoDetail> {
  // FijkPlayer实例
  FijkPlayer player = FijkPlayer();
  ShowConfigAbs vCfg = PlayerShowConfig();

  BackButtonBehavior backButtonBehavior = BackButtonBehavior.none;
  PageController controller = PageController();
  DetailData videoInfo;
  bool isFavorites = false;
  List<dynamic> recommendList = [];
  List<dynamic> recommendDataList = [];

  List tags = [];
  List<dynamic> banner = [];
  List<dynamic> course = [];
  int courseIndex = 0;

  int showIndex = 0; // 简介 评论
  PageController _pageController = PageController();

  // void _incrementCounter() {
  //   _secondsCounter.value += 1;
  // }

  // final ValueNotifier<int> _secondsCounter = ValueNotifier<int>(0);

  // Widget _buildWithValue(BuildContext context, int value, Widget child) {
  //   return Text(_dealTimeToString(), style: GQStyle.white255_11);
  //   return Text(
  //     '$value',
  //     style: Theme.of(context).textTheme.headline4,
  //   );
  // }

  Member member;

  // 活动弹窗
  void showActivetyDialog(Notice notice) {
    UpdateModel.showAvtivetysDialog(backButtonBehavior,
        notice: notice, cancel: () {}, confirm: () {
      _onTapSwiper(notice);
    });
  }

  _onTapSwiper(Notice notice) {
    reqAdClickCount(id: notice.report_id, type: notice.report_type);
    if (notice.type == "route") {
      String linkUrl = notice.url_str;
      List urlList = linkUrl.split('??');
      Map<String, dynamic> pramas = {};
      if (urlList.first == "ktloadwebview") {
        pramas["url"] = urlList.last.toString().substring(4);
        AppGlobal.webExtra = {"url": pramas.values.first};
        if (kIsWeb) {
          CommonUtils.launchURL(
              Uri.decodeComponent(pramas.values.first.trim()));
        } else {
          context.push("/${urlList[0]}");
        }
      } else {
        if (urlList.length > 1 && urlList.last != "") {
          urlList[1].split("&").forEach((item) {
            List stringText = item.split('=');
            pramas[stringText[0]] =
                stringText.length > 1 ? stringText[1] : null;
          });
        }
        String pramasStrs = "";
        if (pramas.values.length > 0) {
          pramas.forEach((key, value) {
            pramasStrs += "/${value}";
          });
        }
        context.push("/${urlList[0]}${pramasStrs}");
      }
    } else {
      CommonUtils.launchURL(notice.url_str.trim());
    }
  }

  initVideoPage() {
    try {
      getVideoDetail(id: widget.id).then((res) {
        if (res.status != 0) {
          banner = res.data.banner;
          isFavorites = res.data.detail.userFavorites == 1;
          tags = res.data.detail.tags == '' || res.data.detail.tags == null
              ? []
              : res.data.detail.tags.split(',');
          videoInfo = res.data.detail;
          if (res.data.detail.topic != null) {
            course = res.data.detail.topic["series"];
            courseIndex = course.indexWhere((element) =>
                element["related_id"].toString() == widget.id.toString());
          }
          getDetailRecommendList(id: widget.id).then((recommend) {
            if (recommend.status != 0) {
              recommendList = recommend.data;
            }
            setState(() {});
            if (res.data.ad_pops != null) {
              showActivetyDialog(res.data.ad_pops);
            }
          });
        } else {
          CommonUtils.showText(res.msg);
          context.pop();
        }
      });
    } catch (e) {
      print(e);
    }
  }

  // _getCommentData() {
  //   cartoonListCommentMv(id: widget.id, last_ix: '', page: page)
  //       .then((res) {
  //     if (res.data == null) {
  //       networkErr = true;
  //       setState(() {});
  //       return;
  //     }
  //     List st = res.data["list"];
  //     last_ix = res.data["last_ix"] == null ? "" : res.data["last_ix"];
  //     if (page == 1) {
  //       noMore = false;
  //       _comentsList = st;
  //     } else if (st.length > 0) {
  //       _comentsList.addAll(st);
  //     } else {
  //       noMore = true;
  //     }
  //     isHud = false;
  //     setState(() {});
  //   });
  // }

  bool isClickCourse = true;
  final GlobalKey<FlickVideoNormalState> _globalKey = GlobalKey();
  _getCourse(String id) {
    CommonUtils.startLoadGIF(tip: CommonUtils.txt("jzz"));
    getVideoDetail(id: id).then((res) {
      BotToast.closeAllLoading();
      if (res.status != 0) {
        banner = res.data.banner;
        course = res.data.detail.topic["series"];
        isFavorites = res.data.detail.userFavorites == 1;
        tags = res.data.detail.tags == '' || res.data.detail.tags == null
            ? []
            : res.data.detail.tags.split(',');
        videoInfo = res.data.detail;
        setState(() {}); //刷新当前界面并切换播放链接
        _globalKey.currentState.initChangeURL(videoInfo);
        Future.delayed(Duration(seconds: 3), () {
          isClickCourse = true;
        });
      } else {
        CommonUtils.showText(res.msg);
      }
    });
  }

  @override
  void initState() {
    super.initState();

    member = Provider.of<HomeConfig>(context, listen: false).member;
    if (member.new_user && AppGlobal.vipLevel < 1) {
      // _countDown();
    }
    initVideoPage();
  }

  @override
  void dispose() async {
    controller?.dispose();
    // _secondsCounter.dispose();
    // _cancelTimer();
    /// 取消路由订阅
    if (!kIsWeb) player.release();
    super.dispose();
  }

  Widget _btnItem({String icon, String name, Color color}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        LImage(
          icon,
          width: ScreenUtil().setWidth(25),
          fit: BoxFit.fitWidth,
        ),
        SizedBox(
          width: ScreenUtil().setWidth(7),
        ),
        Text(
          name,
          style: TextStyle(
              color: color != null ? color : Color.fromRGBO(153, 153, 153, 1),
              fontSize: ScreenUtil().setSp(13),
              fontFamily: GQStyle.hanyi,
              fontWeight: FontWeight.w500),
        )
      ],
    );
  }

  List<Map> _getEvaluation() {
    return [
      {
        "bg": "good_lok_n",
        "title": CommonUtils.txt("hkyp"),
        "num": videoInfo.userAction["good_look"].toString()
      },
      {
        "bg": "good_lik_n",
        "title": CommonUtils.txt("bxz"),
        "num": videoInfo.userAction["must_awesome"].toString()
      },
      {
        "bg": "good_qp_n",
        "title": CommonUtils.txt("smg"),
        "num": videoInfo.userAction["what_awesome"].toString()
      },
      {
        "bg": "good_jj_n",
        "title": CommonUtils.txt("bhk"),
        "num": videoInfo.userAction["no_awesome"].toString()
      }
    ];
  }

  // int _seconds = 0;
  // Timer _timer;
  // _countDown() {
  //   var now = DateTime.now();
  //   var diff = DateTime.parse(
  //       "${now.year}-${now.month < 10 ? "0${now.month}" : now.month}-${now.day < 10 ? "0${now.day}" : now.day} 24:00:00");
  //   var twoHours = diff.difference(now);
  //   _seconds = twoHours.inSeconds;
  //   _startTimer();
  // }

  // String _dealTimeToString() {
  //   int hour = _seconds ~/ 3600;
  //   int minute = _seconds % 3600 ~/ 60;
  //   int second = _seconds % 60;
  //   return CommonUtils.txt('xsyt') +
  //       " ${hour < 10 ? "0$hour" : hour}:${minute < 10 ? "0$minute" : minute}:${second < 10 ? "0$second" : second}";
  // }

  // _startTimer() {
  //   _timer = Timer.periodic(Duration(seconds: 1), (timer) {
  //     _seconds--;
  //     // setState(() {}); // 这个一直刷新 不行 换一个

  //     _secondsCounter.value += 1;
  //     if (_seconds == 0) {
  //       _cancelTimer();
  //     }
  //   });
  // }

  // _cancelTimer() {
  //   if (_timer != null) {
  //     _timer.cancel();
  //     _timer = null;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    double _w = (ScreenUtil().screenWidth -
            GQStyle.pagePadding * 2 -
            ScreenUtil().setWidth(4)) /
        2;
    return Scaffold(
      backgroundColor: GQStyle.bgColor,
      floatingActionButton: GestureDetector(
        onTap: () {
          context.pop();
        },
        child: Container(
          margin: EdgeInsets.only(bottom: ScreenUtil().setWidth(40)),
          height: ScreenUtil().setWidth(40),
          width: ScreenUtil().setWidth(40),
          decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF00d2be), Color(0xFF6496fc)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius:
                  BorderRadius.all(Radius.circular(ScreenUtil().setWidth(20)))),
          child: Center(
            child: Text(
              CommonUtils.txt("fahui"),
              style: GQStyle.white255_13_M,
            ),
          ),
        ),
      ),
      body: videoInfo == null
          ? PageStatus.loading(mounted)
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  //预留状态栏
                  height: MediaQuery.of(context).padding.top,
                  color: Colors.black,
                ),
                Container(
                  height: ScreenUtil().screenWidth * 9 / 16,
                  width: double.infinity,
                  color: Colors.black,
                  child: kIsWeb
                      ? FlickVideoNormal(
                          key: _globalKey,
                          data: videoInfo,
                          isLocal: false,
                        )
                      : FijkView(
                          color: Colors.black,
                          fit: FijkFit.cover,
                          player: player,
                          panelBuilder: (
                            FijkPlayer player,
                            FijkData data,
                            BuildContext context,
                            Size viewSize,
                            Rect texturePos,
                          ) {
                            //使用自定义的布局
                            return CustomFijkPanel(
                              videoInfo: videoInfo,
                              player: player,
                              viewSize: viewSize,
                              texturePos: texturePos,
                              pageContent: context,
                              showConfig: vCfg,
                              isLocal: false,
                            );
                          },
                        ),
                ),
                Container(
                  height: ScreenUtil().setWidth(38),
                  padding:
                      EdgeInsets.symmetric(horizontal: GQStyle.pagePadding),
                  decoration: BoxDecoration(
                    border: Border(
                        bottom:
                            BorderSide(color: Color(0xFF212122), width: 0.5)),
                  ),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          _pageController.animateToPage(0,
                              duration: Duration(milliseconds: 200),
                              curve: Curves.easeIn);
                        },
                        child: Text(
                          CommonUtils.txt('jj'),
                          style: showIndex == 0
                              ? GQStyle.white_17
                              : GQStyle.gray172_17,
                        ),
                      ),
                      SizedBox(
                        width: ScreenUtil().setWidth(10),
                      ),
                      GestureDetector(
                        onTap: () {
                          _pageController.animateToPage(1,
                              duration: Duration(milliseconds: 200),
                              curve: Curves.easeIn);
                        },
                        child: Text(
                          CommonUtils.txt('pl') + '(${videoInfo.countComment})',
                          style: showIndex == 1
                              ? GQStyle.white_17
                              : GQStyle.gray172_17,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: PageView(
                    onPageChanged: (value) {
                      showIndex = value;
                      FocusScopeNode currentFocus = FocusScope.of(context);
                      if (!currentFocus.hasPrimaryFocus &&
                          currentFocus.focusedChild != null) {
                        FocusManager.instance.primaryFocus.unfocus();
                      }
                      setState(() {});
                    },
                    controller: _pageController,
                    children: [
                      SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: GQStyle.pagePadding),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(height: ScreenUtil().setWidth(15)),
                              Text(
                                videoInfo.title,
                                style: GQStyle.white255_18_M,
                                maxLines: 2,
                              ),
                              SizedBox(
                                height: ScreenUtil().setWidth(
                                    videoInfo.topic == null ||
                                            videoInfo.topic["desp"] == null ||
                                            videoInfo.topic["desp"] == ""
                                        ? 0
                                        : 12),
                              ),
                              videoInfo.topic == null ||
                                      videoInfo.topic["desp"] == null ||
                                      videoInfo.topic["desp"] == ""
                                  ? Container()
                                  : videoInfo.topic["desp"].length == 0
                                      ? Container()
                                      : Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                videoInfo.topic["desp"] ?? "",
                                                style: GQStyle.gray163_13,
                                              ),
                                            ),
                                            GestureDetector(
                                              behavior:
                                                  HitTestBehavior.translucent,
                                              onTap: () {
                                                _showDespAlert();
                                              },
                                              child: Text(
                                                CommonUtils.txt("qbjj"),
                                                style: GQStyle.jellyCyan_13_M,
                                                textAlign: TextAlign.end,
                                              ),
                                            )
                                          ],
                                        ),
                              // SizedBox(
                              //   height: ScreenUtil()
                              //       .setWidth(AppGlobal.vipLevel < 1 ? 23 : 0),
                              // ),
                              // AppGlobal.vipLevel < 1
                              //     ? Center(
                              //         child: Container(
                              //           width: ScreenUtil().setWidth(350),
                              //           height: ScreenUtil().setWidth(50),
                              //           child: GestureDetector(
                              //             behavior: HitTestBehavior.translucent,
                              //             onTap: () {
                              //               context.push('/${Routes.vip}');
                              //             },
                              //             child: Stack(
                              //               alignment:
                              //                   AlignmentDirectional.center,
                              //               children: [
                              //                 Column(
                              //                   children: [
                              //                     SizedBox(
                              //                         height: ScreenUtil()
                              //                             .setWidth(10)),
                              //                     Container(
                              //                       width: ScreenUtil()
                              //                           .setWidth(350),
                              //                       height: ScreenUtil()
                              //                           .setWidth(40),
                              //                       child: Stack(
                              //                         children: [
                              //                           LImage(
                              //                             "v_time_bg_n",
                              //                           ),
                              //                           Center(
                              //                             child: Text(
                              //                               member.new_user
                              //                                   ? CommonUtils.txt(
                              //                                       'xyhktzk')
                              //                                   : CommonUtils.txt(
                              //                                       'ktvkpyp'),
                              //                               style: GQStyle
                              //                                   .yellow255_15_M,
                              //                             ),
                              //                           )
                              //                         ],
                              //                       ),
                              //                     ),
                              //                   ],
                              //                 ),
                              //                 Positioned(
                              //                   right: ScreenUtil().setWidth(1),
                              //                   top: 0,
                              //                   child: Stack(
                              //                     children: [
                              //                       LImage(
                              //                         "v_vbs_n",
                              //                         width: ScreenUtil()
                              //                             .setWidth(101),
                              //                         height: ScreenUtil()
                              //                             .setWidth(25),
                              //                       ),
                              //                       Padding(
                              //                           padding:
                              //                               EdgeInsets.only(
                              //                             left: ScreenUtil()
                              //                                 .setWidth(10),
                              //                             top: ScreenUtil()
                              //                                 .setWidth(1.5),
                              //                           ),
                              //                           child: ValueListenableBuilder<
                              //                                   int>(
                              //                               valueListenable:
                              //                                   _secondsCounter,
                              //                               builder:
                              //                                   _buildWithValue)),
                              //                       // Padding(
                              //                       //   padding: EdgeInsets.only(
                              //                       //     left: ScreenUtil()
                              //                       //         .setWidth(10),
                              //                       //     top: ScreenUtil()
                              //                       //         .setWidth(1.5),
                              //                       //   ),
                              //                       //   child: Text(
                              //                       //       _dealTimeToString(),
                              //                       //       style: GQStyle
                              //                       //           .white255_11),
                              //                       // ),
                              //                     ],
                              //                   ),
                              //                 )
                              //               ],
                              //             ),
                              //           ),
                              //         ),
                              //       )
                              //     : Container(),
                              SizedBox(
                                height: ScreenUtil().setWidth(22),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${videoInfo.countPlay}' +
                                        CommonUtils.txt('cbf'),
                                    style: GQStyle.gray153_14_M,
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          userFavorites(
                                                  type: 1, id: videoInfo.id)
                                              .then((res) {
                                            if (res != null &&
                                                res.status != 0) {
                                              isFavorites = !isFavorites;
                                              isFavorites
                                                  ? videoInfo.favorites++
                                                  : videoInfo.favorites--;
                                              setState(() {});
                                            } else {
                                              CommonUtils.showText(res.msg);
                                            }
                                          });
                                        },
                                        child: _btnItem(
                                            icon: isFavorites
                                                ? 'comic_collect_s'
                                                : 'comic_collect_n',
                                            name: CommonUtils.renderFixedNumber(
                                                videoInfo.favorites),
                                            color: isFavorites
                                                ? Color.fromRGBO(0, 210, 190, 1)
                                                : Color.fromRGBO(
                                                    153, 153, 153, 1)),
                                      ),
                                      SizedBox(
                                        width: ScreenUtil().setWidth(20),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          context.push(CommonUtils.getRealHash(
                                              'kwantsharetousers'));
                                        },
                                        child: _btnItem(
                                          icon: 'share',
                                          name: CommonUtils.txt('fx'),
                                        ),
                                      ),
                                      SizedBox(
                                        width: ScreenUtil()
                                            .setWidth(kIsWeb ? 0 : 20),
                                      ),
                                      kIsWeb
                                          ? Container()
                                          : GestureDetector(
                                              onTap: () async {
                                                // 先判断本地有没有
                                                Member member =
                                                    Provider.of<HomeConfig>(
                                                            context,
                                                            listen: false)
                                                        .member;
                                                Map taskInfo = {
                                                  "id": "${videoInfo.id}",
                                                  "urlPath": "",
                                                  "title": videoInfo.title,
                                                  "thumbCover": videoInfo
                                                          .coverThumbHorizontal ??
                                                      videoInfo
                                                          .coverThumbVerticle,
                                                  "tags": tags.join('/'),
                                                  "contentType": 1,
                                                  "downloading": false,
                                                  "isWaiting": true
                                                };
                                                Box box = await Hive.openBox(
                                                    'qypjbox');
                                                List tasks = box.get(
                                                        'download_video_tasks') ??
                                                    [];
                                                int existTaskIndex =
                                                    tasks.indexWhere((e) =>
                                                        e["id"] ==
                                                        taskInfo["id"]);
                                                if (tasks.isNotEmpty &&
                                                    existTaskIndex != -1) {
                                                  Map info =
                                                      tasks[existTaskIndex];
                                                  if (info['progress'] == 1) {
                                                    CommonUtils.showText(
                                                        CommonUtils.txt(
                                                            "wjyxz"));
                                                  } else {
                                                    CommonUtils.showText(
                                                        CommonUtils.txt(
                                                            "dqrwcz"));
                                                  }

                                                  return;
                                                }

                                                if (member.exp == 0) {
                                                  YyShowDialog.showdPNGDiaog(
                                                      context,
                                                      title:
                                                          CommonUtils.txt('ts'),
                                                      btnText: CommonUtils.txt(
                                                          'fxdv'),
                                                      cancelText:
                                                          CommonUtils.txt('qx'),
                                                      callBack: () {
                                                    context.push(
                                                        CommonUtils.getRealHash(
                                                            'welfaretaskpage'));
                                                  }, content: (setDialogState) {
                                                    return DefaultTextStyle(
                                                        style: GQStyle
                                                            .graya3a2a2_13,
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                                CommonUtils.txt(
                                                                    'jfyebz')),
                                                          ],
                                                        ));
                                                  });
                                                } else {
                                                  YyShowDialog.showdPNGDiaog(
                                                      context,
                                                      title:
                                                          CommonUtils.txt('ts'),
                                                      btnText: CommonUtils.txt(
                                                          'qrxz'),
                                                      cancelText:
                                                          CommonUtils.txt('qx'),
                                                      callBack: () {
                                                    _downFromExp();
                                                  }, content: (setDialogState) {
                                                    return DefaultTextStyle(
                                                        style: GQStyle
                                                            .graya3a2a2_13,
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(CommonUtils.txt(
                                                                    'xzxyhf')
                                                                .replaceAll("0",
                                                                    "${member.exp_down}")),
                                                          ],
                                                        ));
                                                  });
                                                }
                                                // if (AppGlobal.vipLevel < 1) {

                                                // } else {
                                                //   if (kIsWeb) {
                                                //     CommonUtils.showText(
                                                //         CommonUtils.txt(
                                                //             'qxapty'));
                                                //     return;
                                                //   }
                                                //   if (Provider.of<HomeConfig>(
                                                //               context,
                                                //               listen: false)
                                                //           .member
                                                //           .video_download_value ==
                                                //       0) {
                                                //     CommonUtils.showText(
                                                //         CommonUtils.txt(
                                                //             'xzcsw'));
                                                //     return;
                                                //   }
                                                //   Map taskInfo = {
                                                //     "id": "${videoInfo.id}",
                                                //     "urlPath":
                                                //         videoInfo.source240,
                                                //     "title": videoInfo.title,
                                                //     "thumbCover": videoInfo
                                                //             .coverThumbHorizontal ??
                                                //         videoInfo
                                                //             .coverThumbVerticle,
                                                //     "tags": tags.join('/'),
                                                //     "contentType": 1,
                                                //     "downloading": false,
                                                //     "isWaiting": true
                                                //   };
                                                //   Box box = await Hive.openBox(
                                                //       'qypjbox');
                                                //   List tasks = box.get(
                                                //           'download_video_tasks') ??
                                                //       [];
                                                //   int existTaskIndex =
                                                //       tasks.indexWhere((e) =>
                                                //           e["id"] ==
                                                //           taskInfo["id"]);
                                                //   if (tasks.isNotEmpty &&
                                                //       existTaskIndex != -1) {
                                                //     CommonUtils.showText(
                                                //         CommonUtils.txt(
                                                //             "dqrwcz"));
                                                //     return;
                                                //   }
                                                //   //修改数据
                                                //   downNum(videoInfo.id)
                                                //       .then((res) {
                                                //     if (res.status == 1) {
                                                //       Member member = Provider
                                                //               .of<HomeConfig>(
                                                //                   context,
                                                //                   listen: false)
                                                //           .member;
                                                //       member.video_download_value -=
                                                //           1;
                                                //       if (member
                                                //               .video_download_value <
                                                //           0)
                                                //         member.video_download_value =
                                                //             0;
                                                //       Provider.of<HomeConfig>(
                                                //               context,
                                                //               listen: false)
                                                //           .setMember(member);
                                                //       DownloadUtil
                                                //           .createDownloadTask(
                                                //               taskInfo);
                                                //     } else {
                                                //       CommonUtils.showText(
                                                //           res.msg);
                                                //     }
                                                //   });
                                                // }
                                              },
                                              child: _btnItem(
                                                icon: 'download',
                                                name: CommonUtils.txt('xz'),
                                              ),
                                            )
                                    ],
                                  )
                                ],
                              ),
                              // Container(
                              //   margin: EdgeInsets.only(
                              //       top: ScreenUtil().setWidth(18)),
                              //   height: ScreenUtil().setWidth(1),
                              //   decoration: BoxDecoration(
                              //       color: Color.fromRGBO(255, 255, 255, 0.1)),
                              // ),
                              course.length == 0 || course == null
                                  ? Container()
                                  : Container(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                              height:
                                                  ScreenUtil().setWidth(17)),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text.rich(
                                                        TextSpan(children: [
                                                          TextSpan(
                                                              text: videoInfo
                                                                          .topic[
                                                                      "title"] ??
                                                                  "",
                                                              style: GQStyle
                                                                  .white255_15_M),
                                                          TextSpan(
                                                              text:
                                                                  "  ${CommonUtils.txt("gng") + course.length.toString() + CommonUtils.txt("jishu")}",
                                                              style: GQStyle
                                                                  .white255_11)
                                                        ]),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                        width: ScreenUtil()
                                                            .setWidth(10)),
                                                  ],
                                                ),
                                              ),
                                              GestureDetector(
                                                behavior:
                                                    HitTestBehavior.translucent,
                                                onTap: () {
                                                  _showEpisodeAlert();
                                                },
                                                child: Row(
                                                  children: [
                                                    Text(
                                                        CommonUtils.txt("ckqb"),
                                                        style: GQStyle
                                                            .jellyCyan_11),
                                                    // LImage(
                                                    //   "more_arrow_n",
                                                    //   width: ScreenUtil()
                                                    //       .setWidth(18),
                                                    //   height: ScreenUtil()
                                                    //       .setWidth(18),
                                                    // )
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                              height:
                                                  ScreenUtil().setWidth(17)),
                                          SizedBox(
                                            height: ScreenUtil().setWidth(48),
                                            child: ListView(
                                              physics: BouncingScrollPhysics(),
                                              scrollDirection: Axis.horizontal,
                                              children: course
                                                  .asMap()
                                                  .keys
                                                  .map((x) => Row(
                                                        children: [
                                                          GestureDetector(
                                                            onTap: () {
                                                              if (!isClickCourse) {
                                                                CommonUtils.showText(
                                                                    CommonUtils.txt(
                                                                        "pfdj"));
                                                                return;
                                                              }
                                                              isClickCourse =
                                                                  !isClickCourse;
                                                              courseIndex = x;
                                                              _getCourse(course[
                                                                          x][
                                                                      "related_id"]
                                                                  .toString());
                                                            },
                                                            child: Container(
                                                              decoration: BoxDecoration(
                                                                  color: Color(
                                                                      0xFF26313b),
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              5)),
                                                                  border: Border.all(
                                                                      color: x ==
                                                                              courseIndex
                                                                          ? GQStyle
                                                                              .jellyCyanColor103224185
                                                                          : Colors
                                                                              .transparent)),
                                                              width:
                                                                  ScreenUtil()
                                                                      .setWidth(
                                                                          48),
                                                              child: Center(
                                                                child: Text(
                                                                    "${x + 1}",
                                                                    style: GQStyle
                                                                        .gray203_18medium),
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                              width:
                                                                  ScreenUtil()
                                                                      .setWidth(
                                                                          12))
                                                        ],
                                                      ))
                                                  .toList(),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                              // Padding(
                              //   padding: EdgeInsets.only(
                              //       left: ScreenUtil().setWidth(30),
                              //       right: ScreenUtil().setWidth(30),
                              //       top: ScreenUtil().setWidth(21.5)),
                              //   child: Row(
                              //       mainAxisAlignment:
                              //           MainAxisAlignment.spaceBetween,
                              //       children: _getEvaluation()
                              //           .map((e) => GestureDetector(
                              //                 onTap: () {
                              //                   if (['', null, false]
                              //                       .contains(AppGlobal.apiToken)) {
                              //                     CommonUtils.showText(
                              //                         CommonUtils.txt("zcyhcz"));
                              //                     return;
                              //                   }
                              //                   if (e["bg"] == "good_lok_n") {
                              //                     getVideoEvaluation(
                              //                             id: videoInfo.id,
                              //                             evaluation: "good_look")
                              //                         .then((res) {
                              //                       if (res.status == 1) {
                              //                         videoInfo.userAction[
                              //                                 "good_look"] =
                              //                             videoInfo.userAction[
                              //                                     "good_look"] +
                              //                                 1;
                              //                         setState(() {});
                              //                       } else {
                              //                         CommonUtils.showText(res.msg);
                              //                       }
                              //                     });
                              //                   }
                              //                   if (e["bg"] == "good_lik_n") {
                              //                     getVideoEvaluation(
                              //                             id: videoInfo.id,
                              //                             evaluation:
                              //                                 "must_awesome")
                              //                         .then((res) {
                              //                       if (res.status == 1) {
                              //                         videoInfo.userAction[
                              //                                 "must_awesome"] =
                              //                             videoInfo.userAction[
                              //                                     "must_awesome"] +
                              //                                 1;
                              //                         setState(() {});
                              //                       } else {
                              //                         CommonUtils.showText(res.msg);
                              //                       }
                              //                     });
                              //                   }
                              //                   if (e["bg"] == "good_qp_n") {
                              //                     getVideoEvaluation(
                              //                             id: videoInfo.id,
                              //                             evaluation:
                              //                                 "what_awesome")
                              //                         .then((res) {
                              //                       if (res.status == 1) {
                              //                         videoInfo.userAction[
                              //                                 "what_awesome"] =
                              //                             videoInfo.userAction[
                              //                                     "what_awesome"] +
                              //                                 1;
                              //                         setState(() {});
                              //                       } else {
                              //                         CommonUtils.showText(res.msg);
                              //                       }
                              //                     });
                              //                   }
                              //                   if (e["bg"] == "good_jj_n") {
                              //                     getVideoEvaluation(
                              //                             id: videoInfo.id,
                              //                             evaluation: "no_awesome")
                              //                         .then((res) {
                              //                       if (res.status == 1) {
                              //                         videoInfo.userAction[
                              //                                 "no_awesome"] =
                              //                             videoInfo.userAction[
                              //                                     "no_awesome"] +
                              //                                 1;
                              //                         setState(() {});
                              //                       } else {
                              //                         CommonUtils.showText(res.msg);
                              //                       }
                              //                     });
                              //                   }
                              //                 },
                              //                 child: Column(
                              //                   children: [
                              //                     LImage(e["bg"],
                              //                         width:
                              //                             ScreenUtil().setWidth(55),
                              //                         height: ScreenUtil()
                              //                             .setWidth(55)),
                              //                     SizedBox(
                              //                         height:
                              //                             ScreenUtil().setWidth(8)),
                              //                     Text(e["title"],
                              //                         style: GQStyle.white255_13),
                              //                     SizedBox(
                              //                         height: ScreenUtil()
                              //                             .setWidth(13)),
                              //                     Text(
                              //                         "${e["num"]}${CommonUtils.txt("ren")}",
                              //                         style: GQStyle.gray102_13),
                              //                   ],
                              //                 ),
                              //               ))
                              //           .toList()),
                              // ),
                              banner.length == 0 || banner == null
                                  ? Container()
                                  : Container(
                                      padding: EdgeInsets.only(
                                          top: ScreenUtil().setWidth(20)),
                                      child: GeneralBanner(
                                        data: banner,
                                        // height:
                                        //     (ScreenUtil().setWidth(350) * 300 / 700)
                                        //         .ceil(),
                                        height: 100,
                                        // bottom: 0,
                                        radius: 5.0,
                                      ),
                                    ),
                              SizedBox(
                                  height: ScreenUtil().setWidth(
                                      banner.length == 0 || banner == null
                                          ? 20
                                          : 0)),
                              Text(CommonUtils.txt('jctj'),
                                  style: GQStyle.white23_18),
                              Container(
                                child: recommendList.length == 0
                                    ? Center(child: PageStatus.noData())
                                    : GridView.count(
                                        padding: EdgeInsets.symmetric(
                                            // horizontal: GQStyle.pagePadding,
                                            vertical:
                                                ScreenUtil().setWidth(20)),
                                        physics: NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        crossAxisCount: 1,
                                        mainAxisSpacing:
                                            ScreenUtil().setWidth(10),
                                        crossAxisSpacing:
                                            ScreenUtil().setWidth(8),
                                        childAspectRatio: 350 / 108,
                                        scrollDirection: Axis.vertical,
                                        children: recommendList
                                            .map((e) => e['url'] != null
                                                ? AdSingleColumeCard(
                                                    data: Map.from(e))
                                                : VideoSingleColumeCard(
                                                    data: Map.from(e)
                                                      ..addAll(
                                                          {'content_type': 1}),
                                                    replace: true,
                                                  ))
                                            .toList(),
                                      ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      PageViewMixin(
                        child: Container(
                          // height: ScreenUtil().setWidth(40),
                          // color: Colors.red,
                          child: VideoCommentPage(
                            id: widget.id,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  _showDespAlert() {
    return showModalBottomSheet(
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setBottomSheetState) {
            return Container(
              padding:
                  EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(20)),
              decoration: BoxDecoration(
                color: Color(0xFF23262f),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(ScreenUtil().setWidth(20)),
                  topRight: Radius.circular(ScreenUtil().setWidth(20)),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.only(
                          top: ScreenUtil().setWidth(20),
                          bottom: ScreenUtil().setWidth(5)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            videoInfo.topic["title"] ?? "",
                            style: GQStyle.jellyCyan_15_M,
                          ),
                          GestureDetector(
                            onTap: () {
                              context.pop();
                            },
                            child: LImage(
                              "issue_close_n",
                              width: ScreenUtil().setWidth(11),
                              height: ScreenUtil().setWidth(11),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                        "${CommonUtils.txt("gng") + course.length.toString() + CommonUtils.txt("jishu")}·${videoInfo.topic["finished"] == 0 ? CommonUtils.txt("lzz") : CommonUtils.txt("ywj")}",
                        style: GQStyle.gray163_11),
                    SizedBox(height: ScreenUtil().setWidth(20)),
                    Text.rich(
                      TextSpan(
                          text: videoInfo.topic["desp"] ?? "",
                          style: GQStyle.white255_11),
                    ),
                    SizedBox(height: ScreenUtil().setWidth(30)),
                  ],
                ),
              ),
            );
          });
        });
  }

  _showEpisodeAlert() {
    return showModalBottomSheet(
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setBottomSheetState) {
            return Container(
              padding:
                  EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(20)),
              decoration: BoxDecoration(
                color: Color(0xFF23262f),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(ScreenUtil().setWidth(20)),
                  topRight: Radius.circular(ScreenUtil().setWidth(20)),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.only(
                          top: ScreenUtil().setWidth(20),
                          bottom: ScreenUtil().setWidth(5)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: ScreenUtil().setWidth(180),
                            child: Text(
                              videoInfo.topic["title"] ?? "",
                              style: GQStyle.blue80_15_M,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              context.pop();
                            },
                            child: LImage(
                              "issue_close_n",
                              width: ScreenUtil().setWidth(11),
                              height: ScreenUtil().setWidth(11),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                        "${CommonUtils.txt("gng") + course.length.toString() + CommonUtils.txt("jishu")}·${videoInfo.topic["finished"] == 0 ? CommonUtils.txt("lzz") : CommonUtils.txt("ywj")}",
                        style: GQStyle.gray163_11),
                    SizedBox(height: ScreenUtil().setWidth(20)),
                    GridView.count(
                      crossAxisCount: 6,
                      shrinkWrap: true,
                      mainAxisSpacing: GQStyle.pagePadding,
                      crossAxisSpacing: GQStyle.pagePadding,
                      childAspectRatio: 1 / 1,
                      children: course
                          .asMap()
                          .keys
                          .map((x) => GestureDetector(
                                onTap: () {
                                  context.pop();
                                  if (!isClickCourse) {
                                    CommonUtils.showText(
                                        CommonUtils.txt("pfdj"));
                                    return;
                                  }
                                  isClickCourse = !isClickCourse;
                                  courseIndex = x;
                                  _getCourse(
                                      course[x]["related_id"].toString());
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Color(0xFF26313b),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5)),
                                      border: Border.all(
                                          color: x == courseIndex
                                              ? GQStyle.jellyCyanColor103224185
                                              : Colors.transparent)),
                                  child: Center(
                                    child: Text("${x + 1}",
                                        style: GQStyle.gray203_18medium),
                                  ),
                                ),
                              ))
                          .toList(),
                    ),
                    SizedBox(height: ScreenUtil().setWidth(30))
                  ],
                ),
              ),
            );
          });
        });
  }

  _downFromExp() async {
    Member member = Provider.of<HomeConfig>(context, listen: false).member;
    Map taskInfo = {
      "id": "${videoInfo.id}",
      "urlPath": "",
      "title": videoInfo.title,
      "thumbCover":
          videoInfo.coverThumbHorizontal ?? videoInfo.coverThumbVerticle,
      "tags": tags.join('/'),
      "contentType": 1,
      "downloading": false,
      "isWaiting": true
    };
    Box box = await Hive.openBox('qypjbox');
    List tasks = box.get('download_video_tasks') ?? [];
    int existTaskIndex = tasks.indexWhere((e) => e["id"] == taskInfo["id"]);
    if (tasks.isNotEmpty && existTaskIndex != -1) {
      CommonUtils.showText(CommonUtils.txt("dqrwcz"));
      return;
    }
    Basic res = await downNumByExp(
        id: videoInfo.id, context: context, exp: member.exp - member.exp_down);
    if (res.status == 1) {
      taskInfo["urlPath"] = res.data["downloadUrl"];
      DownloadUtil.createDownloadTask(taskInfo);
    } else {
      CommonUtils.showText(res.msg);
    }
  }
}
