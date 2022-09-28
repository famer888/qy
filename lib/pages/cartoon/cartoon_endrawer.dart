import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qypj/components/common/pullrefreshlist.dart';
import 'package:qypj/components/page_status.dart';
import 'package:qypj/global.dart';
import 'package:qypj/theme/default.dart';
import 'package:qypj/utils/api.dart';
import 'package:qypj/utils/common.dart';
import 'package:qypj/utils/extensionlibrary.dart';
// import 'package:qypj/utils/index.dart';
import 'package:qypj/utils/networkImage.dart';
import 'package:qypj/utils/util_eventbus_class.dart';

class CartoonEndrawer extends StatefulWidget {
  CartoonEndrawer({Key key, this.data}) : super(key: key);
  final dynamic data;

  @override
  State<CartoonEndrawer> createState() => _CartoonEndrawerState();
}

class _CartoonEndrawerState extends State<CartoonEndrawer> {
  int page = 1;
  bool isHud = true;
  List<dynamic> videos = [];
  bool noMore = false;
  bool netWorkErr = false;
  String last_ix = "";
  int currentIndex = -1;
  dynamic _data;

  _getData() {
    topicForVideoList(
      id: _data["topic"]["id"].toString(),
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
        videos = st;
      } else if (st.length > 0) {
        videos.addAll(st);
      } else {
        noMore = true;
      }
      currentIndex = videos.indexWhere((e) => e["id"] == _data["vid"]);
      isHud = false;
      setState(() {});
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    CommonUtils.debugPrint(widget.data);
    _data = widget.data;
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      width: ScreenUtil().setWidth(105),
      decoration: BoxDecoration(color: Color.fromRGBO(0, 0, 0, 0.8)),
      child: netWorkErr
          ? PageStatus.noNetWork(onTap: () {
              netWorkErr = false;
              _getData();
            })
          : isHud
              ? PageStatus.loading(mounted,
                  text: CommonUtils.txt("jzz"), width: 60)
              : PullRefreshList(
                  dbtip: CommonUtils.txt("jzwb"),
                  isAll: noMore,
                  onRefresh: () {
                    page = 1;
                    _getData();
                  },
                  onLoading: () {
                    page++;
                    _getData();
                  },
                  child: videos.length == 0
                      ? PageStatus.noData()
                      : ListView.builder(
                          padding: EdgeInsets.symmetric(
                              horizontal: ScreenUtil().setWidth(10)),
                          shrinkWrap: true,
                          itemCount: videos.length,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                GestureDetector(
                                  behavior: HitTestBehavior.translucent,
                                  onTap: () {
                                    UtilEventbus().fire(
                                      UtilEventbusClass({
                                        "name": "openxj",
                                        "data": videos[index],
                                      }),
                                    );
                                    context.pop();
                                  },
                                  child: Container(
                                    height:
                                        ScreenUtil().setWidth(85 / 83 * 107),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: currentIndex == index
                                            ? Color(0xFF00edfd)
                                            : Colors.transparent,
                                        width: ScreenUtil().setWidth(2),
                                      ),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(
                                              ScreenUtil().setWidth(2))),
                                    ),
                                    child: Stack(
                                      children: [
                                        PlatformAwareNetworkImage(
                                          url: CommonUtils.getThumb(
                                              videos[index]),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(
                                                  ScreenUtil().setWidth(2))),
                                        ),
                                        Positioned(
                                          top: 0,
                                          right: 0,
                                          child: Container(
                                            height: ScreenUtil().setWidth(18),
                                            padding: EdgeInsets.symmetric(
                                                horizontal:
                                                    ScreenUtil().setWidth(5)),
                                            decoration: BoxDecoration(
                                                color: Color.fromRGBO(
                                                    35, 38, 47, 0.8),
                                                borderRadius: BorderRadius.only(
                                                  bottomLeft: Radius.circular(
                                                      ScreenUtil().setWidth(2)),
                                                  topRight: Radius.circular(
                                                      ScreenUtil().setWidth(2)),
                                                )),
                                            child: Center(
                                              child: Text(
                                                  "${videos[index]["series_num"] ?? "00"}",
                                                  style: GQStyle.white255_15_M),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: ScreenUtil().setWidth(10)),
                              ],
                            );
                          })),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
