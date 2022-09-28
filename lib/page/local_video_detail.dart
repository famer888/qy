import 'package:bot_toast/bot_toast.dart';
import 'package:fijkplayer/fijkplayer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qypj/ijktool/fijkplayer_skin.dart';
import 'package:qypj/model/animationDetail.dart';
import 'package:qypj/utils/flick_video_normal.dart';

// 这里实现一个皮肤显示配置项
class LPlayerShowConfig implements ShowConfigAbs {
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

class LocalVideoDetail extends StatefulWidget {
  LocalVideoDetail({Key key, this.videoInfo}) : super(key: key);
  final dynamic videoInfo;
  @override
  _LocalVideoDetailState createState() => _LocalVideoDetailState();
}

class _LocalVideoDetailState extends State<LocalVideoDetail> {
  DetailData td;
  // FijkPlayer实例
  FijkPlayer player = FijkPlayer();
  ShowConfigAbs vCfg = LPlayerShowConfig();

  @override
  void initState() {
    super.initState();
    td = DetailData(
      source240: widget.videoInfo["url"],
      title: widget.videoInfo["title"],
      coverThumbHorizontal: widget.videoInfo["cover_horizontal"],
      coverThumbVerticle: widget.videoInfo["cover_vertical"],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            //预留状态栏
            height: MediaQuery.of(context).padding.top,
            color: Colors.black,
          ),
          Container(
            height: ScreenUtil().screenWidth * 9 / 16,
            width: double.infinity,
            color: Colors.black45,
            child: FijkView(
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
                  videoInfo: td,
                  player: player,
                  viewSize: viewSize,
                  texturePos: texturePos,
                  pageContent: context,
                  showConfig: vCfg,
                  isLocal: true,
                );
              },
            ),
            // child: FlickVideoNormal(
            //   data: td,
            //   isLocal: true,
            // ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    player.release();
    super.dispose();
  }
}
