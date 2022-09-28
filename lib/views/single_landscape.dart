import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qypj/theme/default.dart';
import 'package:qypj/utils/common.dart';
import 'package:qypj/utils/extensionlibrary.dart';
import 'package:qypj/utils/networkImage.dart';

//单列横屏 type = 7
class SingleLandscape extends StatefulWidget {
  SingleLandscape({Key key, this.data}) : super(key: key);
  dynamic data;

  @override
  State<SingleLandscape> createState() => _SingleLandscapeState();
}

class _SingleLandscapeState extends State<SingleLandscape> {
  double _w = ScreenUtil().screenWidth - GQStyle.pagePadding * 2;
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
                          if (widget.data["more_page_show_type"] == 3) {
                            context.push(
                                '/more_and_more_case/${widget.data["id"] ?? "0"}');
                          } else {
                            context.push(
                                '/more_and_more_normal/${widget.data["id"] ?? "0"}');
                          }
                        },
                        child: Row(
                          children: [
                            Text(CommonUtils.txt("gd"),
                                style: GQStyle.gray205_14),
                            SizedBox(width: ScreenUtil().setWidth(7)),
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
          childAspectRatio: 350 / 246,
          scrollDirection: Axis.vertical,
          physics: NeverScrollableScrollPhysics(),
          children: _values
              .map((e) => GestureDetector(
                    onTap: () {
                      context.push(
                          CommonUtils.getRealHash('videoDetail/${e["id"]}'));
                    },
                    child: Stack(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: _w / 350 * 200,
                              child: PlatformAwareNetworkImage(
                                  url: clipImageUrl(CommonUtils.getThumb(e),
                                      inputWidth: ScreenUtil().setWidth(350)),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5))),
                            ),
                            SizedBox(height: ScreenUtil().setWidth(3.5)),
                            Text(e["title"] ?? "loading",
                                style: GQStyle.white255_14),
                            SizedBox(height: ScreenUtil().setWidth(0.5)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                    "${CommonUtils.renderFixedNumber(e["count_play"] ?? 0)}${CommonUtils.txt("cbf")}",
                                    style: GQStyle.gray105_12),
                                Text(
                                    "${CommonUtils.getHMTime(e["duration"] ?? 0)}",
                                    style: GQStyle.gray105_12)
                              ],
                            )
                          ],
                        ),
                        Positioned(
                            right: 0, top: 0, child: CommonUtils.identiWget(e))
                      ],
                    ),
                  ))
              .toList(),
        ),
        SizedBox(height: ScreenUtil().setWidth(16.5))
      ],
    );
  }
}
