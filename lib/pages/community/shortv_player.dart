// ignore_for_file: non_constant_identifier_names
import 'package:bot_toast/bot_toast.dart';
import 'package:fijkplayer/fijkplayer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qypj/ijktool/fijkplayer_skin.dart';
import 'package:qypj/model/animationDetail.dart';
import 'package:qypj/theme/default.dart';
import 'package:qypj/utils/api.dart';
import 'package:qypj/utils/common.dart';
import 'package:qypj/utils/flick_video_normal.dart';
import 'package:qypj/utils/networkImage.dart';

class ShortVPlayer extends StatefulWidget {
  const ShortVPlayer({
    Key key,
    this.cover_url = "",
    this.url = "",
    this.isSimple = false,
    this.coins = 0,
    this.id = 0,
  }) : super(key: key);
  final String url;
  final String cover_url;
  final bool isSimple;
  final int coins;
  final int id;

  @override
  State<ShortVPlayer> createState() => _ShortVPlayerState();
}

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

class _ShortVPlayerState extends State<ShortVPlayer> {
  DetailData videoInfo = DetailData();
  FijkPlayer player = FijkPlayer();
  ShowConfigAbs vCfg = PlayerShowConfig();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    videoInfo.source240 = widget.url;
    videoInfo.preview_url = '';
    videoInfo.coverThumbHorizontal = widget.cover_url;
    videoInfo.coverThumbVerticle = widget.cover_url;
    videoInfo.title = '';
    // initURL();
  }

  @override
  void dispose() {
    if (!kIsWeb) player.release();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return videoInfo.source240.isEmpty && widget.coins > 0
        ? Stack(
            children: [
              PlatformAwareNetworkImage(
                url: widget.cover_url,
                fit: BoxFit.contain,
              ),
              Container(color: Colors.black87),
              Center(
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    CommonUtils.startLoadGIF();
                    reqGetPostURL(id: widget.id).then((value) {
                      BotToast.closeAllLoading();
                      if (value.status == 1) {
                        videoInfo.source240 = value.data['url'] ?? '';
                        setState(() {});
                      } else {
                        CommonUtils.showText(value.msg ?? '');
                      }
                    });
                  },
                  child: Container(
                    height: 34.w,
                    width: 130.w,
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(96, 178, 220, 0.9),
                        borderRadius: BorderRadius.all(Radius.circular(17.w))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        LImage('video_coin_n', width: 18.w, height: 17.w),
                        SizedBox(width: 2.w),
                        Text("${widget.coins}${CommonUtils.txt('jbjsgk')}",
                            style: GQStyle.white12)
                      ],
                    ),
                  ),
                ),
              )
            ],
          )
        : kIsWeb
            ? FlickVideoNormal(
                data: videoInfo,
                isLocal: false,
                noback: true,
              )
            : FijkView(
                color: Colors.black,
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
                    noback: true,
                    videoInfo: videoInfo,
                    player: player,
                    viewSize: viewSize,
                    texturePos: texturePos,
                    pageContent: context,
                    showConfig: vCfg,
                    isLocal: false,
                  );
                },
              );
  }
}
