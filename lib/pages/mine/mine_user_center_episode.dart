import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qypj/base/baseWidget.dart';
import 'package:qypj/components/common/pullrefreshlist.dart';
import 'package:qypj/components/page_status.dart';
import 'package:qypj/theme/default.dart';
import 'package:qypj/utils/api.dart';
import 'package:qypj/utils/common.dart';
import 'package:qypj/utils/extensionlibrary.dart';
import 'package:qypj/utils/networkImage.dart';

class MineUserCenterEpisode extends BaseWidget {
  MineUserCenterEpisode({Key key, this.aff}) : super(key: key);
  final String aff;

  @override
  State<StatefulWidget> cState() {
    // TODO: implement cState
    return _MineUserCenterEpisodeState();
  }
}

class _MineUserCenterEpisodeState
    extends BaseWidgetState<MineUserCenterEpisode> {
  int page = 1;
  bool isHud = true;
  List<dynamic> data = [];
  bool noMore = false;
  bool netWorkErr = false;
  String last_ix = "";

  _getData() {
    otherUserListOfTopic(
      aff: widget.aff,
      page: page,
      last_ix: last_ix,
    ).then((res) {
      if (res.data == null) {
        netWorkErr = true;
        setState(() {});
        return;
      }
      List st = res.data["list"];
      last_ix = res.data["last_ix"] == null ? "" : res.data["last_ix"];
      if (page == 1) {
        noMore = false;
        data = st;
      } else if (st.length > 0) {
        data.addAll(st);
      } else {
        noMore = true;
      }
      isHud = false;
      setState(() {});
    });
  }

  @override
  void onCreate() {
    // TODO: implement onCreate
    setAppTitle(title: CommonUtils.txt("jji"));
    _getData();
  }

  @override
  void onDestroy() {
    // TODO: implement onDestroy
  }

  @override
  Widget pageBody(BuildContext context) {
    // TODO: implement pageBody
    double _w = (ScreenUtil().screenWidth -
            GQStyle.pagePadding * 2 -
            ScreenUtil().setWidth(4)) /
        2;
    return Container(
      color: GQStyle.bgColor,
      child: netWorkErr
          ? PageStatus.noNetWork(onTap: () {
              netWorkErr = false;
              _getData();
            })
          : isHud
              ? PageStatus.loading(mounted)
              : data.length == 0
                  ? PageStatus.noData()
                  : PullRefreshList(
                      isAll: noMore,
                      onRefresh: () {
                        page = 1;
                        _getData();
                      },
                      onLoading: () {
                        page++;
                        _getData();
                      },
                      child: GridView.builder(
                          cacheExtent: ScreenUtil().screenHeight * 5,
                          padding: EdgeInsets.symmetric(
                              horizontal: GQStyle.pagePadding,
                              vertical: ScreenUtil().setWidth(10)),
                          itemCount: data.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: ScreenUtil().setWidth(4.5),
                            crossAxisSpacing: ScreenUtil().setWidth(8),
                            childAspectRatio: 171 / 131.5,
                          ),
                          itemBuilder: (context, index) {
                            var e = data[index];
                            return GestureDetector(
                              onTap: () {
                                context.push(CommonUtils.getRealHash(
                                    'topicsmallvideodetail/${e["id"]}'));
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Stack(
                                    children: [
                                      SizedBox(
                                        height: _w / 171 * 96,
                                        child: PlatformAwareNetworkImage(
                                            url: clipImageUrl(
                                                CommonUtils.getThumb(e),
                                                inputWidth:
                                                    ScreenUtil().setWidth(173)),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5))),
                                      ),
                                      Positioned.fill(
                                          child: Column(
                                        children: [
                                          Spacer(),
                                          Container(
                                            height: ScreenUtil().setWidth(40),
                                            padding: EdgeInsets.symmetric(
                                                horizontal:
                                                    ScreenUtil().setWidth(10),
                                                vertical:
                                                    ScreenUtil().setWidth(7.5)),
                                            decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                    colors: [
                                                  Color.fromRGBO(0, 0, 0, 0.6),
                                                  Colors.transparent,
                                                ],
                                                    begin:
                                                        Alignment.bottomCenter,
                                                    end: Alignment.topCenter)),
                                            child: Align(
                                              alignment: Alignment.bottomCenter,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                      "${CommonUtils.renderFixedNumber(e["views_count"] ?? 0)}${CommonUtils.txt("cbf")}",
                                                      style:
                                                          GQStyle.white255_11),
                                                  Spacer(),
                                                  Text(
                                                      CommonUtils.txt('gon') +
                                                          "${e["mv_count"] ?? 0}" +
                                                          CommonUtils.txt(
                                                              'jishu'),
                                                      style:
                                                          GQStyle.white255_11),
                                                  SizedBox(
                                                      width: ScreenUtil()
                                                          .setWidth(5))
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                      )),
                                    ],
                                  ),
                                  Expanded(
                                    child: Center(
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          e["title"] ?? "loading",
                                          style: GQStyle.white255_13,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            );
                          }),
                    ),
    );
  }
}
