import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qypj/global.dart';
import 'package:qypj/model/animationDetail.dart';
import 'package:qypj/model/homedata.dart';
import 'package:qypj/store/homeConfig.dart';
import 'package:qypj/theme/default.dart';
import 'package:qypj/utils/common.dart';
import 'package:qypj/utils/extensionlibrary.dart';
import 'package:provider/provider.dart';
import 'package:universal_html/html.dart' as html;

class FlickVideoPcontrols extends StatelessWidget {
  const FlickVideoPcontrols({
    Key key,
    this.fontSize = 12,
    this.vtitle = "",
    this.showBack = true,
    this.isPreview = false,
    this.isDone = false,
    this.data,
    this.skiPreview,
    this.shareVp,
    this.nowToVp,
    this.nowByKb,
    this.noback,
  }) : super(key: key);
  final double fontSize;
  final String vtitle;
  final bool showBack;
  final bool isPreview;
  final bool isDone;
  final bool noback;
  final DetailData data;
  final Function skiPreview; //跳过预览
  final Function shareVp; //分享得VIP
  final Function nowToVp; //立即开通
  final Function nowByKb; //扣币购买

  @override
  Widget build(BuildContext context) {
    return isDone && isPreview
        ? _conditionWidget(context)
        : _noConditionWidget(context);
  }

  Widget _conditionWidget(BuildContext context) {
    Widget dgt = Container();
    var vflag = false;
    Member member = Provider.of<HomeConfig>(context, listen: false).member;
    if (AppGlobal.vipLevel < 1 && data.isfree == 1) {
      //需要VIP
      dgt = Text(CommonUtils.txt('kvbw'), style: GQStyle.white255_14_M);
      vflag = false;
    } else if (data.isfree == 2) {
      dgt = DefaultTextStyle(
        style: GQStyle.white255_14_N,
        child: Text.rich(
          TextSpan(children: [
            TextSpan(text: "${data.coins}", style: GQStyle.blue80_14_M),
            TextSpan(text: CommonUtils.txt('jbjsw') + "，"),
            TextSpan(text: CommonUtils.txt('ktvpzk') + "${member.money}")
          ]),
        ),
      );
      vflag = true;
    }

    return Container(
      color: Colors.black87,
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            alignment: Alignment.centerLeft,
            height: ScreenUtil().setWidth(22),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                noback
                    ? Container()
                    : Container(
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                                color: Color.fromRGBO(0, 0, 0, 0.2),
                                offset: Offset(0, 0),
                                blurRadius: ScreenUtil().setWidth(16))
                          ],
                        ),
                        child: GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          child: LImage("nav_back_w_n"),
                          onTap: () {
                            context.pop();
                          },
                        ),
                      ),
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            top: ScreenUtil().setWidth(20),
            left: ScreenUtil().setWidth(50),
            right: ScreenUtil().setWidth(50),
          ),
          child: Column(
            children: [
              Text(CommonUtils.txt("skjs"), style: GQStyle.white255_14_M),
              SizedBox(height: ScreenUtil().setWidth(10)),
              dgt,
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            top: ScreenUtil().setWidth(16),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  if (vflag) {
                    if (nowByKb != null) {
                      nowByKb();
                    }
                  } else {
                    if (nowToVp != null) {
                      nowToVp();
                    }
                  }
                },
                child: Container(
                  height: ScreenUtil().setWidth(32),
                  width: ScreenUtil().setWidth(100),
                  decoration: BoxDecoration(
                    gradient: GQStyle.btnGradient_ff00edfd_ffbbe954,
                    borderRadius: BorderRadius.all(
                        Radius.circular(ScreenUtil().setWidth(3))),
                  ),
                  child: Center(
                    child: Text(
                        vflag
                            ? CommonUtils.txt("gmgk")
                            : CommonUtils.txt("ljkv"),
                        style: GQStyle.white13),
                  ),
                ),
              ),
              SizedBox(width: ScreenUtil().setWidth(37)),
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  if (shareVp != null) shareVp();
                },
                child: Container(
                  height: ScreenUtil().setWidth(32),
                  width: ScreenUtil().setWidth(100),
                  decoration: BoxDecoration(
                    gradient: GQStyle.btnGradient_ff00edfd_ffbbe954,
                    borderRadius: BorderRadius.all(
                        Radius.circular(ScreenUtil().setWidth(3))),
                  ),
                  child: Center(
                    child:
                        Text(CommonUtils.txt("fxdv"), style: GQStyle.white13),
                  ),
                ),
              )
            ],
          ),
        )
      ]),
    );
  }

  Widget _noConditionWidget(BuildContext context) {
    FlickControlManager controlManager =
        Provider.of<FlickControlManager>(context);
    FlickVideoManager flickVideoManager =
        Provider.of<FlickVideoManager>(context);
    FlickDisplayManager flickDisplayManager =
        Provider.of<FlickDisplayManager>(context);
    bool flag = (flickVideoManager.videoPlayerValue.isBuffering &&
            flickVideoManager.videoPlayerValue.isPlaying) ||
        !flickVideoManager.videoPlayerValue.isInitialized;

    return Stack(
      children: <Widget>[
        Positioned.fill(
          child: FlickShowControlsAction(
            handleVideoTap: () {
              FocusScopeNode currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus &&
                  currentFocus.focusedChild != null) {
                FocusManager.instance.primaryFocus.unfocus();
              }
              if (currentFocus.hasPrimaryFocus) {
                flickDisplayManager.handleVideoTap();
              }
            },
            child: FlickSeekVideoAction(
              duration: Duration(seconds: 60),
              child: Center(
                child: flag
                    ? Container(
                        height: 40,
                        width: 40,
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.grey[200],
                          valueColor: AlwaysStoppedAnimation(
                            GQStyle.jellyCyanColor103224185,
                          ),
                          strokeWidth: 1.0,
                        ),
                      )
                    : FlickAutoHideChild(
                        showIfVideoNotInitialized: false,
                        child: FlickPlayToggle(
                          replayChild: LImage(
                            "v_replay_n",
                            width: 40,
                            height: 40,
                          ),
                          playChild: LImage(
                            "v_play_n",
                            width: 40,
                            height: 40,
                          ),
                          pauseChild: LImage(
                            "v_pause_n",
                            width: 40,
                            height: 40,
                          ),
                        ),
                      ),
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: FlickAutoHideChild(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: ScreenUtil().setWidth(8)),
                  alignment: Alignment.centerLeft,
                  height: ScreenUtil().setWidth(22),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      showBack
                          ? SizedBox(width: 22)
                          : noback
                              ? Container()
                              : Container(
                                  width: 22,
                                  height: 22,
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                          color: Color.fromRGBO(0, 0, 0, 0.2),
                                          offset: Offset(0, 0),
                                          blurRadius: ScreenUtil().setWidth(16))
                                    ],
                                  ),
                                  child: GestureDetector(
                                    behavior: HitTestBehavior.translucent,
                                    child: LImage("nav_back_w_n"),
                                    onTap: () {
                                      if (showBack) {
                                        context.pop();
                                      } else {
                                        controlManager.toggleFullscreen();
                                      }
                                    },
                                  ),
                                ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  color: vtitle.length == 0
                                      ? Colors.transparent
                                      : Color.fromRGBO(0, 0, 0, 0.2),
                                  offset: Offset(0, 0),
                                  blurRadius: ScreenUtil().setWidth(16))
                            ],
                          ),
                          child: Text(vtitle, style: GQStyle.white255_18_B),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    vertical: ScreenUtil().setWidth(10),
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color.fromRGBO(0, 0, 0, 0.0),
                        Color.fromRGBO(0, 0, 0, 0.5),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: ScreenUtil().setWidth(8)),
                        child: Row(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // kIsWeb
                                //     ? FlickSoundToggle(
                                //         muteChild: LImage("sound_min_n",
                                //             width: ScreenUtil().setWidth(18.7),
                                //             height: ScreenUtil().setWidth(15)),
                                //         unmuteChild: LImage("sound_max_n",
                                //             width: ScreenUtil().setWidth(18.7),
                                //             height: ScreenUtil().setWidth(15)),
                                //       )
                                //     : Container(),
                                // SizedBox(
                                //     width:
                                //         ScreenUtil().setWidth(kIsWeb ? 10 : 0)),
                                FlickCurrentPosition(
                                  fontSize: fontSize,
                                ),
                                Text(
                                  ' / ',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: fontSize),
                                ),
                                FlickTotalDuration(
                                  fontSize: fontSize,
                                ),
                              ],
                            ),
                            Expanded(
                              child: Container(),
                            ),
                            isPreview
                                ? Container()
                                : FlickFullScreenToggle(
                                    enterFullScreenChild: LImage(
                                      "v_nofull_n",
                                      width: 18,
                                      height: 18,
                                    ),
                                    exitFullScreenChild: LImage(
                                      "v_nowfull_n",
                                      width: 18,
                                      height: 18,
                                    ),
                                    toggleFullscreen: () {
                                      if (kIsWeb) {
                                        html.VideoElement video = html.document
                                            .querySelector('video');
                                        video.muted = false;
                                        video.volume = 1;
                                        video.setAttribute(
                                            'playsinline', 'true');
                                        video.setAttribute('autoplay', 'true');
                                        if (html.document.fullscreenElement ==
                                            null) {
                                          video.enterFullscreen();
                                        } else {
                                          html.document.exitFullscreen();
                                        }
                                      } else {
                                        controlManager.toggleFullscreen();
                                      }
                                    },
                                  ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: ScreenUtil().setWidth(8)),
                        child: FlickVideoProgressBar(
                          flickProgressBarSettings: FlickProgressBarSettings(
                            height: 3,
                            handleRadius: 3,
                            backgroundColor: Colors.white24,
                            bufferedColor: Colors.white38,
                            playedColor: GQStyle.jellyCyanColor103224185,
                            handleColor: GQStyle.jellyCyanColor103224185,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        isPreview
            ? Positioned(
                right: 0,
                bottom: ScreenUtil().setWidth(40),
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    if (skiPreview != null) skiPreview();
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: ScreenUtil().setWidth(8)),
                    height: ScreenUtil().setWidth(30),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xff67e0b9).withAlpha((0.6 * 255).toInt()),
                          Color(0xff67e0b9).withAlpha((0.6 * 255).toInt()),
                          // Color.fromRGBO(0, 236, 252, 0.6),
                          // Color.fromRGBO(188, 233, 84, 0.6)
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(ScreenUtil().setWidth(15)),
                        bottomLeft: Radius.circular(ScreenUtil().setWidth(15)),
                      ),
                    ),
                    child: Center(
                      child: Text.rich(
                        TextSpan(
                            text: data.isfree == 2
                                ? "${AppGlobal.vipLevel > 0 ? data.discountCoins : data.coins}${CommonUtils.txt("kbtgyl")}"
                                : CommonUtils.txt("ktvptgyl"),
                            style: GQStyle.white255_12_B),
                      ),
                    ),
                  ),
                ),
              )
            : Container(),
        !flickVideoManager.videoPlayerValue.isInitialized ||
                flickDisplayManager.showPlayerControls
            ? Container()
            : Positioned(
                right: 0,
                left: 0,
                bottom: 0,
                child: FlickVideoProgressBar(
                  flickProgressBarSettings: FlickProgressBarSettings(
                    padding: EdgeInsets.only(bottom: 0),
                    height: 2,
                    handleRadius: 0,
                    curveRadius: 0,
                    backgroundColor: Colors.white24,
                    bufferedColor: Colors.white38,
                    playedColor: GQStyle.jellyCyanColor103224185,
                    handleColor: Colors.transparent,
                  ),
                ),
              ),
        showBack
            ? Positioned(
                top: ScreenUtil().setWidth(8),
                left: ScreenUtil().setWidth(8),
                child: noback
                    ? Container()
                    : Container(
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                                color: Color.fromRGBO(0, 0, 0, 0.2),
                                offset: Offset(0, 0),
                                blurRadius: ScreenUtil().setWidth(16))
                          ],
                        ),
                        child: GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          child: LImage("nav_back_w_n"),
                          onTap: () {
                            if (showBack) {
                              context.pop();
                            } else {
                              controlManager.toggleFullscreen();
                            }
                          },
                        ),
                      ),
              )
            : Container()
      ],
    );
  }
}
