import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../notifiers/home_config_notifier.dart';
import '../../notifiers/user_notifier.dart';
import '../common_widgets/dialog/my_dialog.dart';
import '../common_widgets/keep_alive_wrapper.dart';
import '../common_widgets/my_image.dart';
import '../common_widgets/my_tab_bar.dart';
import '../common_widgets/screen_background.dart';
import '../image_paths.dart';
import '../theme.dart';
import '../../../domain/model/member_model.dart';
import '../../../domain/remote_domain/domains/ai.dart';
import '../../router/routes.dart';
import 'widgets/ar_art/screen.dart';
import 'widgets/ai_magic/screen.dart';
import '../common_widgets/dialog/widgets/regular_dialog.dart';
import '../../utils/common_utils.dart';
import '../../utils/my_toast.dart';
import 'widgets/clothes_remover/screen.dart';
import 'widgets/face_swapper/screen.dart';
import 'widgets/face_swapper/widgets/sheet.dart';

class AIServerScreen extends StatefulWidget {
  const AIServerScreen({super.key});

  @override
  State<AIServerScreen> createState() => _AIServerScreenState();
}

class _AIServerScreenState extends State<AIServerScreen>
    with TickerProviderStateMixin {
  late final _homeConfig = context.read<HomeConfigNotifier>();
  late final config = context.read<HomeConfigNotifier>().config;
  late final userNotifier = context.read<UserNotifier>();
  late final aiDomain = context.read<AIDomain>();

  late int faceCoinsValue = _homeConfig.config.faceCoins;
  late final titles = ['aimf', 'aihh', 'aihl', 'aiqy'];
  late final tabController =
      TabController(length: titles.length, vsync: this, initialIndex: 0);
  int index = 0;
  Map uploadGroudObject = {};
  Map uploadThumObject = {};

  @override
  void initState() {
    super.initState();
    tabController.addListener(() {
      setState(() {
        index = tabController.index;
      });
    });
  }

  Future<void> onOpenMaterialDetail() async {
    const String uploadMaxSize = '2M';
    return showModalBottomSheet(
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        context: context,
        builder: (context) => StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              return DecoratedBox(
                decoration: BoxDecoration(
                  color: const Color(0xff0b0a21),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10.w),
                    topRight: Radius.circular(10.w),
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: EdgeInsets.all(15.w),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 5.w),
                          width: double.infinity,
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('scmb'.tr(), style: MyTheme.white13),
                              const SizedBox.shrink(),
                              InkWell(
                                onTap: () => context.pop(),
                                child: Container(
                                  alignment: Alignment.centerRight,
                                  width: 44.w,
                                  height: 44.w,
                                  child: MyImage.asset(
                                    MyImagePaths.appIssueClose,
                                    width: 11.w,
                                    height: 11.w,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 5.w),
                        GestureDetector(
                          onTap: () {
                            imagePickerAssets(true).then((e) {
                              setState(() {});
                            });
                          },
                          child: Container(
                            width: double.infinity,
                            height: 140.w,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(6.w)),
                              color: const Color(0xff1b1c2b),
                            ),
                            child: uploadGroudObject.isEmpty
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Icon(Icons.add,
                                          color: const Color(0xff9f9f9f),
                                          size: 26.w),
                                      Text('djscmb'.tr(context: context),
                                          style: MyTheme.white13),
                                    ],
                                  )
                                : Stack(
                                    children: [
                                      MyImage.network(
                                        uploadGroudObject['url'],
                                        fit: BoxFit.fitHeight,
                                        borderRadius: 6.w,
                                        backgroundColor: MyTheme.imageBgColor,
                                      ),
                                      Positioned(
                                          top: 0,
                                          right: 0,
                                          child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                uploadGroudObject = {};
                                              });
                                            },
                                            child: Container(
                                              padding: EdgeInsets.all(5.w),
                                              decoration: const BoxDecoration(
                                                  color: Color(0xFF3094FF)),
                                              child: Center(
                                                  child: Icon(
                                                Icons.delete_forever,
                                                size: 20.sp,
                                                color: Colors.white,
                                              )),
                                            ),
                                          ))
                                    ],
                                  ),
                          ),
                        ),
                        SizedBox(height: 10.w),
                        Row(
                          children: [
                            Text('sclbxx'.tr(context: context),
                                style: MyTheme.white13),
                            const SizedBox.shrink(),
                          ],
                        ),
                        SizedBox(height: 10.w),
                        GestureDetector(
                          onTap: () {
                            imagePickerAssets(false).then((e) {
                              setState(() {});
                            });
                          },
                          child: Container(
                            width: double.infinity,
                            height: 140.w,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(6.w)),
                              color: const Color(0xff1b1c2b),
                            ),
                            child: uploadThumObject.isEmpty
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Icon(Icons.add,
                                          color: const Color(0xff9f9f9f),
                                          size: 26.w),
                                      Text('djscrwxx'.tr(context: context),
                                          style: MyTheme.white13),
                                      Text(
                                          'tpdxbcg'.tr(context: context) +
                                              uploadMaxSize,
                                          style: TextStyle(
                                              fontSize: 10.sp,
                                              color: const Color(0xff9f9f9f))),
                                    ],
                                  )
                                : Stack(
                                    children: [
                                      MyImage.network(
                                        uploadThumObject['url'],
                                        fit: BoxFit.fitHeight,
                                        borderRadius: 6.w,
                                        backgroundColor: MyTheme.imageBgColor,
                                      ),
                                      Positioned(
                                          top: 0,
                                          right: 0,
                                          child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                uploadThumObject = {};
                                              });
                                            },
                                            child: Container(
                                              padding: EdgeInsets.all(5.w),
                                              decoration: const BoxDecoration(
                                                  color: Color(0xFF3094FF)),
                                              child: Center(
                                                  child: Icon(
                                                Icons.delete_forever,
                                                size: 20.sp,
                                                color: Colors.white,
                                              )),
                                            ),
                                          ))
                                    ],
                                  ),
                          ),
                        ),
                        SizedBox(height: 10.w),
                        TipText(content: 'zyss'.tr(context: context)),
                        TipText(content: 'zyss1'.tr(context: context)),
                        TipText(content: 'zyss2'.tr(context: context)),
                        TipText(content: 'zyss3'.tr(context: context)),
                        TipText(content: 'zyss4'.tr(context: context)),
                        TipText(content: 'zyss5'.tr(context: context)),
                        SizedBox(height: 10.w),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            UploadFaceTip(
                                thumb: MyImagePaths.uploadFaceRight,
                                title: 'zqwzl'.tr(context: context)),
                            UploadFaceTip(
                                thumb: MyImagePaths.uploadFaceError1,
                                title: 'zdlb'.tr(context: context)),
                            UploadFaceTip(
                                thumb: MyImagePaths.uploadFaceError2,
                                title: 'zdyj'.tr(context: context))
                          ],
                        ),
                        SizedBox(height: 10.w),
                        Row(mainAxisSize: MainAxisSize.max, children: [
                          Text('${'xhjb'.tr(context: context)}：',
                              style: MyTheme.white13),
                          Text('$faceCoinsValue', style: MyTheme.nav_active_14),
                          SizedBox(width: 10.w),
                          Text('${'mfcs'.tr(context: context)}：',
                              style: MyTheme.white13),
                          Selector<UserNotifier, int>(
                              selector: (_, config) =>
                                  config.member.imgFaceValue,
                              builder: (context, number, child) {
                                return Text('$number',
                                    style: MyTheme.nav_active_14);
                              }),
                          const Expanded(child: SizedBox()),
                          GestureDetector(
                            onTap: () {
                              uploadOptional();
                            },
                            child: Container(
                              width: 115.w,
                              padding: EdgeInsets.symmetric(vertical: 10.w),
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(3.w)),
                                  gradient: MyTheme.gradient_90_114),
                              child: Center(
                                child: Text('ljzz'.tr(context: context),
                                    style: MyTheme.white15bold),
                              ),
                            ),
                          )
                        ]),
                        SizedBox(height: 10.w)
                      ],
                    ),
                  ),
                ),
              );
            }));
  }

  Future<void> uploadOptional() async {
    {
      if (uploadThumObject.isEmpty || uploadGroudObject.isEmpty) {
        MyToast.showText(text: 'qsctp'.tr(context: context)); //请上传图片
        return;
      }
      MyToast.showLoading();

      Member? user = userNotifier.member;
      final userCoins = user.money; //用户剩余金币

      final result = await aiDomain.customizeFace(
          ground: uploadGroudObject['media_url'],
          groundW: uploadGroudObject['thumb_width'],
          groundH: uploadGroudObject['thumb_height'],
          thumb: uploadThumObject['media_url'],
          thumbW: uploadThumObject['thumb_width'],
          thumbH: uploadThumObject['thumb_height']);

      MyToast.closeAllLoading();
      if (result.status == 1) {
        setState(() {
          uploadThumObject = {};
          uploadGroudObject = {};
        });
        MyToast.showText(text: result.msg ?? '提交成功');

        final imgFaceValue = userNotifier.member.imgFaceValue - 1;
        if (imgFaceValue >= 0) {
          //更新用户剩余次数
          userNotifier.setImgFaceValue(num: imgFaceValue);
        }
        userNotifier.setMoney(
            money: userNotifier.member.money - faceCoinsValue); //更新用户的金币数量
        context.pop();
      } else {
        if (result.msg != '余额不足') {
          MyToast.showText(text: result.msg ?? '提交失败');
          return;
        }
        //余额不足，提示金币不足
        MyDialog.showDialog(
          context: context,
          child: RegularDialog(
            buttonText: 'qwcz'.tr(),
            cancelText: 'qx'.tr(),
            title: 'ts'.tr(),
            content: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(children: [
                  TextSpan(
                    text: '${tr('ndyebz')}\n${tr('syjb')}',
                    style: MyTheme.white255_15,
                  ),
                  TextSpan(
                    text: '$userCoins',
                    style: MyTheme.orange247_15,
                  )
                ])),
            confirmOnTap: () {
              //前往充值
              context.pop();
              const CoinRechargeRoute().push(context);
            },
            cancelOnTap: () {
              //取消
              context.pop();
            },
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenBackground(
      child: Scaffold(
        appBar: _AppBar(
          tabController: tabController,
          titles: titles,
        ),
        body: TabBarView(
          controller: tabController,
          children: const [
            KeepAliveWrapper(child: AIMagic()),
            KeepAliveWrapper(child: AIArtScreen()),
            KeepAliveWrapper(child: FaceSwapperView()),
            KeepAliveWrapper(child: ClothesRemoverView()),
          ],
        ),
        floatingActionButton: index != 0
            ? const SizedBox()
            : GestureDetector(
                onTap: onOpenMaterialDetail,
                child: Image.asset(
                  MyImagePaths.appCustomModel,
                  height: 32.w,
                  fit: BoxFit.fitHeight,
                ),
              ),
      ),
    );
  }

  Future<void> imagePickerAssets(bool isMb) async {
    if (await CommonUtils.pickImage() case final xFile?) {
      MyToast.showLoading(text: 'scz'.tr());
      final result = await _homeConfig.uploadImage(xFile);
      if (result != null && result['code'] == 1) {
        final url = "${result['msg']}";

        final image = await decodeImageFromList(await xFile.readAsBytes());

        if (isMb) {
          uploadGroudObject = {
            'media_url': url,
            'url': _homeConfig.config.imgBase + url,
            'thumb_width': image.width,
            'thumb_height': image.height,
          };
        } else {
          uploadThumObject = {
            'media_url': url,
            'url': _homeConfig.config.imgBase + url,
            'thumb_width': image.width,
            'thumb_height': image.height,
          };
        }

        if (mounted) {
          setState(() {});
        }
      } else {
        MyToast.showText(text: result?['msg'] ?? 'failed');
      }
      MyToast.closeAllLoading();
    }
  }
}

class _AppBar extends StatelessWidget implements PreferredSizeWidget {
  const _AppBar({required this.tabController, required this.titles});

  final TabController tabController;
  final List<String> titles;

  @override
  final Size preferredSize = const Size.fromHeight(44);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leadingWidth: 40.w,
      leading: GestureDetector(
        onTap: () {
          context.pop();
        },
        child: Padding(
          padding: EdgeInsets.only(left: 15.w),
          child: Image.asset(
            MyImagePaths.appBackIcon,
            width: 20.w,
            height: 20.w,
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            const MineAIRecordRoute().push(context);
          },
          child: const Center(
            child: Text(
              '记录',
              style: TextStyle(color: Colors.white60),
            ),
          ),
        ),
      ],
      backgroundColor: Colors.transparent,
      iconTheme: Theme.of(context).iconTheme.copyWith(color: Colors.white),
      title: Theme(
        data: Theme.of(context).copyWith(
          tabBarTheme: MyTabBarTheme.line(
            labelStyle: MyTheme.jellyCyan_15.copyWith(fontSize: 15.sp),
            unselectedLabelStyle: TextStyle(
              color: const Color.fromRGBO(255, 255, 255, 1),
              fontSize: 15.sp,
              overflow: TextOverflow.visible,
              decoration: TextDecoration.none,
            ),
          ),
        ),
        child: RepaintBoundary(
          child: ScrollConfiguration(
            behavior: ScrollConfiguration.of(context).copyWith(
              scrollbars: false,
            ),
            child: SizedBox(
              height: 41.w,
              child: TabBar(
                physics: const BouncingScrollPhysics(),
                isScrollable: false,
                padding: EdgeInsets.symmetric(vertical: 2.w),
                controller: tabController,
                labelPadding: EdgeInsets.symmetric(horizontal: 8.w),
                tabAlignment: TabAlignment.center,
                tabs: titles
                    .map((title) => Tab(
                          height: MyTheme.navbarHegiht,
                          text: title.tr(context: context),
                        ))
                    .toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TipText extends StatelessWidget {
  const TipText({super.key, required this.content});

  final String content;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(content, style: MyTheme.white11),
        const SizedBox.shrink(),
      ],
    );
  }
}
