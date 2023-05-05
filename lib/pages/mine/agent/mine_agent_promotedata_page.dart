import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qypj/base/baseWidget.dart';
import 'package:qypj/components/page_status.dart';
import 'package:qypj/model/basic.dart';
import 'package:qypj/routers.dart';
import 'package:qypj/theme/default.dart';
import 'package:qypj/utils/api.dart';
import 'package:qypj/utils/common.dart';
import 'package:qypj/utils/extensionlibrary.dart';

class MineAgentPromoteDataPage extends BaseWidget {
  cState() => _MineAgentPromoteDataPageState();
}

class _MineAgentPromoteDataPageState extends BaseWidgetState {
  bool networkErr = false;
  bool isHud = true;

  dynamic _data;

  List<String> dataTitleList = [
    "dysy",
    // "dyyj",
    "dytgs",
    "jrsy",
    // "jryj",
    "jrtgs",
  ];

  List<dynamic> dataTitleValueList = [];

  List<String> statisticsList = [
    "ljysh",
    "ljffyh",
    // "zsxjdl",
  ];

  List<String> statisticsValueList = [
    "direct_proxy_num", // 直推代理
    "direct_pay_num", // 直推付费
    // "direct_xiajidaili", // 直属下级代理
  ];

  List<String> levelList = [
    'dld',
    'zs',
    'bj',
    'hj',
    'by',
    'qt',
    'pt',
  ];

  _getData() async {
    try {
      Basic res = await getProxyDetail({});
      if (res.status != 1) {
        CommonUtils.showText(res.msg);
        isHud = false;
        networkErr = true;
        setState(() {});
      } else {
        isHud = false;
        networkErr = false;
        _data = res.data;

        dataTitleValueList.clear();

        dataTitleValueList.add(_data['curMonth']['reward'] ?? '');
        // dataTitleValueList.add(_data['curMonth']['sell'] ?? '');
        dataTitleValueList.add(_data['curMonth']['invited_num'] ?? '');

        dataTitleValueList.add(_data['today']['reward'] ?? '');
        // dataTitleValueList.add(_data['today']['sell'] ?? '');
        dataTitleValueList.add(_data['today']['invited_num'] ?? '');

        setState(() {});
      }
    } catch (e) {
      isHud = false;
      networkErr = true;
      setState(() {});
    }
  }

  @override
  void onCreate() {
    setAppTitle(
      title: CommonUtils.txt('tgsj'),
    );

    _getData();
  }

  @override
  Widget appbar() {
    return isHud
        ? super.appbar()
        : Stack(children: [
            super.appbar(),
            Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: GQStyle.pagePadding),
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
    // TODO: implement appbar
    return super.appbar();
  }

  @override
  void onDestroy() {
    // TODO: implement onDestroy
  }

  @override
  Widget pageBody(BuildContext context) {
    return networkErr
        ? PageStatus.noNetWork(
            text: CommonUtils.txt('wlcw'),
            onTap: () {
              _getData();
            })
        : isHud
            ? PageStatus.loading(mounted)
            : Container(
                padding: EdgeInsets.symmetric(
                    horizontal: ScreenUtil().setHeight(17.5),
                    vertical: ScreenUtil().setHeight(18)),
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    ClipRRect(
                      borderRadius:
                          BorderRadius.circular(ScreenUtil().setWidth(5)),
                      child: Container(
                        height: ScreenUtil().setWidth(157),
                        child: Stack(
                          children: [
                            Positioned.fill(
                                child: LImage(
                              'dl_penal',
                              fit: BoxFit.cover,
                            )),
                            // Container(
                            //   height: ScreenUtil().setWidth(157),
                            //   decoration: BoxDecoration(
                            //     borderRadius: BorderRadius.all(
                            //         Radius.circular(ScreenUtil().setWidth(5))),
                            //     gradient: LinearGradient(
                            //         begin: Alignment.topCenter,
                            //         end: Alignment.bottomCenter,
                            //         colors: [
                            //           Color(0xfff3e8d8),
                            //           Color(0xffe7cdb6)
                            //         ]),
                            //   ),
                            // ),
                            Positioned.fill(
                              top: ScreenUtil().setWidth(22),
                              child: Row(
                                children: [
                                  Expanded(
                                      child: Container(
                                    child: Column(
                                      children: [
                                        Text(
                                          CommonUtils.txt('ktx'),
                                          style: GQStyle.brown1187551_12_semi,
                                        ),
                                        SizedBox(
                                            height: ScreenUtil().setWidth(5)),
                                        Text(
                                          '${_data['proxy_money'] ?? ''}',
                                          style: GQStyle.brown1187551_24_semi,
                                        ),
                                      ],
                                    ),
                                  )),
                                  Align(
                                    alignment: Alignment.topCenter,
                                    child: Container(
                                        width: ScreenUtil().setHeight(0.5),
                                        height: ScreenUtil().setHeight(45),
                                        color: Color(0xffba957d)),
                                  ),
                                  Expanded(
                                      child: Container(
                                    // height: ScreenUtil().setWidth(50),
                                    child: Column(
                                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          CommonUtils.txt('zsy'),
                                          style: GQStyle.brown1187551_12_semi,
                                        ),
                                        SizedBox(
                                            height: ScreenUtil().setWidth(5)),
                                        Text(
                                          '${_data['all_reward'] ?? ''}',
                                          style: GQStyle.brown1187551_24_semi,
                                        ),
                                      ],
                                    ),
                                  ))
                                ],
                              ),
                            ),
                            Positioned.fill(
                              child: Column(
                                children: [
                                  Expanded(flex: 95, child: Container()),
                                  Container(
                                    alignment: Alignment.center,
                                    child: GestureDetector(
                                      onTap: () {
                                        context.push('/mineAgentToCashPage/1');
                                      },
                                      child: Container(
                                        width: ScreenUtil().setWidth(216),
                                        height: ScreenUtil().setWidth(35),
                                        // alignment: Alignment.center,
                                        // decoration: BoxDecoration(
                                        //     borderRadius:
                                        //         BorderRadiusDirectional
                                        //             .circular(ScreenUtil()
                                        //                 .setWidth(31 / 2.0)),
                                        //     color: Color(0xff3d3732)),
                                        child: LImage(
                                          'ljtx',
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(flex: 25, child: Container()),
                                ],
                              ),
                            ),
                            // Positioned.fill(
                            //   // top: ScreenUtil().setWidth(90),
                            //   child: Row(
                            //     children: [
                            //       Expanded(
                            //           child: Column(
                            //         children: [
                            //           Expanded(flex: 95, child: Container()),
                            //           Container(
                            //             alignment: Alignment.center,
                            //             child: GestureDetector(
                            //               onTap: () {
                            //                 context.push(
                            //                     '/' + Routes.mineAgentToCashPage);
                            //               },
                            //               child: Container(
                            //                 width: ScreenUtil().setWidth(83),
                            //                 height: ScreenUtil().setWidth(27.5),
                            //                 alignment: Alignment.center,
                            //                 decoration: BoxDecoration(
                            //                     borderRadius:
                            //                         BorderRadiusDirectional
                            //                             .circular(ScreenUtil()
                            //                                 .setWidth(27.5 / 2.0)),
                            //                     gradient: LinearGradient(
                            //                       begin: Alignment.bottomCenter,
                            //                       end: Alignment.topCenter,
                            //                       colors: <Color>[
                            //                         Color.fromRGBO(24, 23, 21, 1),
                            //                         Color.fromRGBO(76, 56, 28, 1)
                            //                       ],
                            //                     )),
                            //                 child: Text(
                            //                   CommonUtils.txt('tx'),
                            //                   style: GQStyle.gold14medium,
                            //                 ),
                            //               ),
                            //             ),
                            //           ),
                            //           Expanded(flex: 25, child: Container()),
                            //         ],
                            //       )),
                            //       Expanded(child: Container())
                            //     ],
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: ScreenUtil().setWidth(20)),
                    Container(
                      // height: ScreenUtil().setWidth(165),
                      padding: EdgeInsets.symmetric(
                          vertical: ScreenUtil().setWidth(24)),
                      decoration: BoxDecoration(
                        color: Color(0xff232337),
                        borderRadius: BorderRadius.all(
                            Radius.circular(ScreenUtil().setWidth(5))),
                      ),
                      child: GridView.count(
                        padding: EdgeInsets.zero,
                        physics: NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        childAspectRatio: 190 / 65.0,
                        mainAxisSpacing: ScreenUtil().setWidth(26),
                        crossAxisSpacing: ScreenUtil().setWidth(50),
                        children: dataTitleList.asMap().keys.map((index) {
                          dynamic element = dataTitleList[index];
                          return Container(
                            alignment: Alignment.center,
                            // color: Colors.orange,
                            // height: ScreenUtil().setWidth(36),
                            child: Column(
                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${dataTitleValueList[index]}',
                                  style: GQStyle.white255_15_semibold,
                                ),
                                SizedBox(
                                  height: ScreenUtil().setWidth(5),
                                ),
                                Text(
                                  CommonUtils.txt(element),
                                  style: GQStyle.rgb250219183_14,
                                )
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    SizedBox(
                      height: ScreenUtil().setWidth(40),
                    ),
                    Container(
                      // padding: EdgeInsets.symmetric(
                      //     horizontal: ScreenUtil().setWidth(10)),
                      child: Column(
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            // padding: EdgeInsets.symmetric(
                            //     vertical: ScreenUtil().setWidth(15)),
                            child: Text(
                              CommonUtils.txt('tgztj'),
                              style: GQStyle.white255_18_M,
                            ),
                          ),
                          Wrap(
                            children: statisticsList.asMap().keys.map((index) {
                              String name = statisticsList[index];
                              return Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: ScreenUtil().setWidth(10)),
                                  child: Row(
                                    children: [
                                      Text(
                                        CommonUtils.txt(name),
                                        style: GQStyle.hexffdbb2_13,
                                      ),
                                      Expanded(child: Container()),
                                      Text(
                                        '${_data[statisticsValueList[index]] ?? ''}',
                                        style: GQStyle.white255_15_M,
                                      ),
                                      SizedBox(
                                          width: ScreenUtil().setWidth(40)),
                                    ],
                                  ));
                            }).toList(),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              );
  }
}
