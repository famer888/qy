import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qypj/base/baseWidget.dart';
import 'package:qypj/global.dart';
import 'package:qypj/model/basic.dart';
import 'package:qypj/theme/default.dart';
import 'package:qypj/utils/api.dart';
import 'package:qypj/utils/common.dart';
import 'package:qypj/utils/extensionlibrary.dart';

class HomeComicChooseChapterDownloadPage extends BaseWidget {
  HomeComicChooseChapterDownloadPage({Key key}) : super(key: key);

  @override
  BaseWidgetState<HomeComicChooseChapterDownloadPage> cState() =>
      _HomeComicChooseChapterDownloadPageState();
}

class _HomeComicChooseChapterDownloadPageState
    extends BaseWidgetState<HomeComicChooseChapterDownloadPage> {
  List _chapterList = [];
  List _chapterSelectedList = [];

  _downloadAct() async {
    if (_chapterSelectedList.length == 0) {
      return;
    }

    Map param = {};

    var item = _chapterList.first;
    param['book_id'] = item['pid'];
    var episodes = '';
    for (var item in _chapterSelectedList) {
      try {
        episodes += '${_chapterList[item]['episode']}' + ',';
      } catch (e) {
        print(e);
      }
    }
    episodes = episodes.substring(0, episodes.lastIndexOf(','));
    param['episodes'] = episodes;
    Basic res = await comicChapterDownload(param: param);
    if (res.status == 1) {
      print('object');
    } else {
      CommonUtils.showText(res.msg);
    }
  }

  @override
  void onCreate() {
    _chapterList = AppGlobal.blues;
  }

  @override
  Widget appbar() {
    return Container(
      color: GQStyle.naviColor,
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: GQStyle.pagePadding),
        height: GQStyle.navbarHegiht,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              child: SizedBox(
                height: double.infinity,
                child: LImage(
                  "nav_back_n",
                  width: ScreenUtil().setWidth(20),
                  height: ScreenUtil().setWidth(20),
                ),
              ),
              onTap: () {
                finish();
              },
            ),
            Text(CommonUtils.txt('xzxz'), style: GQStyle.white255_18_B),
            GestureDetector(
              child: SizedBox(
                height: double.infinity,
                child: LImage(
                  "comic_list",
                  width: ScreenUtil().setWidth(20),
                  height: ScreenUtil().setWidth(20),
                ),
              ),
              onTap: () {
                context
                    .push(CommonUtils.getRealHash('comicDownloadStatusPage'));
              },
            )
          ],
        ),
      ),
    );
  }

  @override
  void onDestroy() {}

  @override
  Widget pageBody(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Expanded(
            child: GridView.count(
              // physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.all(GQStyle.pagePadding),
              // shrinkWrap: true,
              crossAxisCount: 4,
              mainAxisSpacing: ScreenUtil().setWidth(10),
              crossAxisSpacing: ScreenUtil().setWidth(10),
              childAspectRatio: 80 / 40,
              children: _chapterList.asMap().keys.map((index) {
                return GestureDetector(
                  onTap: () {
                    _chapterSelectedList.contains(index)
                        ? _chapterSelectedList.remove(index)
                        : _chapterSelectedList.add(index);

                    setState(() {});
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: Color(0xff26313b),
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                            color: _chapterSelectedList.contains(index)
                                ? GQStyle.cyanColor00edfd
                                : Colors.transparent,
                            width:
                                _chapterSelectedList.contains(index) ? 0 : .5)),
                    child: Align(
                        alignment: Alignment.center,
                        child: Text('${_chapterList[index]['episode_title']}',
                            style: TextStyle(
                              fontSize: ScreenUtil().setSp(12),
                              color: Colors.white,
                            ))),
                  ),
                );
              }).toList(),
            ),
          ),
          Container(
            color: Color(0xff23262f),
            margin: EdgeInsets.only(
                bottom: kIsWeb ? 0 : ScreenUtil().bottomBarHeight),
            height: ScreenUtil().setWidth(64),
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Container(
                    // color: Colors.red,
                    child: Center(
                      child: Text(
                        CommonUtils.txt('gon') +
                            CommonUtils.txt('xze') +
                            '${_chapterSelectedList.length}' +
                            CommonUtils.txt('hua'),
                        style: GQStyle.white255_13,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      _downloadAct();
                    },
                    child: Stack(
                      children: [
                        // LImage(
                        //   'comic_read_bg',
                        //   fit: BoxFit.cover,
                        //   width: double.infinity,
                        //   height: double.infinity,
                        // ),
                        Positioned.fill(
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(
                                  ScreenUtil().setWidth(5)),
                              child: Container(
                                decoration: BoxDecoration(
                                    gradient:
                                        GQStyle.btnGradient_ff00edfd_ffbbe954),
                              )),
                        ),
                        Center(
                          child: Text(
                            CommonUtils.txt("qrxz"),
                            style: GQStyle.white255_15_M,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
