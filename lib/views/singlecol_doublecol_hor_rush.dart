import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qypj/theme/default.dart';
import 'package:qypj/utils/api.dart';
import 'package:qypj/utils/common.dart';
import 'package:qypj/utils/extensionlibrary.dart';
import 'package:qypj/utils/networkImage.dart';

//单列双列横屏_抢购 type = 8
class SingleColDoubleColHorRush extends StatefulWidget {
  SingleColDoubleColHorRush({Key key, this.data}) : super(key: key);
  dynamic data;

  @override
  State<SingleColDoubleColHorRush> createState() =>
      _SingleColDoubleColHorRushState();
}

class _SingleColDoubleColHorRushState extends State<SingleColDoubleColHorRush> {
  double _w = (ScreenUtil().screenWidth -
          GQStyle.pagePadding * 2 -
          ScreenUtil().setWidth(4)) /
      2;
  double _cw = ScreenUtil().screenWidth - GQStyle.pagePadding * 2;
  List<dynamic> _values;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.data == null) return;
    _values = widget.data["value"];
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
                Expanded(
                    child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(widget.data["title"] ?? "loading",
                        style: GQStyle.white255_18_B),
                    SizedBox(width: ScreenUtil().setWidth(8.5)),
                    Expanded(
                      child: Text(widget.data["sub_title"] ?? "loading",
                          style: GQStyle.gray168_12),
                    ),
                    SizedBox(width: ScreenUtil().setWidth(8.5)),
                  ],
                )),
                widget.data["more_button"] == 0
                    ? Container()
                    : GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
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
        Container(
          padding: EdgeInsets.symmetric(horizontal: GQStyle.pagePadding),
          child: Column(
              children: _values.map((e) {
            List<dynamic> t = e["value"];
            dynamic ft = t.first;
            t = t.sublist(1, t.length);
            return Column(
              children: [
                GestureDetector(
                  onTap: () {
                    context.push(
                        CommonUtils.getRealHash('videoDetail/${ft["id"]}'));
                  },
                  child: Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                              height: _cw / 350 * 200,
                              child: PlatformAwareNetworkImage(
                                  url: CommonUtils.getThumb(ft),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)))),
                          SizedBox(height: ScreenUtil().setWidth(3.5)),
                          Text(ft["title"] ?? "loading",
                              style: GQStyle.white255_14),
                          SizedBox(height: ScreenUtil().setWidth(3.5)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                  "${CommonUtils.renderFixedNumber(ft["count_play"] ?? 0)}${CommonUtils.txt("cbf")}",
                                  style: GQStyle.gray105_12),
                              Text(
                                  "${CommonUtils.getHMTime(ft["duration"] ?? 0)}",
                                  style: GQStyle.gray105_12)
                            ],
                          ),
                        ],
                      ),
                      Positioned(
                          right: 0, top: 0, child: CommonUtils.identiWget(ft))
                    ],
                  ),
                ),
                SizedBox(
                    height: ScreenUtil().setWidth(t.length == 0 ? 0 : 15.5)),
                t.length == 0
                    ? Container()
                    : GridView.count(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        crossAxisCount: 2,
                        mainAxisSpacing: ScreenUtil().setWidth(15.5),
                        crossAxisSpacing: ScreenUtil().setWidth(4.0),
                        childAspectRatio: 224 / 188,
                        scrollDirection: Axis.vertical,
                        physics: NeverScrollableScrollPhysics(),
                        children: t
                            .map((e) => GestureDetector(
                                  onTap: () {
                                    context.push(CommonUtils.getRealHash(
                                        'videoDetail/${e["id"]}'));
                                  },
                                  child: Stack(
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            height: _w / 173 * 100,
                                            child: PlatformAwareNetworkImage(
                                                url: clipImageUrl(
                                                    clipImageUrl(
                                                        CommonUtils.getThumb(e),
                                                        inputWidth: ScreenUtil()
                                                            .setWidth(173)),
                                                    inputWidth: ScreenUtil()
                                                        .setWidth(173)),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(5))),
                                          ),

                                          Expanded(
                                            flex: 26,
                                            child: Container(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                  e["title"] ?? "loading",
                                                  style: GQStyle.white244_14),
                                            ),
                                          ),
                                          Expanded(
                                              flex: 14,
                                              child: Container(
                                                alignment: Alignment.center,
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      "${CommonUtils.renderFixedNumber(e["count_play"] ?? 0)}${CommonUtils.txt("cbf")}",
                                                      style: GQStyle.gray105_11,
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                    Text(
                                                      "${CommonUtils.getHMTime(e["duration"] ?? 0)}",
                                                      style: GQStyle.gray105_11,
                                                      textAlign:
                                                          TextAlign.center,
                                                    )
                                                  ],
                                                ),
                                              )),
                                          // SizedBox(
                                          //     height:
                                          //         ScreenUtil().setWidth(3.5)),
                                          // Text(e["title"] ?? "loading",
                                          //     style: GQStyle.white244_14),
                                          // SizedBox(
                                          //     height:
                                          //         ScreenUtil().setWidth(3.5)),
                                          // Row(
                                          //   mainAxisAlignment:
                                          //       MainAxisAlignment.spaceBetween,
                                          //   children: [
                                          //     Text(
                                          //         "${CommonUtils.renderFixedNumber(e["count_play"] ?? 0)}${CommonUtils.txt("cbf")}",
                                          //         style: GQStyle.gray105_11),
                                          //     Text(
                                          //         "${CommonUtils.getHMTime(e["duration"] ?? 0)}",
                                          //         style: GQStyle.gray105_11)
                                          //   ],
                                          // )
                                        ],
                                      ),
                                      Positioned(
                                          right: 0,
                                          top: 0,
                                          child: CommonUtils.identiWget(e))
                                    ],
                                  ),
                                ))
                            .toList(),
                      ),
                SizedBox(height: ScreenUtil().setWidth(14)),
                Center(
                  child: SizedBox(
                    height: ScreenUtil().setWidth(42),
                    width: ScreenUtil().setWidth(333),
                    child: GestureDetector(
                      onTap: () {
                        context
                            .push('/more_and_more_collect/${e["id"] ?? "0"}/1');
                      },
                      child: Stack(
                        children: [
                          LImage("supother_n"),
                          Positioned(
                            top: ScreenUtil().setWidth(11),
                            left: ScreenUtil().setWidth(55),
                            child: Text(
                              "${e["price"] ?? 0}${CommonUtils.txt("jbjs")}${e["total_num"]}${CommonUtils.txt("byp")}",
                              style: GQStyle.white255_15_M,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: ScreenUtil().setWidth(26.5))
              ],
            );
          }).toList()),
        ),
      ],
    );
  }
}
