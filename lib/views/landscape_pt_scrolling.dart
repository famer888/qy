import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qypj/theme/default.dart';
import 'package:qypj/utils/common.dart';
import 'package:qypj/utils/extensionlibrary.dart';
import 'package:qypj/utils/networkImage.dart';

//横向竖屏滚动 type=15
class LandscapePtScrolling extends StatefulWidget {
  LandscapePtScrolling({Key key, this.data}) : super(key: key);
  dynamic data;

  @override
  State<LandscapePtScrolling> createState() => _LandscapePtScrollingState();
}

class _LandscapePtScrollingState extends State<LandscapePtScrolling> {
  double _w = (ScreenUtil().screenWidth -
          GQStyle.pagePadding * 2 -
          ScreenUtil().setWidth(20)) /
      3;

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
                          if (widget.data["content_type"] == 2) {
                            context.push(
                                "/more_and_more_comc/${widget.data["id"] ?? "0"}");
                          } else if (widget.data["content_type"] == 3) {
                            context.push(
                                "/more_and_more_nvel/0/0/${widget.data["id"] ?? "0"}");
                          } else if (widget.data["content_type"] == 6) {
                            context.push(
                                "/more_and_more_png/${widget.data["id"] ?? "0"}");
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
        SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: GQStyle.pagePadding),
          scrollDirection: Axis.horizontal,
          child: Row(
              children: _values
                  .map((e) => Row(
                        children: [
                          SizedBox(
                            width: _w,
                            child: GestureDetector(
                              onTap: () {
                                if (widget.data["content_type"] == 2) {
                                  context.push(CommonUtils.getRealHash(
                                      'comicsdetail/${e["id"] ?? "0"}'));
                                } else if (widget.data["content_type"] == 6) {
                                  context.push(CommonUtils.getRealHash(
                                      'atlasDetail/${e["id"] ?? "0"}'));
                                }
                              },
                              child: Stack(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: _w / 128 * 168,
                                        child: PlatformAwareNetworkImage(
                                            url: clipImageUrl(
                                                CommonUtils.getThumb(e),
                                                inputWidth:
                                                    ScreenUtil().setWidth(128)),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5))),
                                      ),
                                      SizedBox(
                                          height: ScreenUtil().setWidth(3.5)),
                                      Text(e["title"] ?? "loading",
                                          style: GQStyle.white255_14),
                                      SizedBox(
                                          height: ScreenUtil().setWidth(3.5)),
                                      widget.data["content_type"] == 6 //美图标识
                                          ? Container()
                                          : Text(
                                              e["finished"] == 1
                                                  ? "${CommonUtils.txt("wj")} ${CommonUtils.txt("gng")}${e["series"]}${CommonUtils.txt("hua")}"
                                                  : "${CommonUtils.txt("gxz")}${e["series"]}${CommonUtils.txt("hua")}",
                                              style: GQStyle.gray128_11,
                                            )
                                    ],
                                  ),
                                  Positioned(
                                      right: 0,
                                      top: 0,
                                      child: CommonUtils.identiWget(e,
                                          isHideCoin: widget
                                                      .data["content_type"] ==
                                                  2 ||
                                              widget.data["content_type"] == 6))
                                ],
                              ),
                            ),
                          ),
                          SizedBox(width: ScreenUtil().setWidth(10))
                        ],
                      ))
                  .toList()),
        ),
        SizedBox(height: ScreenUtil().setWidth(16.5))
      ],
    );
  }
}
