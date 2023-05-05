import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qypj/theme/default.dart';
import 'package:qypj/utils/common.dart';
import 'package:qypj/utils/extensionlibrary.dart';
import 'package:qypj/utils/networkImage.dart';

//双列横屏_抢购 type = 9
class DoubleColHorRush extends StatefulWidget {
  DoubleColHorRush({Key key, this.data}) : super(key: key);
  dynamic data;

  @override
  State<DoubleColHorRush> createState() => _DoubleColHorRushState();
}

class _DoubleColHorRushState extends State<DoubleColHorRush> {
  double _w = (ScreenUtil().screenWidth -
          GQStyle.pagePadding * 2 -
          ScreenUtil().setWidth(4)) /
      2;
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
                        behavior: HitTestBehavior.translucent,
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
            return Column(
              children: [
                GridView.count(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  mainAxisSpacing: ScreenUtil().setWidth(15.5),
                  crossAxisSpacing: ScreenUtil().setWidth(4),
                  childAspectRatio: 224 / 196,
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: _w / 173 * 100,
                                      child: PlatformAwareNetworkImage(
                                          url: clipImageUrl(
                                              CommonUtils.getThumb(e),
                                              inputWidth:
                                                  ScreenUtil().setWidth(173)),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5))),
                                    ),
                                    SizedBox(
                                        height: ScreenUtil().setWidth(3.5)),
                                    Text(e["title"] ?? "loading",
                                        style: GQStyle.white244_14),
                                    SizedBox(
                                        height: ScreenUtil().setWidth(3.5)),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                            "${CommonUtils.renderFixedNumber(e["play_ct"] ?? 0)}${CommonUtils.txt("cbf")}",
                                            style: GQStyle.gray105_11),
                                        Spacer(),
                                        Text(
                                            "${CommonUtils.getHMTime(e["duration"] ?? 0)}",
                                            style: GQStyle.gray105_11),
                                        SizedBox(
                                            width: ScreenUtil().setWidth(5))
                                      ],
                                    )
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
                        ),
                      ],
                    ),
                  ),
                )),
                SizedBox(height: ScreenUtil().setWidth(26.5))
              ],
            );
          }).toList()),
        ),
      ],
    );
  }
}
