import 'package:flutter/material.dart';
import 'package:flutter_html/shims/dart_ui_real.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qypj/theme/default.dart';
import 'package:qypj/utils/common.dart';
import 'package:qypj/utils/extensionlibrary.dart';
import 'package:qypj/utils/networkImage.dart';

//单列横屏横向滚动_解锁 or 抢购 type = 5 or 10
class SingleColHorScrollUnlock extends StatefulWidget {
  SingleColHorScrollUnlock({Key key, this.data, this.tosup = false})
      : super(key: key);
  bool tosup;
  dynamic data;

  @override
  State<SingleColHorScrollUnlock> createState() =>
      _SingleColHorScrollUnlockState();
}

class _SingleColHorScrollUnlockState extends State<SingleColHorScrollUnlock> {
  // double _w = (ScreenUtil().screenWidth -
  //         GQStyle.pagePadding * 2 -
  //         ScreenUtil().setWidth(6)) /
  //     2;
  double _w = (ScreenUtil().setWidth(156.8));

  List<dynamic> _values;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (widget.data == null) return;
    _values = widget.data["value"];
  }

  @override
  void didUpdateWidget(covariant SingleColHorScrollUnlock oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: GQStyle.pagePadding),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                LImage(
                  "max_triangle_n",
                  width: ScreenUtil().setWidth(18),
                  height: ScreenUtil().setWidth(18),
                ),
                SizedBox(width: ScreenUtil().setWidth(5.5)),
                Text(widget.data["title"] ?? "loading",
                    style: GQStyle.white255_18_B),
                SizedBox(width: ScreenUtil().setWidth(8.5)),
                Text(widget.data["sub_title"] ?? "loading",
                    style: GQStyle.gray168_12),
                Spacer(),
                widget.data["more_button"] == 0
                    ? Container()
                    : GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          //打包合集
                          context.push(
                              '/more_and_more_collect/${_values.first["id"] ?? "0"}/1');
                        },
                        child: Row(
                          children: [
                            Text(CommonUtils.txt("gd"),
                                style: GQStyle.gray205_14),
                            SizedBox(width: ScreenUtil().setWidth(6)),
                            LImage("more_arrow_n",
                                width: ScreenUtil().setWidth(6),
                                height: ScreenUtil().setWidth(12))
                          ],
                        ),
                      )
              ]),
        ),
        SizedBox(height: ScreenUtil().setWidth(11.5)),
        GridView.count(
            padding: EdgeInsets.symmetric(horizontal: GQStyle.pagePadding),
            shrinkWrap: true,
            crossAxisCount: 1,
            mainAxisSpacing: ScreenUtil().setWidth(10),
            crossAxisSpacing: 0,
            childAspectRatio: 350 / (widget.tosup ? 300 : 300),
            scrollDirection: Axis.vertical,
            physics: NeverScrollableScrollPhysics(),
            children: _values
                .map((e) => Container(
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(25, 25, 25, 1.0),
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                    child: Stack(children: [
                      Container(
                        height: ScreenUtil().setWidth(220),
                        child: PlatformAwareNetworkImage(
                          url: clipImageUrl(CommonUtils.getThumb(e),
                              inputWidth: ScreenUtil().setWidth(220)),
                          fit: BoxFit.cover,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(5),
                            topRight: Radius.circular(5),
                          ),
                        ),
                      ),
                      Container(
                        height: ScreenUtil().setWidth(220),
                        // color: Color.fromRGBO(0, 0, 0, 0.8),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: [
                                Color.fromRGBO(25, 25, 25, 1),
                                Color.fromRGBO(25, 25, 25, 0.4)
                              ],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter),
                        ),
                        child: ClipRect(
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                            child: Container(),
                          ),
                        ),
                      ),
                      // Container(
                      //   height: ScreenUtil().setWidth(220),
                      //   decoration: BoxDecoration(
                      //     gradient: LinearGradient(
                      //       begin: Alignment.bottomCenter,
                      //       end: Alignment.topCenter,
                      //       colors: [
                      //         Color.fromRGBO(25, 25, 25, 1.0),
                      //         Color.fromRGBO(0, 0, 0, 0.3)
                      //       ],
                      //     ),
                      //   ),
                      // ),
                      Column(children: [
                        widget.tosup
                            ? Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(height: ScreenUtil().setWidth(29)),
                                  Center(
                                      child: Text(
                                    e["title"] ?? "loading",
                                    style: GQStyle.white255_18_M,
                                  )),
                                  SizedBox(height: ScreenUtil().setWidth(2)),
                                  Center(
                                      child: Text(
                                    e["sub_title"] ?? "loading",
                                    style: GQStyle.gray202_14,
                                  )),
                                  SizedBox(height: ScreenUtil().setWidth(8.5)),
                                  SizedBox(height: ScreenUtil().setWidth(27)),
                                ],
                              )
                            : SizedBox(
                                height: ScreenUtil().setWidth(90),
                                child: Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        e["title"] ?? "loading",
                                        style: GQStyle.white255_18_M,
                                      ),
                                      SizedBox(
                                        height: ScreenUtil().setWidth(5),
                                      ),
                                      Text(
                                        e["sub_title"] ?? "loading",
                                        style: GQStyle.gray202_14,
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                        SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: (e["value"] as List<dynamic>)
                                  .asMap()
                                  .keys
                                  .map((index) {
                                List list = e["value"] as List<dynamic>;
                                dynamic x = list[index];
                                return Row(
                                  children: [
                                    SizedBox(width: ScreenUtil().setWidth(6)),
                                    SizedBox(
                                      width: _w,
                                      child: GestureDetector(
                                        onTap: () {
                                          context.push(CommonUtils.getRealHash(
                                              'videoDetail/${x["id"]}'));
                                        },
                                        child: Stack(
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  height: _w / 157 * 91,
                                                  child:
                                                      PlatformAwareNetworkImage(
                                                    url: clipImageUrl(
                                                        CommonUtils.getThumb(x),
                                                        inputWidth: ScreenUtil()
                                                            .setWidth(157)),
                                                    borderRadius: index == 0
                                                        ? BorderRadius.only(
                                                            topLeft:
                                                                Radius.circular(
                                                                    5),
                                                            bottomLeft:
                                                                Radius.circular(
                                                                    5))
                                                        : index ==
                                                                list.length - 1
                                                            ? BorderRadius.only(
                                                                topRight: Radius
                                                                    .circular(
                                                                        5),
                                                                bottomRight:
                                                                    Radius
                                                                        .circular(
                                                                            5))
                                                            : BorderRadius.zero,
                                                  ),
                                                ),
                                                SizedBox(
                                                    height: ScreenUtil()
                                                        .setWidth(3.5)),
                                                Text(x["title"] ?? "loading",
                                                    style: GQStyle.white232_13),
                                                SizedBox(
                                                    height: ScreenUtil()
                                                        .setWidth(1.5)),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                        "${CommonUtils.renderFixedNumber(x["count_play"] ?? 0)}${CommonUtils.txt("cbf")}",
                                                        style:
                                                            GQStyle.gray105_12),
                                                    Spacer(),
                                                    Text(
                                                        "${CommonUtils.getHMTime(x["duration"] ?? 0)}",
                                                        style:
                                                            GQStyle.gray105_12),
                                                    SizedBox(
                                                        width: ScreenUtil()
                                                            .setWidth(5))
                                                  ],
                                                ),
                                              ],
                                            ),
                                            Positioned(
                                                right: 0,
                                                top: 0,
                                                child: CommonUtils.identiWget(x,
                                                    topRightRaiuds:
                                                        index != list.length - 1
                                                            ? 0
                                                            : 5))
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }).toList()
                                ..add(
                                  Row(children: [
                                    SizedBox(width: ScreenUtil().setWidth(6))
                                  ]),
                                ),
                            )),
                        // SizedBox(
                        //     height:
                        //         ScreenUtil().setWidth(widget.tosup ? 16 : 0)),
                        widget.tosup
                            ? Expanded(
                                child: Center(
                                    child: SizedBox(
                                height: ScreenUtil().setWidth(26),
                                width: ScreenUtil().setWidth(235),
                                child: GestureDetector(
                                  onTap: () {
                                    context.push(
                                        '/more_and_more_collect/${e["id"] ?? "0"}/1');
                                  },
                                  child: Stack(
                                    children: [
                                      LImage("sup_n"),
                                      Center(
                                        child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: ScreenUtil()
                                                    .setWidth(13.5)),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  "${e["price"] ?? 0}${CommonUtils.txt("jbjs")}${e["total_num"]}${CommonUtils.txt("byp")}",
                                                  style: GQStyle.white255_12,
                                                ),
                                                Text(
                                                  e["is_pay"] == 1
                                                      ? CommonUtils.txt("nyyd")
                                                      : CommonUtils.txt("ljqg"),
                                                  style: GQStyle.white255_12,
                                                ),
                                              ],
                                            )),
                                      )

                                      // Positioned(
                                      //   top: ScreenUtil().setWidth(11),
                                      //   left: ScreenUtil().setWidth(55),
                                      //   child: Text(
                                      //     "${e["price"] ?? 0}${CommonUtils.txt("jbjs")}${e["total_num"]}${CommonUtils.txt("byp")}",
                                      //     style: GQStyle.white255_15_M,
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                ),
                              )))
                            : Expanded(
                                child: Center(
                                child: SizedBox(
                                  height: ScreenUtil().setWidth(42),
                                  width: ScreenUtil().setWidth(333),
                                  child: GestureDetector(
                                    onTap: () {
                                      context.push(
                                          '/more_and_more_collect/${e["id"] ?? "0"}/1');
                                    },
                                    child: Stack(
                                      children: [
                                        LImage("supother_n"),
                                        Positioned(
                                          top: ScreenUtil().setWidth(11),
                                          left: ScreenUtil().setWidth(55),
                                          child: Text(
                                            "${e["price"] ?? 0}${CommonUtils.txt("jbjs")} ${e["total_num"]}${CommonUtils.txt("byp")}",
                                            style: GQStyle.white255_15_M,
                                          ),
                                        ),
                                        // Center(
                                        //   child: Padding(
                                        //       padding: EdgeInsets.symmetric(
                                        //           horizontal: ScreenUtil()
                                        //               .setWidth(13.5)),
                                        //       child: Row(
                                        //         mainAxisAlignment:
                                        //             MainAxisAlignment
                                        //                 .spaceBetween,
                                        //         children: [
                                        //           Text(
                                        //             "${e["price"] ?? 0}${CommonUtils.txt("jbjs")}${e["total_num"]}${CommonUtils.txt("byp")}",
                                        //             style: GQStyle.white255_12,
                                        //           ),
                                        //           Text(
                                        //             e["is_pay"] == 1
                                        //                 ? CommonUtils.txt("nyyd")
                                        //                 : CommonUtils.txt("ljqg"),
                                        //             style: GQStyle.white255_12,
                                        //           ),
                                        //         ],
                                        //       )),
                                        // ),
                                      ],
                                    ),
                                  ),
                                ),
                              )),
                        // SizedBox(
                        //     height:
                        //         ScreenUtil().setWidth(widget.tosup ? 25 : 16)),
                      ]),

                      Positioned(
                          right: 0,
                          top: 0,
                          child: widget.tosup
                              ? Container()
                              : Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: ScreenUtil().setWidth(8)),
                                  decoration: BoxDecoration(
                                    color: Color.fromRGBO(25, 114, 205, 1),
                                    borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(5),
                                        topRight: Radius.circular(5)),
                                  ),
                                  height: ScreenUtil().setWidth(18),
                                  child: Center(
                                      child: Text(CommonUtils.txt('zht'),
                                          style: GQStyle.white255_10)),
                                ))
                    ])))
                .toList()),
        SizedBox(height: ScreenUtil().setWidth(26.5))
      ],
    );
  }
}
