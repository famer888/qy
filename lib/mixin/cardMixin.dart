import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qypj/global.dart';
import 'package:qypj/utils/common.dart';
import 'package:qypj/utils/networkImage.dart';
import 'package:qypj/utils/download_video.dart';
import 'package:universal_html/html.dart' as html;
import 'package:qypj/utils/extensionlibrary.dart';

mixin CardMixin<T extends StatefulWidget> on State<T> {
  @override
  void initState() {
    super.initState();
  }

  String getCardDesc(widget) {
    String result = '';
    if (widget.showField == null) return "";
    if (widget.showField.indexOf('second_title') != -1) {
      result += widget.cardData['second_title'];
    }
    if (widget.showField.indexOf('tags') != -1) {
      if (result != '' && result != null) result += '/';
      result += widget.cardData['tags'].replaceAll(',', ' ');
    }
    return result;
  }

  Function navToPage(data) {}

  String getRouter(int contentType, {String id, bool replace}) {
    String router;
    switch (contentType) {
      case 1: //视频
        router = replace
            ? CommonUtils.getRealHash()
                .replaceAll(RegExp(r"videoDetail/.*"), 'videoDetail/$id')
            : CommonUtils.getRealHash('videoDetail/$id');
        break;
      case 2: //漫画
        router = replace
            ? CommonUtils.getRealHash()
                .replaceAll(RegExp(r"comicsdetail/.*"), 'comicsdetail/$id')
            : CommonUtils.getRealHash('comicsdetail/$id');
        break;
      case 3: //小说
        router = replace
            ? CommonUtils.getRealHash()
                .replaceAll(RegExp(r"novelDetail/.*"), 'novelDetail/$id')
            : CommonUtils.getRealHash('novelDetail/$id');
        break;
      case 4: //链接

        break;
      case 5: //有声小说
        router = CommonUtils.getRealHash('audiobookDetail/0');
        break;
      case 6: //图集
        router = replace
            ? CommonUtils.getRealHash()
                .replaceAll(RegExp(r"atlasDetail/.*"), 'atlasDetail/$id')
            : CommonUtils.getRealHash('atlasDetail/$id');
        break;
      case 7: //短视频
        router = CommonUtils.getRealHash('smallVideo/0');
        break;
      default:
    }
    return router;
  }

  Widget callDetail({
    Widget child,
    int contentType,
    dynamic cardData,
    dynamic widget,
    dynamic smallVideoData,
    bool replace = false,
    bool isLocal = false,
    double progress = 0,
    bool downloading = false,
    bool isWaiting = false,
    Function setDownloading,
  }) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        if (isLocal) {
          if (progress.toInt() == 1) {
            // 跳详情
            context.push(CommonUtils.getRealHash('localVideoDetail/0'),
                extra: {'videoInfo': cardData});
          } else if (!downloading && !isWaiting) {
            setDownloading();
            DownloadUtil.createDownloadTask(cardData);
          }
        } else if (contentType != 4) {
          var id = cardData['related_id'] == null
              ? cardData['id']
              : cardData['related_id'];
          AppGlobal.currentDetailRouteExtra = {
            'videoData': smallVideoData,
            'id': id,
            'elementId': cardData['element_id'],
            'page': widget.page == null || widget.page == 0 ? 1 : widget.page
          };
          if (replace) {
            context.push(
                getRouter(contentType, id: id.toString(), replace: replace),
                replace: replace);
          } else {
            context.push(
                getRouter(contentType, id: id.toString(), replace: replace));
          }
        } else {
          if (cardData['redirect_type'] == 1) {
            String linkUrl = cardData['link_url'];
            List urlList = linkUrl.split('?');
            Map<String, dynamic> pramas = {};
            if (urlList.length > 1) {
              urlList[1].split("&").forEach((item) {
                List stringText = item.split('=');
                pramas[stringText[0]] =
                    stringText.length > 1 ? stringText[1] : null;
              });
            }
            Map<String, dynamic> pramasObj = {};
            if (pramas['pramaskey'] != null) {
              pramasObj[pramas['pramaskey']] = pramas;
            } else {
              pramasObj = pramas;
            }
            context.push(urlList[0], extra: pramasObj);
          } else if (cardData['redirect_type'] == 2) {
            CommonUtils.launchURL(cardData['link_url']);
          }
        }
      },
      child: child,
    );
  }

  Widget renderStackThumbArea(widget, thumbWidth, thumbHeight,
      {double progress = 0,
      bool downloading = false,
      bool downloadError = false,
      bool isWaiting = false,
      bool isLocal = false,
      marginBottom = 6.5}) {
    String getDownloadText() {
      String _text = downloadError
          ? CommonUtils.txt('xsbcs')
          : isWaiting
              ? CommonUtils.txt('ddxz')
              : progress == 0
                  ? CommonUtils.txt('djxz')
                  : downloading
                      ? CommonUtils.txt('xzjd')
                      : CommonUtils.txt('ztxz');
      return _text;
    }

    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        Container(
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: marginBottom != 0
                    ? BorderRadius.all(
                        Radius.circular(ScreenUtil().setWidth(5)))
                    : BorderRadius.vertical(
                        bottom: Radius.zero,
                        top: Radius.circular(ScreenUtil().setWidth(5)))),
            width: thumbWidth,
            height: thumbHeight,
            margin:
                EdgeInsets.only(bottom: ScreenUtil().setWidth(marginBottom)),
            child: PlatformAwareNetworkImage(
              fit: BoxFit.cover,
              url: widget.thumbUrl,
            )),
        isLocal && progress.toInt() != 1
            ? Positioned(
                top: 0,
                right: 0,
                bottom: ScreenUtil().setWidth(marginBottom),
                left: 0,
                child: Container(
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(0, 0, 0, 0.5),
                      borderRadius: marginBottom != 0
                          ? BorderRadius.all(
                              Radius.circular(ScreenUtil().setWidth(5)))
                          : BorderRadius.vertical(
                              bottom: Radius.zero,
                              top: Radius.circular(ScreenUtil().setWidth(5)))),
                  child: Center(
                    child: Text(
                      getDownloadText(),
                      style: TextStyle(
                          color: progress == -1
                              ? Color.fromRGBO(103, 224, 185, 1.0)
                              : Colors.white,
                          decoration: TextDecoration.none,
                          fontWeight: FontWeight.bold,
                          fontSize: ScreenUtil().setSp(18)),
                    ),
                  ),
                ))
            : Container(),
        isLocal && progress.toInt() != 1
            ? Positioned(
                top: 0,
                right: 0,
                bottom: ScreenUtil().setWidth(marginBottom),
                left: 0,
                child: Container(
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                        borderRadius: marginBottom != 0
                            ? BorderRadius.all(
                                Radius.circular(ScreenUtil().setWidth(5)))
                            : BorderRadius.vertical(
                                bottom: Radius.zero,
                                top:
                                    Radius.circular(ScreenUtil().setWidth(5)))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          height: ScreenUtil().setWidth(2),
                          width: thumbWidth * progress,
                          decoration: BoxDecoration(
                              color: Color.fromRGBO(103, 224, 185, 1.0),
                              borderRadius: BorderRadius.all(
                                  Radius.circular(ScreenUtil().setWidth(1)))),
                        ),
                      ],
                    )),
              )
            : Container(),
      ],
    );
  }
}
