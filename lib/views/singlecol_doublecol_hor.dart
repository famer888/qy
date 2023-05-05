import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qypj/theme/default.dart';
import 'package:qypj/utils/common.dart';
import 'package:qypj/utils/extensionlibrary.dart';
import 'package:qypj/utils/networkImage.dart';

//单列双列横屏 type = 3
class SingleColDoubleColHor extends StatefulWidget {
  SingleColDoubleColHor({Key key, this.data}) : super(key: key);
  dynamic data;

  @override
  State<SingleColDoubleColHor> createState() => _SingleColDoubleColHorState();
}

class _SingleColDoubleColHorState extends State<SingleColDoubleColHor> {
  double _w = (ScreenUtil().screenWidth -
          GQStyle.pagePadding * 2 -
          ScreenUtil().setWidth(4)) /
      2;
  double _tw = ScreenUtil().screenWidth - ScreenUtil().setWidth(50);
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
        Center(
            child: SizedBox(
          width: _tw,
          height: _tw / 321 * 76,
          child: PlatformAwareNetworkImage(
            url: widget.data["icon"],
            nofigure: true,
          ),
        )),
        SizedBox(height: ScreenUtil().setWidth(16)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: GQStyle.pagePadding),
          child: GestureDetector(
              onTap: () {
                context.push(CommonUtils.getRealHash(
                    'videoDetail/${_firstValue["id"]}'));
              },
              child: Stack(children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                        height: _cw / 350 * 200,
                        child: PlatformAwareNetworkImage(
                            url: CommonUtils.getThumb(_firstValue),
                            borderRadius:
                                BorderRadius.all(Radius.circular(5)))),
                    SizedBox(height: ScreenUtil().setWidth(3.5)),
                    Text(_firstValue["title"] ?? "loading",
                        style: GQStyle.white255_14),
                    SizedBox(height: ScreenUtil().setWidth(3.5)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                            "${CommonUtils.renderFixedNumber(_firstValue["play_ct"] ?? 0)}${CommonUtils.txt("cbf")}",
                            style: GQStyle.gray105_12),
                        Text(
                            "${CommonUtils.getHMTime(_firstValue["duration"] ?? 0)}",
                            style: GQStyle.gray105_12)
                      ],
                    ),
                  ],
                ),
                Positioned(
                    right: 0,
                    top: 0,
                    child: CommonUtils.identiWget(_firstValue))
              ])),
        ),
        SizedBox(height: ScreenUtil().setWidth(_values.length == 0 ? 0 : 15.5)),
        _values.length == 0
            ? Container()
            : GridView.count(
                shrinkWrap: true,
                padding: EdgeInsets.symmetric(horizontal: GQStyle.pagePadding),
                crossAxisCount: 2,
                mainAxisSpacing: ScreenUtil().setWidth(15.5),
                crossAxisSpacing: ScreenUtil().setWidth(4),
                childAspectRatio: 224 / 188,
                scrollDirection: Axis.vertical,
                physics: NeverScrollableScrollPhysics(),
                children: _values
                    .map((e) => GestureDetector(
                          onTap: () {
                            context.push(CommonUtils.getRealHash(
                                'videoDetail/${e["id"]}'));
                          },
                          child: Stack(children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: _w / 173 * 100,
                                  child: PlatformAwareNetworkImage(
                                      url: clipImageUrl(CommonUtils.getThumb(e),
                                          inputWidth:
                                              ScreenUtil().setWidth(173)),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5))),
                                ),
                                Expanded(
                                  flex: 26,
                                  child: Container(
                                    alignment: Alignment.centerLeft,
                                    child: Text(e["title"] ?? "loading",
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
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "${CommonUtils.renderFixedNumber(e["play_ct"] ?? 0)}${CommonUtils.txt("cbf")}",
                                            style: GQStyle.gray105_11,
                                            textAlign: TextAlign.center,
                                          ),
                                          Text(
                                            "${CommonUtils.getHMTime(e["duration"] ?? 0)}",
                                            style: GQStyle.gray105_11,
                                            textAlign: TextAlign.center,
                                          )
                                        ],
                                      ),
                                    )),
                              ],
                            ),
                            Positioned(
                                right: 0,
                                top: 0,
                                child: CommonUtils.identiWget(e))
                          ]),
                        ))
                    .toList(),
              ),
        SizedBox(height: ScreenUtil().setWidth(16.5))
      ],
    );
  }
}
