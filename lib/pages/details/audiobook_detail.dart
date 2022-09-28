import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qypj/utils/extensionlibrary.dart';
import 'package:provider/provider.dart';
import 'package:qypj/components/card/comics_card.dart';
import 'package:qypj/components/page_status.dart';
import 'package:qypj/pages/details/atlas_detail.dart';
import 'package:qypj/store/homeConfig.dart';
import 'package:qypj/theme/default.dart';
import 'package:qypj/utils/api.dart';
import 'package:qypj/utils/common.dart';
import 'package:qypj/utils/networkImage.dart';

class AudiobookDetail extends StatefulWidget {
  AudiobookDetail({Key key, this.id}) : super(key: key);
  final dynamic id;
  @override
  _AudiobookDetailState createState() => _AudiobookDetailState();
}

class _AudiobookDetailState extends State<AudiobookDetail> {
  Map novelDetail;
  bool isLike = false;
  List seriesesList = [];
  int cureentIndex = 0;
  int money = 0;
  List recommendList = [];
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    getBookRecommendList(limit: 15, page: 1, type: 2).then((res) {
      if (res['status'] != 0) {
        recommendList = res['data'] == null ? [] : res['data'];
        setState(() {});
      }
    });
    getBookDetail(id: widget.id, type: 2).then((res) {
      if (res['status'] != 0) {
        novelDetail = res['data'];
        isLike = res['data']['userFavorites'] == 1;
        List serieses = res['data']['serieses'];
        serieses.forEach((element) {
          if (element['series'] <= 3) {
            seriesesList.add(element);
          } else if (element['series'] == serieses.length) {
            seriesesList.add(element);
          }
        });
        setState(() {});
      } else {
        context.pop();
        CommonUtils.showText(res['msg']);
      }
    });
  }

  Widget _head() {
    return Container(
      height: ScreenUtil().setWidth(44),
      width: double.infinity,
      decoration: BoxDecoration(
          gradient: LinearGradient(
        colors: [Colors.black38, Colors.black12],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      )),
      child: Stack(
        children: [
          // Center(
          //   child: Text(
          //     '1/9',
          //     style: DefaultStyle.white18bold,
          //   ),
          // ),
          Positioned(
              top: 0,
              bottom: 0,
              right: 0,
              left: 0,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: GQStyle.pagePadding),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        context.pop();
                      },
                      child: Image.asset(
                        'assets/images/details/icon_w_back.png',
                        width: ScreenUtil().setWidth(22),
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                    Container()
                  ],
                ),
              ))
        ],
      ),
    );
  }

  Widget _btnItem({String icon, String name, Color color}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          'assets/images/details/$icon.png',
          width: ScreenUtil().setWidth(25),
          fit: BoxFit.fitWidth,
        ),
        SizedBox(
          width: ScreenUtil().setWidth(7),
        ),
        Text(
          name,
          style: TextStyle(
              color: color != null ? color : Color(0xff999999),
              fontSize: ScreenUtil().setSp(14)),
        )
      ],
    );
  }

  Widget _selectHua() {
    money = Provider.of<HomeConfig>(context, listen: false).member.money;
    return Column(
        mainAxisSize: MainAxisSize.min,
        children: seriesesList
            .asMap()
            .keys
            .map<Widget>((e) => _chapterItem(
                id: seriesesList[e]['story_id'],
                more: seriesesList.length >= 0 && e == 3,
                isFree: seriesesList[e]['is_free'],
                chapter: CommonUtils.txt('d') +
                    '${seriesesList[e]['series']}' +
                    CommonUtils.txt('zhj'),
                title: seriesesList[e]['title']))
            .toList());
  }

  Widget _chapterItem(
      {int id, String chapter, String title, bool more, int isFree}) {
    Color bgcolor = Colors.white;
    String icon;
    // if (isFree == 1) {
    //   bgcolor = Color(0xffe8e7e9);
    //   icon = 'assets/images/details/icon_isvip.png';
    // }
    // if (isFree == 2) {
    //   icon = 'assets/images/details/icon_iscoin.png';
    // }
    // if('当前章节'){
    //   bgcolor=Color(0xfff36f65);
    // }
    return GestureDetector(
      onTap: () {
        if (more) {
          _scaffoldKey.currentState.openEndDrawer();
        } else {
          // swichNovel(id);
        }
      },
      child: Container(
          width: double.infinity,
          height: ScreenUtil().setWidth(34),
          margin: EdgeInsets.only(bottom: ScreenUtil().setWidth(9)),
          decoration: BoxDecoration(
              color: bgcolor,
              borderRadius: BorderRadius.circular(ScreenUtil().setWidth(2.5))),
          child: Stack(
            children: [
              Container(
                padding:
                    EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(17)),
                height: double.infinity,
                child: more
                    ? Row(
                        children: [
                          Text(
                            '···',
                            style: GQStyle.lgray14,
                          )
                        ],
                      )
                    : Row(
                        children: [
                          Text(
                            chapter,
                            style: GQStyle.lgray14,
                          ),
                          SizedBox(
                            width: ScreenUtil().setWidth(20),
                          ),
                          Expanded(
                              child: Text(
                            title,
                            style: GQStyle.lgray14,
                          ))
                        ],
                      ),
              ),
              Positioned(
                  left: 0,
                  top: 0,
                  child: icon == null
                      ? Container()
                      : Image.asset(
                          icon,
                          height: ScreenUtil().setWidth(10),
                          fit: BoxFit.fitWidth,
                        ))
            ],
          )),
    );
  }

  //阅读器目录
  Widget comicDrawer() {
    return Container(
      height: ScreenUtil().screenHeight,
      width: ScreenUtil().setWidth(286.5),
      color: Color(0xfff7f6fb),
      child: Column(
        children: [
          SizedBox(
            height: ScreenUtil().statusBarHeight,
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                vertical: ScreenUtil().setWidth(19),
                horizontal: ScreenUtil().setWidth(14)),
            child: Row(
              children: [
                Text(CommonUtils.txt('ywj'),
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: ScreenUtil().setSp(18),
                        fontWeight: FontWeight.w700)),
                SizedBox(width: ScreenUtil().setWidth(10.5)),
                Text(
                    CommonUtils.txt('gxz') +
                        '${novelDetail['serieses'].length}' +
                        CommonUtils.txt('hua'),
                    style: TextStyle(
                        color: Color(0xff999999),
                        fontSize: ScreenUtil().setSp(13))),
              ],
            ),
          ),
          Expanded(
              child: SingleChildScrollView(
            padding: EdgeInsets.only(bottom: ScreenUtil().setWidth(20)),
            child: Wrap(
              spacing: ScreenUtil().setWidth(2.5),
              runSpacing: ScreenUtil().setWidth(4),
              children: novelDetail['serieses'].asMap().keys.map<Widget>((e) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      cureentIndex = e + 1;
                    });
                  },
                  child: Container(
                    width: ScreenUtil().setWidth(84.5),
                    height: ScreenUtil().setWidth(32),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2.5),
                        color: cureentIndex == e + 1
                            ? Color(0xffff506b)
                            : Colors.white),
                    child: Center(
                        child: Text(
                      novelDetail['serieses'][e]['series'].toString(),
                      style: TextStyle(
                          color: cureentIndex == e + 1
                              ? Colors.white
                              : Colors.black,
                          fontSize: ScreenUtil().setSp(15)),
                    )),
                  ),
                );
              }).toList(),
            ),
          ))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List tags = novelDetail == null ||
            novelDetail['tags'] == '' ||
            novelDetail['tags'] == null
        ? []
        : novelDetail['tags'].split(',');
    return Scaffold(
      backgroundColor: Color(0xfff7f6fb),
      endDrawer: novelDetail == null ? Container() : comicDrawer(),
      key: _scaffoldKey,
      body: SafeArea(
        child: Column(
          children: [
            Stack(
              children: [
                novelDetail == null
                    ? Container()
                    : Container(
                        width: double.infinity,
                        height: ScreenUtil().setWidth(210),
                        child: PlatformAwareNetworkImage(
                            url: novelDetail['thumb']),
                      ),
                Positioned(top: 0, left: 0, right: 0, child: _head())
              ],
            ),
            novelDetail == null
                ? PageStatus.loading(mounted)
                : Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: GQStyle.pagePadding,
                                vertical: ScreenUtil().setWidth(17.5)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  novelDetail['title'],
                                  style: TextStyle(
                                      color: Color(0xff333333),
                                      fontSize: ScreenUtil().setSp(16),
                                      fontWeight: FontWeight.bold),
                                ),
                                // Padding(
                                //   padding: EdgeInsets.symmetric(
                                //       vertical: ScreenUtil().setWidth(14.5)),
                                //   child: Seiyuu(
                                //     thumbUrl: 'https://staff.tea123.me/e.jpg',
                                //     name: '声优名字',
                                //   ),
                                // ),
                                SizedBox(
                                  height: ScreenUtil().setWidth(15),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${novelDetail['views_count']}' +
                                          CommonUtils.txt('rcbf'),
                                      style: GQStyle.gray11,
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            userFavorites(
                                                    type: 5,
                                                    id: novelDetail['id'])
                                                .then((res) {
                                              if (res != null &&
                                                  res.status != 0) {
                                                isLike = !isLike;
                                                setState(() {});
                                              } else {
                                                CommonUtils.showText(res.msg);
                                              }
                                            });
                                          },
                                          child: _btnItem(
                                              icon: isLike
                                                  ? 'icon_like'
                                                  : 'icon_unlike',
                                              name: isLike
                                                  ? CommonUtils.txt('ysc')
                                                  : CommonUtils.txt('sc'),
                                              color: isLike
                                                  ? Color(0xfff36f65)
                                                  : Color(0xff999999)),
                                        ),
                                        SizedBox(
                                          width: ScreenUtil().setWidth(20),
                                        ),
                                        _btnItem(
                                            icon: 'icon_down',
                                            name: CommonUtils.txt('xz')),
                                        SizedBox(
                                          width: ScreenUtil().setWidth(20),
                                        ),
                                        GestureDetector(
                                          onTap: () {},
                                          child: _btnItem(
                                              icon: 'icon_share',
                                              name: CommonUtils.txt('fx')),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                                tags.length == 0
                                    ? Container()
                                    : Container(
                                        margin: EdgeInsets.only(
                                            bottom: ScreenUtil().setWidth(14.5),
                                            top: ScreenUtil().setWidth(20)),
                                        child: Wrap(
                                            spacing: ScreenUtil().setWidth(5),
                                            runSpacing:
                                                ScreenUtil().setWidth(14),
                                            children: tags
                                                .asMap()
                                                .keys
                                                .map(
                                                  (e) => YyTap(
                                                      text: '#${tags[e]}'),
                                                )
                                                .toList()),
                                      ),
                                Text(
                                  novelDetail['desc'] ?? '--',
                                  style: TextStyle(
                                      color: Color(0XFF666666),
                                      fontSize: ScreenUtil().setSp(12)),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: ScreenUtil().setWidth(16)),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            CommonUtils.txt('zxzj'),
                                            style: GQStyle.black1834,
                                          ),
                                          SizedBox(
                                            width: ScreenUtil().setWidth(8.5),
                                          ),
                                          Text(
                                            CommonUtils.txt('gxz') +
                                                '${novelDetail['serieses'].length}' +
                                                CommonUtils.txt('hua'),
                                            style: GQStyle.gray13,
                                          ),
                                        ],
                                      ),
                                      GestureDetector(
                                        behavior: HitTestBehavior.translucent,
                                        onTap: () {
                                          _scaffoldKey.currentState
                                              .openEndDrawer();
                                        },
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              CommonUtils.txt('qb'),
                                              style: GQStyle.gray12,
                                            ),
                                            SizedBox(
                                              width: ScreenUtil().setWidth(8.5),
                                            ),
                                            Image.asset(
                                              'assets/images/details/icon_right.png',
                                              width: ScreenUtil().setWidth(12),
                                              fit: BoxFit.fitWidth,
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                _selectHua(),
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: ScreenUtil().setWidth(24)),
                                  child: Text(
                                    CommonUtils.txt('xgtj'),
                                    style: GQStyle.black1834,
                                  ),
                                ),
                                recommendList.length == 0
                                    ? PageStatus.noData(
                                        text: CommonUtils.txt('xswtj'))
                                    : Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: recommendList
                                            .asMap()
                                            .keys
                                            .map<Widget>((e) => Padding(
                                                  padding: EdgeInsets.only(
                                                      top: ScreenUtil()
                                                          .setWidth(14)),
                                                  child: ComicsCard(
                                                      replace: true,
                                                      data: recommendList[e]),
                                                ))
                                            .toList(),
                                      )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
          ],
        ),
      ),
    );
  }
}

class Seiyuu extends StatefulWidget {
  Seiyuu({Key key, this.thumbUrl, this.name}) : super(key: key);
  String thumbUrl;
  String name;
  @override
  _SeiyuuState createState() => _SeiyuuState();
}

class _SeiyuuState extends State<Seiyuu> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          margin: EdgeInsets.only(right: ScreenUtil().setWidth(9)),
          width: ScreenUtil().setWidth(25),
          height: ScreenUtil().setWidth(25),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(ScreenUtil().setWidth(12.5)),
            child: PlatformAwareNetworkImage(url: widget.thumbUrl),
          ),
        ),
        Text(
          widget.name,
          style: GQStyle.gray14,
        )
      ],
    );
  }
}
