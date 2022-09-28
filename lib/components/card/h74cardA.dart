/*
 * @Author: Tom
 * @Date: 2021-12-14 19:20:47
 * @LastEditTime: 2021-12-29 15:10:24
 * @LastEditors: Tom
 * @Description: 
 * @FilePath: /flutter2021/lib/components/card/h74cardA.dart
 */
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qypj/mixin/cardMixin.dart';
import 'package:qypj/theme/default.dart';
import 'package:qypj/utils/index.dart';

class H74CardA extends StatefulWidget {
  H74CardA(
      {Key key,
      this.width,
      this.thumbUrl,
      this.cardMargin,
      this.previewUrl,
      this.tagIconType,
      this.cardData,
      this.showField = '',
      this.contentType,
      this.page,
      this.replace = false,
      this.isLocal = false,
      this.isNovel = false,
      this.isSearch = false})
      : super(key: key);
  final double width;
  final String thumbUrl;
  final EdgeInsets cardMargin;
  final String previewUrl;
  final int tagIconType;
  final dynamic cardData;
  final String showField;
  final int contentType;
  final int page;
  final bool replace;
  final bool isLocal;
  final bool isNovel;
  final bool isSearch;
  @override
  _H74CardAState createState() => _H74CardAState();
}

class _H74CardAState extends State<H74CardA> with CardMixin<H74CardA> {
  double progress = 0;
  bool downloading = false;
  bool downloadError = false;
  bool isWaiting = false;
  @override
  void initState() {
    super.initState();
    if (widget.cardData["progress"] != null) {
      setState(() {
        progress = widget.cardData["progress"] + .0;
        downloading = widget.cardData["downloading"];
        isWaiting = widget.cardData["isWaiting"];
      });
    }
    if (widget.isLocal) {
      EventBus().on('DOWNLOADVIDEO_PROGRESS_${widget.cardData["id"]}', (arg) {
        if (widget.cardData["id"] == arg["id"]) {
          setState(() {
            progress = arg["progress"] ?? progress;
            downloading = arg["downloading"] ?? true;
            downloadError = arg["downloadError"] ?? false;
            isWaiting = false;
          });
        }
      });
    }
  }

  @override
  void didUpdateWidget(H74CardA oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isLocal) {
      if (widget.cardData["id"] != oldWidget.cardData["id"]) {
        setState(() {
          progress = widget.cardData["progress"] + .0;
          downloading = widget.cardData["downloading"];
          isWaiting = widget.cardData["isWaiting"];
          downloadError = false;
        });
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    EventBus().off('DOWNLOADVIDEO_PROGRESS_${widget.cardData["id"]}');
  }

  @override
  Widget build(BuildContext context) {
    double thumbWidth = widget.width;
    double thumbHeight = thumbWidth / 7 * 4;
    // String desc = getCardDesc(widget);
    return callDetail(
        cardData: widget.cardData,
        widget: widget,
        smallVideoData: widget.isSearch ? widget.cardData : null,
        replace: widget.replace,
        isLocal: widget.isLocal,
        progress: progress,
        downloading: downloading,
        isWaiting: isWaiting,
        setDownloading: () {
          setState(() {
            isWaiting = true;
          });
        },
        child: Container(
          width: thumbWidth,
          margin: widget.cardMargin ?? EdgeInsets.zero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              renderStackThumbArea(widget, thumbWidth, thumbHeight,
                  progress: progress,
                  downloading: downloading,
                  downloadError: downloadError,
                  isWaiting: isWaiting,
                  isLocal: widget.isLocal,
                  marginBottom: 6.5),
              widget.showField.indexOf('title') != -1
                  ? Padding(
                      padding:
                          EdgeInsets.only(bottom: ScreenUtil().setWidth(5)),
                      child: Container(
                          height: ScreenUtil().setWidth(20),
                          child: Text(
                            widget.cardData['title'],
                            style: GQStyle.white255_15_M,
                          )),
                    )
                  : Container(),
            ],
          ),
        ),
        contentType: widget.contentType);
  }
}
