import 'dart:async';
import 'dart:io';
import 'package:bot_toast/bot_toast.dart';
import 'package:flurry/flurry.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qypj/pages/community/home_community.dart';
import 'package:qypj/pages/welfare/welfare_page.dart';
import 'package:qypj/utils/extensionlibrary.dart';
import 'package:qypj/utils/util_eventbus_class.dart';
import 'package:provider/provider.dart';
import 'package:qypj/components/index_page.dart';
import 'package:qypj/components/page_status.dart';
import 'package:qypj/components/updateModel.dart';
import 'package:qypj/components/wode.dart';
import 'package:qypj/global.dart';
import 'package:qypj/model/homedata.dart';
import 'package:qypj/routers.dart';
import 'package:qypj/store/homeConfig.dart';
import 'package:qypj/theme/default.dart';
import 'package:qypj/utils/api.dart';
import 'package:qypj/utils/common.dart';
import 'package:hive/hive.dart';
import "package:universal_html/html.dart" as html;

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  BackButtonBehavior backButtonBehavior = BackButtonBehavior.none;
  bool showUpdateStatus = false;
  bool showAnnouncementStatus = false;
  bool showActivety = false;
  bool initPage = false;
  List navBarItem = [
    {
      "title": CommonUtils.txt("sy"),
      "activeIcon": "tab_home_s",
      "icon": "tab_home_n",
      "newyear_icon": "qy_newyear_tab_home",
    },
    {
      "title": CommonUtils.txt("sp"),
      "activeIcon": "tab_dm_s",
      "icon": "tab_dm_n",
      "newyear_icon": "qy_newyear_tab_dm",
    },
    {
      "title": CommonUtils.txt("ym"),
      "activeIcon": "tab_shequ_s",
      "icon": "tab_shequ_n",
      "newyear_icon": "qy_newyear_tab_sq",
    },
    {
      "title": CommonUtils.txt("wd"),
      "activeIcon": "tab_wode_s",
      "icon": "tab_wode_n",
      "newyear_icon": "qy_newyear_tab_wd",
    },
  ];
  int selectedKey = 0;
  int wfIndex = 0;
  bool loading = true;
  bool netError = false;
  var discrip;
  final GlobalKey<WelfarePageState> _wfKey = new GlobalKey<WelfarePageState>();

  @override
  void initState() {
    super.initState();
    doCache();
    if (AppGlobal.apiBaseURL.length == 0) {
      CommonUtils.checkline(
        onFailed: () {
          CommonUtils.showText('无法连接服务器，请检查手机网络设置');
        },
        onSuccess: () {
          _setupData();
        },
      );
    } else {
      _setupData();
    }
  }

  //打开的时候就清除一下缓存
  void doCache() async {
    if (kIsWeb) {
      PaintingBinding.instance.imageCache.clear();
      AppGlobal.imageCacheBox.clear();
      return;
    }
    String path = AppGlobal.imageCacheBox.path;
    File file = File(path);

    int size = await file.length();
    //大于500M清理磁盘
    if (size > 500 << 20) {
      await AppGlobal.imageCacheBox.clear();
    }
  }

  _setupData() {
    AppGlobal.apInit = true;
    if (!kIsWeb) {
      _initDownloadStastu();
    }
    fetchBeforeEnterApp();
    if (!kIsWeb) _initPlatformState();

    discrip = UtilEventbus().on<UtilEventbusClass>().listen((event) {
      if (event.arg["name"] == 'openwf') {
        selectedKey = 1;
        setState(() {});
        Future.delayed(Duration(milliseconds: 100), () {
          _wfKey.currentState.changeIndex(event.arg["data"]["index"] ?? 0);
        });
      }
    });
  }

  _initPlatformState() async {
    await Flurry.initialize(
      androidKey: "G87MKKWNTHCDM2RJQS4Z",
      iosKey: "JWZPHSYDH2WB728P6DQX",
    );
  }

  // 初始化下载状态
  Future<void> _initDownloadStastu() async {
    Box box = await Hive.openBox('qypj_video_box');
    List tasks = box.get('download_video_tasks') ?? [];
    if (tasks.length > 0) {
      tasks = tasks.map((element) {
        element["downloading"] = false;
        element["isWaiting"] = false;
        return element;
      }).toList();
    }
    box.put("download_video_tasks", tasks);
  }

  void checkUpdateAnnouncement(VersionMsg version, Config config) {
    // "mstatus": 0,    | 系统公告状态 0 没有 1通知 2禁用
    // "must": "0",     | 更新开关 0 不更新  1 强制更新 2 非强制更新
    // "tips": "",      | 更新描述
    // "message": "",   | 公告描述
    var _versionLocal = AppGlobal.appinfo['version'];
    var targetVersion = version.version.replaceAll('.', '');
    var currentVersion = _versionLocal.replaceAll('.', '');

    // 强制更新 线上版本大于当前版本才更新
    var needUpdate = int.parse(targetVersion) > int.parse(currentVersion);

    if (AppGlobal.yyShow == false) return;

    if (kIsWeb) {
      if (version.mstatus == 1) showAnnouncement(version.message);
      return;
    }
    if (version.must == 1 && needUpdate) {
      showUpdate(version.version, version.tips, version.apk,
          must: version.must,
          showAnnouncementDialog: false,
          official: config.officeSite,
          solution: config.solution);
      return;
    }

    // 非强制更新 无公告 (关闭更新后弹出公告)
    if (version.must == 2 && version.mstatus == 0 && needUpdate) {
      showUpdate(version.version, version.tips, version.apk,
          must: version.must,
          message: version.message,
          showAnnouncementDialog: version.mstatus == 0,
          official: config.officeSite,
          solution: config.solution);
      return;
    }

    // 非强制更新 有公告 (关闭更新后弹出公告)
    if (version.must == 2 && version.mstatus == 1 && needUpdate) {
      showUpdate(version.version, version.tips, version.apk,
          must: version.must,
          message: version.message,
          showAnnouncementDialog: version.mstatus == 1,
          official: config.officeSite,
          solution: config.solution);
      return;
    }
    // 无更新 有公告
    if (version.mstatus == 1) {
      showAnnouncement(version.message);
    }
  }

  void fetchBeforeEnterApp() async {
    Box box = AppGlobal.appBox;
    await getHomeConfig(context).then((res) {
      if (res.status == 1) {
        box.put("lines_url", res.data.config.lines_url.toList());
        box.put("github_url", res.data.config.github_url.toString());
        box.put('office_web', res.data.config.officeSite);
        Timer(Duration(seconds: 3), () {
          String imageUrl = res.data.ads?.imgUrl;
          if (imageUrl != null) {
            CommonUtils.getRealImage(
                url: res.data.ads?.imgUrl,
                setUrl: (urllink) {
                  box.put('ads', {
                    'image': urllink,
                    'url': res.data.ads.url,
                    'id': res.data.ads.report_id,
                    'type': res.data.ads.report_type,
                  });
                  CommonUtils.debugPrint(CommonUtils.txt('gdjw'));
                });
          } else {
            box.put('ads', null);
          }
        });
        getUserInfo(context).then((value) {
          initDialog();
          getClipboardText();
          loading = false;
          setState(() {});
        });
      } else {
        netError = true;
        setState(() {});
      }
    });
  }

  void getClipboardText() {
    if (kIsWeb) {
      Uri u = Uri.parse(html.window.location.href);
      String aff = u.queryParameters['qypjb_aff'];
      if (aff != null) {
        toInvitation(affCode: aff);
      }
    } else {
      Clipboard.getData(Clipboard.kTextPlain).then((value) {
        if (value != null) {
          sendCodeInvitation(value);
        }
      });
    }
  }

  Future<void> sendCodeInvitation(value) async {
    if (value.text == null) return;
    List cliptextList = value.text.split(":").toList();
    if (cliptextList.length > 1) {
      if (cliptextList[0] == 'qypjb_aff') {
        if (cliptextList[1] != '') {
          toInvitation(affCode: cliptextList[1]);
        }
      }
    }
  }

  // 更新提示
  void showUpdate(String version, String tips, String apkurl,
      {int must,
      String message,
      bool showAnnouncementDialog,
      String official,
      String solution}) {
    if (showUpdateStatus == true) return;
    UpdateModel.showUpdateDialog(backButtonBehavior, gowebsite: () {
      CommonUtils.launchURL(official);
    }, gowebguide: () {
      CommonUtils.launchURL(solution);
    }, cancel: () {
      if (showAnnouncementDialog) {
        showAnnouncement(message);
        AppGlobal.yyShow = false;
      }
    }, confirm: () {
      AppGlobal.yyShow = false;
      if (kIsWeb) {
        //刷新网页
        CommonUtils.launchURL(
            Provider.of<HomeConfig>(context, listen: true).config.officeSite);
      } else {
        if (Platform.isAndroid) {
          UpdateModel.androidUpdate(backButtonBehavior,
              version: version, url: apkurl);
        } else {
          CommonUtils.launchURL(apkurl);
        }
      }
    },
        version: CommonUtils.txt('yybt') + "v.$version",
        mustupdate: must == 1,
        text: '$tips');

    showUpdateStatus = true;
    setState(() {});
  }

  // 公告提示
  void showAnnouncement(String message) {
    if (showAnnouncementStatus == true) return;
    bool isSelf = false;
    try {
      isSelf = Provider.of<HomeConfig>(context, listen: false).member.channel ==
          "self";
    } catch (e) {}

    UpdateModel.showAnnouncementDialog(
      backButtonBehavior,
      cancel: () {
        AppGlobal.yyShow = false;
      },
      confirm: () {
        AppGlobal.yyShow = false;
        context.push("/mineAgentPage");
      },
      confirmApp: () {
        context.push('/${Routes.appCenter}');
      },
      text: "$message",
      type: isSelf ? "2" : "1",
    );
    setState(() {
      showAnnouncementStatus = true;
    });
  }

  // 活动弹窗
  void showActivetyDialog(Notice notice) {
    if (showActivety == true) return;
    if (AppGlobal.showActivity == false) return;
    UpdateModel.showAvtivetysDialog(backButtonBehavior, notice: notice,
        cancel: () {
      AppGlobal.showActivity = false;
      if (Provider.of<HomeConfig>(context, listen: false).versionMsg != null) {
        var version =
            Provider.of<HomeConfig>(context, listen: false).versionMsg;
        var config = Provider.of<HomeConfig>(context, listen: false).config;
        checkUpdateAnnouncement(version, config);
      }
    }, confirm: () {
      AppGlobal.showActivity = false;
      _onTapSwiper(notice);
      if (Provider.of<HomeConfig>(context, listen: false).versionMsg != null) {
        var version =
            Provider.of<HomeConfig>(context, listen: false).versionMsg;
        var config = Provider.of<HomeConfig>(context, listen: false).config;
        checkUpdateAnnouncement(version, config);
      }
    });
    setState(() {
      showActivety = true;
    });
  }

  _onTapSwiper(Notice notice) {
    reqAdClickCount(id: notice.report_id, type: notice.report_type);
    if (notice.type == "route") {
      String linkUrl = notice.url_str;
      List urlList = linkUrl.split('??');
      Map<String, dynamic> pramas = {};
      if (urlList.first == "ktloadwebview") {
        pramas["url"] = urlList.last.toString().substring(4);
        AppGlobal.webExtra = {"url": pramas.values.first};
        if (kIsWeb) {
          CommonUtils.launchURL(
              Uri.decodeComponent(pramas.values.first.trim()));
        } else {
          context.push("/${urlList[0]}");
        }
      } else {
        if (urlList.length > 1 && urlList.last != "") {
          urlList[1].split("&").forEach((item) {
            List stringText = item.split('=');
            pramas[stringText[0]] =
                stringText.length > 1 ? stringText[1] : null;
          });
        }
        String pramasStrs = "";
        if (pramas.values.length > 0) {
          pramas.forEach((key, value) {
            pramasStrs += "/${value}";
          });
        }
        context.push("/${urlList[0]}${pramasStrs}");
      }
    } else {
      CommonUtils.launchURL(notice.url_str.trim());
    }
  }

  initDialog() {
    if (!initPage) {
      initPage = true;
      if (Provider.of<HomeConfig>(context, listen: false).notice != null) {
        var notice = Provider.of<HomeConfig>(context, listen: false).notice;
        // title 活动图片地址  content 活动跳转地址 type 跳转类型 1 路由 2 内部webview 3 外部
        showActivetyDialog(notice);
      }
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    discrip.cancel();
  }

  @override
  Widget build(BuildContext context) {
    AppGlobal.appContext = context;
    Member member = Provider.of<HomeConfig>(context, listen: true).member;
    return Scaffold(
      backgroundColor: GQStyle.bgColor,
      resizeToAvoidBottomInset: false,
      body: netError
          ? PageStatus.noNetWork(onTap: () {
              netError = false;
              fetchBeforeEnterApp();
            })
          : loading
              ? PageStatus.loading(mounted)
              : SingleChildScrollView(
                  physics: NeverScrollableScrollPhysics(),
                  child: SizedBox(
                    height: ScreenUtil().screenHeight,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                            child: Stack(
                          children: [
                            Positioned(
                                left: -selectedKey * ScreenUtil().screenWidth,
                                top: 0,
                                bottom: 0,
                                child: Container(
                                  width: ScreenUtil().screenWidth,
                                  height: double.infinity,
                                  child: IndexPage(
                                    isShow: selectedKey == 0,
                                  ),
                                )),
                            Positioned(
                                left: (-selectedKey + 1) *
                                    ScreenUtil().screenWidth,
                                top: 0,
                                bottom: 0,
                                child: Container(
                                  width: ScreenUtil().screenWidth,
                                  height: double.infinity,
                                  child: WelfarePage(
                                    key: _wfKey,
                                    isShow: selectedKey == 1,
                                  ),
                                )),
                            Positioned(
                                left: (-selectedKey + 2) *
                                    ScreenUtil().screenWidth,
                                top: 0,
                                bottom: 0,
                                child: Container(
                                  width: ScreenUtil().screenWidth,
                                  height: double.infinity,
                                  child:
                                      HomeCommunity(isShow: selectedKey == 2),
                                )),
                            Positioned(
                                left: (-selectedKey + 3) *
                                    ScreenUtil().screenWidth,
                                top: 0,
                                bottom: 0,
                                child: Container(
                                    width: ScreenUtil().screenWidth,
                                    height: double.infinity,
                                    child: Wode(
                                      isShow: selectedKey == 3,
                                    ))),
                          ],
                        )),
                        member != null && member.reg_tip.length > 0
                            ? GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onTap: () {
                                  context.push("/login/0");
                                },
                                child: Container(
                                  padding: EdgeInsets.only(
                                      left: GQStyle.pagePadding,
                                      right: GQStyle.pagePadding / 2),
                                  height: ScreenUtil().setWidth(30),
                                  color: Color.fromRGBO(255, 99, 71, 0.8),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        member.reg_tip,
                                        style: GQStyle.white255_14_M,
                                      ),
                                      LImage(
                                        "reg_rarow_n",
                                        width: ScreenUtil().setWidth(22),
                                        height: ScreenUtil().setWidth(22),
                                      )
                                    ],
                                  ),
                                ),
                              )
                            : Container(),
                        Container(
                          padding: EdgeInsets.only(bottom: GQStyle.bottom),
                          height: GQStyle.bottomnavbarHegiht,
                          decoration: BoxDecoration(
                            color: GQStyle.bgColor,
                            boxShadow: [
                              BoxShadow(
                                  color: Color.fromRGBO(39, 39, 39, 1),
                                  spreadRadius: 0.0,
                                  offset: Offset(0.0, -0.5),
                                  blurRadius: 0.0),
                            ],
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: navBarItem
                                .asMap()
                                .keys
                                .map((key) => Expanded(
                                        child: GestureDetector(
                                      behavior: HitTestBehavior.translucent,
                                      onTap: () {
                                        setState(() {
                                          selectedKey = key;
                                        });
                                      },
                                      child: Column(
                                        children: [
                                          LImage(
                                            selectedKey == key
                                                ? navBarItem[key]['activeIcon']
                                                : navBarItem[key]['icon'],
                                            // navBarItem[key]['newyear_icon'],
                                            width: ScreenUtil().setWidth(22.7),
                                            height: ScreenUtil().setWidth(22.7),
                                            fit: BoxFit.fitWidth,
                                          ),
                                          // SizedBox(
                                          //     height:
                                          //         ScreenUtil().setWidth(4.5)),
                                          Text(
                                            navBarItem[key]['title'],
                                            style: selectedKey == key
                                                ? TextStyle(
                                                    color:
                                                        GQStyle.cyanColor00edfd,
                                                    fontSize:
                                                        ScreenUtil().setSp(11),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    decoration:
                                                        TextDecoration.none)
                                                : GQStyle.graya8f8f8f_11,
                                          )
                                        ],
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                      ),
                                    )))
                                .toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }
}
