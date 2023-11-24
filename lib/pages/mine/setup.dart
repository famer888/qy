import 'dart:convert';
import 'dart:io';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qypj/base/baseWidget.dart';
import 'package:qypj/model/homedata.dart';
import 'package:qypj/utils/extensionlibrary.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:qypj/components/yy_dialog.dart';
import 'package:qypj/global.dart';
import 'package:qypj/routers.dart';
import 'package:qypj/store/homeConfig.dart';
import 'package:qypj/theme/default.dart';
import 'package:qypj/utils/api.dart';
import 'package:qypj/utils/common.dart';
import 'package:qypj/utils/http.dart';
import 'package:qypj/utils/index.dart';
import 'package:qypj/utils/networkImage.dart';

class SetupPage extends BaseWidget {
  SetupPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> cState() {
    // TODO: implement cState
    return _SetupPageState();
  }
}

class _SetupPageState extends BaseWidgetState<SetupPage> {
  BackButtonBehavior backButtonBehavior = BackButtonBehavior.none;
  String fileUrl;
  double progress = 0.0;
  bool avatarLoadding = false;
  final tkcontroller = TextEditingController();
  final FocusNode focusNodeTxt = FocusNode();

  _setupItem({String title, String rightText, Function onTap}) {
    return GestureDetector(
      onTap: () {
        if (onTap != null) {
          onTap();
        }
      },
      behavior: HitTestBehavior.translucent,
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: ScreenUtil().setWidth(18),
            vertical: ScreenUtil().setWidth(18)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: GQStyle.black64_15_M,
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                rightText != null
                    ? SizedBox(
                        width: ScreenUtil().setWidth(100),
                        child: Text(
                          rightText,
                          style: GQStyle.gray180_14_line,
                          textAlign: TextAlign.right,
                        ),
                      )
                    : Container(),
                SizedBox(
                  width: ScreenUtil().setWidth(3.5),
                ),
                LImage(
                  'wd_glarrow_n',
                  width: ScreenUtil().setWidth(25),
                  height: ScreenUtil().setWidth(25),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  _line() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: GQStyle.pagePadding),
      color: Color.fromRGBO(21, 21, 42, 1),
      height: ScreenUtil().setWidth(0.5),
    );
  }

  clearToken() {
    Box box = AppGlobal.appBox;
    box.delete('qypj_token');
  }

  final ImagePicker _picker = ImagePicker();
  Future<void> imagePickerAssets() async {
    final XFile file = await _picker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      bool flag = await CommonUtils.pngLimitSize(file);
      if (flag) return;
      uploadFileImg(file);
    }
  }

  void uploadFileImg(XFile file) async {
    CommonUtils.startLoadGIF(tip: CommonUtils.txt('scz'));
    var res;
    if (kIsWeb) {
      res = await PlatformAwareHttp.xfileHtmlUploadImage(
          file: file, position: 'upload');
    } else {
      res = await PlatformAwareHttp.xfileUploadImage(
          file: file, position: 'upload');
    }
    var data = jsonDecode(res);
    if (data['code'] == 1) {
      var newImagePath = data['msg'];
      var result = await updateUserInfo(thumb: newImagePath);
      BotToast.closeAllLoading();
      if (result.status != 0) {
        if (!kIsWeb) fileUrl = file.path;
        Member member = Provider.of<HomeConfig>(context, listen: false).member;
        member.thumb = AppGlobal.imgBase + newImagePath;
        Provider.of<HomeConfig>(context, listen: false).setMember(member);
        setState(() {});
      } else {
        CommonUtils.showText(result.msg);
      }
    } else {
      BotToast.closeAllLoading();
      CommonUtils.showText(data['msg'] ?? "failed");
    }
  }

  void showUpimg() {
    if (AppGlobal.vipLevel < 1) {
      YyShowDialog.showdPNGDiaog(
        context,
        title: CommonUtils.txt('ts'),
        content: (setDialogState) {
          return Text(
            CommonUtils.txt('khygtx'),
            style: GQStyle.white255_13,
          );
        },
        cancelText: CommonUtils.txt('qx'),
        btnText: CommonUtils.txt('ljkt'),
        callBack: () {
          context.push('/${Routes.vip}');
        },
      );
      return;
    }
    imagePickerAssets();
  }

  @override
  Widget pageBody(BuildContext context) {
    var members = Provider.of<HomeConfig>(context, listen: true).member;
    bool isLogin = false;
    if (['', null, false].contains(AppGlobal.apiToken)) {
      isLogin = false;
    } else {
      isLogin = true;
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
            child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    EdgeInsets.symmetric(vertical: ScreenUtil().setWidth(30)),
                child: Center(
                    child: Container(
                  width: ScreenUtil().setWidth(90),
                  height: ScreenUtil().setWidth(140),
                  child: Stack(
                    children: [
                      Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              showUpimg();
                            },
                            child: Container(
                              width: ScreenUtil().setWidth(90),
                              height: ScreenUtil().setWidth(90),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(
                                    ScreenUtil().setWidth(45)),
                                child: fileUrl != null
                                    ? Image.file(
                                        File(fileUrl),
                                        fit: BoxFit.cover,
                                      )
                                    : UserAvatar(),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: ScreenUtil().setWidth(10),
                          ),
                          GestureDetector(
                            onTap: () {
                              showUpimg();
                            },
                            child: Text(
                              CommonUtils.txt('xgtx'),
                              style: GQStyle.gray187_15_M,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                )),
              ),
              _setupItem(
                  title: CommonUtils.txt('nc'),
                  rightText: '${members?.nickname}',
                  onTap: () {
                    if (AppGlobal.vipLevel < 1) {
                      YyShowDialog.showdPNGDiaog(
                        context,
                        title: CommonUtils.txt('ts'),
                        content: (setDialogState) {
                          return Text(
                            CommonUtils.txt('khygm'),
                            style: GQStyle.gray203_13,
                          );
                        },
                        cancelText: CommonUtils.txt('qx'),
                        btnText: CommonUtils.txt('ljkt'),
                        callBack: () {
                          context.push('/${Routes.vip}');
                        },
                      );
                      return;
                    }
                    context.push(CommonUtils.getRealHash('fillcode'), extra: {
                      'title': CommonUtils.txt("txi") + CommonUtils.txt('nc')
                    });
                  }),
              _line(),
              _setupItem(
                  title: CommonUtils.txt('qchc'),
                  onTap: () {
                    if (kIsWeb) {
                      clearCached();
                      CommonUtils.showText(CommonUtils.txt('qhcg'));
                      return;
                    }
                    clearCached();
                    AppGlobal.imageCacheBox.clear();
                    CommonUtils.showText(CommonUtils.txt('qhccq'));
                  }),
              _line(),
              _setupItem(
                  title: CommonUtils.txt('bbgx'),
                  rightText: '${AppGlobal.appinfo['version']}'),
              _line(),
              SizedBox(
                height: 20,
              )
            ],
          ),
        )),
        isLogin
            ? GestureDetector(
                onTap: () {
                  CommonUtils.startLoadGIF(tip: CommonUtils.txt('tuc'));
                  clearCached().then((_) {
                    AppGlobal.apiToken = '';
                    clearToken();
                    getUserInfo(context).then((value) {
                      BotToast.closeAllLoading();
                      context.pop();
                      EventBus().emit('need-update-login-state', 'quit');
                    });
                  });
                },
                child: Container(
                  height: ScreenUtil().setWidth(49),
                  decoration: BoxDecoration(
                    color: Color(0xFF23262e),
                    border: Border(
                        top: BorderSide(
                            color: Color(0xFF272727),
                            width: ScreenUtil().setWidth(1))),
                    // borderRadius: BorderRadius.only(
                    //   topLeft: Radius.circular(ScreenUtil().setWidth(2)),
                    //   topRight: Radius.circular(ScreenUtil().setWidth(2)),
                    // ),
                  ),
                  child: Center(
                    child: Text(
                      CommonUtils.txt('tcdl'),
                      style: GQStyle.white255_18_B,
                    ),
                  ),
                ),
              )
            : Container()
      ],
    );
  }

  @override
  void onCreate() {
    // TODO: implement onCreate
    setAppTitle(title: CommonUtils.txt("bjzl"));
  }

  @override
  void onDestroy() {
    // TODO: implement onDestroy
  }
}

class UserAvatar extends StatelessWidget {
  const UserAvatar({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeConfig>(builder: (ctx, state, child) {
      return state.member?.thumb == null || state.member?.thumb.length == 0
          ? LImage(
              'flj_logo_icon',
              width: double.infinity,
              fit: BoxFit.fitHeight,
            )
          : PlatformAwareNetworkImage(
              fit: BoxFit.cover,
              url: '${state.member.thumb}',
            );
    });
  }
}
