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

class CommunityTagsAll extends BaseWidget {
  CommunityTagsAll({Key key, this.type}) : super(key: key);
  final int type; //0展示 1选择数据

  @override
  State<StatefulWidget> cState() {
    // TODO: implement cState
    return _CommunityTagsAllState();
  }
}

class _CommunityTagsAllState extends BaseWidgetState<CommunityTagsAll> {
  List<dynamic> cates = [];
  int setIndex = 0;
  int page = 1;
  bool noMore = false;
  bool networkErr = false;
  bool isHud = true;
  List<dynamic> data = [];

  @override
  void onCreate() {
    // TODO: implement onCreate
    setAppTitle(
        title: widget.type == 0
            ? CommonUtils.txt("qbbq")
            : CommonUtils.txt("xzbq"));
    _getData();
  }

  _getData() {
    communityListCate().then((res) {
      if (res.status == 1) {
        cates = res.data;
        _getDataById();
      } else {
        CommonUtils.showText(res.msg);
        context.pop();
      }
    });
  }

  _getDataById() {
    communityListTopic(cate_id: cates[setIndex]["id"].toString(), page: page)
        .then((res) {
      if (res.data == null) {
        networkErr = true;
        return;
      }
      List st = res.data;
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
  void onDestroy() {
    // TODO: implement onDestroy
  }

  @override
  Widget pageBody(BuildContext context) {
    // TODO: implement pageBody
    return cates.length == 0
        ? PageStatus.loading(mounted)
        : Container(
            child: Row(
              children: [
                Container(
                  color: Color(0xFF26313a),
                  width: ScreenUtil().setWidth(100),
                  child: ListView.builder(
                      itemCount: cates.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () {
                            if (setIndex == index) return;
                            setIndex = index;
                            page = 1;
                            isHud = true;
                            setState(() {});
                            _getDataById();
                          },
                          child: Container(
                            height: ScreenUtil().setWidth(50),
                            decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      color: Colors.white10,
                                      width: ScreenUtil().setWidth(0.5))),
                            ),
                            child: Stack(
                              children: [
                                setIndex == index
                                    ? Positioned(
                                        left: 0,
                                        top: ScreenUtil().setWidth(29 / 2),
                                        child: Container(
                                          width: ScreenUtil().setWidth(3),
                                          height: ScreenUtil().setWidth(21),
                                          color: Color(0xFFfdfc00),
                                        ),
                                      )
                                    : Container(),
                                Center(
                                  child: Text(
                                    cates[index]["name"],
                                    style: setIndex == index
                                        ? GQStyle.blue80_18_M
                                        : GQStyle.white255_14_M,
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      }),
                ),
                Expanded(
                    child: PullRefreshList(
                  isAll: noMore,
                  onRefresh: () {
                    page = 1;
                    _getDataById();
                  },
                  onLoading: () {
                    page++;
                    _getDataById();
                  },
                  child: isHud
                      ? PageStatus.loading(mounted)
                      : ListView.builder(
                          padding: EdgeInsets.symmetric(
                              horizontal: ScreenUtil().setWidth(15),
                              vertical: ScreenUtil().setWidth(13)),
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () {
                                if (widget.type == 0) {
                                  context.push(
                                      "/communitytagdetail/${data[index]["id"]}");
                                } else {
                                  UtilEventbus().fire(
                                    UtilEventbusClass({
                                      "name": "tagsall",
                                      "data": data[index],
                                    }),
                                  );
                                  context.pop();
                                }
                              },
                              child: Column(
                                children: [
                                  SizedBox(height: ScreenUtil().setWidth(7)),
                                  Row(
                                    children: [
                                      SizedBox(
                                        height: ScreenUtil().setWidth(90),
                                        width: ScreenUtil().setWidth(90),
                                        child: PlatformAwareNetworkImage(
                                          url: data[index]["thumb"] ?? "",
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(
                                                  ScreenUtil().setWidth(5))),
                                        ),
                                      ),
                                      SizedBox(
                                          width: ScreenUtil().setWidth(13)),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "#${data[index]["name"] ?? ""}",
                                              style: GQStyle.blue80_13_M,
                                            ),
                                            SizedBox(
                                                height:
                                                    ScreenUtil().setWidth(14)),
                                            Text(
                                                "${CommonUtils.renderFixedNumber(data[index]["follow_num"] ?? 0)}${CommonUtils.txt("gz")}",
                                                style: GQStyle.gray163_11),
                                            SizedBox(
                                                height:
                                                    ScreenUtil().setWidth(9)),
                                            Text(
                                                "${CommonUtils.renderFixedNumber(data[index]["view_num"] ?? 0)}${CommonUtils.txt("llan")}",
                                                style: GQStyle.gray163_11),
                                          ],
                                        ),
                                      ),
                                      widget.type == 0
                                          ? GestureDetector(
                                              behavior:
                                                  HitTestBehavior.translucent,
                                              onTap: () {
                                                //话题关注/取消关注
                                                communityFollowTopic(
                                                        topic_id: data[index]
                                                                ["id"]
                                                            .toString())
                                                    .then((res) {
                                                  if (res.status == 1) {
                                                    data[index]
                                                        ["is_follow"] = data[
                                                                    index]
                                                                ["is_follow"] ==
                                                            1
                                                        ? 0
                                                        : 1;
                                                    setState(() {});
                                                  } else {
                                                    CommonUtils.showText(
                                                        res.msg);
                                                  }
                                                });
                                              },
                                              child: Container(
                                                width:
                                                    ScreenUtil().setWidth(55),
                                                height:
                                                    ScreenUtil().setWidth(25),
                                                decoration: BoxDecoration(
                                                    color: data[index]
                                                                ["is_follow"] ==
                                                            1
                                                        ? Color(0xFF00eefe)
                                                        : Colors.transparent,
                                                    borderRadius: BorderRadius.all(
                                                        Radius.circular(
                                                            ScreenUtil()
                                                                .setWidth(
                                                                    25 / 2))),
                                                    border: Border.all(
                                                        color: data[index]["is_follow"] == 1
                                                            ? Colors.transparent
                                                            : Color(0xFF00eefe),
                                                        width: ScreenUtil()
                                                            .setWidth(0.5))),
                                                child: Center(
                                                  child: Text(
                                                    data[index]["is_follow"] ==
                                                            1
                                                        ? CommonUtils.txt("ygz")
                                                        : "+ ${CommonUtils.txt("gz")}",
                                                    style: data[index]
                                                                ["is_follow"] ==
                                                            1
                                                        ? GQStyle.white11
                                                        : GQStyle.blue80_11,
                                                  ),
                                                ),
                                              ),
                                            )
                                          : Container()
                                    ],
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(
                                        top: ScreenUtil().setWidth(7)),
                                    height: ScreenUtil().setWidth(1),
                                    color: Color(0xFF26313a),
                                  )
                                ],
                              ),
                            );
                          }),
                ))
              ],
            ),
          );
  }
}
