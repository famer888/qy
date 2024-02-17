import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qypj/base/baseWidget.dart';
import 'package:qypj/components/page_status.dart';
import 'package:qypj/model/basic.dart';
import 'package:qypj/model/homedata.dart';
import 'package:qypj/routers.dart';
import 'package:qypj/store/homeConfig.dart';
import 'package:qypj/theme/default.dart';
import 'package:qypj/utils/api.dart';
import 'package:qypj/utils/common.dart';
import 'package:qypj/utils/networkImage.dart';
import 'package:qypj/utils/extensionlibrary.dart';
import 'package:provider/provider.dart';

class MineAgentPage extends BaseWidget {
  cState() => _MineAgentPageState();
}

class _MineAgentPageState extends BaseWidgetState {
  bool networkErr = false;
  bool isHud = false;
  dynamic _proxy_money; //余额

  dynamic _data;

  List<String> levelList = [
    'dld',
    'zs',
    'bj',
    'hj',
    'by',
    'qt',
    'pt',
  ];
  Color tableBorderColor = GQStyle.goldColor234_202_147;

  @override
  void onCreate() {
    setAppTitle(
      title: CommonUtils.txt('dlzq'),
    );

    Member members = Provider.of<HomeConfig>(context, listen: false).member;

    // members.channel = "test";
    // Provider.of<HomeConfig>(context, listen: false).setMember(members);

    if (members != null && members.channel == 'self') {
      _getAgentinfo();
    } else {
      // isHud = false;
      setState(() {});
    }

    // TODO: implement onCreate
  }

  @override
  Widget backGroundView() {
    // TODO: implement backGroundView
    return Container(
      alignment: Alignment.topCenter,
      width: double.infinity,
      height: double.infinity,
      // color: Colors.cyan,
      color: GQStyle.blackColor22,
      // child: LImage(''),
    );
  }

  @override
  Widget appbar() {
    Member members = Provider.of<HomeConfig>(context, listen: false).member;
    if (members.channel == 'self') {
      return Stack(children: [
        super.appbar(),
        Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: GQStyle.pagePadding),
              alignment: Alignment.centerRight,
              height: GQStyle.navbarHegiht,
              child: GestureDetector(
                onTap: () {
                  context.push('/${Routes.mineAgentProfitListPage}');
                },
                child: Text(
                  CommonUtils.txt('symx'),
                  style: GQStyle.gray15,
                ),
              ),
            ))
      ]);
    } else {
      // TODO: implement appbar
      return super.appbar();
    }
  }

  @override
  void onDestroy() {
    // TODO: implement onDestroy
  }

  _getAgentinfo() async {
    try {
      Basic res = await getProxyDetail({});
      if (res.status != 1) {
        CommonUtils.showText(res.msg);
        // isHud = false;
        // networkErr = true;
      } else {
        _data = res.data;
        _proxy_money = res.data['proxy_money'];

        // isHud = false;
        // networkErr = false;
      }
      setState(() {});
    } catch (e) {
      // isHud = false;
      // networkErr = true;
      setState(() {});
    }
  }

  @override
  Widget pageBody(BuildContext context) {
    Member members = Provider.of<HomeConfig>(context, listen: false).member;

    return networkErr
        ? PageStatus.noNetWork(onTap: _getAgentinfo)
        : isHud
            ? PageStatus.loading(mounted)
            : Container(
                padding: EdgeInsets.symmetric(horizontal: GQStyle.pagePadding),
                child: Stack(
                  children: [
                    ListView(
                      padding:
                          EdgeInsets.only(bottom: ScreenUtil().setWidth(65)),
                      children: [
                        _data == null
                            ? Container()
                            : Stack(
                                children: [
                                  // ClipPath(
                                  //   clipper: MyClipper(),
                                  //   child:
                                  Container(
                                    height: ScreenUtil().setWidth(157),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(
                                              ScreenUtil().setWidth(5))),
                                      gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            Color.fromRGBO(210, 163, 127, 1),
                                            Color.fromRGBO(245, 228, 212, 1),
                                            Color.fromRGBO(232, 207, 183, 1),
                                          ]),
                                    ),
                                  ),
                                  // ),
                                  SizedBox(height: ScreenUtil().setWidth(11.5)),
                                  Container(
                                    height: ScreenUtil().setWidth(53),
                                    margin: EdgeInsets.all(
                                        ScreenUtil().setWidth(16.5)),
                                    child: Row(
                                      children: [
                                        ClipRRect(
                                            clipBehavior: Clip.hardEdge,
                                            borderRadius: BorderRadius.circular(
                                              ScreenUtil().setWidth(53 / 2.0),
                                            ),
                                            child: Container(
                                              width: ScreenUtil().setWidth(53),
                                              height: ScreenUtil().setWidth(53),
                                              child:
                                                  PlatformAwareNetworkImage(),
                                            )),
                                        SizedBox(
                                          width: ScreenUtil().setWidth(9),
                                        ),
                                        Expanded(
                                            child: Container(
                                          child: Column(
                                            children: [
                                              Expanded(
                                                flex: 1,
                                                child: Row(
                                                  children: [
                                                    Text(
                                                        '${_data['proxy_level_str']}',
                                                        style: GQStyle
                                                            .brown916044_14medium),
                                                    Expanded(
                                                        child: Container()),
                                                    Text(
                                                        CommonUtils.txt(
                                                            'ktxje'),
                                                        style: GQStyle
                                                            .brown916044_12semibold),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: Row(
                                                  children: [
                                                    Text(
                                                        CommonUtils.txt(
                                                            'yhysj'),
                                                        style: GQStyle
                                                            .brown916044_12medium),
                                                    Expanded(
                                                        child: Container()),
                                                    Text('$_proxy_money',
                                                        style: GQStyle
                                                            .brown916044_24semibold)
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        )),
                                      ],
                                    ),
                                  ),
                                  Positioned.fill(
                                      // top: ScreenUtil().setWidth(97),
                                      // bottom: ScreenUtil().setWidth(73),
                                      child: Column(
                                    children: [
                                      Expanded(flex: 97, child: Container()),
                                      SizedBox(
                                          height: ScreenUtil().setWidth(46)),
                                      Container(
                                        // width: double.infinity,
                                        // color: Colors.red,
                                        child: Row(
                                          children: [
                                            Expanded(
                                              flex: 42,
                                              child: Container(),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                context.push(
                                                    '/mineAgentToCashPage/1');
                                              },
                                              child: Container(
                                                width:
                                                    ScreenUtil().setWidth(100),
                                                height:
                                                    ScreenUtil().setWidth(30),
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadiusDirectional
                                                            .circular(
                                                                ScreenUtil()
                                                                    .setWidth(
                                                                        15)),
                                                    gradient: LinearGradient(
                                                      begin: Alignment
                                                          .bottomCenter,
                                                      end: Alignment.topCenter,
                                                      colors: <Color>[
                                                        Color.fromRGBO(
                                                            24, 23, 21, 1),
                                                        Color.fromRGBO(
                                                            76, 56, 28, 1)
                                                      ],
                                                    )),
                                                child: Text(
                                                  CommonUtils.txt('ljtx'),
                                                  style: GQStyle.hexf2c774_14,
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 54,
                                              child: Container(),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                context.push(
                                                    '/${Routes.mineAgentPromoteDataPage}');
                                              },
                                              child: Container(
                                                width:
                                                    ScreenUtil().setWidth(100),
                                                height:
                                                    ScreenUtil().setWidth(30),
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadiusDirectional
                                                            .circular(
                                                                ScreenUtil()
                                                                    .setWidth(
                                                                        15)),
                                                    gradient: LinearGradient(
                                                      begin: Alignment
                                                          .bottomCenter,
                                                      end: Alignment.topCenter,
                                                      colors: <Color>[
                                                        Color.fromRGBO(
                                                            24, 23, 21, 1),
                                                        Color.fromRGBO(
                                                            76, 56, 28, 1)
                                                      ],
                                                    )),
                                                child: Text(
                                                  CommonUtils.txt('tgsj'),
                                                  style: GQStyle.hexf2c774_14,
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 42,
                                              child: Container(),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(flex: 73, child: Container())
                                    ],
                                  )),
                                ],
                              ),
                        Container(
                          padding: EdgeInsets.all(ScreenUtil().setWidth(20)),
                          decoration: BoxDecoration(
                              color: GQStyle.blackColor32,
                              borderRadius: BorderRadius.circular(
                                  ScreenUtil().setWidth(5))),
                          child: Column(
                            children: [
                              AegntTitleWidget(CommonUtils.txt('czjd')),
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  CommonUtils.txt('czsm'),
                                  style: GQStyle.gold15,
                                ),
                              ),
                              Text(
                                CommonUtils.txt('czsmza'),
                                style: TextStyle(
                                    color: Color.fromRGBO(255, 255, 255, 1),
                                    fontSize: ScreenUtil().setSp(11),
                                    overflow: TextOverflow.visible,
                                    decoration: TextDecoration.none),
                                // maxLines: 3,
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  CommonUtils.txt('syly'),
                                  style: GQStyle.gold15,
                                ),
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  '1.' + CommonUtils.txt('ztsy'),
                                  style: GQStyle.white255_11,
                                ),
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  '2.' + CommonUtils.txt('cjsy'),
                                  style: GQStyle.white255_11,
                                ),
                              ),
                            ]
                                .map((e) => Column(
                                      children: [
                                        e,
                                        SizedBox(
                                          height: ScreenUtil().setWidth(15),
                                        ),
                                      ],
                                    ))
                                .toList(),
                          ),
                        ),
                        Container(
                            padding: EdgeInsets.all(ScreenUtil().setWidth(20)),
                            decoration: BoxDecoration(
                                color: GQStyle.blackColor32,
                                borderRadius: BorderRadius.circular(
                                    ScreenUtil().setWidth(5))),
                            child: Column(children: [
                              AegntTitleWidget(CommonUtils.txt('dldjsm')),
                              SizedBox(
                                height: ScreenUtil().setWidth(20),
                              ),
                              Table(
                                border: TableBorder.all(
                                  color: tableBorderColor,
                                  width: ScreenUtil().setWidth(1),
                                ),
                                children: levelList.asMap().keys.map(
                                  (index) {
                                    TextStyle style = index == 0
                                        ? GQStyle.gold12medium
                                        : TextStyle(
                                            color: Color.fromRGBO(
                                                255, 255, 255, 1),
                                            fontSize: ScreenUtil().setSp(11),
                                            overflow: TextOverflow.visible,
                                            decoration: TextDecoration.none);
                                    double height = ScreenUtil()
                                        .setWidth(index == 0 ? 30 : 46);

                                    return TableRow(children: [
                                      Row(
                                        children: [
                                          Expanded(
                                              flex: 71,
                                              child: Container(
                                                height: height,
                                                alignment: Alignment.center,
                                                child: Text(
                                                  CommonUtils.txt(
                                                      levelList[index] + "j"),
                                                  style: style,
                                                ),
                                              )),
                                          Container(
                                            color: tableBorderColor,
                                            height: height,
                                            width: 1,
                                          ),
                                          // LayoutBuilder(builder: (context, constraints) {
                                          //   return Container(
                                          //     color: Colors.cyan,
                                          //     height: constraints.maxHeight,
                                          //     width: 1,
                                          //   );
                                          // }),
                                          Expanded(
                                              flex: 71,
                                              child: Container(
                                                alignment: Alignment.center,
                                                child: Text(
                                                  CommonUtils.txt(
                                                      levelList[index] + "jp"),
                                                  style: style,
                                                ),
                                              )),
                                          Container(
                                            color: tableBorderColor,
                                            height: height,
                                            width: 1,
                                          ),
                                          Expanded(
                                              flex: 176,
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal:
                                                      ScreenUtil().setWidth(20),
                                                ),
                                                // vertical: ScreenUtil().setWidth(10)),
                                                alignment: Alignment.center,
                                                child: Text(
                                                  CommonUtils.txt(
                                                      levelList[index] + "jc"),
                                                  style: style,
                                                  textAlign: TextAlign.center,
                                                  // maxLines: 2,
                                                ),
                                              )),
                                        ],
                                      ),
                                    ]);
                                  },
                                ).toList(),
                              ),
                            ])),
                        Container(
                            padding: EdgeInsets.all(ScreenUtil().setWidth(20)),
                            decoration: BoxDecoration(
                                color: GQStyle.blackColor32,
                                borderRadius: BorderRadius.circular(
                                    ScreenUtil().setWidth(5))),
                            child: Column(children: [
                              AegntTitleWidget(CommonUtils.txt('ztsy')),
                              SizedBox(
                                height: ScreenUtil().setWidth(20),
                              ),
                              Text(
                                CommonUtils.txt('ztsyx'),
                                style: TextStyle(
                                    color: Color.fromRGBO(255, 255, 255, 1),
                                    fontSize: ScreenUtil().setSp(11),
                                    overflow: TextOverflow.visible,
                                    decoration: TextDecoration.none),
                                // maxLines: 3,
                              ),
                              SizedBox(
                                height: ScreenUtil().setWidth(20),
                              ),
                              LImage(
                                'dlcj',
                                width: ScreenUtil().setWidth(283),
                                height: ScreenUtil().setWidth(121),
                              ),
                            ])),
                        Container(
                          padding: EdgeInsets.all(ScreenUtil().setWidth(20)),
                          decoration: BoxDecoration(
                              color: GQStyle.blackColor32,
                              borderRadius: BorderRadius.circular(
                                  ScreenUtil().setWidth(5))),
                          child: Column(
                              children: [
                            AegntTitleWidget(CommonUtils.txt('cjsyt')),
                            Text(
                              CommonUtils.txt('cjsyx'),
                              style: TextStyle(
                                  color: Color.fromRGBO(255, 255, 255, 1),
                                  fontSize: ScreenUtil().setSp(11),
                                  overflow: TextOverflow.visible,
                                  decoration: TextDecoration.none),
                              // maxLines: 3,
                            ),
                            Container(
                              alignment: Alignment.topCenter,
                              width: double.infinity,
                              // height: 20,
                              // color: Colors.red,
                              child: LImage(
                                'dlcy',
                                width: ScreenUtil().setWidth(340),
                                height: ScreenUtil().setWidth(165),
                              ),
                            ),
                            RichText(
                                text: TextSpan(children: [
                              TextSpan(
                                text: CommonUtils.txt('cjsyy'),
                                style: GQStyle.white11,
                              ),
                              TextSpan(
                                text: CommonUtils.txt('cjsyyw'),
                                style: TextStyle(
                                    color: Color.fromRGBO(0, 188, 9, 1),
                                    fontSize: ScreenUtil().setSp(11),
                                    overflow: TextOverflow.ellipsis,
                                    decoration: TextDecoration.none),
                              ),
                            ])),
                            RichText(
                                text: TextSpan(children: [
                              TextSpan(
                                text: CommonUtils.txt('cjsye'),
                                style: GQStyle.white11,
                              ),
                              TextSpan(
                                text: CommonUtils.txt('cjsyew'),
                                style: TextStyle(
                                    color: Color.fromRGBO(36, 98, 239, 1),
                                    fontSize: ScreenUtil().setSp(11),
                                    overflow: TextOverflow.ellipsis,
                                    decoration: TextDecoration.none),
                              ),
                            ])),
                            RichText(
                                text: TextSpan(children: [
                              TextSpan(
                                text: CommonUtils.txt('cjsyys'),
                                style: GQStyle.white11,
                              ),
                              TextSpan(
                                text: CommonUtils.txt('cjsysw'),
                                style: TextStyle(
                                    color: Color.fromRGBO(239, 127, 36, 1),
                                    fontSize: ScreenUtil().setSp(11),
                                    overflow: TextOverflow.ellipsis,
                                    decoration: TextDecoration.none),
                              ),
                            ]))
                          ]
                                  .map((e) => Column(
                                        children: [
                                          e,
                                          SizedBox(
                                            height: ScreenUtil().setWidth(15),
                                          ),
                                        ],
                                      ))
                                  .toList()),
                        ),
                        Container(
                          padding: EdgeInsets.all(ScreenUtil().setWidth(20)),
                          decoration: BoxDecoration(
                              color: GQStyle.blackColor32,
                              borderRadius: BorderRadius.circular(
                                  ScreenUtil().setWidth(5))),
                          child: Column(children: [
                            AegntTitleWidget(
                              CommonUtils.txt(
                                'zj',
                              ),
                              hideIcon: false,
                            ),
                            SizedBox(
                              height: ScreenUtil().setWidth(20),
                            ),
                            Text(
                              CommonUtils.txt('zjy'),
                              style: TextStyle(
                                  color: Color.fromRGBO(255, 255, 255, 1),
                                  fontSize: ScreenUtil().setSp(11),
                                  overflow: TextOverflow.visible,
                                  decoration: TextDecoration.none),
                              // maxLines: 5,
                            ),
                            SizedBox(
                              height: ScreenUtil().setWidth(20),
                            ),
                            Text(
                              CommonUtils.txt('zje'),
                              style: TextStyle(
                                  color: Color.fromRGBO(255, 255, 255, 1),
                                  fontSize: ScreenUtil().setSp(11),
                                  overflow: TextOverflow.visible,
                                  decoration: TextDecoration.none),
                              // maxLines: 5,
                            ),
                            SizedBox(
                              height: ScreenUtil().setWidth(40),
                            ),
                            AegntTitleWidget(
                              CommonUtils.txt('gzkd'),
                              hideIcon: true,
                            ),
                            SizedBox(height: ScreenUtil().setWidth(20)),
                            GestureDetector(
                              onTap: () {
                                Config config = Provider.of<HomeConfig>(context,
                                        listen: false)
                                    .config;
                                CommonUtils.launchURL(config.officialGroup);
                              },
                              child: LImage(
                                'dljq',
                                width: ScreenUtil().setWidth(255),
                                height: ScreenUtil().setWidth(35),
                              ),
                            ),
                            SizedBox(height: ScreenUtil().setWidth(15)),
                          ]),
                        ),
                        SizedBox(
                          height: ScreenUtil().setWidth(15),
                        )
                      ]
                          .map((e) => Column(
                                children: [
                                  SizedBox(
                                    height: ScreenUtil().setWidth(15),
                                  ),
                                  e
                                ],
                              ))
                          .toList(),
                    ),
                    Positioned(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: GestureDetector(
                          onTap: () {
                            context.push('/${Routes.kwantsharetousers}');
                          },
                          child: SafeArea(
                            child: Container(
                              height: ScreenUtil().setWidth(38.5),
                              child: Center(
                                child: Container(
                                  width: ScreenUtil().setWidth(264),
                                  height: ScreenUtil().setWidth(38.5),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Color(0xFFfaddbd),
                                        Color(0xFFf2c380)
                                      ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    ),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(
                                          ScreenUtil().setWidth(38.5 / 2)),
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      CommonUtils.txt("ljtg"),
                                      style: TextStyle(
                                        fontSize: ScreenUtil().setSp(20),
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xffaa5000),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
  }
}

class AegntTitleWidget extends StatelessWidget {
  AegntTitleWidget(this.title, {this.hideIcon = false});
  String title;
  bool hideIcon;
  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        // padding: EdgeInsets.all(ScreenUtil().setWidth(20)),
        child: UnconstrainedBox(
            child: Row(
          children: [
            hideIcon
                ? Container()
                : LImage(
                    'dlbtw',
                    width: ScreenUtil().setWidth(43),
                    height: ScreenUtil().setWidth(14.5),
                  ),
            Container(
              padding:
                  EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(4.5)),
              child: Text(
                title,
                style: kIsWeb
                    ? GQStyle.gold18M
                    : TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: ScreenUtil().setSp(18),
                        foreground: Paint()
                          ..shader = LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  // begin: Alignment.centerLeft,
                                  // end: Alignment.centerRight,
                                  colors: <Color>[
                                    Color.fromRGBO(236, 180, 129, 1),

                                    Color.fromRGBO(255, 238, 216, 1),

                                    // Colors.green,
                                    // Colors.red
                                  ],
                                  tileMode: TileMode.repeated)
                              .createShader(
                            //Rect.largest
                            Rect.fromLTWH(
                                0.0, 0.0, 3.0, ScreenUtil().setWidth(19)),
                          )),
              ),
            ),
            hideIcon
                ? Container()
                : LImage(
                    'dlbtw2',
                    width: ScreenUtil().setWidth(43),
                    height: ScreenUtil().setWidth(14.5),
                  ),
          ],
        )));
  }
}

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    // double scale = 0.8;
    // double roundFactor = size.height * (1 - scale);
    double roundFactor = ScreenUtil().setWidth(5);

    // path.moveTo(0, size.height * 0.8);
    // path.addRRect(RRect.)

    // path.moveTo(0, size.height / 3.3);
    // path.lineTo(0, 0);
    path.lineTo(0, size.height - roundFactor);
    path.quadraticBezierTo(
        size.width / 2.0, size.height, size.width, size.height - roundFactor);
    // path.lineTo(size.width - roundFactor, size.height);
    path.lineTo(size.width, 0);

    // path.lineTo(0, size.height / 3.3);

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}
