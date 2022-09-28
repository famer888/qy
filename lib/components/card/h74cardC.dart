import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qypj/mixin/cardMixin.dart';
import 'package:qypj/theme/default.dart';
import 'package:qypj/utils/networkImage.dart';

// ignore: must_be_immutable
class H74CardC extends StatefulWidget {
  H74CardC(
      {Key key,
      this.width,
      this.thumbUrl,
      this.verticalthumbUrl,
      this.cardMargin,
      this.previewUrl,
      this.tagIconType,
      this.contentType,
      this.cardData,
      this.showField = '',
      this.page,
      this.replace = false,
      this.isNovel = false,
      this.isSearch = false})
      : super(key: key);
  final double width;
  final String thumbUrl;
  final String verticalthumbUrl;
  final EdgeInsets cardMargin;
  final String previewUrl;
  final int tagIconType;
  final int contentType;
  final dynamic cardData;
  final String showField;
  final int page;
  final bool replace;
  final bool isNovel;
  final bool isSearch;
  @override
  _H74CardCState createState() => _H74CardCState();
}

class _H74CardCState extends State<H74CardC> with CardMixin<H74CardC> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double thumbWidth;
    double thumbHeight;
    double verticalThumbWidth;
    String desc = getCardDesc(widget);
    if (widget.verticalthumbUrl != null) {
      thumbWidth = ScreenUtil().setWidth(243);
      thumbHeight = thumbWidth / 7 * 4;
      verticalThumbWidth = ScreenUtil().setWidth(100);
    } else {
      thumbWidth = widget.width;
      thumbHeight = thumbWidth / 7 * 4;
    }
    return callDetail(
        cardData: widget.cardData,
        widget: widget,
        smallVideoData: widget.isSearch ? widget.cardData : null,
        replace: widget.replace,
        child: Container(
          width: widget.width,
          margin: widget.cardMargin ?? EdgeInsets.zero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.all(
                              Radius.circular(ScreenUtil().setWidth(5)))),
                      width: verticalThumbWidth,
                      height: thumbHeight,
                      margin: EdgeInsets.only(
                          bottom: ScreenUtil().setWidth(12.5),
                          right: ScreenUtil().setWidth(7)),
                      child: PlatformAwareNetworkImage(
                        url: widget.verticalthumbUrl,
                      )),
                  renderStackThumbArea(widget, thumbWidth, thumbHeight)
                ],
              ),
              widget.showField.indexOf('title') != -1
                  ? Padding(
                      padding:
                          EdgeInsets.only(bottom: ScreenUtil().setWidth(5)),
                      child: Text(
                        widget.cardData['title'],
                        style: GQStyle.blackMedium1534,
                      ),
                    )
                  : Container(),
              desc != ''
                  ? Text(
                      desc,
                      style: GQStyle.gray13,
                    )
                  : Container()
            ],
          ),
        ),
        contentType: widget.contentType);
  }
}
