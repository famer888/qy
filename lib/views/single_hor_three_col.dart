import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qypj/theme/default.dart';
import 'package:qypj/utils/common.dart';
import 'package:qypj/utils/extensionlibrary.dart';
import 'package:qypj/utils/networkImage.dart';

//单横三列竖屏 type = 12
class SingleHorThreeCol extends StatefulWidget {
  SingleHorThreeCol({Key key, this.data}) : super(key: key);
  dynamic data;

  @override
  State<SingleHorThreeCol> createState() => _SingleHorThreeColState();
}

class _SingleHorThreeColState extends State<SingleHorThreeCol> {
  double _w = (ScreenUtil().screenWidth -
          GQStyle.pagePadding * 2 -
          ScreenUtil().setWidth(20)) /
      3;
  double _cw = ScreenUtil().screenWidth - GQStyle.pagePadding * 2;
  List<dynamic> _values;
  dynamic _firstValue;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.data == null) return;
    List<dynamic> ts = widget.data["value"];
    _firstValue = ts.first;
    _values = ts.sublist(1, ts.length);
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
                        onTap: () {},
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
        Padding(
          padding: EdgeInsets.symmetric(horizontal: GQStyle.pagePadding),
          child: GestureDetector(
            onTap: () {
              if (widget.data["content_type"] == 2) {
                context.push(CommonUtils.getRealHash(
                    'comicsdetail/${_firstValue["id"] ?? "0"}'));
              } else if (widget.data["content_type"] == 6) {
                context.push(CommonUtils.getRealHash(
                    'atlasDetail/${_firstValue["id"] ?? "0"}'));
              }
            },
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                        height: _cw / 350 * 185,
                        child: PlatformAwareNetworkImage(
                          url: clipImageUrl(CommonUtils.getThumb(_firstValue),
                              inputWidth: ScreenUtil().setWidth(350)),
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        )),
                    SizedBox(height: ScreenUtil().setWidth(3.5)),
                    Text(_firstValue["title"] ?? "loading",
                        style: GQStyle.white255_14),
                    SizedBox(height: ScreenUtil().setWidth(3.5)),
                    Text(
                      _firstValue["finished"] == 1
                          ? "${CommonUtils.txt("wj")} ${CommonUtils.txt("gng")}${_firstValue["series"]}${CommonUtils.txt("hua")}"
                          : "${CommonUtils.txt("gxz")}${_firstValue["series"]}${CommonUtils.txt("hua")}",
                      style: GQStyle.gray128_11,
                    )
                  ],
                ),
                Positioned(
                    right: 0,
                    top: 0,
                    child: CommonUtils.identiWget(_firstValue,
                        isHideCoin: widget.data["content_type"] == 2 ||
                            widget.data["content_type"] == 6))
              ],
            ),
          ),
        ),
        SizedBox(height: ScreenUtil().setWidth(10)),
        GridView.count(
            padding: EdgeInsets.symmetric(horizontal: GQStyle.pagePadding),
            shrinkWrap: true,
            crossAxisCount: 3,
            mainAxisSpacing: ScreenUtil().setWidth(10),
            crossAxisSpacing: ScreenUtil().setWidth(10),
            childAspectRatio: 110 / 200,
            scrollDirection: Axis.vertical,
            physics: NeverScrollableScrollPhysics(),
            children: _values
                .map((e) => GestureDetector(
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: _w / 110 * 147,
                                child: PlatformAwareNetworkImage(
                                    url: clipImageUrl(CommonUtils.getThumb(e),
                                        inputWidth: ScreenUtil().setWidth(110)),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5))),
                              ),
                              SizedBox(height: ScreenUtil().setWidth(3.5)),
                              Text(e["title"] ?? "loading",
                                  style: GQStyle.white255_14_M),
                              SizedBox(height: ScreenUtil().setWidth(3.5)),
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
                                  isHideCoin:
                                      widget.data["content_type"] == 2 ||
                                          widget.data["content_type"] == 6))
                        ],
                      ),
                    ))
                .toList()),
        SizedBox(height: ScreenUtil().setWidth(16.5))
      ],
    );
  }
}
