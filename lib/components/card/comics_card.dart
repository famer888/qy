import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qypj/mixin/cardMixin.dart';
import 'package:qypj/utils/common.dart';
import 'package:qypj/utils/networkImage.dart';

class ComicsCard extends StatefulWidget {
  ComicsCard(
      {Key key,
      this.thumbUrl,
      this.data,
      this.contentType = 5,
      this.replace = false})
      : super(key: key);
  String thumbUrl;
  dynamic data;
  int contentType;
  bool replace;
  @override
  _ComicsCardState createState() => _ComicsCardState();
}

class _ComicsCardState extends State<ComicsCard> with CardMixin {
  @override
  Widget build(BuildContext context) {
    String tags = widget.data['tags'] == '' || widget.data['tags'] == null
        ? ''
        : '#' + widget.data['tags'].rplaceAll(',', '  #');
    return callDetail(
        cardData: widget.data,
        contentType: widget.contentType,
        widget: widget,
        replace: true,
        child: Container(
          margin: EdgeInsets.only(bottom: ScreenUtil().setWidth(14.5)),
          decoration: BoxDecoration(
            // color: Colors.white,
            borderRadius: BorderRadius.circular(5),
            // boxShadow: [
            //   BoxShadow(
            //       color: Colors.black12,
            //       offset: Offset(0, ScreenUtil().setWidth(1)),
            //       blurRadius: ScreenUtil().setWidth(5))
            // ]
          ),
          child: Row(
            children: [
              Container(
                margin: EdgeInsets.only(right: ScreenUtil().setWidth(22.5)),
                width: ScreenUtil().setWidth(90.5),
                height: ScreenUtil().setWidth(125.5),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: PlatformAwareNetworkImage(url: widget.thumbUrl),
                ),
              ),
              Expanded(
                  child: Container(
                height: ScreenUtil().setWidth(125.5),
                padding:
                    EdgeInsets.symmetric(vertical: ScreenUtil().setWidth(8)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.data['title'],
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Color(0xff333333),
                          fontSize: ScreenUtil().setSp(16),
                          fontWeight: FontWeight.bold),
                    ),
                    // Seiyuu(
                    //   thumbUrl: 'https://staff.tea123.me/e.jpg',
                    //   name: '声优名字',
                    // ),
                    Text(tags,
                        style: TextStyle(
                          color: Color(0xff666666),
                          fontSize: ScreenUtil().setSp(13),
                        )),
                    Row(
                      children: [
                        Text(
                          '${widget.data['views_count']}' +
                              CommonUtils.txt('cgk'),
                          style: TextStyle(
                              color: Color(0xff999999),
                              fontSize: ScreenUtil().setSp(13)),
                        ),
                        SizedBox(
                          width: ScreenUtil().setWidth(52.5),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              'assets/images/mine/comics_like.png',
                              width: ScreenUtil().setWidth(15),
                              height: ScreenUtil().setWidth(15),
                            ),
                            SizedBox(
                              width: ScreenUtil().setWidth(2.5),
                            ),
                            Text(
                              CommonUtils.renderFixedNumber(
                                  widget.data['likes_count']),
                              style: TextStyle(
                                  color: Color(0xffff3967),
                                  fontSize: ScreenUtil().setSp(11)),
                            )
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ))
            ],
          ),
        ));
  }
}
