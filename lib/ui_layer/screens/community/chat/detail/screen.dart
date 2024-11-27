import 'package:bot_toast/bot_toast.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swiper_null_safety_flutter3/flutter_swiper_null_safety_flutter3.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../../domain/api_validator.dart';
import '../../../../../domain/domain.dart';
import '../../../../../domain/model/chat/chat_detail_model.dart';
import '../../../../../domain/model/common_media_model.dart';
import '../../../../../domain/model/girl/girl_detail_model.dart';
import '../../../../../domain/model/member_model.dart';
import '../../../../../domain/model/post/post_media_model.dart';
import '../../../../../domain/type_def.dart';
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

class ChatDetailScreen extends StatefulWidget {
  const ChatDetailScreen({super.key, required this.id});

  final int id;
  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen>
    with WidgetsBindingObserver {
  late final _domain = context.read<ChatDomain>();
  late final _userNotifier = context.read<UserNotifier>();

  // AsyncValue<ChatDetailModel> _asyncValue = const AsyncInit();

  bool isHud = true;
  bool netError = false;
  bool noMore = false;

  bool isReplay = false;
  String commid = "0";
  String tip = 'wyddxf'.tr();
  int _selectedIndex = 0;

  int page = 1;
  String last_ix = "0";

  late ChatInfoModel data;
  List<CommonMediaModel> _medias = [];
  String _tip = '';

  Map picMap = {};

  void getData() async {
    final result = await _domain.chatDetail(id: widget.id);
    isHud = false;

    if (result.data?.chat case final girlData when girlData != null) {
      data = girlData;
      _medias = girlData.medias ?? [];

      _tip = result.data?.tip ?? '';

      netError = false;
      if (mounted) setState(() {});
    } else {
      netError = true;
      if (mounted) setState(() {});
    }
  }

  //收藏
  void postCollectData() async {
    final result = await _domain.chatFavorite(id: widget.id);

    if (result.status == 1) {
      data.isFavorite = data.isFavorite == 0 ? 1 : 0;
      int favoriteFct = data.favoriteFct ?? 0;
      favoriteFct += data.isFavorite == 1 ? 1 : -1;
      if (favoriteFct < 0) {
        favoriteFct = 0;
      }
      data.favoriteFct = favoriteFct;
      setState(() {});
    } else {
      MyToast.showText(text: result.msg ?? '');
    }
  }

  //购买
  void buyChat() async {
    final userNotifier = context.read<UserNotifier>();

    Member? user = userNotifier.member;
    final userCoins = user.money; //用户剩余金币

    bool isInsufficient = userCoins < data.coins!;

    // isInsufficient = false;
    MyDialog.showDialog(
      context: context,
      child: RegularDialog(
        buttonText: isInsufficient ? tr('qwcz') : tr('gmgk'),
        cancelText: 'qx'.tr(),
        title: 'ts'.tr(),
        content: Column(
          children: [
            RichText(
                textAlign: TextAlign.center,
                text: TextSpan(children: [
                  TextSpan(
                    text: '${data.coins}' + 'jbjs'.tr(),
                    style: MyTheme.white255_15,
                  ),
                ])),
            Text('ktvpzk'.tr() + "：$userCoins", style: MyTheme.white255_15),
          ],
        ),
        confirmOnTap: () {
          //前往充值
          context.pop();

          if (isInsufficient) {
            const CoinRechargeRoute().push(context);
          } else {
            reqChatBuy(userCoins - data.coins!);
          }
        },
        cancelOnTap: () {
          //取消
          context.pop();
        },
      ),
    );
  }

  reqChatBuy(int money) async {
    final result = await _domain.chatBuy(id: widget.id);

    if (result.status == 1) {
      data.contact = result.data['contact'];

      _userNotifier.setMoney(money: money);

      setState(() {});
    } else {
      MyToast.showText(text: result.msg ?? '');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getData();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement pageBody
    double width = ScreenUtil().screenWidth - MyTheme.pagePadding * 2;
    return Stack(
      children: [
        Scaffold(
          // appBar: MyAppBar(
          //     // title: 'fbyp'.tr(context: context),
          //     ),
          body: netError
              ? NetworkErrorView(
                  text: 'wlcw'.tr(),
                  onTap: getData,
                )
              : isHud
                  ? const LoadingView()
                  : SingleChildScrollView(
                      // padding:
                      //     EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 320.w,
                            child: Stack(
                              children: [
                                Swiper(
                                  itemCount: _medias.length,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                        onTap: () {
                                          if (_medias[index].mediaType != 1) {
                                            return;
                                          }

                                          List<PostMediaModel> pics = [];
                                          for (var element in _medias) {
                                            if (element.mediaType == 1) {
                                              pics.add(PostMediaModel.fromJson({
                                                'media_url': element.mediaUrl
                                              }));
                                            }
                                          }

                                          Map pPicMap = Map.from(picMap);
                                          pPicMap['resources'] = pics;

                                          int jumpIndex = 0;
                                          for (var i = 0;
                                              i < pics.length;
                                              i++) {
                                            if (pics[i].mediaUrl ==
                                                _medias[index].mediaUrl) {
                                              jumpIndex = i;
                                              break;
                                            }
                                          }
                                          pPicMap['index'] = jumpIndex;

                                          MediaViewerRoute({
                                            'resources': pics,
                                            'index': jumpIndex
                                          }).push(context);
                                        },
                                        child: MyImage.network(
                                            _medias[index].mediaCover ?? '')
                                        //   NetImageTool(
                                        //   url: Utils.getPICURL(_medias[index]),
                                        // ),
                                        );
                                  },
                                  onIndexChanged: (index) {
                                    _selectedIndex = index;
                                    setState(() {});
                                  },
                                ),
                                Positioned(
                                  right: 10.w,
                                  bottom: 10.w,
                                  child: Container(
                                    width: 55.w,
                                    height: 25.w,
                                    decoration: BoxDecoration(
                                        color:
                                            MyTheme.blackColor.withOpacity(0.5),
                                        borderRadius:
                                            BorderRadius.circular(12.5.w)),
                                    child: Center(
                                      child: Text(
                                        "${_selectedIndex + 1} / ${_medias.length}",
                                        style: MyTheme.white16,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: MyTheme.pagePadding),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(top: 16.w),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '${data.name}',
                                        style: MyTheme.white20semi,
                                      ),
                                      Row(
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              const MineShareToUserRoute()
                                                  .push(context);
                                            },
                                            child: MyImage.asset(
                                              MyImagePaths.appChatShare,
                                              width: 25.w,
                                              height: 25.w,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 5.w,
                                          ),
                                          GestureDetector(
                                            behavior:
                                                HitTestBehavior.translucent,
                                            onTap: postCollectData,
                                            child: Row(
                                              children: [
                                                MyImage.asset(
                                                  data.isFavorite == 1
                                                      ? MyImagePaths
                                                          .appChatCollectS
                                                      : MyImagePaths
                                                          .appChatCllectN,
                                                  width: 25.w,
                                                  height: 25.w,
                                                ),
                                                SizedBox(
                                                  width: 2.w,
                                                ),
                                                Text(
                                                  CommonUtils.renderFixedNumber(
                                                      data.favoriteFct ?? 0),
                                                  style: MyTheme.white16,
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 10.w,
                                ),

                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      (data.payFct.toString()) + 'rlg'.tr(),
                                      style: MyTheme.white06_14_M,
                                      maxLines: 99,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10.w,
                                ),
                                Text(
                                  _tip,
                                  maxLines: 1000,
                                  style: MyTheme.orange247_12,
                                ),

                                //                               "tdzl": "她的资料",
                                // "grzl": "个人资料",
                                // "xfqk": "消费情况",
                                // "fwxm": "服务项目",
                                // "jiesao": "介绍",
                                // "lxfs": "联系方式",
                                // "lxfsys": "联系方式：已隐藏，需要a金币解锁",
                                SizedBox(
                                  height: 10.w,
                                ),
                                Text(
                                  'tdzl'.tr(),
                                  style: MyTheme.white16medium,
                                ),
                                SizedBox(
                                  height: 10.w,
                                ),
                                Text(
                                  'grzl'.tr() +
                                      ": " +
                                      '${data.age}' +
                                      'sold'.tr() +
                                      '/' +
                                      '${data.cup}' +
                                      'bzcup'.tr() +
                                      '/' +
                                      '${data.weight}' +
                                      'k'.tr() +
                                      '/' +
                                      '${data.height}' +
                                      'c'.tr(),
                                  style: MyTheme.white06_12,
                                ),
                                SizedBox(
                                  height: 10.w,
                                ),
                                Text(
                                  'xfqk'.tr() + ": " + '${data.price}',
                                  style: MyTheme.white06_12,
                                ),
                                SizedBox(
                                  height: 10.w,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'fwsj'.tr() + ": " + '${data.time}',
                                      style: MyTheme.white06_12,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10.w,
                                ),

                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'fwxm'.tr() + ": ",
                                      style: MyTheme.white06_12,
                                    ),
                                    Expanded(
                                      child: Text('${data.option}',
                                          style: MyTheme.white06_12,
                                          maxLines: 99),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10.w,
                                ),

                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'jiesao'.tr() + ": ",
                                      style: MyTheme.white06_12,
                                    ),
                                    Expanded(
                                      child: Text('${data.price}',
                                          style: MyTheme.white06_12,
                                          maxLines: 99),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10.w,
                                ),
                                '${data.contact}'.isEmpty
                                    ? Text(
                                        data.type == 1 // 0： 免费 1:VIP 2:金币
                                            ? 'lxfsysvip'.tr()
                                            : 'lxfsys'.tr().replaceAll(
                                                'a', '${data.coins}'),
                                        style: MyTheme.orange247_12,
                                      )
                                    : RichText(
                                        maxLines: 999,
                                        text: TextSpan(children: [
                                          TextSpan(
                                            text: 'lxfs'.tr() +
                                                ": " +
                                                '${data.contact}',
                                            style: MyTheme.jellyCyan_12,
                                          ),
                                          WidgetSpan(
                                              child: GestureDetector(
                                            behavior:
                                                HitTestBehavior.translucent,
                                            onTap: () {
                                              // uploadData();
                                              Clipboard.setData(ClipboardData(
                                                  text: '${data.contact}'));

                                              MyToast.showText(
                                                  text: 'yfz'.tr());
                                            },
                                            child: Container(
                                              margin: EdgeInsets.symmetric(
                                                  horizontal:
                                                      MyTheme.pagePadding),
                                              // height: 15.w,
                                              width: 31.w,
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                  color: MyTheme.jellyCyanColor,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          7.5.w)),
                                              child: Text(
                                                'fuz'.tr(),
                                                style: MyTheme.white255_10,
                                              ),
                                            ),
                                          ))
                                        ])),
                                SizedBox(
                                  height: 10.w,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 40.w,
                          ),
                          '${data.contact}'.isNotEmpty
                              ? Container()
                              : Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: MyTheme.pagePadding,
                                      vertical: 20.h),
                                  child: MyButton.gradient(
                                    minimumSize: Size.fromHeight(40.w),
                                    onPressed: () async {
                                      // uploadData();
                                      buyChat();
                                    },
                                    borderRadius: 8,
                                    text: data.type == 1 // 0： 免费 1:VIP 2:金币
                                        ? 'vmfjs'.tr()
                                        : '${data.coins}' + 'jbjs'.tr(),
                                  ),
                                ),
                        ],
                      ),
                    ),
        ),
        // Utils.createNav(
        //     navColor: Colors.transparent,
        //     left: GestureDetector(
        //       child: Container(
        //         alignment: Alignment.centerLeft,
        //         width: 40.w,
        //         height: 40.w,
        //         child: LocalPNG(
        //           name: 'app_nav_back_w',
        //           width: 17.w,
        //           height: 17.w,
        //           fit: BoxFit.contain,
        //         ),
        //       ),
        //       behavior: HitTestBehavior.translucent,
        //       onTap: () {
        //         // finish();
        //       },
        //     )),
        const MyAppBar(),
      ],
    );
  }
}
