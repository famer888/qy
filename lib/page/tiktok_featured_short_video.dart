import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:qypj/components/page_status.dart';
import 'package:qypj/mixin/general_video_mixin.dart';
import 'package:qypj/model/basic.dart';
import 'package:qypj/model/videolist.dart';
import 'package:qypj/utils/api.dart';
import 'package:qypj/utils/common.dart';
import 'package:qypj/utils/flick_small_video_normal.dart';

class TikTokFeaturedShortVideo extends StatefulWidget {
  TikTokFeaturedShortVideo({
    Key key,
    this.type = 0,
    this.topic_id,
    this.bottom = 20,
  }) : super(key: key);
  int type; //0 关注 1推荐 2合集
  String topic_id; //合集ID
  double bottom;

  @override
  _TikTokFeaturedShortVideoState createState() =>
      _TikTokFeaturedShortVideoState();
}

class _TikTokFeaturedShortVideoState extends State<TikTokFeaturedShortVideo>
    with GeneralVideoMinxin {
  List<VideoItem> videoList = [];
  int page = 1;
  bool isHud = true;
  bool noMore = false;
  String last_ix = "";
  PageController _pageController = PageController();

  List<Map<int, FlickManager>> videos = [];

  int loadMoreCount = 3;
  int preloadCount = 2;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _getData();
  }

  loadIndex(int target) async {
    currentIndex = target;
    var newIndex = target;
    //快速滑动取消缓存
    if (videos[newIndex][newIndex] == null) {
      if (videoList.length - newIndex <= loadMoreCount + 1) {
        page++;
        _getData();
      }
      return;
    }
    for (var x = 0; x < videoList.length; x++) {
      if (x < newIndex - preloadCount || x > newIndex + preloadCount) {
        if (videos[x][x] != null) {
          videos[x][x].dispose();
          videos[x][x] = null;
        }
        CommonUtils.debugPrint("释放控制器$x");
      }
    }

    for (var x = 1; x <= preloadCount; x++) {
      int subx = newIndex - x;
      if (subx >= 0) {
        if (videos[subx][subx] == null) {
          videos[subx][subx] = FlickManager(
              autoPlay: false,
              videoPlayerController: await initController(videoList[subx]));
        }
        CommonUtils.debugPrint("当前播放$newIndex--缓存前$subx");
      }
      int addx = newIndex + x;
      if (addx < videoList.length) {
        if (videos[addx][addx] == null) {
          videos[addx][addx] = FlickManager(
              autoPlay: false,
              videoPlayerController: await initController(videoList[addx]));
        }
        CommonUtils.debugPrint("当前播放$newIndex--缓存后$addx");
      }
    }
    //加载下一页
    if (videoList.length - newIndex <= loadMoreCount + 1) {
      page++;
      _getData();
    }
  }

  _getData() async {
    Basic res;
    if (widget.type == 0) {
      res = await cartoonFollowForyou(last_ix: last_ix, page: page);
    } else if (widget.type == 1) {
      res = await cartoonForyou(last_ix: last_ix, page: page);
    } else {
      res = await topicForVideoList(
          last_ix: last_ix, page: page, id: widget.topic_id);
    }
    if (res.status == 1) {
      last_ix = res.data["last_ix"] == null ? "" : res.data["last_ix"];
      List<VideoItem> st = List.from(res.data["list"])
          .map<VideoItem>((e) => VideoItem.fromJson(e))
          .toList();

      if (page == 1) {
        noMore = false;
        videoList = st;
        _createvcs(videoList);
      } else if (st.length > 0) {
        videoList.addAll(st);
        _createvcs(st);
      } else {
        noMore = true;
      }
      isHud = false;
    } else {
      CommonUtils.showText(res.msg);
    }
  }

  _createvcs(List t) async {
    if (kIsWeb) {
      setState(() {});
      return;
    }
    List<Map<int, FlickManager>> cvs = [];
    for (var x = 0; x < t.length; x++) {
      //只初始化前3个数据
      cvs.add({
        x: (x < 3 && page == 1)
            ? FlickManager(
                autoPlay: false,
                videoPlayerController: await initController(videoList[x]))
            : null
      });
    }
    if (page == 1) {
      videos = cvs;
    } else {
      videos.addAll(cvs);
    }
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return isHud
        ? PageStatus.loading(mounted)
        : videoList.length == 0
            ? PageStatus.noData()
            : PageView.builder(
                physics: QuickerScrollPhysics(),
                controller: _pageController,
                scrollDirection: Axis.vertical,
                itemCount: videoList.length,
                itemBuilder: (context, x) {
                  return kIsWeb
                      ? FlickSmallVideoNormal(
                          data: videoList[x],
                          vcDispose: () {
                            var p = _pageController.page;
                            if (p % 1 == 0) {
                              int index = p ~/ 1;
                              currentIndex = index;
                              //加载下一页
                              if (videoList.length - index <=
                                      loadMoreCount + 1 &&
                                  videoList.length > 0) {
                                page++;
                                CommonUtils.debugPrint("kisb====dasdasda");
                                _getData();
                              }
                            }
                          },
                          bottom: widget.bottom,
                        )
                      : FlickSmallVideoNormal(
                          data: videoList[x],
                          flickManager: videos[x][x],
                          vcDispose: () {
                            videos[x][x] = null;
                            CommonUtils.debugPrint("系统自动释放当前$x");
                            var p = _pageController.page;
                            if (p % 1 == 0) {
                              loadIndex(p ~/ 1);
                            }
                          },
                          bottom: widget.bottom,
                        );
                });
  }

  @override
  void dispose() {
    for (int x = 0; x < videos.length; x++) {
      if (videos[x][x] != null) {
        videos[x][x].dispose();
        videos[x][x] = null;
      }
    }
    videoList = [];
    _pageController.dispose();
    super.dispose();
    CommonUtils.debugPrint("dispose tiko vc");
  }
}

class QuickerScrollPhysics extends BouncingScrollPhysics {
  const QuickerScrollPhysics({ScrollPhysics parent}) : super(parent: parent);

  @override
  QuickerScrollPhysics applyTo(ScrollPhysics ancestor) {
    return QuickerScrollPhysics(parent: buildParent(ancestor));
  }

  @override
  SpringDescription get spring => SpringDescription.withDampingRatio(
        mass: 0.2,
        stiffness: 300.0,
        ratio: 1.1,
      );
}
