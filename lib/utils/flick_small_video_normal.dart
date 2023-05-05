import 'dart:convert';

import 'package:bot_toast/bot_toast.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qypj/components/yy_dialog.dart';
import 'package:qypj/global.dart';
import 'package:qypj/mixin/general_video_mixin.dart';
import 'package:qypj/mixin/watchRecordMixin.dart';
import 'package:qypj/model/videolist.dart';
import 'package:qypj/pages/cartoon/cartoon_review.dart';
import 'package:qypj/routers.dart';
import 'package:qypj/store/homeConfig.dart';
import 'package:qypj/theme/default.dart';
import 'package:qypj/utils/api.dart';
import 'package:qypj/utils/common.dart';
import 'package:qypj/utils/extensionlibrary.dart';
import 'package:qypj/utils/flick_small_video_pcontrols.dart';
// import 'package:qypj/utils/index.dart';
import 'package:qypj/utils/networkImage.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:qypj/utils/util_eventbus_class.dart';

class FlickSmallVideoNormal extends StatefulWidget {
  FlickSmallVideoNormal({
    Key key,
    this.data,
    this.flickManager,
    this.vcDispose,
    this.bottom = 20,
  }) : super(key: key);
  bool isLocal;
  final FlickManager flickManager;
  final VideoItem data;
  final double bottom;
  final Function() vcDispose;

  @override
  _FlickSmallVideoNormalState createState() => _FlickSmallVideoNormalState();
}

class _FlickSmallVideoNormalState extends State<FlickSmallVideoNormal>
    with GeneralVideoMinxin, WatchRecordMixin {
  bool isDone = false;
  bool showAlert = false;
  bool ismute = false;
  FlickManager flickManager;
  VideoItem data;
  var discrip;

  @override
  void initState() {
    super.initState();
    flickManager = widget.flickManager;
    data = widget.data;
    initFick();
    discrip = UtilEventbus().on<UtilEventbusClass>().listen((event) {
      if (event.arg["name"] == 'openxj') {
        VideoItem tp = VideoItem.fromJson(event.arg["data"]);
        if (tp.id == data.id) return;
        data = tp;
        initFick(isNew: true);
      }
    });
  }

  initFick({bool isNew = false}) async {
    VideoPlayerController controller;
    if (controller == null || isNew || flickManager == null) {
      controller = await initController(data);
    }
    if (isNew) {
      //更改播放地址
      flickManager.handleChangeVideo(
          controller..setLooping(data.source_240.length > 0));
      Future.delayed(Duration(seconds: 1), () {
        if (flickManager.flickDisplayManager.showPlayerControls && !kIsWeb) {
          flickManager.flickDisplayManager.handleVideoTap();
        }
      });
    } else {
      if (flickManager == null) {
        flickManager =
            FlickManager(autoPlay: !kIsWeb, videoPlayerController: controller);
      }
      flickManager.flickVideoManager.videoPlayerController
          .setLooping(data.source_240.length > 0);
      flickManager.onVideoEnd = (() {
        isDone = true;
        if (!showAlert && !(data.source_240.length > 0)) showAlertVp();
        setState(() {});
      });
    }
    if (!kIsWeb) {
      flickManager.flickVideoManager.videoPlayerController.play();
    }
    if (mounted) setState(() {});
    //正式播放才会进行记录
    if (data.source_240.length == 0) return;
  }

  buySmallVideo(int money) {
    CommonUtils.startLoadGIF(tip: CommonUtils.txt("zfz"));
    buyVideo(
      id: data.id,
      exp: (money - AppGlobal.vipLevel > 0 ? data.discount_coins : data.coins),
      context: context,
    ).then((res) {
      BotToast.closeAllLoading();
      if (res.status != 0) {
        data.source_240 = res.data["url"];
        initFick(isNew: true);
      } else {
        CommonUtils.showText(res.msg);
      }
    });
  }

  showAlertVp() {
    if (data.isfree == 2) {
      int money = Provider.of<HomeConfig>(context, listen: false).member.money;
      bool isInsufficient =
          money < (AppGlobal.vipLevel > 0 ? data.discount_coins : data.coins);
      YyShowDialog.showdialog(
        context,
        title:
            isInsufficient ? CommonUtils.txt('jbbz') : CommonUtils.txt('jbsp'),
        content: (setDialogState) {
          return DefaultTextStyle(
              style: GQStyle.gray203_13,
              child: Column(
                children: [
                  Text.rich(TextSpan(text: CommonUtils.txt('shf'), children: [
                    TextSpan(
                        text:
                            '${AppGlobal.vipLevel > 0 ? data.discount_coins : data.coins}' +
                                CommonUtils.txt('jb'),
                        style: GQStyle.blue80_13_M)
                  ])),
                  SizedBox(height: ScreenUtil().setWidth(33.5)),
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      context.pop();
                      if (isInsufficient) {
                        context.push('/${Routes.coinRecharge}');
                      } else {
                        buySmallVideo(money);
                      }
                    },
                    child: Container(
                      height: ScreenUtil().setWidth(32),
                      width: ScreenUtil().setWidth(162),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(ScreenUtil().setWidth(16)),
                        ),
                        gradient: GQStyle.btnGradient_ff00edfd_ffbbe954,
                      ),
                      child: Center(
                        child: Text(
                          isInsufficient
                              ? CommonUtils.txt('ybzcz')
                              : CommonUtils.txt('gmgk'),
                          style: GQStyle.white255_12,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: ScreenUtil().setWidth(18.5)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                          CommonUtils.txt('kyje') +
                              "：$money" +
                              CommonUtils.txt('jb'),
                          style: GQStyle.gray203_13),
                      SizedBox(width: ScreenUtil().setWidth(13.5)),
                      GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          context.pop();
                          context.push('/${Routes.coinRecharge}');
                        },
                        child: Row(
                          children: [
                            Text(CommonUtils.txt('qcz'),
                                style: GQStyle.blue80_13_M),
                          ],
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: ScreenUtil().setWidth(14)),
                ],
              ));
        },
      );
    } else {
      YyShowDialog.showdPNGDiaog(
        context,
        title: CommonUtils.txt('mfwl'),
        btnText: CommonUtils.txt('cv'),
        cancelBack: () {
          context.push(CommonUtils.getRealHash('kwantsharetousers'));
        },
        cancelText: CommonUtils.txt('fxwxk'),
        callBack: () {
          context.push('/${Routes.vip}');
        },
        content: (setDialogState) {
          return DefaultTextStyle(
              style: GQStyle.gray203_13,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    Provider.of<HomeConfig>(context, listen: false)
                        .config
                        .tips_share_text,
                    style: GQStyle.gray203_13,
                    maxLines: 3,
                  ),
                ],
              ));
        },
      );
    }
    showAlert = true;
  }

  @override
  void dispose() {
    _dealReportsData();
    flickManager.dispose();
    if (widget.vcDispose != null) widget.vcDispose();
    discrip.cancel();
    super.dispose();
  }

  _dealReportsData() {
    AppGlobal.reports.add({
      "id": data.id,
      "duration":
          flickManager.flickVideoManager.videoPlayerValue.position.inSeconds
    });
    //去重
    final ids = AppGlobal.reports.map((e) => e["id"]).toSet();
    AppGlobal.reports.retainWhere((x) => ids.remove(x["id"]));
    CommonUtils.debugPrint(AppGlobal.reports.toString());
    if (AppGlobal.reports.length > 14) {
      //15个记录上报
      reportVisit(
          json: AppGlobal.reports
              .map((item) => jsonEncode(item))
              .toList()
              .toString());
      AppGlobal.reports = [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return flickManager == null
        ? Container()
        : VisibilityDetector(
            key: ObjectKey(flickManager),
            onVisibilityChanged: (visibility) {
              if (visibility.visibleFraction == 0 && this.mounted) {
                flickManager.flickControlManager?.autoPause();
              } else if (visibility.visibleFraction == 1.0) {
                flickManager.flickControlManager?.autoResume();
              }
              if (flickManager.flickDisplayManager.showPlayerControls &&
                  !kIsWeb) {
                flickManager.flickDisplayManager.handleVideoTap();
              }
            },
            child: Container(
              child: FlickVideoPlayer(
                flickManager: flickManager,
                flickVideoWithControls: FlickVideoWithControls(
                  videoFit: BoxFit.contain,
                  playerLoadingFallback: Stack(
                    children: [
                      PlatformAwareNetworkImage(
                          url: data.cover_vertical ?? data.cover_horizontal),
                      Container(color: Colors.black87)
                    ],
                  ),
                  playerErrorFallback: Container(),
                  controls: FlickSmallVideoPcontrols(
                    isPreview: !(data.source_240.length > 0),
                    isDone: isDone,
                    data: data,
                    alertBack: () {
                      showAlertVp();
                    },
                    refreshBack: (x) {
                      if (x == 0) {
                        setState(() {});
                      } else {
                        showAlert = true;
                      }
                    },
                    reviewBack: () {
                      showAlert = true;
                      _showReview();
                    },
                    bottom: widget.bottom,
                  ),
                ),
                flickVideoWithControlsFullscreen: FlickVideoWithControls(
                  controls: FlickSmallVideoPcontrols(
                    isPreview: !(data.source_240.length > 0),
                    isDone: isDone,
                    data: data,
                  ),
                ),
              ),
            ),
          );
  }

  _showReview() {
    return showModalBottomSheet(
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setBottomSheetState) {
            return CartoonReview(id: data.id);
          });
        });
  }
}
