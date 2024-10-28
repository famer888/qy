import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'dart:developer' as developer;

import '../../../../../../../domain/api_validator.dart';
import '../../../../../../../domain/model/ai/ai_model.dart';
import '../../../../../../../domain/model/member_model.dart';
import '../../../../../../../domain/remote_domain/domains/ai.dart';
import '../../../../../../notifiers/home_config_notifier.dart';
import '../../../../../../notifiers/user_notifier.dart';
import '../../../../../../router/routes.dart';
import '../../../../../../utils/common_utils.dart';
import '../../../../../../utils/my_toast.dart';
import '../../../../../common_widgets/dialog/widgets/regular_dialog.dart';
import '../../../../../common_widgets/my_image.dart';
import '../../../../../image_paths.dart';
import '../../../../../theme.dart';

class FaceSwapSheetView extends StatefulWidget {
  const FaceSwapSheetView({super.key, required this.data});

  final AIModel data;

  @override
  State<FaceSwapSheetView> createState() => _FaceSwapSheetViewState();
}

class _FaceSwapSheetViewState extends State<FaceSwapSheetView> {
  String _aiRule = ''; //换脸规则

  Map imgMap = {};

  final ImagePicker _picker = ImagePicker();
  late final homeConfigNotifier = context.read<HomeConfigNotifier>();
  late final userNotifier = context.read<UserNotifier>();

  @override
  void initState() {
    super.initState();

    _aiRule = tr('airuledesc');
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sheetHeight = ScreenUtil().screenHeight * 0.7;

    String imgUrl = '';
    if (imgMap.isNotEmpty) {
      imgUrl = imgMap['url'];
      imgUrl = imgUrl.substring(1); //删除第一个字符/
      imgUrl = homeConfigNotifier.config.imgBase + imgUrl;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
      color: MyTheme.bgColor,
      height: sheetHeight,
      child: Stack(
        children: [
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 13.w),
                Center(
                  child: Text(
                    widget.data.title ?? '',
                    style: MyTheme.white20medium,
                    maxLines: 1,
                  ),
                ),
                SizedBox(height: 13.w),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () {
                              // _isChooseFaceImage = false;
                              // _showImagePicker();
                            },
                            child: Container(
                              width: double.infinity,
                              height: 200.w,
                              clipBehavior: Clip.hardEdge,
                              decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.05),
                                  borderRadius: BorderRadius.circular(7.w)),
                              child: MyImage.network(
                                widget.data.thumb ?? '',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 20.w),
                    Expanded(
                      child: Column(
                        children: [
                          GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () {
                              _showImagePicker();
                            },
                            child: Container(
                              width: double.infinity,
                              height: 200.w,
                              decoration: imgMap.isEmpty
                                  ? DottedDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(7.w)),
                                      shape: Shape.box,
                                      color: MyTheme.cyanColor00edfd,
                                      strokeWidth: 1.w)
                                  : null,
                              alignment: Alignment.center,
                              child: imgMap.isNotEmpty
                                  ? MyImage.network(imgUrl)
                                  : Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        MyImage.asset(
                                          MyImagePaths.appUploadImg,
                                          width: 35.w,
                                          height: 35.w,
                                        ),
                                        SizedBox(height: 5.w),
                                        Text(
                                          tr('sclbtp'), //上传脸部图片
                                          style: MyTheme.white08_12,
                                        ),
                                        SizedBox(height: 5.w),
                                        Text(
                                          tr('tpdxbcg2mb'), //图片大小不超过2MB
                                          style: MyTheme.white06_10,
                                        )
                                      ],
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 13.w),
                Text(
                  tr('aizysx'), //注意事项
                  style: MyTheme.white15semibold,
                ),
                SizedBox(height: 10.w),
                Text(
                  _aiRule,
                  style: MyTheme.white06_12,
                  maxLines: 100,
                ),
                SizedBox(height: 25.w),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        MyImage.asset(
                          MyImagePaths.appAiFaceSampleCorrect,
                          width: 55.w,
                          height: 55.w,
                        ),
                        SizedBox(height: 8.w),
                        Text(
                          tr('zmwzd'),
                          style: MyTheme.white14,
                        )
                      ],
                    ),
                    Column(
                      children: [
                        MyImage.asset(
                          MyImagePaths.appAiFaceSampleGlasses,
                          width: 55.w,
                          height: 55.w,
                        ),
                        SizedBox(height: 8.w),
                        Text(
                          tr('bzdmb'),
                          style: MyTheme.white14,
                        )
                      ],
                    ),
                    Column(
                      children: [
                        MyImage.asset(
                          MyImagePaths.appAiFaceSampleMask,
                          width: 55.w,
                          height: 55.w,
                        ),
                        SizedBox(height: 8.w),
                        Text(
                          tr('bzdyj'),
                          style: MyTheme.white14,
                        )
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 30.w),
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: _postTakeOff,
                  child: Container(
                    margin:
                        EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
                    height: 50.w,
                    decoration: BoxDecoration(
                        gradient: MyTheme.gradient_90_114,
                        borderRadius: BorderRadius.circular(25.w)),
                    child: Center(
                      child: Builder(builder: (context) {
                        final faceCt = userNotifier.member.faceCt ?? 0;
                        final faceCoins =
                            homeConfigNotifier.config.faceCoins ?? 0;
                        String text = tr('tjdd'); //提交订单
                        if (faceCt > 0) {
                          //有剩余免费次数
                          text += '(${tr('aijrsy')}$faceCt${tr('ci')})';
                        } else {
                          text += '($faceCoins${tr('jb')}/${tr('ci')})';
                        }
                        return Text(
                          text,
                          style: MyTheme.white16medium,
                        );
                      }),
                    ),
                  ),
                )
              ],
            ),
          ),
          Positioned(
              //关闭按钮
              top: 13.w,
              right: 0.w,
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                child: MyImage.asset(
                  MyImagePaths.appCircleClose,
                  width: 25.w,
                  height: 25.w,
                  fit: BoxFit.contain,
                ),
                onTap: () {
                  context.pop();
                },
              )),
        ],
      ),
    );
  }

  //提交订单
  _postTakeOff() {
    if (imgMap.isEmpty) {
      CommonUtils.showDialog(
        context: context,
        builder: (context) => RegularDialog(
          buttonText: 'qd'.tr(),
          title: 'ts'.tr(),
          content: Text(
            'qxztp'.tr(),
            style: MyTheme.white255_15,
          ),
          confirmOnTap: () {
            context.pop();
          },
        ),
      );
      return;
    }

    Member? user = userNotifier.member;
    final userCoins = user.money; //用户剩余金币
    final faceCt = user.faceCt ?? 0; //当日剩余次数
    final needCoins = homeConfigNotifier.config.faceCoins ?? 0; //处理一张图片所需金币

    if (faceCt > 0) {
      //有剩余次数-直接提交订单
      _faceSwapOptonal(0, faceCt);
    } else {
      //直接使用金币
      if (userCoins >= needCoins) {
        //余额充足-直接提交订单
        _faceSwapOptonal(needCoins, faceCt);
      } else {
        //余额不足，提示金币不足
        CommonUtils.showDialog(
          context: context,
          builder: (context) => RegularDialog(
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
                    style: MyTheme.bloodOrange2557710_14,
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

  //素材换脸接口操作
  Future<void> _faceSwapOptonal(int needCoins, int faceCt) async {
    MyToast.showLoading(text: tr('aiscz'));
    final aiDomain = context.read<AIDomain>();
    final res = await aiDomain.aIChangeFace(
        id: widget.data.id ?? 0,
        thumb: imgMap['url'],
        thumbH: imgMap['thumb_height'],
        thumbW: imgMap['thumb_width']);
    MyToast.closeAllLoading();
    if (res.isValid) {
      if (needCoins == 0) {
        //使用剩余次数不需要金币时更新用户剩余次数
        userNotifier.setFaceCt(faceCt: faceCt - 1);
      } else {
        userNotifier.setMoney(
            money: userNotifier.member.money - needCoins); //更新用户的金币数量
      }

      if (mounted) {
        setState(() {
          imgMap = {}; //清空图片数据，可重新选择上传图片
        });
      }
      _showSuccesDialog();
    } else {
      MyToast.showText(text: res.msg ?? '');
    }
  }

  void _showSuccesDialog() {
    CommonUtils.showDialog(
      context: context,
      builder: (context) => RegularDialog(
        buttonText: 'gb'.tr(),
        title: 'ts'.tr(),
        content: Text(
          textAlign: TextAlign.center,
          tr('tjcgck'),
          style: MyTheme.white255_15,
          maxLines: 6,
        ),
        confirmOnTap: () {
          context.pop();
        },
      ),
    );
  }

  void _showImagePicker() {
    _imagePickerAssets();
  }

  Future<void> _imagePickerAssets() async {
    final XFile? file = await _picker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      bool flag = await CommonUtils.pngLimit2MSize(file);
      if (flag) return;
      uploadFileImg(file);
    }
  }

  //选择图片成功先生成服务器
  void uploadFileImg(XFile xFile) async {
    MyToast.showLoading(text: 'scz'.tr());
    final result = await homeConfigNotifier.uploadImage(xFile);

    developer.log('AI-换脸：图片上传返回数据：$result');

    if (result != null && result['code'] == 1) {
      final url = "${result['msg']}";

      final image = await decodeImageFromList(await xFile.readAsBytes());

      imgMap = {
        'url': url,
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
