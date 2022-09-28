import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qypj/model/animationDetail.dart';
import 'package:qypj/model/homedata.dart';
import 'package:qypj/model/videolist.dart';
import 'package:qypj/pages/cartoon/cartoon_endrawer.dart';
import 'package:qypj/utils/api.dart';
import 'package:qypj/utils/extensionlibrary.dart';
import 'package:qypj/utils/flick_small_video_normal.dart';
import 'package:qypj/theme/default.dart';
import 'package:qypj/utils/common.dart';
import 'package:qypj/utils/index.dart';

class SmallVideoDetail extends StatefulWidget {
  SmallVideoDetail({Key key, this.id}) : super(key: key);
  final String id;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SmallVideoDetailState();
  }
}

class _SmallVideoDetailState extends State<SmallVideoDetail> {
  VideoItem videoInfo;
  final GlobalKey<ScaffoldState> _sscaffoldKey = GlobalKey<ScaffoldState>();
  dynamic topic;

  @override
  void initState() {
    super.initState();
    initVideoPage();
    EventBus().on('OpenDrawerJJ', (arg) {
      topic = arg;
      _sscaffoldKey.currentState.openEndDrawer();
      setState(() {});
    });
  }

  initVideoPage() {
    getVideoDetail(id: widget.id).then((res) {
      if (res.status != 0) {
        DetailData data = res.data.detail;
        //模型转换
        videoInfo = VideoItem(
            cover_vertical: data.coverThumbVerticle,
            cover_horizontal: data.coverThumbHorizontal,
            id: data.id,
            isfree: data.isfree,
            member: Member.fromJson(data.member),
            count_comment: data.countComment,
            title: data.title,
            preview_url: data.preview_url,
            source_240: data.source240,
            favorites: data.favorites,
            duration: data.duration,
            coins: data.coins,
            discount_coins: data.discountCoins,
            userFavorites: data.userFavorites);
        setState(() {});
      } else {
        CommonUtils.showText(res.msg);
        context.pop();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: CartoonEndrawer(data: topic),
      endDrawerEnableOpenDragGesture: false,
      key: _sscaffoldKey,
      backgroundColor: GQStyle.bgColor,
      body: Stack(
        children: [
          videoInfo == null
              ? Container()
              : FlickSmallVideoNormal(data: videoInfo, bottom: 50),
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            child: IgnorePointer(
              child: Container(
                height: ScreenUtil().setWidth(116),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color.fromRGBO(0, 0, 0, 0.6),
                      Color.fromRGBO(0, 0, 0, 0.0)
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
              top: kIsWeb
                  ? ScreenUtil().setWidth(10)
                  : MediaQuery.of(context).padding.top +
                      ScreenUtil().setWidth(8),
              child: Container(
                height: GQStyle.navbarHegiht,
                padding: EdgeInsets.symmetric(horizontal: GQStyle.pagePadding),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            context.pop();
                          },
                          child: LImage(
                            'nav_back_n',
                            width: ScreenUtil().setWidth(22),
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
