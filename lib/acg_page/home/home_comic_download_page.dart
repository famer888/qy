import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qypj/base/baseWidget.dart';
import 'package:qypj/global.dart';
import 'package:qypj/theme/default.dart';
import 'package:qypj/utils/common.dart';
import 'package:qypj/utils/networkImage.dart';

class HomeComicDownloadPage extends BaseWidget {
  HomeComicDownloadPage({Key key}) : super(key: key);

  @override
  BaseWidgetState<HomeComicDownloadPage> cState() =>
      _HomeComicChooseChapterDownloadPageState();
}

class _HomeComicChooseChapterDownloadPageState
    extends BaseWidgetState<HomeComicDownloadPage> {
  List _chapterList = [];
  List _chapterSelectedList = [];
  @override
  void onCreate() {
    _chapterList = AppGlobal.blues;
    setAppTitle(title: CommonUtils.txt('xzxz'));
  }

  @override
  Widget appbar() {
    return super.appbar();
  }

  @override
  void onDestroy() {}

  @override
  Widget pageBody(BuildContext context) {
    return Container(
      // color: Colors.deepOrange,
      child: ListView(
        // padding: EdgeInsets.zero,
        children: _chapterList.asMap().keys.map((index) {
          dynamic e = _chapterList[index];
          return Container(
            height: ScreenUtil().setWidth(155),
            padding: EdgeInsets.symmetric(vertical: GQStyle.pagePadding),
            margin: EdgeInsets.symmetric(
              horizontal: GQStyle.pagePadding,
            ),
            decoration: BoxDecoration(
              // color: Colors.deepOrange,
              // borderRadius: BorderRadius.circular(5),
              border: Border(
                bottom: BorderSide(color: Color(0xff26313b), width: 1),
              ),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: ScreenUtil().setWidth(95),
                  height: ScreenUtil().setWidth(125),
                  child: PlatformAwareNetworkImage(
                      url: CommonUtils.getThumb(e),
                      borderRadius:
                          BorderRadius.circular(ScreenUtil().setWidth(5))),
                ),
                SizedBox(width: GQStyle.pagePadding),
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      e['title'] ?? e['episode_title'],
                      style: GQStyle.white255_15,
                    ),
                    Text(
                      e['title'] ?? e['episode_title'],
                      style: GQStyle.graya3a2a2_11,
                    ),
                    SizedBox(
                      height: ScreenUtil().setWidth(15),
                    ),
                    Text(
                      '已上传36%',
                      style: GQStyle.jellyCyan_11,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: ScreenUtil().setWidth(7.5)),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(1.25),
                        child: LinearProgressIndicator(
                          minHeight: 2.5,
                          backgroundColor: Colors.white,
                          color: Colors.cyan,
                          value: 0.36,
                        ),
                      ),
                    )
                  ],
                ))
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
