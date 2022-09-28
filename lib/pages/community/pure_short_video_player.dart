import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qypj/mixin/general_video_mixin.dart';
import 'package:qypj/model/videolist.dart';
import 'package:qypj/theme/default.dart';
import 'package:qypj/utils/common.dart';
import 'package:qypj/utils/networkImage.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class PureShortVideoPlayer extends StatefulWidget {
  PureShortVideoPlayer({Key key, this.cover_url, this.url}) : super(key: key);

  final String url;
  final String cover_url;

  @override
  _PureShortVideoPlayerState createState() => _PureShortVideoPlayerState();
}

class _PureShortVideoPlayerState extends State<PureShortVideoPlayer>
    with GeneralVideoMinxin {
  FlickManager flickManager;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initURL();
  }

  initURL() async {
    VideoItem data = VideoItem(source_240: widget.url, preview_url: "");
    flickManager = FlickManager(
        autoPlay: !kIsWeb, videoPlayerController: await initController(data));
    setState(() {});
  }

  @override
  void dispose() {
    flickManager.dispose();
    super.dispose();
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
              } else if (visibility.visibleFraction == 1) {
                flickManager.flickControlManager?.autoResume();
              }
            },
            child: Container(
              child: FlickVideoPlayer(
                flickManager: flickManager,
                flickVideoWithControls: FlickVideoWithControls(
                  videoFit: BoxFit.contain,
                  playerErrorFallback: Container(),
                  playerLoadingFallback: Stack(
                    children: [
                      Positioned.fill(
                        child: PlatformAwareNetworkImage(url: widget.cover_url),
                      ),
                      Center(
                        child: Container(
                          height: ScreenUtil().setWidth(50),
                          width: ScreenUtil().setWidth(50),
                          child: CircularProgressIndicator(
                            backgroundColor: Colors.grey[200],
                            valueColor: AlwaysStoppedAnimation(
                              Color.fromRGBO(0, 237, 253, 1.0),
                            ),
                            strokeWidth: 1.0,
                          ),
                        ),
                      )
                    ],
                  ),
                  controls: Stack(
                    children: [
                      Positioned.fill(
                          child: FlickShowControlsAction(
                        child: Center(
                          child: FlickAutoHideChild(
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
                      )),
                      Positioned(
                        left: GQStyle.pagePadding,
                        right: GQStyle.pagePadding,
                        bottom: 0,
                        child: FlickAutoHideChild(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
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
                                                fontSize:
                                                    ScreenUtil().setSp(12)),
                                          ),
                                          FlickTotalDuration(
                                            color: Colors.white60,
                                            fontSize: ScreenUtil().setSp(12),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: ScreenUtil().setWidth(10)),
                                  FlickVideoProgressBar(
                                    flickProgressBarSettings:
                                        FlickProgressBarSettings(
                                      padding: EdgeInsets.only(
                                          bottom: ScreenUtil().setWidth(50)),
                                      height: 3,
                                      handleRadius: 3,
                                      curveRadius: 3,
                                      backgroundColor: Colors.white24,
                                      bufferedColor: Colors.white38,
                                      playedColor: Colors.white,
                                      handleColor: Colors.white,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                flickVideoWithControlsFullscreen: FlickVideoWithControls(
                  controls: Container(),
                ),
              ),
            ),
          );
  }
}
