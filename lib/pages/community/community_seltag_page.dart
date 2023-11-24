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
import 'package:qypj/utils/util_eventbus_class.dart';

class CommunitySeltagPage extends BaseWidget {
  CommunitySeltagPage({Key key, this.id, this.type}) : super(key: key);
  int id;
  int type;

  @override
  State<StatefulWidget> cState() {
    // TODO: implement cState
    return _CommunitySeltagPageState();
  }
}

class _CommunitySeltagPageState extends BaseWidgetState<CommunitySeltagPage> {
  bool isHud = true;
  bool netError = false;
  bool noMore = false;
  List tops = [];
  int page = 1;

  void getData() {
    communityTopics(page: page).then((value) {
      if (value.data == null) {
        netError = true;
        setState(() {});
        return;
      }
      List tp = List.from(value.data);
      if (page == 1) {
        noMore = false;
        tops = tp;
      } else if (tp.isNotEmpty) {
        tops.addAll(tp);
      } else {
        noMore = true;
      }
      isHud = false;
      if (widget.type == 1) tops.removeWhere((el) => el["is_ai"] == 1);
      setState(() {});
    });
  }

  @override
  void onCreate() {
    // TODO: implement onCreate
    setAppTitle(title: CommonUtils.txt('xzht'));
    getData();
  }

  @override
  void onDestroy() {
    // TODO: implement onDestroy
  }

  @override
  Widget pageBody(BuildContext context) {
    // TODO: implement pageBody
    return isHud
        ? PageStatus.loading(mounted)
        : tops.isEmpty
            ? PageStatus.noData()
            : PullRefreshList(
                isAll: noMore,
                onRefresh: () {
                  page = 1;
                  getData();
                },
                onLoading: () {
                  page++;
                  getData();
                },
                child: ListView.builder(
                    padding: EdgeInsets.symmetric(
                        horizontal: GQStyle.pagePadding, vertical: 0.w),
                    itemCount: tops.length,
                    itemBuilder: (cx, index) {
                      dynamic e = tops[index];
                      return GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          UtilEventbus().fire(
                            UtilEventbusClass({"name": "tagsall", "data": e}),
                          );
                          context.pop();
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 10.w),
                          margin: EdgeInsets.only(bottom: 10.w),
                          height: 70.w,
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(32, 35, 44, 1),
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.w)),
                            border: e['id'] == widget.id
                                ? Border.all(color: GQStyle.cyanColor00edfd)
                                : null,
                          ),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 46.w,
                                height: 46.w,
                                child: PlatformAwareNetworkImage(
                                  url: CommonUtils.getThumb(e),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(23.w)),
                                ),
                              ),
                              SizedBox(width: 5.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('#${e['name']}',
                                        style: GQStyle.white15bold),
                                    SizedBox(height: 5.w),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "${CommonUtils.renderFixedNumber(e["post_num"])}${CommonUtils.txt("tiez")}",
                                          style: GQStyle.white12,
                                        ),
                                        Text(
                                          "${CommonUtils.renderFixedNumber(e["view_num"])}${CommonUtils.txt("llan")}",
                                          style: GQStyle.white12,
                                        ),
                                        Text(
                                          "${CommonUtils.renderFixedNumber(e["follow_num"])}${CommonUtils.txt("gz")}",
                                          style: GQStyle.white12,
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
              );
    ;
  }
}
