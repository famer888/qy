import 'package:flutter/material.dart';
import 'package:qypj/components/common/pagetitlebar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qypj/components/common/pullrefreshlist.dart';
import 'package:qypj/components/page_status.dart';
import 'package:qypj/page/gen_custom_nav.dart';
import 'package:qypj/page/yyq_diamond_nav.dart';
import 'package:qypj/pages/community/community_post.dart';
import 'package:qypj/theme/default.dart';
import 'package:qypj/utils/api.dart';
import 'package:qypj/utils/common.dart';
import 'package:qypj/utils/extensionlibrary.dart';
import 'package:qypj/utils/networkImage.dart';
import 'package:qypj/utils/pageviewmixin.dart';

class CollectPage extends StatefulWidget {
  CollectPage({Key key}) : super(key: key);

  @override
  _CollectPageState createState() => _CollectPageState();
}

class _CollectPageState extends State<CollectPage> {
  final myController = TextEditingController();
  int currentTab = 0;
  int limit = 24;
  List tabList = [
    {'id': 1, 'name': CommonUtils.txt('sping')},
    {'id': 14, 'name': CommonUtils.txt('tiezt')},
    // {'id': 2, 'name': CommonUtils.txt('mh')},
    // {'id': 3, 'name': CommonUtils.txt('xs')},
    // {'id': 6, 'name': CommonUtils.txt('mt')},
    // {'id': 7, 'name': CommonUtils.txt('ym')},
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GQStyle.bgColor,
      body: SafeArea(
          child: Column(
        children: [
          PageTitleBar(
            title: CommonUtils.txt('wdsc'),
          ),
          Expanded(
            child: YyqDiamondNav(
              titles: tabList.map<String>((e) => e["name"]).toList(),
              pages: tabList
                  .map((e) => PageViewMixin(
                        child: CollectList(type: e['id']),
                      ))
                  .toList(),
              defaultStyle: GQStyle.white255_15_M,
              selectStyle: GQStyle.blue80_15_M,
              navColor: GQStyle.bgColor,
              inedxFunc: (index) {
                currentTab = index;
                setState(() {});
              },
            ),
          )
        ],
      )),
    );
  }
}

class CollectList extends StatefulWidget {
  final int type;

  CollectList({Key key, this.type}) : super(key: key);
  @override
  _CollectListState createState() => _CollectListState();
}

class _CollectListState extends State<CollectList> {
  List<dynamic> dataList;
  bool isHud = true;
  int page = 1;
  bool netError = false;
  bool noMore = false;
  String last_ix = "";

  _getData() async {
    var result =
        await getUserFavor(page: page, type: widget.type, last_ix: last_ix);
    if (result == null) {
      netError = true;
      setState(() {});
    }
    List<dynamic> st = result['data']["list"];
    last_ix =
        result['data']["last_ix"] == null ? "" : result['data']["last_ix"];
    if (page == 1) {
      noMore = false;
      dataList = st;
    } else if (st.length > 0) {
      dataList.addAll(st);
    } else {
      noMore = true;
    }
    netError = false;
    isHud = false;
    setState(() {});
  }

  Widget _videoList() {
    double _w = (ScreenUtil().screenWidth -
            GQStyle.pagePadding * 2 -
            ScreenUtil().setWidth(4)) /
        2;
    return PullRefreshList(
        isAll: noMore,
        onRefresh: () {
          page = 1;
          last_ix = "";
          _getData();
        },
        onLoading: () {
          page += 1;
          _getData();
        },
        child: GridView.builder(
            cacheExtent: ScreenUtil().screenHeight * 5,
            padding: EdgeInsets.symmetric(
                horizontal: GQStyle.pagePadding,
                vertical: ScreenUtil().setWidth(20)),
            itemCount: dataList.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: ScreenUtil().setWidth(4),
              crossAxisSpacing: ScreenUtil().setWidth(4),
            ),
            itemBuilder: (context, index) {
              var t = dataList[index];
              CommonUtils.debugPrint(t);
              return GestureDetector(
                onTap: () {
                  if (t["mv_type"] == 1) {
                    context.push(
                        CommonUtils.getRealHash('videoDetail/${t["id"]}'));
                  } else {
                    context.push(
                        CommonUtils.getRealHash('smallvideodetail/${t["id"]}'));
                  }
                },
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: _w / 173 * 100,
                          child: PlatformAwareNetworkImage(
                              url: clipImageUrl(CommonUtils.getThumb(t),
                                  inputWidth: ScreenUtil().setWidth(173)),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5))),
                        ),
                        SizedBox(height: ScreenUtil().setWidth(3.5)),
                        Text(t["title"] ?? "loading",
                            style: GQStyle.white255_14),
                        SizedBox(height: ScreenUtil().setWidth(3.5)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                                "${CommonUtils.renderFixedNumber(t["play_ct"] ?? 0)}${CommonUtils.txt("cbf")}",
                                style: GQStyle.gray105_11),
                            Spacer(),
                            Text("${CommonUtils.getHMTime(t["duration"] ?? 0)}",
                                style: GQStyle.gray105_11),
                            SizedBox(width: ScreenUtil().setWidth(5))
                          ],
                        )
                      ],
                    )
                  ],
                ),
              );
            }));
  }

  _postList() {
    return PullRefreshList(
      isAll: noMore,
      onRefresh: () {
        page = 1;
        last_ix = "";
        _getData();
      },
      onLoading: () {
        page += 1;
        _getData();
      },
      child: ListView.builder(
          itemCount: 1, //标签+帖子
          itemBuilder: (context, index) {
            return CommunityPost(data: dataList, showHead: false);
          }),
    );
  }

  getListWidget() {
    switch (widget.type) {
      case 1:
        return _videoList();
        break;
      case 14:
        return _postList();
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    return netError
        ? PageStatus.noNetWork()
        : isHud
            ? PageStatus.loading(mounted)
            : (dataList.length > 0 ? getListWidget() : PageStatus.noData());
  }
}
