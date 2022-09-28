import 'package:flutter/material.dart';
import 'package:qypj/components/card/comics_card.dart';
import 'package:qypj/components/card/h74cardA.dart';
import 'package:qypj/components/common/pagetitlebar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qypj/components/card/v34card.dart';
import 'package:qypj/page/flj_slider_nav.dart';
import 'package:qypj/page/gen_custom_nav.dart';
import 'package:qypj/page/yyq_diamond_nav.dart';
import 'package:qypj/theme/default.dart';
import 'package:qypj/utils/common.dart';
import 'package:qypj/utils/pageviewmixin.dart';
import 'package:hive/hive.dart';
import 'package:qypj/utils/index.dart';
import 'package:qypj/components/page_status.dart';
import 'dart:io';
import 'package:qypj/utils/download_video.dart';

class DownPage extends StatefulWidget {
  DownPage({Key key}) : super(key: key);

  @override
  _DownPageState createState() => _DownPageState();
}

class _DownPageState extends State<DownPage> with TickerProviderStateMixin {
  final myController = TextEditingController();
  int currentTab = 0;
  bool isEdit = false;
  bool isAll = false;
  List tabList = [
    {
      'id': 1,
      'name': CommonUtils.txt('shp'),
    },
    // {
    //   'id': 2,
    //   'name': CommonUtils.txt('mh'),
    // },
    // {
    //   'id': 3,
    //   'name': CommonUtils.txt('xs'),
    // }
  ];
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GQStyle.bgColor,
      body: SafeArea(
          child: Column(
        children: [
          PageTitleBar(
            title: CommonUtils.txt('wdxz'),
            rightWidget: GestureDetector(
              onTap: () {
                setState(() {
                  isEdit = !isEdit;
                });
              },
              child: Container(
                child: Text(
                  CommonUtils.txt('bj'),
                  style: GQStyle.gray150_14,
                ),
              ),
            ),
          ),
          Expanded(
            child: YyqDiamondNav(
              titles: tabList.map<String>((e) => e["name"]).toList(),
              pages: [
                PageViewMixin(
                  child: DownList(type: 1, isEdit: isEdit, current: currentTab),
                ),
                // PageViewMixin(
                //   child: DownList(type: 2, isEdit: isEdit, current: currentTab),
                // ),
                // PageViewMixin(
                //   child: DownList(type: 3, isEdit: isEdit, current: currentTab),
                // ),
              ],
              inedxFunc: (x) {
                currentTab = x;
                setState(() {});
              },
              defaultStyle: GQStyle.white255_15_M,
              selectStyle: GQStyle.blue80_15_M,
            ),
          ),
          renderBottom()
        ],
      )),
    );
  }

  Widget renderBottom() {
    String allIcon = 'wd_allsel_n';
    String allNotIcon = 'wd_noallsel_n';
    if (!isEdit) {
      return Container();
    }
    return Container(
      decoration: BoxDecoration(
        color: Color.fromRGBO(25, 25, 25, 1),
        boxShadow: [
          BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.1),
              offset: Offset(0, 0),
              blurRadius: 10.0,
              spreadRadius: 0)
        ],
      ),
      child: Row(
        children: [
          Expanded(
              child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              EventBus().emit(
                  "EDIT_DOWNLOAD", {"isAll": !isAll, "current": currentTab});
              setState(() {
                isAll = !isAll;
              });
            },
            child: Container(
              padding: EdgeInsets.only(left: ScreenUtil().setWidth(15)),
              alignment: Alignment.centerLeft,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    isAll ? Icons.check_circle_outline : Icons.circle_outlined,
                    color: isAll
                        ? Color.fromRGBO(0, 210, 190, 1)
                        : GQStyle.grayColor180,
                    size: ScreenUtil().setWidth(20),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: ScreenUtil().setWidth(10)),
                    child: Text(
                      CommonUtils.txt('qxu'),
                      // isAll ? CommonUtils.txt('qbx') : CommonUtils.txt('qxu'),
                      style: isAll ? GQStyle.blue80_15 : GQStyle.gray180_15,
                    ),
                  )
                ],
              ),
            ),
          )),
          GestureDetector(
            onTap: () {
              EventBus().emit(
                  "EDIT_DOWNLOAD", {"isDelete": true, "current": currentTab});
            },
            child: Container(
              padding: EdgeInsets.symmetric(
                  vertical: ScreenUtil().setWidth(15),
                  horizontal: ScreenUtil().setWidth(40)),
              decoration: BoxDecoration(
                gradient: GQStyle.btnGradient_ff00edfd_ffbbe954,
              ),
              child: Center(
                child: Text(
                  CommonUtils.txt('sch'),
                  style: GQStyle.white15bold,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class DownList extends StatefulWidget {
  DownList({Key key, this.type, this.isEdit, this.current}) : super(key: key);
  int type;
  bool isEdit;
  int current;
  @override
  _DownListState createState() => _DownListState();
}

class _DownListState extends State<DownList> {
  List data = [];
  bool loading = true;
  List chooseList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    switch (widget.type) {
      case 1:
        // 获取视频数据
        getVideoDownloadInfo();
        break;
      case 2:
        // 获取漫画数据
        getComicsDownloadInfo();
        break;
      case 3:
        // 获取小说数据
        getNovelDownloadInfo();
        break;
      // case 4:
      //   // 获取有声小说数据
      //   break;
      default:
        getVideoDownloadInfo();
    }
    EventBus().on('EDIT_DOWNLOAD', (arg) {
      if (arg["current"] == widget.type - 1) {
        if (arg["isAll"] != null && arg["isAll"]) {
          for (var i = 0; i < data.length; i++) {
            data[i]["choosed"] = true;
          }
          setState(() {});
        } else if (arg["isAll"] != null && !arg["isAll"]) {
          for (var i = 0; i < data.length; i++) {
            data[i]["choosed"] = false;
          }
          setState(() {});
        }
        if (arg["isDelete"] != null && arg["isDelete"]) {
          onDelete();
        }
      }
    });
  }

  onDelete() async {
    Box box = await Hive.openBox('qypjbox');
    // data = box.get('download_video_tasks') ?? [];
    for (var i = 0; i < data.length; i++) {
      if (data[i]["choosed"] == true) {
        DownloadUtil.removeTask(data[i]["id"]);
        String path = data[i]["url"];
        String dir = path.substring(0, path.lastIndexOf("/"));
        Directory directory = Directory(dir);
        bool isExists = await directory.exists();
        if (isExists) {
          directory.deleteSync(recursive: true);
        }
      }
    }
    data.removeWhere((e) => e["choosed"] == true);
    box.put("download_video_tasks", data);
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    EventBus().off('EDIT_DOWNLOAD');
  }

  // 获取视频下载信息
  Future getVideoDownloadInfo() async {
    Box box = await Hive.openBox('qypjbox');
    data = box.get('download_video_tasks') ?? [];
    for (var i = 0; i < data.length; i++) {
      data[i]["choosed"] = false;
    }
    setState(() {
      loading = false;
    });
  }

  getComicsDownloadInfo() {
    setState(() {
      loading = false;
    });
  }

  getNovelDownloadInfo() {
    setState(() {
      loading = false;
    });
  }

  _videoList() {
    String chooseIcon = 'wd_radiosel_n';
    String chooseNotIcon = 'wd_radio_n';

    return data.length == 0
        ? PageStatus.noData(text: CommonUtils.txt('spxzk'))
        : GridView.builder(
            cacheExtent: ScreenUtil().screenHeight * 5,
            padding: EdgeInsets.symmetric(
                horizontal: GQStyle.pagePadding,
                vertical: ScreenUtil().setWidth(20)),
            itemCount: data.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: ScreenUtil().setWidth(20),
              crossAxisSpacing: ScreenUtil().setWidth(7),
              childAspectRatio: 1.15,
            ),
            itemBuilder: (context, index) {
              return Stack(
                children: [
                  H74CardA(
                    width: (ScreenUtil().screenWidth -
                            GQStyle.pagePadding * 2 -
                            ScreenUtil().setWidth(7)) /
                        2,
                    contentType: data[index]["contentType"],
                    thumbUrl: data[index]["thumbCover"],
                    cardData: data[index],
                    showField: 'title,tags',
                    isLocal: true,
                  ),
                  widget.isEdit
                      ? Positioned(
                          top: 0,
                          right: 0,
                          bottom: 0,
                          left: 0,
                          child: GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () {
                              data[index]["choosed"] = !data[index]["choosed"];
                              setState(() {});
                            },
                            child: Container(
                              alignment: Alignment.topLeft,
                              padding: EdgeInsets.only(
                                  top: ScreenUtil().setWidth(6),
                                  left: ScreenUtil().setWidth(6)),
                              child: LImage(
                                data[index]["choosed"] == true
                                    ? chooseIcon
                                    : chooseNotIcon,
                                width: ScreenUtil().setWidth(17),
                                height: ScreenUtil().setWidth(17),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ))
                      : Container()
                ],
              );
            });
  }

  _comicsList() {
    return data.length == 0
        ? PageStatus.noData(text: CommonUtils.txt('xzkfz'))
        : GridView.builder(
            cacheExtent: ScreenUtil().screenHeight * 5,
            padding: EdgeInsets.symmetric(
                horizontal: GQStyle.pagePadding,
                vertical: ScreenUtil().setWidth(20)),
            itemCount: 10,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: ScreenUtil().setWidth(9.5),
              crossAxisSpacing: ScreenUtil().setWidth(9.5),
              childAspectRatio: 0.53,
            ),
            itemBuilder: (context, index) {
              return V34Card(
                width: ScreenUtil().setWidth(110.5),
                thumbUrl: 'https://staff.tea123.me/e.jpg',
              );
            });
  }

  _novelList() {
    return data.length == 0
        ? PageStatus.noData(text: CommonUtils.txt('xzkfz'))
        : GridView.builder(
            cacheExtent: ScreenUtil().screenHeight * 5,
            padding: EdgeInsets.symmetric(
                horizontal: GQStyle.pagePadding,
                vertical: ScreenUtil().setWidth(20)),
            itemCount: 10,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: ScreenUtil().setWidth(9.5),
              crossAxisSpacing: ScreenUtil().setWidth(9.5),
              childAspectRatio: 0.53,
            ),
            itemBuilder: (context, index) {
              return V34Card(
                width: ScreenUtil().setWidth(110.5),
                thumbUrl: 'https://staff.tea123.me/e.jpg',
              );
            });
  }

  _voiceNovelList() {
    return ListView.builder(
        padding: EdgeInsets.symmetric(
            horizontal: GQStyle.pagePadding,
            vertical: ScreenUtil().setWidth(20)),
        itemCount: 10,
        itemBuilder: (context, index) {
          return ComicsCard(
            thumbUrl: 'https://staff.tea123.me/e.jpg',
          );
        });
  }

  getListWidget() {
    switch (widget.type) {
      case 1:
        return _videoList();
        break;
      case 2:
        return _comicsList();
        break;
      case 3:
        return _novelList();
        break;
      // case 4:
      //   return _voiceNovelList();
      //   break;
      default:
        return _comicsList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return loading ? PageStatus.loading(mounted) : getListWidget();
  }
}
