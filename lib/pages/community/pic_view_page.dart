import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qypj/components/common/pagetitlebar.dart';
import 'package:qypj/pages/community/pure_short_video_player.dart';
import 'package:qypj/utils/common.dart';
import 'package:qypj/utils/networkImage.dart';
import 'package:photo_view/photo_view_gallery.dart';

class PicViewPage extends StatefulWidget {
  PicViewPage({Key key, this.pramas}) : super(key: key);
  final Map pramas;

  @override
  _PicViewPageState createState() => _PicViewPageState();
}

class _PicViewPageState extends State<PicViewPage> {
  int currentIndex = 0;
  PageController _controller;
  List<GlobalKey> keyList = [];
  List<TransformationController> transformationControllerList = [];

  int _selectedIndex = 0;

  bool _scroolEnabled = true;

  @override
  void initState() {
    super.initState();
    widget.pramas['resources'].forEach((item) {
      GlobalKey _key = GlobalKey();
      TransformationController transformationController =
          TransformationController();
      transformationControllerList.add(transformationController);
      keyList.add(_key);
    });
    _controller = PageController(initialPage: widget.pramas['index']);
    _controller.addListener(() {
      if (_controller.page.toInt().toDouble() == _controller.page) {
        _selectedIndex = _controller.page.toInt();
        setState(() {});
      }
    });
    currentIndex = widget.pramas['index'];
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget comicButtom({String type, Function onTap}) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        if (onTap != null) {
          onTap();
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(7.5)),
        width: ScreenUtil().setWidth(45),
        height: ScreenUtil().setWidth(75),
        decoration: BoxDecoration(
            color: Color.fromRGBO(0, 0, 0, 0.7),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(
                    type == 'left' ? ScreenUtil().setWidth(37.5) : 10),
                topRight: Radius.circular(
                    type == 'left' ? 10 : ScreenUtil().setWidth(37.5)),
                bottomLeft: Radius.circular(
                    type == 'left' ? ScreenUtil().setWidth(37.5) : 10),
                bottomRight: Radius.circular(
                    type == 'left' ? 10 : ScreenUtil().setWidth(37.5)))),
        child: Row(
          textDirection: type == 'left' ? TextDirection.ltr : TextDirection.rtl,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            LImage(type == 'left' ? 'pre_left_n' : 'pre_right_n',
                width: ScreenUtil().setWidth(12.5),
                height: ScreenUtil().setWidth(16),
                fit: BoxFit.contain),
            DefaultTextStyle(
                style: TextStyle(
                    color: Colors.white, fontSize: ScreenUtil().setSp(12)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(type == 'left'
                        ? CommonUtils.txt("syz")
                        : CommonUtils.txt("xyz")),
                  ],
                ))
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
          child: Stack(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // PageTitleBar(title: CommonUtils.txt("mtxq")),
          Stack(
            children: [
              PhotoViewGallery.builder(
                pageController: _controller,
                itemCount: widget.pramas['resources'].length,
                onPageChanged: (index) {
                  // var e = widget.pramas['resources'][index];
                  // if (e['type'] == 2) AppGlobal.videoPageIsActive = true;
                },
                builder: (context, index) {
                  var e = widget.pramas['resources'][index];
                  Widget widget1;
                  if (e['type'] == 2) {
                    CommonUtils.debugPrint(e['url']);
                    widget1 = PureShortVideoPlayer(
                      url: e['url'] ?? e['media_url'],
                      cover_url: e['video_cover'] ?? e['cover'],
                    );

                    return PhotoViewGalleryPageOptions.customChild(
                        initialScale: 1.0,
                        minScale: 1.0,
                        maxScale: 10.0,
                        disableGestures: true,
                        child: widget1);
                  } else {
                    widget1 = PlatformAwareNetworkImage(
                        background: Colors.black,
                        fit: BoxFit.contain,
                        url: CommonUtils.getThumb(e));
                    return PhotoViewGalleryPageOptions.customChild(
                        initialScale: 1.0,
                        minScale: 1.0,
                        maxScale: 10.0,
                        child: widget1);
                  }
                },
              ),
              widget.pramas['showNav'] == 0
                  ? Container()
                  : Positioned(
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
            ],
          ),
          widget.pramas['showNav'] == 0
              ? Container()
              : Container(
                  margin:
                      EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                  child: PageTitleBar()),
        ],
      )),
    );
  }
}
