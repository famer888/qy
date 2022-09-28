import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qypj/global.dart';
import 'package:qypj/model/videolist.dart';
import 'package:qypj/theme/default.dart';
import 'package:qypj/utils/api.dart';
import 'package:qypj/utils/common.dart';
import 'package:qypj/utils/extensionlibrary.dart';
import 'package:qypj/utils/index.dart';
import 'package:qypj/utils/networkImage.dart';
import 'package:provider/provider.dart';

class FlickSmallVideoPcontrols extends StatelessWidget {
  const FlickSmallVideoPcontrols({
    Key key,
    this.iconSize = 38,
    this.vtitle = "",
    this.isPreview = false,
    this.isDone = false,
    this.data,
    this.alertBack,
    this.refreshBack,
    this.reviewBack,
    this.bottom = 20,
  }) : super(key: key);
  final double iconSize;
  final double bottom;
  final String vtitle;
  final bool isPreview;
  final bool isDone;
  final VideoItem data;
  final Function(int) refreshBack; //点赞刷新
  final Function alertBack; //弹窗回调
  final Function reviewBack; //评论回调

  @override
  Widget build(BuildContext context) {
    return _noConditionWidget(context);
  }

  Widget _noConditionWidget(BuildContext context) {
    FlickVideoManager flickVideoManager =
        Provider.of<FlickVideoManager>(context);
    FlickControlManager controlManager =
        Provider.of<FlickControlManager>(context);
    bool flag = (flickVideoManager.videoPlayerValue.isBuffering &&
            flickVideoManager.videoPlayerValue.isPlaying) ||
        !flickVideoManager.videoPlayerValue.isInitialized;

    return Stack(
      children: <Widget>[
        Positioned.fill(
          child: FlickShowControlsAction(
            handleVideoTap: () {
              if (flag) return;
              flickVideoManager.isVideoEnded
                  ? controlManager.replay()
                  : controlManager.togglePlay();
            },
            child: Center(
              child: flag
                  ? Container(
                      height: ScreenUtil().setWidth(50),
                      width: ScreenUtil().setWidth(50),
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.grey[200],
                        valueColor: AlwaysStoppedAnimation(
                          Color.fromRGBO(0, 237, 253, 1.0),
                        ),
                        strokeWidth: 1.0,
                      ),
                    )
                  : FlickAutoHideChild(
                      showIfVideoNotInitialized: false,
                      child: FlickPlayToggle(
                        replayChild: LImage(
                          "v_replay_n",
                          width: ScreenUtil().setWidth(50),
                          height: ScreenUtil().setWidth(50),
                        ),
                        playChild: LImage(
                          "v_play_n",
                          width: ScreenUtil().setWidth(50),
                          height: ScreenUtil().setWidth(50),
                        ),
                        pauseChild: LImage(
                          "v_pause_n",
                          width: ScreenUtil().setWidth(50),
                          height: ScreenUtil().setWidth(50),
                        ),
                      ),
                    ),
            ),
          ),
        ),
        Positioned(
            child: Container(
                height: double.infinity,
                width: double.infinity,
                child: Stack(
                  children: [
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: IgnorePointer(
                        child: Container(
                          height: ScreenUtil().setWidth(300),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color.fromRGBO(0, 0, 0, 0.7),
                                Color.fromRGBO(0, 0, 0, 0.0)
                              ],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                        bottom: ScreenUtil().setWidth(30 + bottom * 2),
                        left: 0,
                        right: 0,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: GQStyle.pagePadding),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      _identiWidget(),
                                      SizedBox(
                                        width: ScreenUtil().screenWidth -
                                            ScreenUtil().setWidth(26 + 10 + 50),
                                        child: Text(
                                          data.title,
                                          style: GQStyle.white255_18_M,
                                          maxLines: 3,
                                        ),
                                      ),
                                      SizedBox(
                                          height: ScreenUtil().setWidth(13)),
                                      Text(
                                        "@${data.member.nickname ?? "loading"}",
                                        style: GQStyle.white255_13_M,
                                      ),
                                    ],
                                  ),
                                  SizedBox(width: ScreenUtil().setWidth(10)),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Container(
                                        width: ScreenUtil().setWidth(50),
                                        height: ScreenUtil().setWidth(58.5),
                                        child: Stack(
                                          children: [
                                            SizedBox(
                                              height: ScreenUtil().setWidth(50),
                                              width: ScreenUtil().setWidth(50),
                                              child: GestureDetector(
                                                onTap: () {
                                                  context.push(
                                                      '/mineUserCenter/${data.member.aff}');
                                                },
                                                child:
                                                    PlatformAwareNetworkImage(
                                                  imageName: "flj_logo_icon",
                                                  fit: BoxFit.cover,
                                                  url: data.member.thumb ?? "",
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(
                                                      ScreenUtil().setWidth(25),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              left: ScreenUtil().setWidth(16.5),
                                              bottom: 0,
                                              child: GestureDetector(
                                                behavior:
                                                    HitTestBehavior.translucent,
                                                onTap: () {
                                                  if (data.member.is_follow ==
                                                      1) return;
                                                  communityFollowUser(
                                                          aff: data.member.aff
                                                              .toString())
                                                      .then((res) {
                                                    if (res.status == 1) {
                                                      data.member
                                                          .is_follow = data
                                                                  .member
                                                                  .is_follow ==
                                                              1
                                                          ? 0
                                                          : 1;
                                                      if (refreshBack != null) {
                                                        refreshBack(0);
                                                      }
                                                    } else {
                                                      CommonUtils.showText(
                                                          res.msg);
                                                    }
                                                  });
                                                },
                                                child: LImage(
                                                  data.member.is_follow == 1
                                                      ? "sv_follow_h"
                                                      : "sv_follow_n",
                                                  width:
                                                      ScreenUtil().setWidth(17),
                                                  height:
                                                      ScreenUtil().setWidth(17),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                          height: ScreenUtil().setWidth(20)),
                                      GestureDetector(
                                        onTap: () {
                                          userSmallFavorites(id: data.id)
                                              .then((res) {
                                            if (res.status == 1) {
                                              data.userFavorites =
                                                  data.userFavorites == 1
                                                      ? 0
                                                      : 1;
                                              data.userFavorites == 1
                                                  ? data.favorites++
                                                  : data.favorites--;
                                              if (refreshBack != null) {
                                                refreshBack(0);
                                              }
                                            } else {
                                              CommonUtils.showText(res.msg);
                                            }
                                          });
                                        },
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            LImage(
                                              data.userFavorites == 1
                                                  ? "sv_lke_n"
                                                  : "sv_unlke_n",
                                              width: ScreenUtil().setWidth(36),
                                              height: ScreenUtil().setWidth(36),
                                            ),
                                            SizedBox(
                                              height: ScreenUtil().setWidth(4),
                                            ),
                                            Text(
                                                CommonUtils.renderNumber(
                                                    data.favorites),
                                                style: GQStyle.white255_13_B)
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: ScreenUtil().setWidth(20),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          if (reviewBack != null) {
                                            reviewBack();
                                          }
                                        },
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            LImage(
                                              'sv_review_n',
                                              width: ScreenUtil().setWidth(36),
                                              height: ScreenUtil().setWidth(36),
                                            ),
                                            SizedBox(
                                              height: ScreenUtil().setWidth(4),
                                            ),
                                            Text(
                                                CommonUtils.renderNumber(
                                                    data.count_comment),
                                                style: GQStyle.white255_13_B)
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: ScreenUtil().setWidth(20),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          context.push(CommonUtils.getRealHash(
                                              'kwantsharetousers'));
                                        },
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            LImage(
                                              'sv_share_n',
                                              width: ScreenUtil().setWidth(36),
                                              height: ScreenUtil().setWidth(36),
                                            ),
                                            SizedBox(
                                              height: ScreenUtil().setWidth(4),
                                            ),
                                            Text(CommonUtils.txt('fx'),
                                                style: GQStyle.white255_13_B)
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: ScreenUtil().setWidth(
                                            data.topic == null ? 0 : 20),
                                      ),
                                      data.topic == null
                                          ? Container()
                                          : GestureDetector(
                                              onTap: () {
                                                if (refreshBack != null) {
                                                  refreshBack(1);
                                                }
                                                EventBus().emit(
                                                    'OpenDrawerJJ', {
                                                  "topic": data.topic,
                                                  "vid": data.id
                                                });
                                              },
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  LImage(
                                                    'sv_sel_n',
                                                    width: ScreenUtil()
                                                        .setWidth(36),
                                                    height: ScreenUtil()
                                                        .setWidth(36),
                                                  ),
                                                  SizedBox(
                                                    height: ScreenUtil()
                                                        .setWidth(4),
                                                  ),
                                                  Text(CommonUtils.txt('xuanj'),
                                                      style:
                                                          GQStyle.white255_13_B)
                                                ],
                                              ),
                                            )
                                    ],
                                  )
                                ],
                              ),
                            ],
                          ),
                        )),
                    Positioned(
                        left: GQStyle.pagePadding,
                        right: GQStyle.pagePadding,
                        bottom: 0,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        FlickCurrentPosition(
                                          color: Colors.white60,
                                          fontSize: ScreenUtil().setSp(12),
                                        ),
                                        Text(
                                          ' / ',
                                          style: TextStyle(
                                              color: Colors.white60,
                                              fontSize: ScreenUtil().setSp(12)),
                                        ),
                                        FlickTotalDuration(
                                          color: Colors.white60,
                                          fontSize: ScreenUtil().setSp(12),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                                FlickVideoProgressBar(
                                  flickProgressBarSettings:
                                      FlickProgressBarSettings(
                                    padding: EdgeInsets.symmetric(
                                        vertical:
                                            ScreenUtil().setWidth(bottom)),
                                    height: 3,
                                    handleRadius: 3,
                                    curveRadius: 3,
                                    backgroundColor: Colors.white24,
                                    bufferedColor: Colors.white38,
                                    playedColor: Color(0xFF00edfd),
                                    handleColor: Color(0xFF00edfd),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ))
                  ],
                ))),
      ],
    );
  }

  Widget _identiWidget() {
    if (data.source_240.length > 0) {
      return Container();
    }
    int level = 0;
    if (data.isfree == 1 && AppGlobal.vipLevel < 1) {
      //不是VIP用户、视频是VIP权限
      level = 0;
    }

    if (data.isfree == 2) {
      //不管是不是VIP用户、视频是扣币权限
      level = 1;
    }
    return GestureDetector(
      onTap: () {
        if (alertBack != null) alertBack();
      },
      child: Container(
        margin: EdgeInsets.only(bottom: ScreenUtil().setWidth(18)),
        padding: EdgeInsets.symmetric(horizontal: GQStyle.pagePadding),
        height: ScreenUtil().setWidth(28),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(4)),
            gradient: LinearGradient(
              colors: [
                Color(level == 0 ? 0xFFff7d3e : 0xFF89cefc),
                Color(level == 0 ? 0xFFffcd3b : 0xFF058ce9)
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            )),
        child: level == 0
            ? Row(
                children: [
                  Text(
                      CommonUtils.txt("ktvcwzb") +
                          " ⌈${CommonUtils.getHMTime(data.duration)}⌋",
                      style: GQStyle.white127_11_B)
                ],
              )
            : Center(
                child: Text(
                "${(AppGlobal.vipLevel > 0 ? data.discount_coins : data.coins)}${CommonUtils.txt("jbjsw")} ⌈${CommonUtils.getHMTime(data.duration)}⌋",
                style: GQStyle.white255_11_B,
              )),
      ),
    );
  }
}
