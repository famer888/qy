import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qypj/theme/default.dart';
import 'package:qypj/utils/common.dart';
import 'package:qypj/utils/extensionlibrary.dart';
import 'package:qypj/utils/networkImage.dart';

//单列横屏文本 type=16
class SingleColandscapeTxt extends StatefulWidget {
  SingleColandscapeTxt({Key key, this.data}) : super(key: key);
  dynamic data;

  @override
  State<SingleColandscapeTxt> createState() => _SingleColandscapeTxtState();
}

class _SingleColandscapeTxtState extends State<SingleColandscapeTxt> {
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
                          if (widget.data["content_type"] == 3) {
                            context.push(
                                "/more_and_more_nvel/0/0/${widget.data["id"] ?? "0"}");
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
          childAspectRatio: 349 / 114,
          scrollDirection: Axis.vertical,
          physics: NeverScrollableScrollPhysics(),
          children: _values
              .map((e) => GestureDetector(
                    onTap: () {
                      context.push(CommonUtils.getRealHash(
                          'novelDetail/${e["id"] ?? "0"}'));
                    },
                    child: Container(
                        padding:
                            EdgeInsets.only(right: ScreenUtil().setWidth(10)),
                        decoration: BoxDecoration(
                            color: Color.fromRGBO(25, 25, 25, 1.0),
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                        child: Row(
                          children: [
                            SizedBox(
                              width: ScreenUtil().setWidth(110 * 70 / 90.0),
                              child: Stack(
                                children: [
                                  PlatformAwareNetworkImage(
                                      url: clipImageUrl(CommonUtils.getThumb(e),
                                          inputWidth: ScreenUtil()
                                              .setWidth(110 * 70 / 90.0)),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5))),
                                  Positioned(
                                      right: 0,
                                      top: 0,
                                      child: CommonUtils.identiWget(e,
                                          isHideCoin: true))
                                ],
                              ),
                            ),
                            SizedBox(width: ScreenUtil().setWidth(7)),
                            Expanded(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: ScreenUtil().setWidth(5)),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: ScreenUtil().setWidth(120),
                                      child: Text(e["title"] ?? "loading",
                                          style: GQStyle.white255_14_M),
                                    ),
                                    Spacer(),
                                    Expanded(
                                        child: Row(
                                      children: [
                                        LImage(
                                          "capter_n",
                                          width: ScreenUtil().setWidth(12),
                                          height: ScreenUtil().setWidth(14),
                                        ),
                                        SizedBox(
                                            width: ScreenUtil().setWidth(5)),
                                        Text(e["views_count"].toString(),
                                            style: GQStyle.white255_14)
                                      ],
                                    ))
                                  ],
                                ),
                                SizedBox(height: ScreenUtil().setWidth(7.5)),
                                Text(e["desc"] ?? "loading",
                                    style: GQStyle.gray128_11, maxLines: 3),
                              ],
                            )),
                          ],
                        )),
                  ))
              .toList(),
        ),
        SizedBox(height: ScreenUtil().setWidth(26.5))
      ],
    );
  }
}
