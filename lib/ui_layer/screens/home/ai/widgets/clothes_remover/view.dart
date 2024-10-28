import 'package:cross_file/cross_file.dart';
import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../../../../domain/api_validator.dart';
import '../../../../../../domain/model/member_model.dart';
import '../../../../../../domain/remote_domain/domains/ai.dart';
import '../../../../../notifiers/home_config_notifier.dart';
import '../../../../../notifiers/user_notifier.dart';
import '../../../../../router/routes.dart';
import '../../../../../utils/common_utils.dart';
import '../../../../../utils/my_toast.dart';
import '../../../../common_widgets/dialog/widgets/regular_dialog.dart';
import '../../../../common_widgets/my_image.dart';
import '../../../../image_paths.dart';
import '../../../../theme.dart';

class ClothesRemoverView extends StatefulWidget {
  const ClothesRemoverView({super.key});

  @override
  State<ClothesRemoverView> createState() => _ClothesRemoverViewState();
}

class _ClothesRemoverViewState extends State<ClothesRemoverView> {
  String _aiRule = ''; //脱衣规则
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
    final coins = homeConfigNotifier.config.stripCoins ?? 0;
    final topHeight = 125.w;
    final contentW = 110.w;

    String imgUrl = '';
    if (imgMap.isNotEmpty) {
      imgUrl = imgMap['url'];
      imgUrl = imgUrl.substring(1); //删除第一个字符/
      imgUrl = homeConfigNotifier.config.imgBase + imgUrl;
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10.w),
            Text(
              '${tr('clyzzpfyw')}$coins${tr('jb')}', //处理一张照片费用为xx金币
              style: MyTheme.white08_14_M,
            ),
            SizedBox(height: 10.w),
            Container(
              height: topHeight,
              decoration: imgMap.isEmpty
                  ? DottedDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(4.w)),
                      shape: Shape.box,
                      color: MyTheme.cyanColor00edfd,
                      strokeWidth: 1.w)
                  : null,
              alignment: Alignment.center,
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  _showImagePicker();
                },
                child: imgMap.isEmpty
                    ? SizedBox(
                        height: topHeight,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            MyImage.asset(
                              MyImagePaths.appUploadImg,
                              width: 35.w,
                              height: 35.w,
                            ),
                            SizedBox(height: 5.w),
                            Text(
                              tr('djsctp'), //点击上传图片
                              style: MyTheme.white08_12,
                            ),
                            SizedBox(height: 5.w),
                            Text(
                              tr('tpdxbcg2mb'), //图片大小不超过2MB
                              style: MyTheme.white06_10,
                            )
                          ],
                        ),
                      )
                    : SizedBox(
                        width: contentW,
                        height: topHeight,
                        child: MyImage.network(
                          imgUrl,
                          borderRadius: 7.w,
                        ),
                      ),
              ),
            ),
            SizedBox(height: 20.w),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: _postTakeOff,
                    child: Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
                      // width: 345.w,
                      height: 50.w,
                      decoration: BoxDecoration(
                          gradient: MyTheme.gradient_90_114,
                          borderRadius: BorderRadius.circular(25.w)),
                      child: Center(
                        child: Builder(builder: (context) {
                          return _postStripOffBtnWidget(); //提交按钮组件
                        }),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 28.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
              ],
            ),
            SizedBox(height: 13.w),
            Container(
              height: 42.w,
              alignment: Alignment.centerLeft,
              child: Text(
                tr('shili'), //示例
                style: MyTheme.white15semibold,
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 5.w, bottom: MyTheme.pagePadding),
              child: MyImage.asset(
                MyImagePaths.appStripOff,
                width: 345.w,
                height: 200.w,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _postStripOffBtnWidget() {
    final stripCt = userNotifier.member.stripCt ?? 0;
    String text = tr('ljsc'); //立即生成
    if (stripCt > 0) {
      text += '(${tr('aijrsy')}$stripCt${tr('ci')})';
    }
    return Text(
      text,
      style: MyTheme.white16medium,
    );
  }

  //立即生成
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
    final stripCt = user.stripCt ?? 0; //当日剩余次数
    final needCoins = homeConfigNotifier.config.stripCoins ?? 0; //处理一张图片所需金币

    if (stripCt > 0) {
      //有剩余次数-直接生成
      _stripOffOptonal(0, stripCt);
    } else {
      //直接使用金币
      if (userCoins >= needCoins) {
        //余额充足-直接生成
        _stripOffOptonal(needCoins, stripCt);
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

  //脱衣接口操作
  Future<void> _stripOffOptonal(int needCoins, int stripCt) async {
    MyToast.showLoading(text: tr('aiscz'));
    final aiDomain = context.read<AIDomain>();
    final res = await aiDomain.aIStrip(
        thumb: imgMap['url'],
        thumbH: imgMap['thumb_height'],
        thumbW: imgMap['thumb_width']);
    MyToast.closeAllLoading();
    if (res.isValid) {
      if (needCoins == 0) {
        //使用剩余次数不需要金币时更新用户剩余次数
        userNotifier.setStripCt(stripCt: stripCt - 1);
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
