import 'package:bot_toast/bot_toast.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../../../domain/model/member_model.dart';
import '../../../../../../domain/remote_domain/domains/ai.dart';
import '../../../../notifiers/home_config_notifier.dart';
import '../../../../notifiers/user_notifier.dart';
import '../../../../router/routes.dart';
import '../../../../utils/common_utils.dart';
import '../../../../utils/my_toast.dart';
import '../../../common_widgets/dialog/my_dialog.dart';
import '../../../common_widgets/dialog/widgets/regular_dialog.dart';
import '../../../common_widgets/my_image.dart';
import '../../../image_paths.dart';
import '../../../theme.dart';

class ClothesRemoverView extends StatefulWidget {
  const ClothesRemoverView({super.key});

  @override
  State<ClothesRemoverView> createState() => _ClothesRemoverViewState();
}

class _ClothesRemoverViewState extends State<ClothesRemoverView> {
  late final _homeConfig = context.read<HomeConfigNotifier>();
  late final aiDomain = context.read<AIDomain>();
  late final userNotifier = context.read<UserNotifier>();
  late int stripCoinsValue = _homeConfig.config.stripCoins;
  String uploadMaxSize = '2M';
  Map uploadObject = {};
  EdgeInsets piaddings = EdgeInsets.symmetric(horizontal: 10.w);
  Future _initData() async {}

  Future<void> imagePickerAssets() async {
    if (await CommonUtils.pick2MImage() case final xFile?) {
      MyToast.showLoading(text: 'scz'.tr());
      final result = await _homeConfig.uploadImage(xFile);
      if (result != null && result['code'] == 1) {
        final url = "${result['msg']}";

        final image = await decodeImageFromList(await xFile.readAsBytes());

        uploadObject = {
          'media_url': url,
          'url': _homeConfig.config.imgBase + url,
          'thumb_width': image.width,
          'thumb_height': image.height,
        };

        if (mounted) {
          setState(() {});
        }
      } else {
        MyToast.showText(text: result?['msg'] ?? 'failed');
      }
      MyToast.closeAllLoading();
    }
  }

  void onSubmitOffDerobe() async {
    if (uploadObject.isEmpty) {
      MyToast.showText(text: 'qsctp'.tr(context: context));
      return;
    }
    MyToast.showLoading();
    Member? user = userNotifier.member;
    final userCoins = user.money; //用户剩余金币

    final result = await aiDomain.strip(
        thumb: uploadObject['media_url'],
        thumbW: uploadObject['thumb_width'],
        thumbH: uploadObject['thumb_height']);
    BotToast.closeAllLoading();
    if (result.status == 1) {
      setState(() {
        uploadObject = {};
      });
      final stripValue = user.stripValue - 1;
      if (stripValue >= 0) {
        //更新用户剩余次数
        userNotifier.setStripValue(num: stripValue);
      } else {
        //免费次数不够直接扣金币，刷新用户金币余额
        userNotifier.setMoney(money: user.money - stripCoinsValue); //更新用户的金币数量
      }
      MyToast.showText(text: result.msg ?? '提交成功');
    } else {
      if (result.msg != '余额不足') {
        MyToast.showText(text: result.msg ?? '提交失败');
        return;
      }
      //余额不足，提示金币不足
      if (!mounted) return;
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

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(slivers: [
      SliverList.list(children: [
        SizedBox(height: 10.w),
        Container(
            padding: EdgeInsets.symmetric(vertical: 5.w),
            margin: EdgeInsets.symmetric(horizontal: 10.w),
            alignment: Alignment.center,
            color: Colors.white.withOpacity(0.08),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('clyzzpdfy'.tr(context: context), style: MyTheme.white14),
                Text('$stripCoinsValue', style: MyTheme.yellow_14),
                Text('jb'.tr(context: context), style: MyTheme.yellow_14),
                Text('，', style: MyTheme.white14),
                Selector<UserNotifier, int>(
                    selector: (_, config) => config.member.stripValue,
                    builder: (context, number, child) {
                      return Row(
                        children: [
                          Text('nymfcs'.tr(context: context),
                              style: MyTheme.white14),
                          Text('$number', style: MyTheme.yellow_14),
                          Text('ci'.tr(context: context),
                              style: MyTheme.white14)
                        ],
                      );
                    })
              ],
            )),
        SizedBox(height: 10.w),
        Padding(
          padding: piaddings,
          child: GestureDetector(
            onTap: imagePickerAssets,
            child: Container(
              width: double.infinity,
              height: 140.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(6.w)),
                color: Colors.white.withOpacity(0.08),
              ),
              child: uploadObject.isEmpty
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        const MyImage.asset(
                          MyImagePaths.appUploadImg,
                          width: 60,
                          height: 49,
                        ),
                        SizedBox(height: 8.w),
                        Text('djscrwxx'.tr(context: context),
                            style: MyTheme.white07_12),
                        SizedBox(height: 5.w),
                        Text(
                          'tpdxbcg2mb'.tr(context: context),
                          style: MyTheme.white07_12,
                        ),
                      ],
                    )
                  : Stack(
                      children: [
                        MyImage.network(
                          uploadObject['url'],
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
                                  uploadObject = {};
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
        ),
        SizedBox(height: 10.w),
        Center(
          child: GestureDetector(
            onTap: onSubmitOffDerobe,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 10.w, horizontal: 3.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(3.w)),
                  gradient: MyTheme.btnGradient_ff00edfd_ffbbe954,
                ),
                child: Center(
                    child: Text(
                  'shengc'.tr(context: context),
                  style: MyTheme.white15bold,
                )),
              ),
            ),
          ),
        ),
        SizedBox(height: 10.w),
        Padding(
          padding: piaddings,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10.w),
              Text('zyss'.tr(context: context), style: MyTheme.white15_M),
              SizedBox(height: 5.w),
              ...List.generate(
                6,
                (i) => Text('zyss${i + 1}'.tr(context: context),
                    style: MyTheme.white07_11),
              ),
            ],
          ),
        ),
        SizedBox(height: 10.w),
        Padding(
          padding: piaddings,
          child: Row(
            children: [
              Text('sl'.tr(context: context), style: MyTheme.white15),
              const SizedBox.shrink(),
            ],
          ),
        ),
        SizedBox(height: 10.w),
        Padding(
            padding: piaddings,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                PictureCard(
                    thumb: MyImagePaths.appStritpBefore,
                    text: 'quyq'.tr(context: context)),
                PictureCard(
                    thumb: MyImagePaths.appStritpAfter,
                    text: 'quyh'.tr(context: context))
              ],
            ))
      ])
    ]);
  }
}

class PictureCard extends StatelessWidget {
  const PictureCard({
    super.key,
    required this.thumb,
    required this.text,
  });

  final String thumb;
  final String text;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.w),
      child: SizedBox(
        width: 172.w,
        child: Stack(
          children: [
            Image.asset(
              thumb,
              width: 172.w,
              height: 230.w,
              fit: BoxFit.contain,
            ),
            Positioned(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 6.w, horizontal: 5.w),
                decoration: BoxDecoration(
                  color: const Color(0xff009dff),
                  borderRadius:
                      BorderRadius.only(bottomRight: Radius.circular(10.w)),
                ),
                child: Text(
                  text,
                  style: MyTheme.white12medium,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
