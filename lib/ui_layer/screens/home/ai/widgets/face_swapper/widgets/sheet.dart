import 'package:bot_toast/bot_toast.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../../../../domain/model/ai/ai_face_material_model.dart';
import '../../../../../../../domain/model/member_model.dart';
import '../../../../../../../domain/remote_domain/domains/ai.dart';
import '../../../../../../notifiers/home_config_notifier.dart';
import '../../../../../../notifiers/user_notifier.dart';
import '../../../../../../router/routes.dart';
import '../../../../../../utils/common_utils.dart';
import '../../../../../../utils/my_toast.dart';
import '../../../../../common_widgets/dialog/my_dialog.dart';
import '../../../../../common_widgets/dialog/widgets/regular_dialog.dart';
import '../../../../../common_widgets/localization_text.dart';
import '../../../../../common_widgets/my_image.dart';
import '../../../../../image_paths.dart';
import '../../../../../theme.dart';

class FaceSwapSheetView extends StatefulWidget {
  const FaceSwapSheetView({super.key, this.data});

  final AiFaceMaterialModel? data;

  @override
  State<FaceSwapSheetView> createState() => _FaceSwapSheetViewState();
}

class _FaceSwapSheetViewState extends State<FaceSwapSheetView> {
  late final _homeConfig = context.read<HomeConfigNotifier>();
  late final faceCoinsValue = _homeConfig.config.faceCoins;
  late final userNotifier = context.read<UserNotifier>();
  late final aiDomain = context.read<AIDomain>();

  Map uploadObject = {};
  Map uploadGroudObject = {};

  Future<void> imagePickerAssets({bool isModel = false}) async {
    if (await CommonUtils.pickImage(limitSize: 2) case final xFile?) {
      MyToast.showLoading(text: 'scz'.tr());
      final result = await _homeConfig.uploadImage(xFile);
      if (result != null && result['code'] == 1) {
        final url = "${result['msg']}";

        final image = await decodeImageFromList(await xFile.readAsBytes());

        if (isModel) {
          uploadGroudObject = {
            'media_url': url,
            'url': _homeConfig.config.imgBase + url,
            'thumb_width': image.width,
            'thumb_height': image.height,
          };
        } else {
          uploadObject = {
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

  @override
  Widget build(BuildContext context) {
    final item = widget.data;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xff0b0b21),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 5.w),
                width: double.infinity,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    item == null
                        ? LocalizationText(
                            'scmb',
                            style: MyTheme.white15_M,
                          )
                        : Text(
                            '${'mob'.tr()}-${item.title}',
                            style: MyTheme.white15_M,
                          ),
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
              item == null
                  ? GestureDetector(
                      onTap: () {
                        imagePickerAssets(isModel: true).then((e) {
                          setState(() {});
                        });
                      },
                      child: Container(
                        width: double.infinity,
                        height: 140.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(6.w)),
                          color: Colors.white.withOpacity(0.08),
                        ),
                        child: uploadGroudObject.isNotEmpty
                            ? Stack(
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
                              )
                            : Column(
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
                                  Text('djscmb'.tr(context: context),
                                      style: MyTheme.white07_12),
                                  SizedBox(height: 5.w),
                                ],
                              ),
                      ),
                    )
                  : SizedBox(
                      height: 140.w,
                      child: MyImage.network(
                        item.thumb,
                        fit: BoxFit.fitHeight,
                        borderRadius: 6.w,
                        backgroundColor: Colors.white.withOpacity(0.08),
                      ),
                    ),
              SizedBox(height: 10.w),
              Row(
                children: [
                  Text('sclbxx'.tr(context: context), style: MyTheme.white15_M),
                  const SizedBox.shrink(),
                ],
              ),
              SizedBox(height: 10.w),
              GestureDetector(
                onTap: () {
                  imagePickerAssets().then((e) {
                    setState(() {});
                  });
                },
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
              SizedBox(height: 10.w),
              Text('zyss'.tr(context: context), style: MyTheme.white15_M),
              SizedBox(height: 5.w),
              ...List.generate(
                5,
                (i) => Text('zyss${i + 1}'.tr(context: context),
                    style: MyTheme.white07_11),
              ),
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
              SizedBox(height: 20.w),
              Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text('${'xhjb'.tr(context: context)}：',
                        style: MyTheme.white13),
                    Text('$faceCoinsValue', style: MyTheme.yellow_12),
                    SizedBox(width: 10.w),
                    Text('${'mfcs'.tr(context: context)}：',
                        style: MyTheme.white13),
                    Selector<UserNotifier, int>(
                        selector: (_, config) => config.member.imgFaceValue,
                        builder: (context, number, child) {
                          return Text('$number', style: MyTheme.yellow_12);
                        }),
                    const Expanded(child: SizedBox()),
                    GestureDetector(
                      onTap: () async {
                        if (uploadObject.isEmpty ||
                            (uploadGroudObject.isEmpty && item == null)) {
                          MyToast.showText(
                              text: 'qsctp'.tr(context: context)); //请上传图片
                          return;
                        }
                        MyToast.showLoading();

                        Member? user = userNotifier.member;
                        final userCoins = user.money; //用户剩余金币

                        final result = item == null
                            ? await aiDomain.customizeFace(
                                ground: uploadGroudObject['media_url'],
                                groundW: uploadGroudObject['thumb_width'],
                                groundH: uploadGroudObject['thumb_height'],
                                thumb: uploadObject['media_url'],
                                thumbW: uploadObject['thumb_width'],
                                thumbH: uploadObject['thumb_height'])
                            : await aiDomain.changeFace(
                                id: item.id,
                                thumb: uploadObject['media_url'],
                                thumbW: uploadObject['thumb_width'],
                                thumbH: uploadObject['thumb_height']);
                        BotToast.closeAllLoading();
                        if (result.status == 1) {
                          setState(() {
                            uploadObject = {};
                          });
                          MyToast.showText(text: result.msg ?? '提交成功');

                          final imgFaceValue =
                              userNotifier.member.imgFaceValue - 1;
                          if (imgFaceValue >= 0) {
                            //更新用户剩余次数
                            userNotifier.setImgFaceValue(num: imgFaceValue);
                          } else {
                            //免费次数不够直接扣金币，刷新用户金币余额
                            userNotifier.setMoney(
                                money: userNotifier.member.money -
                                    faceCoinsValue); //更新用户的金币数量
                          }
                          context.pop();
                        } else {
                          if (result.msg != '余额不足') {
                            MyToast.showText(text: result.msg ?? '提交失败');
                            return;
                          }

                          if (!context.mounted) return;
                          //余额不足，提示金币不足
                          MyDialog.showDialog(
                            context: context,
                            child: RegularDialog(
                              buttonText: 'qwcz'.tr(),
                              cancelText: 'qx'.tr(),
                              title: 'ts'.tr(),
                              content: RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: '${tr('ndyebz')}\n${tr('syjb')}',
                                      style: MyTheme.white255_15,
                                    ),
                                    TextSpan(
                                      text: '$userCoins',
                                      style: MyTheme.yellow_12,
                                    )
                                  ],
                                ),
                              ),
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
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 5.w,
                          horizontal: 15.w,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30.w),
                          gradient: MyTheme.btnGradient_ff00edfd_ffbbe954,
                        ),
                        child: Center(
                          child: Text('ljzz'.tr(context: context),
                              style: MyTheme.white14),
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
  }
}

class UploadFaceTip extends StatelessWidget {
  const UploadFaceTip({super.key, required this.thumb, required this.title});

  final String thumb;
  final String title;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        children: [
          Image.asset(
            thumb,
            width: 60.w,
            fit: BoxFit.fitHeight,
          ),
          SizedBox(height: 10.w),
          Text(
            title,
            style: MyTheme.white13,
          )
        ],
      ),
    );
  }
}
