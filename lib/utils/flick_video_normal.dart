import 'package:bot_toast/bot_toast.dart';
import 'package:dio/dio.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qypj/components/yy_dialog.dart';
import 'package:qypj/global.dart';
import 'package:qypj/mixin/watchRecordMixin.dart';
import 'package:qypj/model/animationDetail.dart';
import 'package:qypj/model/homedata.dart';
import 'package:qypj/routers.dart';
import 'package:qypj/store/homeConfig.dart';
import 'package:qypj/theme/default.dart';
import 'package:qypj/utils/api.dart';
import 'package:qypj/utils/common.dart';
import 'package:qypj/utils/crypto.dart';
import 'package:qypj/utils/extensionlibrary.dart';
import 'package:qypj/utils/flick_video_pcontrols.dart';
import 'package:qypj/utils/networkImage.dart';
import 'package:qypj/utils/shelf_proxy.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:universal_html/html.dart' as html;
import 'package:visibility_detector/visibility_detector.dart';

class FlickVideoNormal extends StatefulWidget {
  FlickVideoNormal({
    Key key,
    this.isLocal = false,
    this.data,
    this.noback = false,
    this.autoPlay = true,
  }) : super(key: key);
  bool isLocal;
  bool noback;
  bool autoPlay;
  final DetailData data;

  @override
  FlickVideoNormalState createState() => FlickVideoNormalState();
}

class FlickVideoNormalState extends State<FlickVideoNormal>
    with WatchRecordMixin {
  FlickManager flickManager;
  bool isDone = false;
  bool isPrew = false;
  bool showAlert = false;

  @override
  void initState() {
    super.initState();
    initURL();
  }

  initChangeURL(DetailData ex) {
    widget.data.source240 = ex.source240;
    widget.data.preview_url = ex.preview_url;
    initURL(isNew: true);
  }

  initURL({bool isNew = false}) {
    String purl = "";
    if (widget.data.source240.length > 0) {
      isPrew = false;
      purl = widget.data.source240;
    } else if (widget.data.preview_url.length > 0) {
      isPrew = true;
      purl = widget.data.preview_url;
    }
    // purl = "http://172.104.35.32/m38/index.m3u8";
    CommonUtils.debugPrint(purl);
    if (kIsWeb) {
      if (AppGlobal.m3u8_encrypt == '1') {
        new Dio().get(purl).then((res) {
          String decrypted = PlatformAwareCrypto.decryptM3U8(res.data);
          final _blob =
              html.Blob([decrypted], 'application/x-mpegURL', 'native');
          final _url = html.Url.createObjectUrl(_blob);
          CommonUtils.debugPrint(_url);
          initPlayer(_url, isNew: isNew);
        });
      } else {
        initPlayer(purl, isNew: isNew);
      }
    } else if (!widget.isLocal) {
      if (AppGlobal.m3u8_encrypt == '1') {
        createServer(purl).then((proxyConfig) {
          String proxyurl =
              purl.replaceAll(proxyConfig['origin'], proxyConfig['localproxy']);
          initPlayer(proxyurl, isNew: isNew);
        });
      } else {
        initPlayer(purl, isNew: isNew);
      }
    } else {
      // 创建本地播放服务
      createStaticServer(purl).then((url) => initPlayer(url, isNew: isNew));
    }
  }

  initPlayer(String url, {bool isNew = false}) {
    if (!isNew) {
      flickManager = FlickManager(
          autoPlay: !kIsWeb,
          videoPlayerController: VideoPlayerController.network(url),
          onVideoEnd: () {
            isDone = true;
            if (!showAlert && isPrew) showAlertVp();
            setState(() {});
          });
    } else {
      //更改播放地址
      flickManager.handleChangeVideo(VideoPlayerController.network(url));
      isDone = false;
      showAlert = false;
    }
    setState(() {});
    //正式播放才会进行记录
    if (widget.data.source240.length == 0) return;
  }

  byVideoRes(int coins) {
    CommonUtils.startLoadGIF(tip: CommonUtils.txt("dhz"));
    buyVideo(id: widget.data.id, coins: coins, context: context).then((res) {
      //关闭加载动画
      BotToast.closeAllLoading();
      if (res.status != 0) {
        widget.data.source240 = res.data["url"];
        initURL(isNew: true);
      } else {
        CommonUtils.showText(res.msg);
      }
    });
  }

  showAlertVp({bool goby = false}) {
    Member member = Provider.of<HomeConfig>(context, listen: false).member;
    bool isInsufficient = member.money < widget.data.coins;
    if (goby && !isInsufficient) {
      byVideoRes(member.money - widget.data.coins); //直接购买
      return;
    }
    if (widget.data.isfree == 2) {
      YyShowDialog.showdialog(
        context,
        title: CommonUtils.txt('ts'),
        cancelText:
            isInsufficient ? CommonUtils.txt('qwcz') : CommonUtils.txt('gmgk'),
        btnText: CommonUtils.txt('fxdv'),
        callBack: () {
          context.push(CommonUtils.getRealHash('welfaretaskpage'));
        },
        cancelBack: () {
          if (isInsufficient) {
            context.push('/${Routes.coinRecharge}');
          } else {
            byVideoRes(member.money - widget.data.coins);
          }
        },
        content: (setDialogState) {
          return DefaultTextStyle(
            style: GQStyle.gray203_13,
            child: Column(
              children: [
                Text(CommonUtils.txt('gmspkwz'),
                    style: GQStyle.gray203_13, maxLines: 3),
                SizedBox(height: ScreenUtil().setWidth(15)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("${widget.data.coins}" + CommonUtils.txt('jb'),
                        style: GQStyle.blue80_13_M),
                  ],
                ),
                SizedBox(height: ScreenUtil().setWidth(15)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                        CommonUtils.txt('kyje') +
                            "：${member.money}" +
                            CommonUtils.txt('jb'),
                        style: GQStyle.gray203_13),
                  ],
                ),
              ],
            ),
          );
        },
      );
    } else {
      YyShowDialog.showdPNGDiaog(
        context,
        title: CommonUtils.txt('ts'),
        cancelText: CommonUtils.txt('cv'),
        btnText: CommonUtils.txt('fxdv'),
        cancelBack: () {
          context.push('/${Routes.vip}');
        },
        callBack: () {
          context.push(CommonUtils.getRealHash('welfaretaskpage'));
        },
        content: (setDialogState) {
          return DefaultTextStyle(
            style: GQStyle.gray203_13,
            child: Column(
              children: [
                Text(CommonUtils.txt('gmvkwz'), style: GQStyle.gray203_13),
                SizedBox(
                  height: ScreenUtil().setWidth(15),
                ),
                Text(
                  Provider.of<HomeConfig>(context, listen: false)
                      .config
                      .tips_share_text,
                  style: GQStyle.gray203_13,
                  maxLines: 3,
                ),
              ],
            ),
          );
        },
      );
    }
    //显示了弹窗
    showAlert = true;
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
                if (isPrew && isDone) return;
                flickManager.flickControlManager?.autoPause();
              } else if (visibility.visibleFraction == 1) {
                flickManager.flickControlManager?.autoResume();
              }
            },
            child: Container(
              child: FlickVideoPlayer(
                flickManager: flickManager,
                flickVideoWithControls: FlickVideoWithControls(
                  playerLoadingFallback: Stack(
                    children: [
                      PlatformAwareNetworkImage(
                          url: widget.data.coverThumbHorizontal ??
                              widget.data.coverThumbVerticle),
                      Container(color: Colors.black87)
                    ],
                  ),
                  playerErrorFallback: Container(),
                  videoFit: BoxFit.contain,
                  controls: FlickVideoPcontrols(
                    noback: widget.noback,
                    isPreview: isPrew,
                    isDone: isDone,
                    data: widget.data,
                    shareVp: () {
                      context.push(CommonUtils.getRealHash('welfaretaskpage'));
                    },
                    skiPreview: () {
                      showAlertVp();
                    },
                    nowToVp: () {
                      context.push('/${Routes.vip}');
                    },
                    nowByKb: () {
                      showAlertVp(goby: true);
                    },
                  ),
                ),
                flickVideoWithControlsFullscreen: FlickVideoWithControls(
                  playerErrorFallback: Container(),
                  videoFit: BoxFit.contain,
                  controls: FlickVideoPcontrols(
                      showBack: false, vtitle: widget.data.title),
                ),
              ),
            ),
          );
  }
}
