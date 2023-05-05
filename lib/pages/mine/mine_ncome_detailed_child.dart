import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qypj/base/baseWidget.dart';
import 'package:qypj/components/common/pullrefreshlist.dart';
import 'package:qypj/components/page_status.dart';
import 'package:qypj/theme/default.dart';
import 'package:qypj/utils/api.dart';
import 'package:qypj/utils/common.dart';
import 'package:qypj/utils/networkImage.dart';

class MineNcomeDetailedChild extends StatefulWidget {
  MineNcomeDetailedChild({Key key, this.source = ""}) : super(key: key);
  final String source;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MineNcomeDetailedChildState();
  }
}

class _MineNcomeDetailedChildState extends State<MineNcomeDetailedChild> {
  List<dynamic> vList;
  bool isHud = true;
  bool noMore = false;
  bool netWorkErr = false;
  String last_ix = "";
  int page = 1;

  _getData() {
    earnTotalInfo(
      source: widget.source,
      page: page,
      last_ix: last_ix,
    ).then((res) {
      if (res.data == null) {
        netWorkErr = true;
        setState(() {});
        return;
      }
      List st = List.from(res.data["list"]);
      last_ix = res.data["last_ix"] == null ? "" : res.data["last_ix"];
      if (page == 1) {
        noMore = false;
        vList = st;
      } else if (st.length > 0) {
        vList.addAll(st);
      } else {
        noMore = true;
      }
      isHud = false;
      setState(() {});
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement pageBody
    return isHud
        ? PageStatus.loading(mounted)
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
            child: vList.length == 0
                ? PageStatus.noData()
                : ListView.builder(
                    padding:
                        EdgeInsets.symmetric(horizontal: GQStyle.pagePadding),
                    shrinkWrap: true,
                    itemCount: vList.length,
                    itemBuilder: (context, index) {
                      return Container(
                        height: ScreenUtil().setWidth(62),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Container(
                            //   height: 10,
                            //   color: Colors.deepOrange,
                            // ),
                            Expanded(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // SizedBox(
                                  //   width: ScreenUtil().setWidth(34),
                                  //   height: ScreenUtil().setWidth(34),
                                  //   child: PlatformAwareNetworkImage(
                                  //     url: CommonUtils.getThumb(
                                  //         vList[index]["source_member"]),
                                  //     borderRadius: BorderRadius.all(
                                  //         Radius.circular(
                                  //             ScreenUtil().setWidth(17))),
                                  //   ),
                                  // ),
                                  // SizedBox(width: ScreenUtil().setWidth(10)),
                                  Expanded(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                    vList[index][
                                                                "source_member"]
                                                            ["nickname"] ??
                                                        "",
                                                    style:
                                                        GQStyle.white255_13_M),
                                                Expanded(
                                                    child: Text(
                                                        '·${vList[index]["desc"] ?? ""}',
                                                        style: GQStyle
                                                            .graya3a2a2_11_M))
                                              ],
                                            ),
                                            SizedBox(
                                                height:
                                                    ScreenUtil().setWidth(7)),
                                            Text(
                                                "${RelativeDateFormat.format(DateTime.parse(vList[index]["created_at"] ?? ""))}",
                                                style: GQStyle.graya3a2a2_12),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    // width: 30,
                                    // height: 10,
                                    // height: double.infinity,
                                    child: Text(
                                        "+${vList[index]["coinCnt"] ?? 0}${CommonUtils.txt("bs")}",
                                        style: GQStyle.blue80_13_M),
                                  )
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: ScreenUtil().setWidth(44),
                                ),
                                Expanded(
                                  child: Container(
                                    height: ScreenUtil().setWidth(0.5),
                                    color: Color.fromRGBO(255, 255, 255, 0.1),
                                  ),
                                ),
                              ],
                            ),
                            // Container(
                            //   height: 10,
                            //   color: Colors.green,
                            // ),
                          ],
                        ),
                      );
                    }),
          );
  }
}
