import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qypj/components/card/avatar.dart';
import 'package:qypj/mixin/cardMixin.dart';
import 'package:qypj/theme/default.dart';
import 'package:qypj/utils/common.dart';

// ignore: must_be_immutable
class H74CardB extends StatefulWidget {
  H74CardB(
      {Key key,
      this.width,
      this.thumbUrl,
      this.cardMargin,
      this.previewUrl,
      this.tagIconType, // 0不显示 1免费 2VIP 3扣币 4AD
      this.comment = 0,
      this.like = 0,
      this.meliked = false,
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
  final EdgeInsets cardMargin;
  final String previewUrl;
  final int comment;
  final int like;
  final bool meliked;
  final int tagIconType;
  final int contentType;
  final dynamic cardData;
  final String showField;
  final int page;
  final bool replace;
  final bool isNovel;
  final bool isSearch;
  @override
  _H74CardBState createState() => _H74CardBState();
}

class _H74CardBState extends State<H74CardB> with CardMixin<H74CardB> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double thumbWidth = widget.width;
    double thumbHeight = thumbWidth / 7 * 4;
    return callDetail(
        cardData: widget.cardData,
        widget: widget,
        smallVideoData: widget.isSearch ? widget.cardData : null,
        child: Container(
          width: widget.width,
          margin: widget.cardMargin ?? EdgeInsets.zero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              renderStackThumbArea(widget, thumbWidth, thumbHeight),
              widget.showField.indexOf('title') != -1
                  ? Padding(
                      padding:
                          EdgeInsets.only(bottom: ScreenUtil().setWidth(6.5)),
                      child: Text(
                        widget.cardData['title'],
                        style: GQStyle.blackMedium1534,
                      ),
                    )
                  : Container(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Avatar(
                    thumbUrl: 'https://staff.tea123.me/e.jpg',
                    title: CommonUtils.txt('mz') + '1',
                    size: 34,
                    direction: Axis.horizontal,
                    followStatus: 1,
                  ),
                  Row(
                    children: [
                      Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(
                                right: ScreenUtil().setWidth(3)),
                            child: Image.asset(
                              'assets/images/comment-icon.png',
                              width: ScreenUtil().setWidth(20),
                              height: ScreenUtil().setWidth(20),
                            ),
                          ),
                          Text(widget.comment.toString(), style: GQStyle.gray10)
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(
                                right: ScreenUtil().setWidth(3),
                                left: ScreenUtil().setWidth(18)),
                            child: Image.asset(
                                widget.meliked
                                    ? 'assets/images/like-icon.png'
                                    : 'assets/images/dislike-icon.png',
                                width: ScreenUtil().setWidth(20),
                                height: ScreenUtil().setWidth(20)),
                          ),
                          Text(widget.like.toString(),
                              style: widget.meliked
                                  ? GQStyle.red10
                                  : GQStyle.gray10)
                        ],
                      )
                    ],
                  )
                ],
              )
            ],
          ),
        ),
        contentType: widget.contentType);
  }
}
