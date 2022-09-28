import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qypj/mixin/cardMixin.dart';
import 'package:qypj/theme/default.dart';
import 'package:qypj/utils/networkImage.dart';

// ignore: must_be_immutable
class H74CardD extends StatefulWidget {
  H74CardD(
      {Key key,
      this.width,
      this.thumbUrl,
      this.verticalthumbUrl,
      this.cardMargin,
      this.previewUrl,
      this.titleBarColor,
      this.tagIconType,
      this.contentType,
      this.cardData,
      this.showField = '',
      this.page,
      this.replace,
      this.isNovel = false,
      this.isSearch})
      : super(key: key);
  final double width;
  final String thumbUrl;
  final String verticalthumbUrl;
  final EdgeInsets cardMargin;
  final String previewUrl;
  final Color titleBarColor;
  final int tagIconType;
  final int contentType;
  final dynamic cardData;
  final String showField;
  final int page;
  final bool replace;
  final bool isNovel;
  final bool isSearch;
  @override
  _H74CardDState createState() => _H74CardDState();
}

class _H74CardDState extends State<H74CardD> with CardMixin<H74CardD> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double thumbWidth = widget.width;
    double thumbHeight = thumbWidth / 7 * 4;
    String desc = getCardDesc(widget);
    return callDetail(
        cardData: widget.cardData,
        widget: widget,
        smallVideoData: widget.isSearch ? widget.cardData : null,
        replace: widget.replace,
        child: Container(
          width: widget.width,
          margin: widget.cardMargin ?? EdgeInsets.zero,
          child: Column(
            children: [
              renderStackThumbArea(widget, thumbWidth, thumbHeight,
                  marginBottom: 0),
              Stack(clipBehavior: Clip.none, children: [
                Container(
                  width: widget.width,
                  height: ScreenUtil().setWidth(59),
                  padding: EdgeInsets.only(left: ScreenUtil().setWidth(70)),
                  decoration: BoxDecoration(
                      color: Colors.deepOrangeAccent,
                      borderRadius: BorderRadius.vertical(
                          bottom: Radius.circular(ScreenUtil().setWidth(5)))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      widget.showField.indexOf('title') != -1
                          ? Padding(
                              padding: EdgeInsets.only(
                                  bottom: ScreenUtil().setWidth(5)),
                              child: Text(
                                widget.cardData['title'],
                                style: GQStyle.white15bold,
                              ),
                            )
                          : Container(),
                      desc != ''
                          ? Text(
                              desc,
                              style: GQStyle.white13,
                            )
                          : Container()
                    ],
                  ),
                ),
                Positioned(
                    left: ScreenUtil().setWidth(9.8),
                    bottom: ScreenUtil().setWidth(8.5),
                    child: Container(
                      color: Colors.black,
                      width: ScreenUtil().setWidth(50),
                      height: ScreenUtil().setWidth(70.5),
                      child: PlatformAwareNetworkImage(
                        url: widget.verticalthumbUrl,
                      ),
                    ))
              ]),
            ],
          ),
        ),
        contentType: widget.contentType);
  }
}
