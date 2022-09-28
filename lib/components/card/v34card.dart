import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qypj/mixin/cardMixin.dart';
import 'package:qypj/theme/default.dart';
import 'package:qypj/utils/common.dart';
import 'package:qypj/utils/networkImage.dart';

// ignore: must_be_immutable
class V34Card extends StatefulWidget {
  V34Card(
      {Key key,
      this.width,
      this.thumbUrl,
      this.cardMargin,
      this.tagIconType, // 0不显示 1免费 2VIP 3扣币 4AD
      this.cardData,
      this.showField = '',
      this.contentType,
      this.id,
      this.page,
      this.height,
      this.isNovel = false,
      this.replace = false,
      this.isSearch = false})
      : super(key: key);
  final double width;
  final double height;
  final String thumbUrl;
  final EdgeInsets cardMargin;
  final int tagIconType;
  final dynamic cardData;
  final String showField;
  final int contentType;
  final dynamic id;
  final int page;
  final bool isNovel;
  final bool replace;
  final bool isSearch;
  @override
  _V34CardState createState() => _V34CardState();
}

class _V34CardState extends State<V34Card> with CardMixin<V34Card> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double thumbHeight = widget.width / 3 * 4;
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                alignment: AlignmentDirectional.topEnd,
                children: [
                  Container(
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.all(
                              Radius.circular(ScreenUtil().setWidth(5)))),
                      height: thumbHeight,
                      margin:
                          EdgeInsets.only(bottom: ScreenUtil().setWidth(6.5)),
                      child: PlatformAwareNetworkImage(
                        fit: BoxFit.cover,
                        url: widget.thumbUrl,
                      )),
                ],
              ),
              widget.showField.indexOf('title') != -1
                  ? Padding(
                      padding:
                          EdgeInsets.only(bottom: ScreenUtil().setWidth(5)),
                      child: Text(
                        widget.cardData['title'],
                        style: GQStyle.white255_15_M,
                      ),
                    )
                  : Container(),
              (desc == null || desc.length == 0)
                  ? Container()
                  : Text(
                      desc,
                      style: GQStyle.gray153_13,
                    )
            ],
          ),
        ),
        contentType: widget.contentType);
  }
}
