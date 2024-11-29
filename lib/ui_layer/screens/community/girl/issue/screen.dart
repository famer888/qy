import 'dart:convert';

import 'package:bot_toast/bot_toast.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../../../../domain/api_validator.dart';
import '../../../../../domain/domain.dart';
import '../../../../../domain/model/girl/girl_option_model.dart';
import '../../../../../domain/type_def.dart';
import '../../../../notifiers/home_config_notifier.dart';
import '../../../../router/routes.dart';
import '../../../../utils/common_utils.dart';
import '../../../common_widgets/dialog/my_dialog.dart';
import '../../../common_widgets/dialog/widgets/regular_dialog.dart';
import '../../../common_widgets/my_app_bar.dart';
import '../../../common_widgets/my_button.dart';
import '../../../image_paths.dart';

import '../../../../../domain/async_value.dart';
import '../../../../../domain/enum.dart';
import '../../../../../domain/model/review_data_model.dart';
import '../../../../../domain/model/topic_detail_model.dart';
import '../../../../../domain/model/user_model.dart';
import '../../../../notifiers/user_notifier.dart';
import '../../../../utils/my_toast.dart';
import '../../../common_widgets/follow_button.dart';
import '../../../common_widgets/my_image.dart';
import '../../../common_widgets/my_list_view.dart';
import '../../../common_widgets/post/comment.dart';
import '../../../common_widgets/post/comment_input.dart';
import '../../../common_widgets/post/replies_sheet_view.dart';
import '../../../common_widgets/screen_background.dart';
import '../../../common_widgets/status/loading.dart';
import '../../../common_widgets/status/network_error.dart';
import '../../../theme.dart';
import '../../detail/content.dart';

class GirlIssueScreen extends StatefulWidget {
  const GirlIssueScreen({super.key});

  @override
  State<GirlIssueScreen> createState() => _GirlIssueScreenState();
}

class _GirlIssueScreenState extends State<GirlIssueScreen> {
  late final _domain = context.read<GirlDomain>();
  late final _homeConfigNotifier = context.read<HomeConfigNotifier>();

  bool isHud = true;
  bool netError = false;
  final ImagePicker picker = ImagePicker();

  int picLimit = 6;
  List<Map> upList = [];

  List<GirlOptionItemModel> classes = [];
  GirlOptionItemModel? girlClass;

  List<GirlOptionItemModel> tags = [];
  GirlOptionItemModel? girlTag;

  String girlName = '';
  String girlAge = '';
  String girlHeight = '';
  String girlWeight = '';
  String girlCup = '';
  String girlPrice = '';
  String girlTime = '';
  String girlOption = '';
  String girlIntro = '';
  String girlContact = '';

  getOptionData() async {
    final result = await _domain.getOptions();

    if (result.status == 1) {
      if (result.data case final options? when options.isNotEmpty) {
// GirlOptionModel

        for (var element in options) {
          if (element.value == 'class') {
            classes = List.from(element.items ?? []);
          }
        }

        for (var element in options) {
          if (element.value == 'tag') {
            tags = List.from(element.items ?? []);
          }
        }

        isHud = false;
        if (mounted) setState(() {});
      }
    } else {
      MyToast.showText(text: result.msg ?? '');
    }
  }

  showTags(BuildContext ctx) {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: ctx,
        builder: (context) {
          return Container(
            color: MyTheme.bgColor,
            padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
            // height: 200.w,\
            constraints: BoxConstraints(minHeight: 100.w, maxHeight: 300.w),
            child: Column(
              children: [
                SizedBox(
                  height: 40.w,
                  child: Row(
                    children: [
                      Spacer(),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(ctx).pop();
                        },
                        child: Icon(
                          Icons.close,
                          size: 25.w,
                          color: MyTheme.white08Color,
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 10.w,
                ),
                Wrap(
                    runSpacing: 5.w,
                    spacing: 5.w,
                    children: tags
                        .map((e) => GestureDetector(
                              onTap: () {
                                girlTag = e;
                                setState(() {});
                                Navigator.of(ctx).pop();
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10.w, vertical: 5.w),
                                decoration: BoxDecoration(
                                    color: MyTheme.whiteColor.withOpacity(0.05),
                                    borderRadius: BorderRadius.circular(5.w)),
                                child: Text(
                                  '${e.name}',
                                  style: MyTheme.white08_14,
                                ),
                              ),
                            ))
                        .toList()),
                SizedBox(
                    // height: MyTheme.bottom + 20.w,
                    )
              ],
            ),
          );
        });
  }

  showClass(BuildContext ctx) {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: ctx,
        builder: (context) {
          return Container(
            color: MyTheme.bgColor,
            padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
            // height: 200.w,\
            constraints: BoxConstraints(minHeight: 100.w, maxHeight: 300.w),
            child: Column(
              children: [
                SizedBox(
                  height: 40.w,
                  child: Row(
                    children: [
                      Spacer(),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(ctx).pop();
                        },
                        child: Icon(
                          Icons.close,
                          size: 25.w,
                          color: MyTheme.white08Color,
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 10.w,
                ),
                Wrap(
                    runSpacing: 5.w,
                    spacing: 5.w,
                    children: classes
                        .map((e) => GestureDetector(
                              onTap: () {
                                girlClass = e;
                                setState(() {});
                                Navigator.of(ctx).pop();
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10.w, vertical: 5.w),
                                decoration: BoxDecoration(
                                    color: MyTheme.whiteColor.withOpacity(0.05),
                                    borderRadius: BorderRadius.circular(5.w)),
                                child: Text(
                                  '${e.name}',
                                  style: MyTheme.white08_14,
                                ),
                              ),
                            ))
                        .toList()),
                SizedBox(
                    // height: MyTheme.bottom + 20.w,
                    )
              ],
            ),
          );
        });
  }

  Future<void> imagePickerAssets() async {
    if (await CommonUtils.pickImage() case final xFile?) {
      MyToast.showLoading(text: 'scz'.tr());
      final result = await _homeConfigNotifier.uploadImage(xFile);
      if (result != null && result['code'] == 1) {
        final url = "${result['msg']}";

        final image = await decodeImageFromList(await xFile.readAsBytes());

        upList.add({
          'media_url': url,
          'url': _homeConfigNotifier.config.imgBase + url,
          'thumb_width': image.width,
          'thumb_height': image.height,
        });
        if (mounted) {
          setState(() {});
        }
      } else {
        MyToast.showText(text: result?['msg'] ?? 'failed');
      }
      MyToast.closeAllLoading();
    }
  }

  void uploadData() async {
    if (girlClass == null ||
        girlTag == null ||
        girlName.isEmpty ||
        girlAge.isEmpty ||
        girlHeight.isEmpty ||
        girlWeight.isEmpty ||
        girlCup.isEmpty ||
        girlPrice.isEmpty ||
        girlTime.isEmpty ||
        girlOption.isEmpty ||
        girlIntro.isEmpty ||
        girlContact.isEmpty) {
      MyToast.showText(text: "qs".tr());
      return;
    }
    if (upList.isEmpty) {
      MyToast.showText(text: "qsctp".tr());

      return;
    }

    List media = [];
    for (var element in upList) {
      media.add({
        'cover': element['media_url'],
        "uri": element['media_url'],
        "width": element['thumb_width'],
        "height": element['thumb_height'],
        "type": "img",
      });
    }

    MyToast.showLoading();

    final result = await _domain.girlCreate(allInfo: {
      "title": girlName,
      "class": girlClass?.value,
      "tag": girlTag?.value,
      "price": girlPrice,
      "age": girlAge,
      "height": girlHeight,
      "weight": girlWeight,
      "cup": girlCup,
      "serv": girlOption,
      "time": girlTime,
      "contact": girlContact,
      "intro": girlIntro,
      "medias": json.encode(media),
    });

    if (result.status == 1) {
      MyDialog.showDialog(
        context: context,
        child: RegularDialog(
          buttonText: 'qr'.tr(),
          cancelText: 'qx'.tr(),
          title: 'ts'.tr(),
          content: Text(
            result.msg ?? '',
            style: MyTheme.gray153_13,
            maxLines: 10,
          ),
          confirmOnTap: () {
            context.pop();
          },
          cancelOnTap: () {
            //取消
            context.pop();
          },
        ),
      );
    } else {
      MyDialog.showDialog(
        context: context,
        child: RegularDialog(
          buttonText: 'qr'.tr(),
          cancelText: 'qx'.tr(),
          title: 'ts'.tr(),
          content: Text(
            result.msg ?? '',
            style: MyTheme.gray153_13,
            maxLines: 10,
          ),
          confirmOnTap: () {
            context.pop();
            FocusScope.of(context).unfocus();
          },
          cancelOnTap: () {
            //取消

            context.pop();
            FocusScope.of(context).unfocus();
          },
        ),
      );
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getOptionData();
  }

  // @override
  // void onCreate() {
  //   setAppTitle(
  //       titleW: Text('fbyp'), style: MyTheme.nav_title_font));
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: 'fbyp'.tr(context: context),
      ),
      body: netError
          ? NetworkErrorView(
              text: 'wlcw'.tr(),
              onTap: getOptionData,
            )
          : isHud
              ? const LoadingView()
              : Container(
                  color: MyTheme.bgColor,
                  padding:
                      EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      FocusScope.of(context).unfocus();
                    },
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                '*',
                                style: TextStyle(
                                    // fontFamily: hanyi,
                                    color: MyTheme.jellyCyanColor,
                                    fontSize: 15.sp,
                                    overflow: TextOverflow.ellipsis,
                                    fontWeight: FontWeight.w500,
                                    decoration: TextDecoration.none,
                                    height: 2),
                              ),
                              SizedBox(
                                width: 5.w,
                              ),
                              Text(
                                'bt'.tr() + ':',
                                style: MyTheme.white255_15_semibold,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10.w,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 15.w),
                            decoration: BoxDecoration(
                                color: MyTheme.whiteColor.withOpacity(0.05),
                                borderRadius: BorderRadius.circular(4.w)),
                            child: TextField(
                              onChanged: (value) {
                                girlName = value;
                              },
                              style: MyTheme.white255_14,
                              cursorColor: MyTheme.whiteColor,
                              textInputAction: TextInputAction.done,
                              decoration: CommonUtils.customInputStyle(
                                  horizontal: 15.w, hit: 'zzlsrbtwz'.tr()),
                            ),
                          ),
                          SizedBox(
                            height: 10.w,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text('*',
                                  style: TextStyle(
                                      // fontFamily: hanyi,
                                      color: MyTheme.jellyCyanColor,
                                      fontSize: 15.sp,
                                      overflow: TextOverflow.ellipsis,
                                      fontWeight: FontWeight.w500,
                                      decoration: TextDecoration.none,
                                      height: 2)),
                              SizedBox(
                                width: 5.w,
                              ),
                              Text(
                                'tdzl'.tr() + ':',
                                style: MyTheme.white255_15_semibold,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10.w,
                          ),
                          Row(
                            children: [
                              Container(
                                width: 80.w,
                                child: Center(
                                  child: Text(
                                    'liex'.tr() + ':',
                                    style: MyTheme.white255_15_semibold,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: GestureDetector(
                                  behavior: HitTestBehavior.translucent,
                                  onTap: () {
                                    // CommonUtils.showDialog()
                                    showClass(context);
                                  },
                                  child: Container(
                                      height: 48.w,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 15.w),
                                      decoration: BoxDecoration(
                                          color: MyTheme.whiteColor
                                              .withOpacity(0.05),
                                          borderRadius:
                                              BorderRadius.circular(4.w)),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            girlClass == null
                                                ? 'qxzyx'.tr()
                                                : '${girlClass?.name}',
                                            style: girlClass == null
                                                ? MyTheme.white04_14
                                                : MyTheme.white255_14,
                                          ),
                                        ],
                                      )),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10.w,
                          ),
                          Row(
                            children: [
                              Container(
                                width: 80.w,
                                child: Center(
                                  child: Text(
                                    'bqian'.tr() + ':',
                                    style: MyTheme.white255_15_semibold,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: GestureDetector(
                                  behavior: HitTestBehavior.translucent,
                                  onTap: () {
                                    // CommonUtils.showDialog()
                                    showTags(context);
                                  },
                                  child: Container(
                                      height: 48.w,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 15.w),
                                      decoration: BoxDecoration(
                                          color: MyTheme.whiteColor
                                              .withOpacity(0.05),
                                          borderRadius:
                                              BorderRadius.circular(4.w)),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            girlTag == null
                                                ? 'qxzbq'.tr()
                                                : '${girlTag?.name}',
                                            style: girlTag == null
                                                ? MyTheme.white04_14
                                                : MyTheme.white255_14,
                                          ),
                                        ],
                                      )),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10.w,
                          ),
                          Row(
                            children: [
                              Container(
                                width: 80.w,
                                child: Center(
                                  child: Text(
                                    'nl'.tr() + ':',
                                    style: MyTheme.white255_15_semibold,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  height: 48.w,
                                  padding: EdgeInsets.symmetric(vertical: 15.w),
                                  decoration: BoxDecoration(
                                      color:
                                          MyTheme.whiteColor.withOpacity(0.05),
                                      borderRadius: BorderRadius.circular(4.w)),
                                  child: TextField(
                                    onChanged: (value) {
                                      girlAge = value;
                                    },
                                    style: MyTheme.white255_14,
                                    cursorColor: MyTheme.whiteColor,
                                    inputFormatters: [
                                      FilteringTextInputFormatter(
                                          RegExp("[0-9]"),
                                          allow: true),
                                      LengthLimitingTextInputFormatter(4),
                                    ],
                                    keyboardType: TextInputType.number,
                                    textInputAction: TextInputAction.done,
                                    decoration: CommonUtils.customInputStyle(
                                        horizontal: 15.w,
                                        hit: 'qsrnh'.tr() + 'nl'.tr()),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10.w),
                          Row(
                            children: [
                              Container(
                                width: 80.w,
                                child: Center(
                                  child: Text(
                                    'sg'.tr() + ':',
                                    style: MyTheme.white255_15_semibold,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 15.w),
                                  decoration: BoxDecoration(
                                      color:
                                          MyTheme.whiteColor.withOpacity(0.05),
                                      borderRadius: BorderRadius.circular(4.w)),
                                  child: TextField(
                                    onChanged: (value) {
                                      girlHeight = value;
                                    },
                                    style: MyTheme.white255_14,
                                    cursorColor: MyTheme.whiteColor,
                                    inputFormatters: [
                                      FilteringTextInputFormatter(
                                          RegExp("[0-9]"),
                                          allow: true),
                                      LengthLimitingTextInputFormatter(4),
                                    ],
                                    keyboardType: TextInputType.number,
                                    textInputAction: TextInputAction.done,
                                    decoration: CommonUtils.customInputStyle(
                                        horizontal: 15.w,
                                        hit: 'qsrnh'.tr() + 'sg'.tr() + ' cm'),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10.w),
                          Row(
                            children: [
                              Container(
                                width: 80.w,
                                child: Center(
                                  child: Text(
                                    'tz'.tr() + ':',
                                    style: MyTheme.white255_15_semibold,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 15.w),
                                  decoration: BoxDecoration(
                                      color:
                                          MyTheme.whiteColor.withOpacity(0.05),
                                      borderRadius: BorderRadius.circular(4.w)),
                                  child: TextField(
                                    onChanged: (value) {
                                      girlWeight = value;
                                    },
                                    style: MyTheme.white255_14,
                                    cursorColor: MyTheme.whiteColor,
                                    inputFormatters: [
                                      FilteringTextInputFormatter(
                                          RegExp("[0-9]"),
                                          allow: true),
                                      LengthLimitingTextInputFormatter(4),
                                    ],
                                    keyboardType: TextInputType.number,
                                    textInputAction: TextInputAction.done,
                                    decoration: CommonUtils.customInputStyle(
                                        horizontal: 15.w,
                                        hit: 'qsrnh'.tr() + 'tz'.tr() + ' kg'),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10.w),
                          Row(
                            children: [
                              Container(
                                width: 80.w,
                                child: Center(
                                  child: Text(
                                    'bzcup'.tr() + ':',
                                    style: MyTheme.white255_15_semibold,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 15.w),
                                  decoration: BoxDecoration(
                                      color:
                                          MyTheme.whiteColor.withOpacity(0.05),
                                      borderRadius: BorderRadius.circular(4.w)),
                                  child: TextField(
                                    onChanged: (value) {
                                      girlCup = value;
                                    },
                                    style: MyTheme.white255_14,
                                    cursorColor: MyTheme.whiteColor,
                                    textInputAction: TextInputAction.done,
                                    decoration: CommonUtils.customInputStyle(
                                        horizontal: 15.w,
                                        hit: 'qsrnh'.tr() + 'bzcup'.tr()),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10.w),
                          Row(
                            children: [
                              Container(
                                width: 80.w,
                                child: Center(
                                  child: Text(
                                    'fybz'.tr() + ':',
                                    style: MyTheme.white255_15_semibold,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 15.w),
                                  decoration: BoxDecoration(
                                      color:
                                          MyTheme.whiteColor.withOpacity(0.05),
                                      borderRadius: BorderRadius.circular(4.w)),
                                  child: TextField(
                                    onChanged: (value) {
                                      girlPrice = value;
                                    },
                                    style: MyTheme.white255_14,
                                    cursorColor: MyTheme.whiteColor,
                                    textInputAction: TextInputAction.done,
                                    decoration: CommonUtils.customInputStyle(
                                        horizontal: 15.w, hit: 'qsrfybz'.tr()),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10.w),
                          Row(
                            children: [
                              Container(
                                width: 80.w,
                                child: Center(
                                  child: Text(
                                    'fwsj'.tr() + ':',
                                    style: MyTheme.white255_15_semibold,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 15.w),
                                  decoration: BoxDecoration(
                                      color:
                                          MyTheme.whiteColor.withOpacity(0.05),
                                      borderRadius: BorderRadius.circular(4.w)),
                                  child: TextField(
                                    onChanged: (value) {
                                      girlTime = value;
                                    },
                                    style: MyTheme.white255_14,
                                    cursorColor: MyTheme.whiteColor,
                                    textInputAction: TextInputAction.done,
                                    decoration: CommonUtils.customInputStyle(
                                        horizontal: 15.w, hit: 'qsrfwsj'.tr()),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10.w),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 80.w,
                                child: Center(
                                  child: Text(
                                    'fwxm'.tr() + ':',
                                    style: MyTheme.white255_15_semibold,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: SizedBox(
                                  height: 150.w,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: MyTheme.whiteColor
                                            .withOpacity(0.05),
                                        borderRadius:
                                            BorderRadius.circular(4.w)),
                                    child: TextField(
                                      keyboardType: TextInputType.multiline,
                                      maxLines: 10,
                                      autofocus: false,
                                      onChanged: (value) {
                                        girlOption = value;
                                      },
                                      style: MyTheme.white255_14,
                                      cursorColor: MyTheme.whiteColor,
                                      textInputAction: TextInputAction.done,
                                      decoration: CommonUtils.customInputStyle(
                                        horizontal: 15.w,
                                        hit: 'qsrfwxm'.tr(),
                                        vertical: 8,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10.w),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 80.w,
                                child: Center(
                                  child: Text(
                                    'fwjs'.tr() + ':',
                                    style: MyTheme.white255_15_semibold,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: SizedBox(
                                  height: 150.w,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: MyTheme.whiteColor
                                            .withOpacity(0.05),
                                        borderRadius:
                                            BorderRadius.circular(4.w)),
                                    child: TextField(
                                      keyboardType: TextInputType.multiline,
                                      maxLines: 10,
                                      autofocus: false,
                                      onChanged: (value) {
                                        girlIntro = value;
                                      },
                                      style: MyTheme.white255_14,
                                      cursorColor: MyTheme.whiteColor,
                                      textInputAction: TextInputAction.done,
                                      decoration: CommonUtils.customInputStyle(
                                        horizontal: 15.w,
                                        hit: 'qsrfwjs'.tr(),
                                        vertical: 8,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10.w),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                '*',
                                style: TextStyle(
                                    // fontFamily: hanyi,
                                    color: MyTheme.jellyCyanColor,
                                    fontSize: 15.sp,
                                    overflow: TextOverflow.ellipsis,
                                    fontWeight: FontWeight.w500,
                                    decoration: TextDecoration.none,
                                    height: 2),
                              ),
                              SizedBox(
                                width: 5.w,
                              ),
                              Text(
                                'lxfs'.tr() + ':',
                                style: MyTheme.white255_15_semibold,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10.w,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 15.w),
                            decoration: BoxDecoration(
                                color: MyTheme.whiteColor.withOpacity(0.05),
                                borderRadius: BorderRadius.circular(4.w)),
                            child: TextField(
                              onChanged: (value) {
                                girlContact = value;
                              },
                              style: MyTheme.white255_14,
                              cursorColor: MyTheme.whiteColor,
                              textInputAction: TextInputAction.done,
                              decoration: CommonUtils.customInputStyle(
                                  horizontal: 15.w, hit: 'qsrlxfs'.tr()),
                            ),
                          ),
                          SizedBox(
                            height: 10.w,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                '*',
                                style: TextStyle(
                                    // fontFamily: hanyi,
                                    color: MyTheme.jellyCyanColor,
                                    fontSize: 15.sp,
                                    overflow: TextOverflow.ellipsis,
                                    fontWeight: FontWeight.w500,
                                    decoration: TextDecoration.none,
                                    height: 2),
                              ),
                              SizedBox(
                                width: 5.w,
                              ),
                              Text(
                                'sctp'.tr() + ':',
                                style: MyTheme.white255_15_semibold,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10.w,
                          ),
                          GridView.count(
                            padding: EdgeInsets.zero,
                            crossAxisCount: 3,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            mainAxisSpacing: 10.w,
                            crossAxisSpacing: 10.w,
                            children: upList.map((e) {
                              Widget w = Stack(
                                children: [
                                  Padding(
                                    padding:
                                        EdgeInsets.only(top: 9.w, right: 9.w),
                                    child: Container(
                                        width: double.infinity,
                                        height: double.infinity,
                                        clipBehavior: Clip.hardEdge,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5.w),
                                        ),
                                        child: MyImage.network(
                                          e["url"] ?? '',
                                          fit: BoxFit.contain,
                                        )),
                                  ),
                                  Positioned(
                                    top: 0,
                                    right: 0,
                                    child: GestureDetector(
                                      behavior: HitTestBehavior.translucent,
                                      onTap: () {
                                        upList.remove(e);
                                        if (mounted) setState(() {});
                                      },
                                      child: MyImage.asset(
                                        MyImagePaths.appPostDelete,
                                        width: 18.w,
                                        height: 18.w,
                                      ),
                                    ),
                                  )
                                ],
                              );
                              return w;
                            }).toList()
                              ..add(
                                upList.length == picLimit
                                    ? Container()
                                    : GestureDetector(
                                        onTap: imagePickerAssets,
                                        child: Stack(children: [
                                          Container(
                                            decoration: BoxDecoration(
                                                color: MyTheme.whiteColor005,
                                                borderRadius:
                                                    BorderRadius.circular(7.w)),
                                          ),
                                          Align(
                                              alignment: Alignment.center,
                                              child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    MyImage.asset(
                                                        MyImagePaths
                                                            .appGirlPicker,
                                                        width: 30.w,
                                                        height: 30.w),
                                                    SizedBox(height: 5.w),
                                                    Text('djsctp'.tr(),
                                                        style:
                                                            MyTheme.white08_12)
                                                  ]))
                                        ]),
                                      ),
                              ),
                          ),
                          SizedBox(
                            height: 10.w,
                          ),
                          Row(
                            children: [
                              Text(
                                'zuscazpbcgbm'
                                    .tr()
                                    .replaceAll('a', '$picLimit')
                                    .replaceAll('b', '2'),
                                style: MyTheme.white04_14,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 40.w,
                          ),
                          MyButton.gradient(
                            minimumSize: Size.fromHeight(40.w),
                            onPressed: () async {
                              uploadData();
                            },
                            borderRadius: 8,
                            text: 'ljfb'.tr(context: context),
                          ),
                          SizedBox(
                            height: 100.w,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
    );
  }
}
