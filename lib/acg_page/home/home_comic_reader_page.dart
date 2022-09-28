import 'dart:async';
import 'dart:math';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import 'package:qypj/model/comicsData.dart';
import 'package:qypj/store/homeConfig.dart';
import 'package:qypj/theme/default.dart';
import 'package:qypj/utils/crypto.dart';
import 'package:qypj/utils/extensionlibrary.dart';
import 'package:qypj/components/gestureZoomBox.dart';
import 'package:qypj/components/page_status.dart';
import 'package:qypj/components/scrollablePositionedList/item_positions_listener.dart';
import 'package:qypj/components/scrollablePositionedList/scrollable_positioned_list.dart';
import 'package:qypj/components/yy_dialog.dart';
import 'package:qypj/global.dart';
import 'package:qypj/mixin/watchRecordMixin.dart';
import 'package:qypj/pages/details/comicsImg.dart';
import 'package:qypj/routers.dart';
import 'package:qypj/utils/api.dart';
import 'package:qypj/utils/common.dart';
import 'package:qypj/utils/index.dart';
import 'package:qypj/utils/networkImage.dart';
import 'package:provider/provider.dart';
import 'package:qypj/model/comicsDetail.dart';
// import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class HomeComicReaderPage extends StatefulWidget {
  final int id;
  final int episode;
  final String title;
  HomeComicReaderPage({Key key, this.id, this.episode, this.title})
      : super(key: key);

  @override
  _HomeComicReaderPageState createState() => _HomeComicReaderPageState();
}

class _HomeComicReaderPageState extends State<HomeComicReaderPage>
    with WatchRecordMixin {
  ItemScrollController comicScroll = ItemScrollController();
  ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();
  bool isHorizontal = false; //是否横向滑动
  int selectState = 1; //底部翻页控制器选择
  bool isAutomatic = false; //是否开启自动翻页
  int cureentIndex; //当前 X 话
  bool showPrompt = false; //展示提示
  bool isShow = true; //控制器的隐藏显示
  bool isTap = false; //正在控制器上操作
  double topOffset = 0; //垂直方向滑动记录
  double leftOffset = 0; //横向方向滑动记录
  int comicLength = 1; //漫画length
  bool automatic = false;
  int animationTime = 300;
  bool intPage = true;
  Axis scrollDirection = Axis.vertical;
  Map controllerOffset;
  bool isFavorites = false; // 是否收藏
  bool isLike = false; // 是否点赞
  Data data;
  bool ascend = true; //排序 升序还是降序

  Map loadedImgs = {}; // 已经加载过的图片 超过100或更多直接清空缓存

  // List episodeList = [];
  List timeList = [
    1,
    1.5,
    2,
    2.5,
    3,
    3.5,
    4,
    4.5,
    5,
    5.5,
    6,
    6.5,
    7,
    7.5,
    8,
    8.5,
    9,
    9.5,
    10
  ];
  List comicsData;
  int defaultTime = 8;
  Timer _timer;
  int currenPage = 0;
  bool loading = true;
  double leftDx;
  double leftDxb;
  GlobalKey _key = GlobalKey();
  GlobalKey _keyb = GlobalKey();
  int randomIndex;
  _getRenderBox(_) {
    //获取`RenderBox`对象
    RenderBox renderBox = _key.currentContext.findRenderObject();
    Offset offset = renderBox.localToGlobal(Offset(0, 0));
    leftDx = offset.dx;
    RenderBox renderBoxb = _keyb.currentContext.findRenderObject();
    Offset offsetb = renderBoxb.localToGlobal(Offset(0, 0));
    leftDxb = offsetb.dx;
    var manhuaData = AppGlobal.manhuaWatchRecordBox.get(widget.id.toString());
    if (manhuaData != null && manhuaData[widget.episode] != null) {
      currenPage = manhuaData[widget.episode];
      setState(() {});
      comicScroll.jumpTo(index: manhuaData[widget.episode] + 1);
    }
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    cureentIndex = widget.episode;

    data = AppGlobal.comicData;

    isFavorites = data.userFavorites == 1;
    isLike = data.userLike == 1;
    getPageDetail();
  }

  Future _itemCatalogAlertBottom() {
    return showModalBottomSheet(
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setBottomSheetState) {
            return Container(
              height: ScreenUtil().screenHeight * 0.7,
              padding: EdgeInsets.only(
                  left: GQStyle.pagePadding,
                  right: GQStyle.pagePadding,
                  top: ScreenUtil().setWidth(20)),
              decoration: BoxDecoration(
                  color: Color(0xff23262f),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(ScreenUtil().setWidth(15)),
                      topRight: Radius.circular(ScreenUtil().setWidth(15)))),
              child: Column(
                children: [
                  Container(
                    height: ScreenUtil().setWidth(40),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                // constraints: BoxConstraints(
                                //     maxWidth: ScreenUtil().setWidth(200)),
                                child: Text(
                                  widget.title,
                                  style: GQStyle.jellyCyan_15_M,
                                ),
                              ),
                              Text(
                                CommonUtils.txt('gx') +
                                    CommonUtils.txt('sj') +
                                    '：' +
                                    data.updateTime,
                                style: GQStyle.white255_11,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: ScreenUtil().setWidth(10)),
                        GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () {
                            ascend = !ascend;
                            setBottomSheetState(() {});
                          },
                          child: Container(
                            height: double.infinity,
                            child: Row(
                              children: [
                                Text(
                                  CommonUtils.txt("zxu"),
                                  style: GQStyle.jellyCyan_11,
                                ),
                                Container(
                                  color: GQStyle.cyanColor00edfd,
                                  width: 1,
                                  height: ScreenUtil().setWidth(7),
                                  margin: EdgeInsets.symmetric(
                                      horizontal: ScreenUtil().setWidth(7)),
                                ),
                                Text(
                                  CommonUtils.txt("dxu"),
                                  style: GQStyle.jellyCyan_11,
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: ScreenUtil().setWidth(17)),
                  Expanded(child: _episdItem(sortAscend: ascend))
                ],
              ),
            );
          });
        });
  }

  Widget _episdItem({bool sortAscend = false}) {
    List list = AppGlobal.blues;

    List temp;

    if (sortAscend) {
      temp = list;
    } else {
      temp = [];
      for (var item in AppGlobal.blues) {
        temp.insert(0, item);
      }
    }
    return GridView.count(
      // physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.only(
          bottom: max(MediaQuery.of(context).padding.bottom,
              ScreenUtil().setWidth(20))),
      // shrinkWrap: true,
      crossAxisCount: 4,
      mainAxisSpacing: ScreenUtil().setWidth(10),
      crossAxisSpacing: ScreenUtil().setWidth(10),
      childAspectRatio: 80 / 40,
      children: temp.asMap().keys.map((index) {
        dynamic e = temp[index];
        return GestureDetector(
          onTap: () {
            context.pop();
            swichComic(e["episode"], replace: true);
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 2),
            decoration: BoxDecoration(
                color: Color(0xff26313b),
                borderRadius: BorderRadius.circular(5),
                border: cureentIndex == e["episode"]
                    ? Border.all(
                        color: GQStyle.cyanColor00edfd, width: 1) //当前章节 高亮显示
                    : Border.all(color: Colors.transparent, width: 0)),
            child: Align(
                alignment: Alignment.center,
                child: Text(
                  '${temp[index]['episode_title']}',
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(12),
                    color: Colors.white,
                    overflow: TextOverflow.ellipsis,
                  ),
                  maxLines: 2,
                )),
          ),
        );
      }).toList(),
    );
  }

  swichComic(int episode, {bool replace = false}) {
    if (episode == cureentIndex) return;

    dynamic e =
        AppGlobal.blues.where((element) => element["episode"] == episode).first;

    if (e["is_pay"] == 1 || e["is_free"] == 0) {
      context.push(
          CommonUtils.getRealHash().replaceAll(RegExp(r"comicReader/.*"),
              'comicReader/${widget.id}/$episode/${Uri.encodeComponent(widget.title)}'),
          replace: replace);
      return;
    }
    if (e["is_free"] == 1 && AppGlobal.vipLevel > 0) {
      context.push(
          CommonUtils.getRealHash().replaceAll(RegExp(r"comicReader/.*"),
              'comicReader/${widget.id}/$episode/${Uri.encodeComponent(widget.title)}'),
          replace: replace);
      return;
    }
    if (e["is_free"] == 1 && AppGlobal.vipLevel < 1) {
      YyShowDialog.showdPNGDiaog(
        context,
        title: CommonUtils.txt("ts"),
        content: (setDialogState) {
          return Text(
            CommonUtils.txt("kthycd"),
            style: GQStyle.graya3a2a2_13,
          );
        },
        cancelText: CommonUtils.txt("qx"),
        btnText: CommonUtils.txt("ljkt"),
        showUpCloseBtn: true,
        callBack: () {
          context.push('/${Routes.vip}');
        },
      );
      return;
    }
    if (e["is_free"] == 2) {
      if (AppGlobal.isAutoBy) {
        _byComicChapter(episode, replace, e);
        return;
      }
      //扣币
      WidgetsBinding.instance.addPostFrameCallback((_) {
        int money =
            Provider.of<HomeConfig>(context, listen: false).member.money;
        bool isInsufficient = money < e["view_money"];

        if (isInsufficient) {
          _itemInsufficientAlertBottom(episode, replace, e);
        } else {
          _itemBuyAlertBottom(episode, replace, e);
        }
      });
      setState(() {});
    }
  }

  /// 弹出金币不足提示
  Future _itemInsufficientAlertBottom(
      int episode, bool replace, dynamic e) async {
    int money = Provider.of<HomeConfig>(context, listen: false).member.money;

    return showModalBottomSheet(
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setBottomSheetState) {
            return Container(
              // height: ScreenUtil().setWidth(180),
              padding: EdgeInsets.only(
                  left: ScreenUtil().setWidth(17.5),
                  right: ScreenUtil().setWidth(17.5),
                  top: ScreenUtil().setWidth(20),
                  bottom: ScreenUtil().setWidth(25)),
              decoration: BoxDecoration(
                  color: Color(0xff23262f),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(ScreenUtil().setWidth(15)),
                      topRight: Radius.circular(ScreenUtil().setWidth(15)))),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(width: ScreenUtil().setWidth(10)),
                      Text(CommonUtils.txt('zfts'),
                          style: GQStyle.white255_18_M),
                      GestureDetector(
                        onTap: () {
                          context.pop();
                        },
                        child: LImage(
                          'alert_close_n',
                          color: Colors.white,
                          width: ScreenUtil().setWidth(10),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: ScreenUtil().setWidth(25)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            CommonUtils.txt('jb') + CommonUtils.txt('ye') + ':',
                            style: GQStyle.white255_13,
                          ),
                          SizedBox(width: ScreenUtil().setWidth(5)),
                          Text(
                            '$money',
                            style: GQStyle.jellyCyan_18_M,
                          ),
                        ],
                      ),
                      RichText(
                          text: TextSpan(children: [
                        TextSpan(
                          text: CommonUtils.txt('ybzqw'),
                          style: GQStyle.graya3a2a2_13,
                        ),
                        TextSpan(
                            text: CommonUtils.txt('cz'),
                            style: TextStyle(
                                color: Color(0xff00edfd),
                                fontSize: ScreenUtil().setSp(13),
                                overflow: TextOverflow.ellipsis,
                                decoration: TextDecoration.underline),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                context.pop();
                                context.push('/${Routes.coinRecharge}');
                              }),
                      ]))
                    ],
                  ),

                  Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: GQStyle.pagePadding),
                      child: Text(
                          '${CommonUtils.txt('gkhxh')}${e['view_money']}${CommonUtils.txt('jb')}\n${CommonUtils.txt('sfqrgk')}',
                          textAlign: TextAlign.center,
                          style: GQStyle.white255_13)),
                  GestureDetector(
                    onTap: () {
                      context.pop();
                      context.push('/${Routes.coinRecharge}');
                    },
                    child: SizedBox(
                        width: ScreenUtil().setWidth(300),
                        height: ScreenUtil().setWidth(32),
                        child: Stack(
                          children: [
                            // LImage('comic_buy_btn_bg'),
                            Positioned.fill(
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                      ScreenUtil().setWidth(16)),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        gradient: GQStyle
                                            .btnGradient_ff00edfd_ffbbe954),
                                  )),
                            ),
                            Center(
                              child: Text(
                                CommonUtils.txt('qr'),
                                style: GQStyle.white255_13,
                              ),
                            )
                          ],
                        )),
                  ),
                  // Text(
                  //   '更新时间：每周二更新2话',
                  //   style: GQStyle.white255_13,
                  // )
                ],
              ),
            );
          });
        });
  }

  /// 弹出购买
  Future _itemBuyAlertBottom(int episode, bool replace, dynamic e) async {
    int money = Provider.of<HomeConfig>(context, listen: false).member.money;

    return showModalBottomSheet(
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setBottomSheetState) {
            return Container(
              height: ScreenUtil().setWidth(180),
              padding: EdgeInsets.only(
                  left: ScreenUtil().setWidth(17.5),
                  right: ScreenUtil().setWidth(17.5),
                  top: ScreenUtil().setWidth(20),
                  bottom: ScreenUtil().setWidth(25)),
              decoration: BoxDecoration(
                  color: Color(0xff23262f),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(ScreenUtil().setWidth(15)),
                      topRight: Radius.circular(ScreenUtil().setWidth(15)))),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            CommonUtils.txt('jb') + CommonUtils.txt('ye') + ':',
                            style: GQStyle.white255_13,
                          ),
                          SizedBox(width: ScreenUtil().setWidth(5)),
                          Text(
                            '$money',
                            style: GQStyle.jellyCyan_18_M,
                          ),
                        ],
                      ),
                      GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          AppGlobal.isAutoBy = !AppGlobal.isAutoBy;
                          setBottomSheetState(() {});
                        },
                        child: Row(
                          children: [
                            LImage(
                                AppGlobal.isAutoBy
                                    ? 'comic_auto_buy_s'
                                    : 'comic_auto_buy_n',
                                width: ScreenUtil().setWidth(12)),
                            SizedBox(width: ScreenUtil().setWidth(5)),
                            Text(
                              '自动购买',
                              style: GQStyle.white255_13_M,
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      _byComicChapter(episode, replace, e);
                    },
                    child: SizedBox(
                        width: ScreenUtil().setWidth(300),
                        height: ScreenUtil().setWidth(32),
                        child: Stack(
                          children: [
                            // LImage('comic_buy_btn_bg'),
                            Positioned.fill(
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                      ScreenUtil().setWidth(16)),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        gradient: GQStyle
                                            .btnGradient_ff00edfd_ffbbe954),
                                  )),
                            ),
                            Center(
                              child: Text(
                                '${e["view_money"]}' +
                                    CommonUtils.txt('jb') +
                                    CommonUtils.txt('gm'),
                                style: GQStyle.white255_13,
                              ),
                            )
                          ],
                        )),
                  ),
                  Text(
                    CommonUtils.txt('gx') +
                        CommonUtils.txt('sj') +
                        '：' +
                        data.updateTime,
                    style: GQStyle.white255_13,
                  )
                ],
              ),
            );
          });
        });
  }

  _byComicChapter(int episode, bool replace, dynamic e) async {
    await comicChapterBy(book_id: widget.id, episode: episode).then((value) {
      if (value.status == 1) {
        e["is_pay"] = 1;
        // AppGlobal.isAutoBy = true;
        context.push(
            CommonUtils.getRealHash().replaceAll(RegExp(r"comicReader/.*"),
                'comicReader/${widget.id}/$episode/${Uri.encodeComponent(widget.title)}'),
            replace: replace);
      } else {
        AppGlobal.isAutoBy = false;
        CommonUtils.showText(value.msg);
      }
    });
  }

  getPageDetail() async {
    var res = await getComicReading(id: widget.id, episode: widget.episode);

    if (res.status != 0) {
      watchRcordTimer = Timer.periodic(new Duration(seconds: 2), (timer) {
        startWatchRecordTimer(AppGlobal.manhuaWatchRecordBox, widget.id,
            chapterId: widget.episode,
            offset: currenPage,
            thumb: AppGlobal.comicThumb,
            title: widget.title,
            desc: data.description ?? '');
      });
      comicsData = res.data;
      comicLength = res.data.length;
      controllerOffset = {
        'offsetLeft': 0.0, //页面进度
        'pageIndex': {'min': 1, 'max': res.data.length},
        'timeLeft': 0.0, //翻页间隔
        'timeIndex': {'min': 0, 'max': timeList.length}
      };
      loading = false;
      var segmet =
          ScreenUtil().setWidth(590) / controllerOffset['pageIndex']['max'];
      controllerOffset['offsetLeft'] = (currenPage + 1) * segmet;
      setState(() {});
      WidgetsBinding.instance.addPostFrameCallback(_getRenderBox);
    } else {
      CommonUtils.showText(res.msg);
      context.pop();
    }
  }

  @override
  void dispose() {
    super.dispose();
    EventBus().off('GETOFFSET');
    if (_timer != null && _timer.isActive) {
      _timer.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: GQStyle.bgColor,
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      child: loading
          ? PageStatus.loading(mounted)
          : Stack(
              overflow: Overflow.clip,
              children: [
                Column(
                  children: [
                    Expanded(
                        child: GestureZoomBox(
                      maxScale: 5.0,
                      isHorizontal: isHorizontal,
                      doubleTapScale: 2.0,
                      duration: Duration(milliseconds: 200),
                      onPressed: () {
                        isShow = !isShow;
                        setState(() {});
                      },
                      child: comicsPageView(),
                    ))
                  ],
                ),
                pageController(),
                // Center(
                //   child: GestureDetector(
                //     onTap: () async {
                //       int page = currenPage;
                //       for (var i = 0; i < 1000; i++) {
                //         await comicScroll.scrollTo(
                //             index: page + i,
                //             duration: Duration(milliseconds: 400));
                //       }
                //     },
                //     child: Container(
                //       width: 30,
                //       height: 30,
                //       color: Colors.red,
                //     ),
                //   ),
                // )
              ],
            ),
    );
  }

  nextPage() {
    var segmet =
        ScreenUtil().setWidth(295) / controllerOffset['pageIndex']['max'];
    // if (isShow) {
    //   isShow = false;
    // }
    if (currenPage < comicLength - 1) {
      currenPage++;
      controllerOffset['offsetLeft'] = (currenPage + 1) * segmet;
      comicScroll.jumpTo(index: currenPage);
    }
    setState(() {});
  }

  prevPage() {
    var segmet =
        ScreenUtil().setWidth(295) / controllerOffset['pageIndex']['max'];
    // if (isShow) {
    //   isShow = false;
    // }
    if (currenPage >= 1) {
      currenPage--;
      controllerOffset['offsetLeft'] = (currenPage + 1) * segmet;
      CommonUtils.debugPrint(currenPage);
      comicScroll.jumpTo(index: currenPage);
    }
    setState(() {});
  }

  // _removeImageCache() async {
  //   if (AppGlobal.imageCacheBox.isOpen && AppGlobal.imageCacheBox.isNotEmpty) {
  //     AppGlobal.imageCacheBox.deleteFromDisk();
  //     AppGlobal.imageCacheBox =
  //         await Hive.openBox('qypjbox_ImageCache'); //图片缓存
  //     CommonUtils.showText('imageCacheBox.deleteFromDisk()');
  //   }
  // }

  Widget comicsPageView() {
    // return SingleChildScrollView(
    //   child: Wrap(
    //       // shrinkWrap: true,
    //       children: comicsData.asMap().keys.map((index) {
    //     print('加载图片 index = $index');

    //     return ComicsImg(
    //         img: comicsData[index].imgUrl,
    //         isHorizontal: isHorizontal,
    //         width: comicsData[index].imgWidth == '0'
    //             ? ScreenUtil().screenWidth
    //             : double.parse(comicsData[index].imgWidth),
    //         height: comicsData[index].imgHeight == '0'
    //             ? ScreenUtil().screenHeight
    //             : double.parse(comicsData[index].imgHeight),
    //         isTap: isTap,
    //         index: index,
    //         currentIndex: currenPage,
    //         setPosition: (int position, double pageOffset) {
    //           currenPage = position;
    //           controllerOffset['offsetLeft'] = pageOffset;
    //           setState(() {});
    //         },
    //         length: comicLength);
    //   }).toList()),
    // );

    return Listener(
      onPointerDown: (PointerDownEvent e) {
        if (_timer != null && _timer.isActive) {
          _timer.cancel();
        }
      },
      onPointerUp: (PointerUpEvent e) {
        if (_timer != null && !_timer.isActive && isAutomatic) {
          int time = (timeList[defaultTime] * 1000).toInt();
          _timer = Timer.periodic(Duration(milliseconds: time), (timer) {
            autoPage();
          });
        }
      },
      child: ScrollablePositionedList.builder(
          physics: ClampingScrollPhysics(),
          scrollDirection: isHorizontal ? Axis.horizontal : Axis.vertical,
          itemScrollController: comicScroll,
          itemPositionsListener: itemPositionsListener,
          padding: EdgeInsets.only(top: 0),
          itemBuilder: (BuildContext context, int index) {
            // print('加载图片 index = $index');

            // if (kDebugMode) { // 多加载下一张图片 有时候会导致同一图片反复下
            //   int count = 1;
            //   if (index + count < comicsData.length) {
            //     for (var i = 0; i < count; i++) {
            //       CommonUtils.getRealImage(
            //           url: comicsData[index + i + 1].imgUrl);
            //     }
            //   }
            // }

            // PWA清除图片缓存的 好像没啥用 注释了
            // loadedImgs[index] = true;
            // if (loadedImgs.keys.length > 50) {
            //   AppGlobal.imageCacheBox.clear();
            //   loadedImgs.clear();
            //   PaintingBinding.instance.imageCache.clear();
            //   PaintingBinding.instance.imageCache.maximumSizeBytes = 0;
            //   // CommonUtils.showText(
            //   //     '清空_PaintingBinding.instance.imageCache.maximumSizeBytes = 100 << 20缓存');
            // } else {
            //   int size = PaintingBinding.instance.imageCache.currentSizeBytes;
            //   // CommonUtils.showText('index = $index 缓存size = $size');
            //   if (size == 0) {
            //     PaintingBinding.instance.imageCache.maximumSizeBytes =
            //         100 << 20;
            //   }
            // }

            return isHorizontal
                ? comicsData[index].imgWidth == 'none' ||
                        comicsData[index].imgHeight == 'none'
                    ? Container()
                    : Container(
                        height: ScreenUtil().screenHeight,
                        width: ScreenUtil().screenWidth,
                        color: Colors.black,
                        child: Center(
                          child: ComicsImg(
                              img: comicsData[index].imgUrl,
                              isHorizontal: isHorizontal,
                              isTap: isTap,
                              index: index,
                              width: comicsData[index].imgWidth == '0'
                                  ? ScreenUtil().screenWidth
                                  : double.parse(comicsData[index].imgWidth),
                              height: comicsData[index].imgHeight == '0'
                                  ? ScreenUtil().screenHeight
                                  : double.parse(comicsData[index].imgHeight),
                              currentIndex: currenPage,
                              setPosition: (int position, double pageOffset) {
                                currenPage = position;
                                controllerOffset['offsetLeft'] = pageOffset;
                                setState(() {});
                              },
                              length: comicLength),
                        ),
                      )
                : (comicsData[index].imgWidth == 'none' ||
                        comicsData[index].imgHeight == 'none'
                    ? Container()
                    : ComicsImg(
                        img: comicsData[index].imgUrl,
                        isHorizontal: isHorizontal,
                        width: comicsData[index].imgWidth == '0'
                            ? ScreenUtil().screenWidth
                            : double.parse(comicsData[index].imgWidth),
                        height: comicsData[index].imgHeight == '0'
                            ? ScreenUtil().screenHeight
                            : double.parse(comicsData[index].imgHeight),
                        isTap: isTap,
                        index: index,
                        currentIndex: currenPage,
                        setPosition: (int position, double pageOffset) {
                          currenPage = position;
                          controllerOffset['offsetLeft'] = pageOffset;
                          setState(() {});
                        },
                        length: comicLength));
          },
          itemCount: comicLength),
    );
  }

  Widget pageController() {
    return Positioned(
      child: Container(
        height: ScreenUtil().screenHeight,
        width: ScreenUtil().screenWidth,
        child: Stack(
          children: [
            transitionWidget(
                height: ScreenUtil().setWidth(44),
                top: isShow ? 0 : ScreenUtil().setWidth(-50),
                opacity: isShow ? 1 : 0,
                child: comicHeader(),
                time: animationTime),
            Center(
              child: transitionWidget(
                  height: ScreenUtil().setWidth(75),
                  left: isShow
                      ? ScreenUtil().setWidth(5)
                      : ScreenUtil().setWidth(-50),
                  opacity: isShow ? 1 : 0,
                  child: comicButton(
                      type: 'left',
                      onTap: () {
                        if (widget.episode > 1) {
                          swichComic(widget.episode - 1, replace: true);
                        } else {
                          CommonUtils.showText(CommonUtils.txt('yjdyh'));
                        }
                      }),
                  time: animationTime),
            ),
            // Center(
            //     child: transitionWidget(
            //   height: ScreenUtil().setWidth(75),
            //   width: ScreenUtil().setWidth(75),
            //   opacity: isShow ? 1 : 0,
            //   child: GestureDetector(
            //     behavior: HitTestBehavior.translucent,
            //     onTap: () async {
            //       int page = currenPage;
            //       for (var i = 0; i < comicLength - currenPage; i++) {
            //         await comicScroll.scrollTo(
            //             index: page + i, duration: Duration(milliseconds: 600));
            //       }
            //     },
            //     child: Container(
            //       color: Colors.deepOrange,
            //     ),
            //   ),
            // )),
            Center(
              child: transitionWidget(
                  height: ScreenUtil().setWidth(75),
                  left: isShow
                      ? ScreenUtil().screenWidth - ScreenUtil().setWidth(50)
                      : ScreenUtil().screenWidth,
                  opacity: isShow ? 1 : 0,
                  child: comicButton(
                      type: 'right',
                      onTap: () {
                        if (widget.episode < AppGlobal.blues.length) {
                          swichComic(widget.episode + 1, replace: true);
                        } else {
                          CommonUtils.showText(CommonUtils.txt('yjzhh'));
                        }
                      }),
                  time: animationTime),
            ),
            transitionWidget(
                // height: ScreenUtil().setWidth(244),
                bottom: isShow ? 0 : ScreenUtil().setWidth(-150),
                opacity: isShow ? 1 : 0,
                child: bottomController(),
                time: animationTime),
          ],
        ),
      ),
    );
  }

  autoPage() {
    var segmet =
        ScreenUtil().setWidth(295) / controllerOffset['pageIndex']['max'];
    if (currenPage + 1 != comicLength) {
      currenPage++;
      CommonUtils.debugPrint('--------${currenPage + 1}-$comicLength--');
      controllerOffset['offsetLeft'] = (currenPage + 1) * segmet;
      comicScroll.jumpTo(index: currenPage);
      setState(() {});
    } else {
      isAutomatic = false;
      _timer.cancel();
    }
  }

  Widget previousChaptetButton() {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        if (widget.episode > 1) {
          swichComic(widget.episode - 1, replace: true);
        } else {
          CommonUtils.showText(CommonUtils.txt('yjdyh'));
        }
      },
      child: SizedBox(
        width: ScreenUtil().setWidth(45),
        height: ScreenUtil().setWidth(75),
        child: Stack(
          children: [
            LImage('comic_previous_bg'),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  LImage('pre_left_n',
                      width: ScreenUtil().setWidth(12),
                      height: ScreenUtil().setWidth(16)),
                  Text(
                    CommonUtils.txt('syh'),
                    style: TextStyle(
                        color: Color.fromRGBO(255, 255, 255, 1),
                        fontSize: ScreenUtil().setSp(13),
                        overflow: TextOverflow.ellipsis,
                        height: 1.2,
                        decoration: TextDecoration.none),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget comicButton({String type, Function onTap}) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        if (onTap != null) {
          onTap();
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(6.5)),
        width: ScreenUtil().setWidth(45),
        height: ScreenUtil().setWidth(75),
        decoration: BoxDecoration(
            color: Color.fromRGBO(0, 0, 0, 0.5),
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
          textDirection: type == 'left' ? TextDirection.rtl : TextDirection.ltr,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              CommonUtils.txt(type == 'left' ? 'syh' : 'xyh'),
              style: TextStyle(
                  color: Color.fromRGBO(255, 255, 255, 1),
                  fontSize: ScreenUtil().setSp(13),
                  overflow: TextOverflow.ellipsis,
                  height: 1.2,
                  decoration: TextDecoration.none),
            ),
            LImage(type == 'left' ? 'pre_left_n' : 'pre_right_n',
                width: ScreenUtil().setWidth(12.5),
                height: ScreenUtil().setWidth(16),
                fit: BoxFit.contain),
          ],
        ),
      ),
    );
  }

  Widget bottomController() {
    return Container(
      width: ScreenUtil().screenWidth,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          transitionWidget(
              height: ScreenUtil().setWidth(120.5),
              right: automatic ? 0 : ScreenUtil().screenWidth,
              opacity: automatic ? 1 : 0,
              child: DefaultTextStyle(
                  style: TextStyle(
                      color: Colors.white, fontSize: ScreenUtil().setSp(12)),
                  child: Container(
                    height: ScreenUtil().setWidth(120.5),
                    width: ScreenUtil().screenWidth,
                    color: Color.fromRGBO(0, 0, 0, 0.7),
                    padding: EdgeInsets.only(
                        top: ScreenUtil().setWidth(14),
                        bottom: ScreenUtil().setWidth(20)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(CommonUtils.txt('fyjg') +
                            '${timeList[defaultTime]}' +
                            CommonUtils.txt('m')),
                        gestureWidget(_keyb, 'timeLeft', defaultTime,
                            timeList.length - 1),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            GestureDetector(
                              onTap: () {
                                if (_timer != null && _timer.isActive) {
                                  _timer.cancel();
                                }
                                int time =
                                    (timeList[defaultTime] * 1000).toInt();
                                _timer = Timer.periodic(
                                    Duration(milliseconds: time), (timer) {
                                  autoPage();
                                });
                                isAutomatic = true;
                                isShow = false;
                                setState(() {});
                              },
                              child: Container(
                                width: ScreenUtil().setWidth(81),
                                height: ScreenUtil().setWidth(26.5),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.white,
                                        width: ScreenUtil().setWidth(0.5)),
                                    borderRadius: BorderRadius.circular(2.5)),
                                child:
                                    Center(child: Text(CommonUtils.txt('ksh'))),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                if (_timer != null && _timer.isActive) {
                                  _timer.cancel();
                                }
                                setState(() {
                                  isAutomatic = false;
                                  isShow = false;
                                });
                              },
                              child: Container(
                                width: ScreenUtil().setWidth(81),
                                height: ScreenUtil().setWidth(26.5),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.white,
                                        width: ScreenUtil().setWidth(0.5)),
                                    borderRadius: BorderRadius.circular(2.5)),
                                child: Center(
                                    child: Text(CommonUtils.txt('jsfy'))),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  )),
              time: 200),
          Container(
            margin: EdgeInsets.only(top: ScreenUtil().setWidth(3.5)),

            // height: ScreenUtil().setWidth(64),
            width: ScreenUtil().screenWidth,
            padding: EdgeInsets.only(
                top: ScreenUtil().setWidth(15),
                bottom: ScreenUtil().setWidth(12) + GQStyle.bottom),
            decoration: BoxDecoration(
                color: Color(0xff23262f),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(
                      ScreenUtil().setWidth(15),
                    ),
                    topRight: Radius.circular(ScreenUtil().setWidth(15)))),
            child: Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Opacity(
                      opacity: 1.0,
                      child: DefaultTextStyle(
                        style: TextStyle(
                            fontSize: ScreenUtil().setWidth(12),
                            color: Colors.white),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                    '${currenPage + 1 > controllerOffset['pageIndex']['max'] ? controllerOffset['pageIndex']['max'] : currenPage + 1}'),
                                gestureWidget(
                                    _key,
                                    'offsetLeft',
                                    currenPage + 1,
                                    controllerOffset['pageIndex']['max']),
                                Text(controllerOffset['pageIndex']['max']
                                    .toString())
                              ],
                            ),
                            SizedBox(height: ScreenUtil().setWidth(10))
                          ],
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        settingBtn(
                            color: Colors.white,
                            img: 'comic_list',
                            title: CommonUtils.txt('ml'),
                            onTap: () {
                              _itemCatalogAlertBottom();
                            }),
                        settingBtn(
                            color: Colors.white,
                            img: isFavorites
                                ? 'comic_collect_s'
                                : 'comic_collect_n',
                            title: CommonUtils.txt('sc'),
                            onTap: () {
                              userFavorites(type: 2, id: data.dataId)
                                  .then((res) {
                                if (res != null && res.status != 0) {
                                  isFavorites = !isFavorites;
                                  data.userFavorites = isFavorites ? 1 : 0;
                                  setState(() {});
                                } else {
                                  CommonUtils.showText(res.msg);
                                }
                              });
                            }),

                        settingBtn(
                            color: Colors.white,
                            img: isLike ? 'comic_thunbup_s' : 'comic_thunbup_n',
                            title: CommonUtils.txt('dz'),
                            onTap: () {
                              userBookLike(id: data.dataId).then((value) {
                                if (value.status == 1) {
                                  isLike = !isLike;

                                  data.userLike = isLike ? 1 : 0;
                                  setState(() {});
                                } else {
                                  CommonUtils.showText(value.msg);
                                }
                              });
                              // CommonUtils.showText('点赞');
                            }),
                        settingBtn(
                            color: Colors.white,
                            img: 'comic_share_c',
                            title: CommonUtils.txt('fx'),
                            onTap: () {
                              context.push('/' + Routes.kwantsharetousers)
                                  // CommonUtils.showText('分享');
                                  ;
                            }),

                        // settingBtn(
                        //     color:
                        //         selectState == 1 ? Color(0xffff4d0b) : Colors.white,
                        //     img: selectState == 1 ? 'reader_sx_h' : 'reader_sx_n',
                        //     title: '上下翻页',
                        //     onTap: () {
                        //       isHorizontal = false;
                        //       selectState = 1;
                        //       if (automatic) {
                        //         automatic = false;
                        //       }
                        //       setState(() {});
                        //       comicScroll.jumpTo(index: currenPage);
                        //     }),
                        // settingBtn(
                        //     color:
                        //         selectState == 2 ? Color(0xffff4d0b) : Colors.white,
                        //     img: selectState == 2 ? 'reader_zy_h' : 'reader_zy_n',
                        //     title: '左右翻页',
                        //     onTap: () {
                        //       isHorizontal = true;
                        //       selectState = 2;
                        //       if (automatic) {
                        //         automatic = false;
                        //       }
                        //       setState(() {});
                        //       comicScroll.jumpTo(index: currenPage);
                        //     }),
                        // settingBtn(
                        //     color: Colors.white,
                        //     img: 'reader_zd_n', //selectState == 3 ? '7' :
                        //     title: '自动翻页',
                        //     onTap: () {
                        //       setState(() {
                        //         automatic = true;
                        //       });
                        //     })
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
          Container(
            color: Color(0xff23262f),
            height: MediaQuery.of(context).padding.bottom,
          )
        ],
      ),
    );
  }

  fixOffset(String offset, double segmet, int max) {
    if (offset == 'timeLeft') {
      defaultTime = (controllerOffset[offset] / segmet).toInt() > max
          ? max
          : (controllerOffset[offset] / segmet).toInt();
    } else {
      currenPage = (controllerOffset[offset] / segmet).toInt() > max
          ? max
          : (controllerOffset[offset] / segmet).toInt();
      if (currenPage >= 0 && currenPage <= comicLength - 1) {
        comicScroll.jumpTo(index: currenPage);
      }
    }
    setState(() {});
  }

  Widget gestureWidget(GlobalKey key, String offset, int min, int max) {
    //容器长度/分割数量
    var segmet = ScreenUtil().setWidth(295) / max;
    if (offset == 'timeLeft' && intPage) {
      controllerOffset[offset] = defaultTime * segmet;
      intPage = false;
      fixOffset(offset, segmet, max);
    }
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onPanDown: (DragDownDetails e) {
        // CommonUtils.debugPrint('手指触碰');
        if (_timer != null && _timer.isActive) {
          _timer.cancel();
        }
        isTap = true;
        //打印手指按下的位置(相对于屏��)
        controllerOffset[offset] = e.globalPosition.dx - leftDx;
        fixOffset(offset, segmet, max);
      },
      onPanUpdate: (DragUpdateDetails e) {
        //用户手指滑动时，更新偏移，重新构建
        controllerOffset[offset] = e.globalPosition.dx - leftDx < 0
            ? 0.0
            : e.globalPosition.dx - leftDx;
        fixOffset(offset, segmet, max);
      },
      onPanEnd: (DragEndDetails e) {
        isTap = false;
        // CommonUtils.debugPrint('手指抬起');
        if (_timer != null && !_timer.isActive && isAutomatic) {
          int time = (timeList[defaultTime] * 1000).toInt();
          _timer = Timer.periodic(Duration(milliseconds: time), (timer) {
            autoPage();
          });
        }
      },
      child: Container(
        key: key,
        height: ScreenUtil().setWidth(25),
        child: Center(
          child: Container(
            width: ScreenUtil().setWidth(295),
            height: ScreenUtil().setWidth(3),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(ScreenUtil().setWidth(1.5)),
              color: Color.fromRGBO(250, 250, 250, 0.2),
            ),
            child: Stack(
              children: [
                LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints box) {
                    return AnimatedContainer(
                        width: ((box.maxWidth / max) * min).truncateToDouble(),
                        height: ScreenUtil().setWidth(6),
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(ScreenUtil().setWidth(1.5)),
                          color: GQStyle.cyanColor00edfd,
                        ),
                        child: Stack(
                          overflow: Overflow.visible,
                          children: [
                            Positioned(
                                right: 0,
                                top: ScreenUtil().setWidth(-3),
                                child: Container(
                                  width: ScreenUtil().setWidth(9),
                                  height: ScreenUtil().setWidth(9),
                                  decoration: BoxDecoration(
                                      color: GQStyle.cyanColor00edfd,
                                      borderRadius: BorderRadius.circular(
                                          ScreenUtil().setWidth(4.5)),
                                      boxShadow: [
                                        BoxShadow(
                                          color: GQStyle.cyanColor00edfd,
                                          blurRadius: ScreenUtil().setWidth(5),
                                        )
                                      ]),
                                ))
                          ],
                        ),
                        duration: Duration(milliseconds: 0));
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget settingBtn({Color color, String title, String img, Function onTap}) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTap,
      child: Column(
        children: [
          LImage(
            img,
            width: ScreenUtil().setWidth(25),
            height: ScreenUtil().setWidth(25),
          ),
          SizedBox(
            height: ScreenUtil().setWidth(4),
          ),
          RichText(
              text: TextSpan(
            text: title,
            style: GQStyle.white255_11,
          ))
        ],
      ),
    );
  }

  Widget comicHeader() {
    dynamic e = AppGlobal.blues
        .where((element) => element["episode"] == cureentIndex)
        .first;
    return Container(
      height: GQStyle.navbarHegiht,
      width: ScreenUtil().screenWidth,
      color: GQStyle.bgColor,
      padding: EdgeInsets.symmetric(horizontal: GQStyle.pagePadding),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              context.pop();
            },
            child: LImage(
              "nav_back_n",
              width: ScreenUtil().setWidth(20),
              height: ScreenUtil().setWidth(20),
            ),
          ),
          SizedBox(
            height: ScreenUtil().setWidth(22),
            width: ScreenUtil().setWidth(300),
            child: RichText(
              text: TextSpan(
                  // text: "${widget.title}",
                  text: "${widget.title}_${e['episode_title']}",
                  style: GQStyle.white255_16_M),
            ),
          ),
          SizedBox(
            width: ScreenUtil().setWidth(20),
            height: ScreenUtil().setWidth(20),
          )
        ],
      ),
    );
  }

  Widget transitionWidget(
      {int time = 200,
      double height,
      double opacity,
      double width,
      Widget child,
      double left,
      double right,
      double bottom,
      double top}) {
    return Container(
      height: height,
      width: width,
      child: Stack(
        overflow: Overflow.visible,
        children: [
          Container(),
          AnimatedPositioned(
              right: right,
              left: left,
              bottom: bottom,
              top: top,
              child: AnimatedOpacity(
                opacity: opacity,
                duration: Duration(milliseconds: time),
                child: child,
              ),
              duration: Duration(milliseconds: time))
        ],
      ),
    );
  }
}
