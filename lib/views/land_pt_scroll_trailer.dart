import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qypj/theme/default.dart';
import 'package:qypj/utils/common.dart';
import 'package:qypj/utils/extensionlibrary.dart';
import 'package:qypj/utils/networkImage.dart';

//横向竖屏滚动_预告片 type = 2
class LandPtScrollTrailer extends StatefulWidget {
  LandPtScrollTrailer({Key key, this.data, this.scale = 0.47})
      : super(key: key);
  dynamic data;
  double scale;

  @override
  State<LandPtScrollTrailer> createState() => _LandPtScrollTrailerState();
}

class _LandPtScrollTrailerState extends State<LandPtScrollTrailer> {
  double _w = (ScreenUtil().screenWidth -
          GQStyle.pagePadding * 2 -
          ScreenUtil().setWidth(12)) /
      3;
  List<dynamic> _values;
  double _tw = ScreenUtil().screenWidth - ScreenUtil().setWidth(50);

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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            context.push("/actiontrailerstory");
          },
          child: Center(
            child: SizedBox(
              width: _tw,
              height: _tw / 320.5 * 90,
              child: PlatformAwareNetworkImage(
                url: widget.data["icon"],
                nofigure: true,
              ),
            ),
          ),
        ),
        SizedBox(height: ScreenUtil().setWidth(12)),
        SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: GQStyle.pagePadding),
          scrollDirection: Axis.horizontal,
          child: Row(
              children: _values.asMap().keys.map((index) {
            dynamic e = _values[index];
            return Row(children: [
              SizedBox(
                width: _w,
                child: GestureDetector(
                  onTap: () {
                    context.push(CommonUtils.getRealHash(
                        'videoDetail/${e["preview_first"]}'));
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(e["release_app"] ?? "loading",
                            style: GQStyle.gray168_9),
                      ),
                      SizedBox(height: ScreenUtil().setWidth(8.5)),
                      Center(
                        child: LImage("min_triangle_n",
                            width: ScreenUtil().setWidth(9),
                            height: ScreenUtil().setWidth(9)),
                      ),
                      SizedBox(height: ScreenUtil().setWidth(11.5)),
                      SizedBox(
                        height: _w / 106 * 147,
                        child: PlatformAwareNetworkImage(
                          url: clipImageUrl(CommonUtils.getThumb(e),
                              inputWidth: ScreenUtil().setWidth(106)),
                          borderRadius: index == 0
                              ? BorderRadius.only(
                                  topLeft: Radius.circular(5),
                                  bottomLeft: Radius.circular(5))
                              : index == _values.length - 1
                                  ? BorderRadius.only(
                                      topRight: Radius.circular(5),
                                      bottomRight: Radius.circular(5))
                                  : BorderRadius.zero,
                        ),
                      ),
                      SizedBox(height: ScreenUtil().setWidth(2)),
                      Container(
                        alignment: Alignment.centerLeft,
                        height: ScreenUtil().setWidth(35 + 5),
                        child: Text(e["title"],
                            style: TextStyle(
                                color: Color.fromRGBO(255, 255, 255, 1),
                                fontSize: ScreenUtil().setSp(14),
                                height: 1.1,
                                overflow: TextOverflow.ellipsis,
                                decoration: TextDecoration.none),
                            maxLines: 2,
                            textAlign: TextAlign.left),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: ScreenUtil().setWidth(6))
            ]);
          }).toList()),
        ),
        SizedBox(height: ScreenUtil().setWidth(10))
      ],
    );
  }
}
