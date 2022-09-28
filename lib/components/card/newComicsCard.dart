import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qypj/utils/extensionlibrary.dart';
import 'package:universal_html/html.dart' as html;
import 'package:qypj/model/recommendComics.dart';
import 'package:qypj/routers.dart';
import 'package:qypj/theme/default.dart';
import 'package:qypj/utils/common.dart';
import 'package:qypj/utils/networkImage.dart';

class NewComicsCard extends StatefulWidget {
  final Datum cardData;
  final bool relace;
  NewComicsCard({Key key, this.cardData, this.relace = false})
      : super(key: key);

  @override
  _NewComicsCardState createState() => _NewComicsCardState();
}

class _NewComicsCardState extends State<NewComicsCard> {
  String tags = '';
  @override
  void initState() {
    super.initState();
    if (widget.cardData?.tags != null && widget.cardData?.tags != '') {
      List tagsList = widget.cardData.tags.split(',');
      tagsList.forEach((item) {
        tags += '#$item  ';
      });
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.relace) {
          context.push(
              CommonUtils.getRealHash().replaceAll(RegExp(r"comicsdetail/.*"),
                  'comicsdetail/${widget.cardData.datumId}'),
              replace: widget.relace);
        } else {
          context.push(CommonUtils.getRealHash(
              'comicsdetail/${widget.cardData.datumId}'));
        }
      },
      child: Container(
        margin: EdgeInsets.only(bottom: ScreenUtil().setWidth(12.5)),
        child: Container(
          height: ScreenUtil().setWidth(125),
          padding: EdgeInsets.zero,
          child: Row(
            children: [
              ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  child: Container(
                    width: ScreenUtil().setWidth(91),
                    height: ScreenUtil().setWidth(125),
                    child: PlatformAwareNetworkImage(
                      url: widget.cardData == null
                          ? null
                          : widget.cardData.thumb,
                      filterQuality: FilterQuality.high,
                      fit: BoxFit.cover,
                    ),
                  )),
              SizedBox(
                width: ScreenUtil().setWidth(9),
              ),
              Expanded(
                  child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: ScreenUtil().setWidth(0),
                    vertical: ScreenUtil().setWidth(0)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      height: ScreenUtil().setWidth(50),
                      child: Text(
                          widget.cardData == null
                              ? 'loading'
                              : widget.cardData.title,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: TextStyle(
                              height: 1.1,
                              color: Color.fromRGBO(139, 139, 139, 1),
                              fontSize: ScreenUtil().setSp(18),
                              overflow: TextOverflow.ellipsis,
                              decoration: TextDecoration.none)),
                    ),
                    // SizedBox(height: ScreenUtil().setWidth(30)),
                    // Spacer(),
                    SizedBox(
                      width: ScreenUtil().setWidth(9),
                    ),
                    Container(
                        width: ScreenUtil().screenWidth * 0.4,
                        margin:
                            EdgeInsets.only(bottom: ScreenUtil().setWidth(5)),
                        child: Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: widget.cardData.status == 1
                                          ? Colors.transparent
                                          : Color.fromRGBO(255, 77, 11, 1.0),
                                      width: 1.0),
                                  color: widget.cardData.status == 1
                                      ? Color.fromRGBO(255, 77, 11, 1.0)
                                      : Colors.transparent,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4))),
                              child: Text(
                                  widget.cardData == null
                                      ? 'loading'
                                      : '\t\t${widget.cardData.status == 1 ? CommonUtils.txt("wj") : CommonUtils.txt("lz")}\t\t',
                                  style: widget.cardData.status == 1
                                      ? GQStyle.white255_11
                                      : GQStyle.yellow255_11),
                            ),
                            Spacer(),
                            // SizedBox(width: ScreenUtil().setWidth(8)),
                            Text(
                                widget.cardData == null
                                    ? "loading"
                                    : "${CommonUtils.txt("gxz")}${widget.cardData.newestSeries}${CommonUtils.txt("hua")}",
                                style: GQStyle.gray102_13),
                          ],
                        )),
                    Spacer(),
                    Container(
                      // padding: EdgeInsets.only(top: ScreenUtil().setWidth(10)),
                      child: Row(
                        children: [
                          Text(
                              widget.cardData == null
                                  ? 'loading'
                                  : '${CommonUtils.txt("yd")} ${CommonUtils.renderFixedNumber(widget.cardData.viewsCount)}',
                              style: GQStyle.gray153_11),
                          SizedBox(width: ScreenUtil().setWidth(22)),
                          Text(
                              widget.cardData == null
                                  ? 'loading'
                                  : '${CommonUtils.txt("dz")} ${CommonUtils.renderFixedNumber(widget.cardData.likesCount)}',
                              style: GQStyle.gray153_11),
                        ],
                      ),
                    )
                  ],
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }
}
