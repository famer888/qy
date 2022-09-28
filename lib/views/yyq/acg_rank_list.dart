import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qypj/theme/default.dart';
import 'package:qypj/utils/common.dart';
import 'package:qypj/utils/extensionlibrary.dart';
import 'package:qypj/utils/networkImage.dart';

class AcgRankList extends StatefulWidget {
  AcgRankList({Key key, this.data}) : super(key: key);
  dynamic data;

  @override
  State<AcgRankList> createState() => _AcgRankListState();
}

class _AcgRankListState extends State<AcgRankList> {
  List<dynamic> _values;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.data == null) return;
  }

  @override
  Widget build(BuildContext context) {
    try {
      if (widget.data['day']['items'].length +
              widget.data['week']['items'].length +
              widget.data['month']['items'].length ==
          0) {
        return Container();
      }
    } catch (e) {}

    return Container(
      padding: EdgeInsets.symmetric(vertical: ScreenUtil().setWidth(10)),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: GQStyle.pagePadding),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RankSubWidget(
                data: widget.data['day'],
                contentType: widget.data['content_type'],
                index: 0,
              ),
              RankSubWidget(
                data: widget.data['week'],
                contentType: widget.data['content_type'],
                index: 1,
              ),
              RankSubWidget(
                data: widget.data['month'],
                contentType: widget.data['content_type'],
                index: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RankSubWidget extends StatefulWidget {
  RankSubWidget({Key key, this.data, this.index = 0, this.contentType})
      : super(key: key);
  dynamic data;
  int index;
  int contentType;

  @override
  State<RankSubWidget> createState() => _RankSubWidgetState();
}

class _RankSubWidgetState extends State<RankSubWidget> {
  double _w = (ScreenUtil().screenWidth -
          GQStyle.pagePadding * 2 -
          ScreenUtil().setWidth(20)) /
      3;
  dynamic data;

  @override
  void initState() {
    super.initState();
    if (widget.data == null) return;
    data = widget.data;
  }

  @override
  Widget build(BuildContext context) {
    return data['items'].length == 0
        ? Container()
        : Column(
            children: [
              Container(
                width: ScreenUtil().setWidth(274),
                margin: EdgeInsets.only(right: ScreenUtil().setWidth(10)),
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0xff324f5b), Color(0xff125d67)]),
                    borderRadius:
                        BorderRadius.circular(ScreenUtil().setWidth(10))),
                child: Stack(
                  children: [
                    // Positioned(top: 0, right: 0, left: 0, child: LImage('')),
                    Container(
                      padding: EdgeInsets.all(ScreenUtil().setWidth(15)),
                      child: Column(
                        children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      children: [
                                        widget.index == 0
                                            ? LImage(
                                                "rank_day",
                                                width:
                                                    ScreenUtil().setWidth(19),
                                                height:
                                                    ScreenUtil().setWidth(19),
                                              )
                                            : LImage(
                                                "rank_week",
                                                width:
                                                    ScreenUtil().setWidth(19),
                                                height:
                                                    ScreenUtil().setWidth(19),
                                              ),
                                        SizedBox(
                                            width: ScreenUtil().setWidth(6)),
                                        Text('${data['title']}',
                                            style: GQStyle.white255_18_B),
                                      ],
                                    ),
                                    Text(
                                      '${data['tip']}',
                                      style: GQStyle.graya3a2a2_13,
                                    )
                                  ],
                                ),
                                // data["more_button"] == null
                                //     ? Container()
                                //     : data["more_button"] == 0
                                //         ? Container()
                                //         :
                                // 排行榜肯定有全部 直接写死
                                GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () {
                                    context.push("/ranklist");
                                  },
                                  child: Row(
                                    children: [
                                      Text(CommonUtils.txt("ckqb"),
                                          style: GQStyle.jellyCyan_11),
                                      LImage(
                                        'more_arrow_cyan_right',
                                        width: ScreenUtil().setWidth(17),
                                        height: ScreenUtil().setWidth(17),
                                      ),
                                      // MoreRightArrowWidget(
                                      //   width: ScreenUtil().setWidth(7.5),
                                      // ),
                                    ],
                                  ),
                                )
                              ]),
                          SizedBox(height: ScreenUtil().setWidth(15)),
                          data['items'].length == 0
                              ? Container()
                              // : true
                              //     ? Container(
                              //         color: Colors.cyan,
                              //         height: 20,
                              //       )
                              : Wrap(
                                  runSpacing: ScreenUtil().setWidth(10),
                                  children: List.from(data['items']).map((e) {
                                    return SizedBox(
                                      width: double.infinity,
                                      height: ScreenUtil().setWidth(90),
                                      child: GestureDetector(
                                        onTap: () {
                                          if (widget.contentType == 2) {
                                            context.push(CommonUtils.getRealHash(
                                                'comicsdetail/${e["id"] ?? "0"}'));
                                          } else if (widget.contentType == 1 ||
                                              widget.contentType == 16) {
                                            context.push(CommonUtils.getRealHash(
                                                'videoDetail/${e["id"] ?? "0"}'));
                                          } else if (widget.contentType == 24) {
                                            context.push(CommonUtils.getRealHash(
                                                'videoDetail/${data["first_mvid"] ?? '0'}'));
                                          }
                                        },
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Stack(
                                              children: [
                                                SizedBox(
                                                  width:
                                                      ScreenUtil().setWidth(70),
                                                  height:
                                                      ScreenUtil().setWidth(90),
                                                  child: PlatformAwareNetworkImage(
                                                      url: clipImageUrl(
                                                          CommonUtils.getThumb(
                                                              e),
                                                          inputWidth:
                                                              ScreenUtil()
                                                                  .setWidth(
                                                                      110)),
                                                      borderRadius: BorderRadius
                                                          .circular(ScreenUtil()
                                                              .setWidth(5))),
                                                ),
                                                Positioned(
                                                    left: ScreenUtil()
                                                        .setWidth(7.5),
                                                    top: ScreenUtil()
                                                        .setWidth(7.5),
                                                    child: CommonUtils.identifyWidget(
                                                        e,
                                                        isHideCoin: widget.data[
                                                                    "content_type"] ==
                                                                2 ||
                                                            widget.data[
                                                                    "content_type"] ==
                                                                24 ||
                                                            widget.data[
                                                                    "content_type"] ==
                                                                6))
                                              ],
                                            ),
                                            Expanded(
                                              child: Padding(
                                                // color: Colors.deepOrange,
                                                padding: EdgeInsets.all(
                                                  ScreenUtil().setWidth(9.5),
                                                ),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                        e["title"] ?? "loading",
                                                        style: GQStyle
                                                            .white255_14),

                                                    SizedBox(
                                                      height: ScreenUtil()
                                                          .setWidth(15),
                                                      child: ListView.builder(
                                                        itemBuilder:
                                                            (context, index) {
                                                          var item = List.from(
                                                                  e['tag_list'])[
                                                              index];
                                                          return Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .only(
                                                                right:
                                                                    ScreenUtil()
                                                                        .setWidth(
                                                                            10),
                                                              ),
                                                              child:
                                                                  StatusStrokBorderText(
                                                                title: '$item',
                                                              ));
                                                        },
                                                        physics:
                                                            NeverScrollableScrollPhysics(),
                                                        scrollDirection:
                                                            Axis.horizontal,
                                                        itemCount: e['tag_list']
                                                                    .length >
                                                                3
                                                            ? 3
                                                            : e['tag_list']
                                                                .length,
                                                      ),
                                                    ),
                                                    Container()
                                                    // widget.data["content_type"] == 6 //美图标识
                                                    //     ? Container()
                                                    //     : Text(
                                                    //         e["finished"] == 1
                                                    //             ? "${CommonUtils.txt("wj")} ${CommonUtils.txt("gng")}${e["series"]}${CommonUtils.txt("hua")}"
                                                    //             : "${CommonUtils.txt("gxz")}${e["series"]}${CommonUtils.txt("hua")}",
                                                    //         style: GQStyle.gray128_11,
                                                    //         strutStyle:
                                                    //             StrutStyle(height: 1),
                                                    //       )
                                                  ],
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: ScreenUtil().setWidth(5),
              )
            ],
          );
  }
}
