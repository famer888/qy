import 'dart:async';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qypj/store/homeConfig.dart';
import 'package:qypj/theme/default.dart';
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

class ComicReader extends StatefulWidget {
  final int id;
  final int episode;
  final String title;
  ComicReader({Key key, this.id, this.episode, this.title}) : super(key: key);

  @override
  _ComicReaderState createState() => _ComicReaderState();
}

class _ComicReaderState extends State<ComicReader> with WatchRecordMixin {
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
  int animationTime = 500;
  bool intPage = true;
  Axis scrollDirection = Axis.vertical;
  Map controllerOffset;
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
    var manhuaData = AppGlobal.manhuaWatchRecordBox.get(widget.id);
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
    getPageDetail();
  }

  Future _itemAlertBottom() {
    return showModalBottomSheet(
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setBottomSheetState) {
            return Container(
              height: ScreenUtil().screenHeight * 0.8,
              color: Color.fromRGBO(0, 2, 9, 1.0),
              child: Column(
                children: [
                  Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: GQStyle.pagePadding),
                      height: ScreenUtil().setWidth(44),
                      color: Color.fromRGBO(25, 25, 25, 1.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(),
                          Text(CommonUtils.txt("mllb"),
                              style: GQStyle.white255_18),
                          GestureDetector(
                            onTap: () {
                              context.pop();
                            },
                            child: Text(
                              CommonUtils.txt("gb"),
                              style: GQStyle.white234_12,
                            ),
                          )
                        ],
                      )),
                  SizedBox(height: ScreenUtil().setWidth(17)),
                  Expanded(
                      child: SingleChildScrollView(
                    child: _episdItem(),
                    scrollDirection: Axis.vertical,
                  ))
                ],
              ),
            );
          });
        });
  }

  Widget _episdItem() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: GQStyle.pagePadding),
      child: Column(
        children: [
          Column(
            children: AppGlobal.blues.map((e) {
              var str = CommonUtils.txt("mf");
              TextStyle style;
              if (e["is_free"] == 0) {
                str = CommonUtils.txt("mf");
                style = TextStyle(
                    fontSize: ScreenUtil().setSp(14), color: Colors.green);
              } else if (e["is_free"] == 1) {
                str = CommonUtils.txt("vvp");
                style = TextStyle(
                    fontSize: ScreenUtil().setSp(14),
                    color: Color.fromRGBO(144, 61, 0, 1.0));
              } else if (e["is_free"] == 2 && e["is_pay"] == 1) {
                str = CommonUtils.txt("yyd");
                style = TextStyle(
                    fontSize: ScreenUtil().setSp(14),
                    color: Color.fromRGBO(102, 102, 102, 1.0));
              } else {
                str = "${e["view_money"]}${CommonUtils.txt("jb")}";
                style = TextStyle(
                    fontSize: ScreenUtil().setSp(14),
                    color: Color.fromRGBO(255, 77, 11, 1.0));
              }
              return Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      context.pop();
                      swichComic(e["episode"]);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: Color.fromRGBO(25, 25, 25, 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(2.5))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: ScreenUtil().setWidth(34 / 111 * 156),
                            width: ScreenUtil().setWidth(34),
                            child: PlatformAwareNetworkImage(
                                url: e["thumb"],
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(5),
                                    bottomLeft: Radius.circular(5)),
                                fit: BoxFit.fill),
                          ),
                          SizedBox(width: ScreenUtil().setWidth(16)),
                          Expanded(
                              child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                  child: Text(e["episode_title"],
                                      style: GQStyle.gray180_15)),
                              Spacer(),
                              Container(
                                child: Text(str, style: style),
                              ),
                              SizedBox(width: GQStyle.pagePadding)
                            ],
                          ))
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: ScreenUtil().setWidth(18))
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  swichComic(int episode, {bool replace = false}) {
    if (episode == cureentIndex) return;

    dynamic e =
        AppGlobal.blues.where((element) => element["episode"] == episode).first;

    if (e["is_pay"] == 1 || e["is_free"] == 0) {
      context.push(
          CommonUtils.getRealHash().replaceAll(RegExp(r"comicReader/.*"),
              'comicReader/${widget.id}/$episode/${widget.title}'),
          replace: replace);
      return;
    }
    if (e["is_free"] == 1 && AppGlobal.vipLevel > 0) {
      context.push(
          CommonUtils.getRealHash().replaceAll(RegExp(r"comicReader/.*"),
              'comicReader/${widget.id}/$episode/${widget.title}'),
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
            style: TextStyle(
                color: Color.fromRGBO(51, 51, 51, 1),
                fontSize: ScreenUtil().setSp(15),
                decoration: TextDecoration.none),
          );
        },
        cancelText: CommonUtils.txt("qx"),
        btnText: CommonUtils.txt("ljkt"),
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
        YyShowDialog.showdialog(context,
            title:
                isInsufficient ? CommonUtils.txt("jbbz") : e["episode_title"],
            btnText: isInsufficient
                ? CommonUtils.txt("qwcz")
                : CommonUtils.txt("gmbzj"), callBack: () {
          if (isInsufficient) {
            context.push('/${Routes.coinRecharge}');
          } else {
            _byComicChapter(episode, replace, e);
          }
        }, content: (setDialogState) {
          return DefaultTextStyle(
              style: GQStyle.gry30_14_M,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                      "*${CommonUtils.txt("ny")}${money}${CommonUtils.txt("jb")},${CommonUtils.txt("xyhzdgm")}*",
                      style: GQStyle.gray169_14),
                  SizedBox(height: ScreenUtil().setWidth(5)),
                  Text.rich(
                      TextSpan(text: CommonUtils.txt("bzjxhf"), children: [
                    TextSpan(
                        text: '${e["view_money"]}${CommonUtils.txt("jb")}',
                        style: GQStyle.yellow255_14_B)
                  ]))
                ],
              ));
        });
      });
      setState(() {});
    }
  }

  _byComicChapter(int episode, bool replace, dynamic e) async {
    await comicChapterBy(book_id: widget.id, episode: episode).then((value) {
      if (value.status == 1) {
        e["is_pay"] = 1;
        AppGlobal.isAutoBy = true;
        context.push(
            CommonUtils.getRealHash().replaceAll(RegExp(r"comicReader/.*"),
                'comicReader/${widget.id}/$episode/${widget.title}'),
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
            title: widget.title);
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
                pageController()
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

  Widget comicsPageView() {
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            transitionWidget(
                height: ScreenUtil().setWidth(44),
                top: isShow ? 0 : ScreenUtil().setWidth(-50),
                opacity: isShow ? 1 : 0,
                child: comicHeader(),
                time: animationTime),
            transitionWidget(
                height: ScreenUtil().setWidth(244),
                bottom: isShow ? 0 : ScreenUtil().setWidth(-250),
                opacity: isShow ? 1 : 0,
                child: bottomController(),
                time: animationTime)
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
            height: ScreenUtil().setWidth(120),
            width: ScreenUtil().screenWidth,
            color: Color.fromRGBO(0, 0, 0, 0.7),
            padding: EdgeInsets.only(
                top: ScreenUtil().setWidth(15),
                bottom: ScreenUtil().setWidth(12)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DefaultTextStyle(
                  style: TextStyle(
                      fontSize: ScreenUtil().setWidth(12), color: Colors.white),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                          '${currenPage + 1 > controllerOffset['pageIndex']['max'] ? controllerOffset['pageIndex']['max'] : currenPage + 1}'),
                      gestureWidget(_key, 'offsetLeft', currenPage + 1,
                          controllerOffset['pageIndex']['max']),
                      Text(controllerOffset['pageIndex']['max'].toString())
                    ],
                  ),
                ),
                Container(
                  height: ScreenUtil().setWidth(0.2),
                  width: ScreenUtil().screenWidth,
                  color: Color(0xffb1b1b1),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    //selectState
                    settingBtn(
                        color: Colors.white,
                        img: 'episd_syh_n',
                        title: CommonUtils.txt('syyh'),
                        onTap: () {
                          if (widget.episode > 1) {
                            swichComic(widget.episode - 1, replace: true);
                          } else {
                            CommonUtils.showText(CommonUtils.txt('yjdyh'));
                          }
                        }),
                    settingBtn(
                        color: Colors.white,
                        img: 'episd_ml_n',
                        title: CommonUtils.txt('ml'),
                        onTap: () {
                          _itemAlertBottom();
                        }),
                    settingBtn(
                        color: Colors.white,
                        img: 'episd_xyh_n',
                        title: CommonUtils.txt('xyyh'),
                        onTap: () {
                          if (widget.episode < AppGlobal.blues.length) {
                            swichComic(widget.episode + 1, replace: true);
                          } else {
                            CommonUtils.showText(CommonUtils.txt('yjzhh'));
                          }
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
                          color: Color(0xffff4d0b),
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
                                      color: Color(0xffff4d0b),
                                      borderRadius: BorderRadius.circular(
                                          ScreenUtil().setWidth(4.5)),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Color(0xffff4d0b),
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
            width: ScreenUtil().setWidth(23),
            height: ScreenUtil().setWidth(21),
            color: color,
          ),
          SizedBox(
            height: ScreenUtil().setWidth(9),
          ),
          Text(
            title,
            style: TextStyle(
                color: color,
                fontSize: ScreenUtil().setSp(12),
                decoration: TextDecoration.none),
          )
        ],
      ),
    );
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
            LImage(
              (type == 'left' ? 'pre_left_n' : 'pre_right_n'),
              width: ScreenUtil().setWidth(12.5),
              height: ScreenUtil().setWidth(16),
              fit: BoxFit.contain,
            ),
            DefaultTextStyle(
                style: GQStyle.white255_12,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      type == 'left'
                          ? CommonUtils.txt("syh")
                          : CommonUtils.txt("xyh"),
                    ),
                  ],
                ))
          ],
        ),
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
      color: Color.fromRGBO(0, 0, 0, 0.5),
      padding: EdgeInsets.symmetric(horizontal: GQStyle.pagePadding),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              context.pop();
            },
            child: LImage(
              "nav_back_n",
              width: ScreenUtil().setWidth(22),
              height: ScreenUtil().setWidth(22),
            ),
          ),
          SizedBox(
            height: ScreenUtil().setWidth(22),
            width: ScreenUtil().setWidth(300),
            child: RichText(
              text: TextSpan(
                  text: "${widget.title}_${e['episode_title']}",
                  style: GQStyle.white255_16_M),
            ),
          ),
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
