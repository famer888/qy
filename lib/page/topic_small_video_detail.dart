import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qypj/model/videolist.dart';
import 'package:qypj/page/tiktok_featured_short_video.dart';
import 'package:qypj/pages/cartoon/cartoon_endrawer.dart';
import 'package:qypj/utils/extensionlibrary.dart';
import 'package:qypj/theme/default.dart';
import 'package:qypj/utils/common.dart';
import 'package:qypj/utils/index.dart';

class TopicSmallVideoDetail extends StatefulWidget {
  TopicSmallVideoDetail({Key key, this.id}) : super(key: key);
  final String id;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _TopicSmallVideoDetailState();
  }
}

class _TopicSmallVideoDetailState extends State<TopicSmallVideoDetail> {
  final GlobalKey<ScaffoldState> _tscaffoldKey = GlobalKey<ScaffoldState>();
  dynamic topic;

  @override
  void initState() {
    super.initState();
    EventBus().on('OpenDrawerJJ', (arg) {
      topic = arg;
      _tscaffoldKey.currentState.openEndDrawer();
      setState(() {});
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
      key: _tscaffoldKey,
      backgroundColor: GQStyle.bgColor,
      body: Stack(
        children: [
          TikTokFeaturedShortVideo(type: 2, topic_id: widget.id, bottom: 50),
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
