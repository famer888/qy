import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:qypj/base/baseWidget.dart';
import 'package:qypj/components/page_status.dart';
import 'package:qypj/theme/default.dart';
import 'package:qypj/utils/api.dart';
import 'package:qypj/utils/common.dart';
import 'package:qypj/utils/extensionlibrary.dart';
import 'package:qypj/utils/networkImage.dart';
import 'package:qypj/views/general_banner.dart';

class ActionTrailerStory extends BaseWidget {
  ActionTrailerStory({Key key}) : super(key: key);

  @override
  State<StatefulWidget> cState() {
    // TODO: implement cState
    return _ActionTrailerStoryState();
  }
}

class _ActionTrailerStoryState extends BaseWidgetState<ActionTrailerStory> {
  List<dynamic> data = [];
  dynamic detail = {};
  bool netError = false;
  bool isHud = true;

  @override
  void onCreate() {
    // TODO: implement onCreate
    _dealData();
  }

  _dealData() async {
    await posterData().then((res) {
      if (res.status == 1) {
        data = res.data["list"];
        detail = res.data["detail"];
        isHud = false;
        setState(() {});
      } else {
        CommonUtils.showText(res.msg);
        context.pop();
      }
    });
  }

  @override
  void onDestroy() {
    // TODO: implement onDestroy
  }

  @override
  Widget backGroundView() {
    return Container(
      height: ScreenUtil().screenWidth * 337 / 375,
      child: Stack(
        children: [
          PlatformAwareNetworkImage(
            url: detail["background_url"] ?? "",
            fit: BoxFit.fill,
            nofigure: true,
          ),
          Container(color: Color.fromRGBO(0, 2, 9, 0.38))
        ],
      ),
    );
  }

  @override
  Widget pageBody(BuildContext context) {
    // TODO: implement pageBody
    return isHud
        ? PageStatus.loading(mounted)
        : data.length > 0
            ? SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: GQStyle.pagePadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: ScreenUtil().setWidth(27)),
                    Text(detail["title"] ?? "loading",
                        style: GQStyle.white255_24_M),
                    Text(detail["sub_title"] ?? "loading",
                        style: GQStyle.white255_24_M),
                    SizedBox(height: ScreenUtil().setWidth(70)),
                    Column(
                      children: data
                          .map(
                            (e) => Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  e["month_app"] ?? "loading",
                                  style: GQStyle.white255_18_B,
                                ),
                                SizedBox(height: ScreenUtil().setWidth(16)),
                                Container(
                                  height: (ScreenUtil().screenWidth -
                                          GQStyle.pagePadding * 2) /
                                      350 *
                                      150,
                                  child: Swiper(
                                    autoplay: e["playbill_list"].length > 1,
                                    onIndexChanged: (e) {},
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return PlatformAwareNetworkImage(
                                        noVisibilityDetector: true,
                                        url: e["playbill_list"][index],
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5)),
                                      );
                                    },
                                    itemCount: e["playbill_list"].length,
                                    pagination: SwiperPagination(builder:
                                        SwiperCustomPagination(
                                            builder: (context, config) {
                                      int count = e["playbill_list"].length;
                                      return Container(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children:
                                              List.generate(count, (index) {
                                            return config.activeIndex == index
                                                ? Container(
                                                    width: ScreenUtil()
                                                        .setWidth(10),
                                                    height: ScreenUtil()
                                                        .setWidth(5),
                                                    margin: EdgeInsets.only(
                                                        right: ScreenUtil()
                                                            .setWidth(5)),
                                                    color: Color(0xFFF04B3E),
                                                  )
                                                : Container(
                                                    width: ScreenUtil()
                                                        .setWidth(10),
                                                    height: ScreenUtil()
                                                        .setWidth(5),
                                                    margin: EdgeInsets.only(
                                                        right: ScreenUtil()
                                                            .setWidth(5)),
                                                    color: Color(0xFFFFFFFF),
                                                  );
                                          }),
                                        ),
                                      );
                                    })),
                                  ),
                                ),
                                SizedBox(
                                    height: ScreenUtil().setWidth(
                                        e["playbill_list"] == null ||
                                                e["playbill_list"].length == 0
                                            ? 0
                                            : 20)),
                                Row(
                                  children: [
                                    SizedBox(
                                      height: ScreenUtil().setWidth(155),
                                      width: ScreenUtil().setWidth(110),
                                      child: PlatformAwareNetworkImage(
                                        url: CommonUtils.getThumb(e),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5)),
                                      ),
                                    ),
                                    SizedBox(
                                      width: ScreenUtil().setWidth(8),
                                    ),
                                    Expanded(
                                        child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: ScreenUtil()
                                                      .setWidth(200),
                                                  child: Text(
                                                    e["title"],
                                                    style: GQStyle.white255_15,
                                                    maxLines: 1,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height:
                                                      ScreenUtil().setWidth(5),
                                                ),
                                                Text(
                                                  e["publisher"] ?? "loading",
                                                  style: TextStyle(
                                                      color: Color.fromRGBO(
                                                          167, 166, 170, 1.0),
                                                      fontSize: ScreenUtil()
                                                          .setSp(12)),
                                                ),
                                                SizedBox(
                                                  height:
                                                      ScreenUtil().setWidth(5),
                                                ),
                                                SizedBox(
                                                  width: ScreenUtil()
                                                      .setWidth(200),
                                                  child: Text(
                                                    CommonUtils.txt('zy') +
                                                        "：${e["directors"]}",
                                                    style: TextStyle(
                                                        color: Color.fromRGBO(
                                                            167, 166, 170, 1.0),
                                                        fontSize: ScreenUtil()
                                                            .setSp(12)),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height:
                                                      ScreenUtil().setWidth(6),
                                                ),
                                                Text(
                                                  "${e["want_count"]}" +
                                                      CommonUtils.txt('rxk'),
                                                  style: TextStyle(
                                                    color: Color.fromRGBO(
                                                        255, 77, 11, 1.0),
                                                    fontSize:
                                                        ScreenUtil().setSp(12),
                                                  ),
                                                )
                                              ],
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                posterWantSee(
                                                        e["id"].toString())
                                                    .then((res) {
                                                  if (res.status == 1) {
                                                    e["is_want"] =
                                                        !e["is_want"];
                                                    setState(() {});
                                                  } else {
                                                    CommonUtils.showText(
                                                        res.msg);
                                                  }
                                                });
                                              },
                                              behavior:
                                                  HitTestBehavior.translucent,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  LImage(
                                                    e["is_want"] == true
                                                        ? "tu_like_n"
                                                        : "tu_unlike_n",
                                                    width: ScreenUtil()
                                                        .setWidth(20),
                                                    height: ScreenUtil()
                                                        .setWidth(20),
                                                  ),
                                                  e["is_want"] == true
                                                      ? Container()
                                                      : Text(
                                                          CommonUtils.txt('xk'),
                                                          style: GQStyle
                                                              .white255_12,
                                                        )
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                            height: ScreenUtil().setWidth(10)),
                                        Text(
                                          e["desp"],
                                          style: TextStyle(
                                            color: Color.fromRGBO(
                                                131, 131, 146, 1.0),
                                            fontSize: ScreenUtil().setSp(12),
                                          ),
                                          maxLines: 3,
                                        )
                                      ],
                                    ))
                                  ],
                                ),
                                SizedBox(height: ScreenUtil().setWidth(30)),
                              ],
                            ),
                          )
                          .toList(),
                    ),
                    SizedBox(height: ScreenUtil().setWidth(20)),
                  ],
                ),
              )
            : PageStatus.noData();
  }
}
