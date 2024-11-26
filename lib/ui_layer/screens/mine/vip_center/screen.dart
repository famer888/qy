import 'package:bot_toast/bot_toast.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../domain/api_validator.dart';
import '../../../../domain/async_value.dart';
import '../../../../domain/domain.dart';
import '../../../../domain/enum.dart';
import '../../../../domain/model/mine/vip/exp_of_vip_model.dart';
import '../../../../domain/model/product_vip_coin_model.dart';
import '../../../../domain/model/vip_upgrade_model.dart';
import '../../../../domain/type_def.dart';
import '../../../notifiers/user_notifier.dart';
import '../../../router/routes.dart';
import '../../../utils/my_toast.dart';
import '../../common_widgets/fixed_buy_button.dart';
import '../../common_widgets/keep_alive_wrapper.dart';
import '../../common_widgets/localization_text.dart';
import '../../common_widgets/member_vip.dart';
import '../../common_widgets/my_app_bar.dart';
import '../../common_widgets/my_avatar.dart';
import '../../common_widgets/my_image.dart';
import '../../common_widgets/my_tab_bar.dart';
import '../../common_widgets/screen_background.dart';
import '../../common_widgets/status/loading.dart';
import '../../common_widgets/status/network_error.dart';
import '../../image_paths.dart';
import '../../theme.dart';

class VipCenterScreen extends StatefulWidget {
  const VipCenterScreen({super.key, this.index = 0, this.isUpgrade = false});

  final int index;
  final bool isUpgrade;

  @override
  State<VipCenterScreen> createState() => _VipCenterScreenState();
}

class _VipCenterScreenState extends State<VipCenterScreen> {
  @override
  Widget build(BuildContext context) {
    return ScreenBackground(
      child: Scaffold(
        appBar: MyAppBar(
          title: 'hyzx'.tr(context: context),
          rightWidget: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () => RechargeRecordRoute(MyProductType.vip.id.toString())
                .push(context),
            child: Text(
              'czjl'.tr(context: context),
              style: MyTheme.gray150_14,
            ),
          ),
        ),
        body: widget.isUpgrade
            ? const _VipUpgradeBody()
            : _VipCenterBody(
                index: widget.index,
              ),
      ),
    );
  }
}

class _VipCenterBody extends StatefulWidget {
  const _VipCenterBody({super.key, required this.index});
  final int index;

  @override
  State<_VipCenterBody> createState() => _VipCenterBodyState();
}

class _VipCenterBodyState extends State<_VipCenterBody> {
  late final _orderDomain = context.read<OrderDomain>();
  late final _signDomain = context.read<SignDomain>();

  AsyncValue<(ProductOfVipOrCoin, ExpOfVIPListModel)> _asyncValue =
      const AsyncInit();

  @override
  void initState() {
    _init();
    super.initState();
  }

  Future<void> _init() async {
    if (_asyncValue.isLoading) return;

    setState(() {
      _asyncValue = const AsyncLoading();
    });

    final results = await Future.wait([
      _orderDomain.getProduct(type: MyProductType.vip),
      _signDomain.getExpOfVIP(),
    ]);

    setState(() {
      if (results[0].isValid && results[1].isValid) {
        _asyncValue = AsyncData((
          results[0].data as ProductOfVipOrCoin,
          results[1].data as ExpOfVIPListModel,
        ));
      } else {
        _asyncValue = const AsyncError();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return _asyncValue.maybeWhen(
      data: (value) {
        return Column(
          children: [
            const _UserInfoArea(),
            Expanded(
              child: TabBarWithView.line(
                initialIndex: widget.index,
                labelStyle: MyTheme.jellyCyan_15,
                unselectedLabelStyle: MyTheme.white15,
                tabBarPadding: EdgeInsets.symmetric(
                  vertical: MyTheme.pagePadding,
                ),
                tabBarHeight: 40.w,
                isCenter: true,
                titles: [
                  'khy'.tr(context: context),
                  'jfdhvip'.tr(context: context),
                ],
                views: [
                  KeepAliveWrapper(
                    child: _VipContent(
                      productOfVIP: value.$1,
                    ),
                  ),
                  KeepAliveWrapper(
                    child: _ExpContent(
                      expOfVIP: value.$2,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
      error: (_, __) => NetworkErrorView(onTap: _init),
      orElse: () => const LoadingView(),
    );
  }
}

class _VipUpgradeBody extends StatefulWidget {
  const _VipUpgradeBody({super.key});

  @override
  State<_VipUpgradeBody> createState() => _VipUpgradeBodyState();
}

class _VipUpgradeBodyState extends State<_VipUpgradeBody> {
  late final _domain = context.read<UserDomain>();

  AsyncValue<VipUpgradeModel> _asyncValue = const AsyncInit();

  @override
  void initState() {
    _init();
    super.initState();
  }

  Future<void> _init() async {
    if (_asyncValue.isLoading) return;

    setState(() {
      _asyncValue = const AsyncLoading();
    });

    final results = await _domain.userUpgradeGoods();

    setState(() {
      if (results.data case final data?) {
        _asyncValue = AsyncData(data);
      } else {
        _asyncValue = const AsyncError();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return _asyncValue.maybeWhen(
      data: (value) {
        return VipUpgradeContent(
          data: value,
        );
      },
      error: (_, __) => NetworkErrorView(
        onTap: _init,
      ),
      orElse: () => const LoadingView(),
    );
  }
}

class _VipContent extends StatefulWidget {
  const _VipContent({required this.productOfVIP});

  final ProductOfVipOrCoin productOfVIP;

  @override
  State<_VipContent> createState() => _VipContentState();
}

class _VipContentState extends State<_VipContent> {
  final productSelectedNotifier = ValueNotifier(0);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                _TitleHintText(
                  title: 'ktvpxs'.tr(context: context),
                  subTitle: 'zmzxs'.tr(context: context),
                ),
                SizedBox(height: 13.w),
                _ProductCardArea(
                  products: widget.productOfVIP.products,
                  selectedNotifier: productSelectedNotifier,
                  isUpgrade: false,
                ),
                SizedBox(height: 20.w),
                _DescriptionArea(
                  notifier: productSelectedNotifier,
                  products: widget.productOfVIP.products,
                ),
                LocalizationText(
                  'hytq',
                  style: MyTheme.white16medium,
                ),
                SizedBox(height: 10.w),
                _RightArea(
                  notifier: productSelectedNotifier,
                  products: widget.productOfVIP.products,
                ),
              ],
            ),
          ),
        ),
        FixedBuyButton(
          notifier: productSelectedNotifier,
          products: widget.productOfVIP.products,
          vipText: widget.productOfVIP.vipText,
        ),
      ],
    );
  }
}

class _ExpContent extends StatefulWidget {
  const _ExpContent({super.key, required this.expOfVIP});
  final ExpOfVIPListModel expOfVIP;
  @override
  State<_ExpContent> createState() => _ExpContentState();
}

class VipUpgradeContent extends StatefulWidget {
  const VipUpgradeContent({super.key, required this.data});
  final VipUpgradeModel data;

  @override
  State<VipUpgradeContent> createState() => _VipUpgradeContentState();
}

class _VipUpgradeContentState extends State<VipUpgradeContent> {
  final productSelectedNotifier = ValueNotifier(0);

  @override
  Widget build(BuildContext context) {
    final products = widget.data.goods;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10.w),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
                  child: Text(
                    '${'dqhy'.tr(context: context)}:${widget.data.payed?.pName}',
                    style: MyTheme.white16medium,
                  ),
                ),
                SizedBox(
                  height: 10.w,
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
                  child: Text(
                    'ksjz'.tr(context: context),
                    style: MyTheme.white16medium,
                  ),
                ),
                SizedBox(height: 13.w),
                _ProductCardArea(
                  products: products,
                  selectedNotifier: productSelectedNotifier,
                  isUpgrade: true,
                ),
                SizedBox(height: 20.w),
                _DescriptionArea(
                  notifier: productSelectedNotifier,
                  products: products,
                ),
                Center(
                  child: LocalizationText(
                    'hytq',
                    style: MyTheme.white16medium,
                  ),
                ),
                SizedBox(height: 10.w),
                _RightArea(
                  notifier: productSelectedNotifier,
                  products: products,
                ),
              ],
            ),
          ),
        ),
        FixedBuyButton(
          notifier: productSelectedNotifier,
          products: products,
          vipText: '',
          isUpgrade: true,
        ),
      ],
    );
  }
}

class _ExpContentState extends State<_ExpContent> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Selector<UserNotifier, int>(
          selector: (_, userNotifier) => userNotifier.member.exp ?? 0,
          builder: (BuildContext context, value, Widget? child) =>
              _TitleHintText(
            title: 'jfdh'.tr(context: context),
            subTitle: 'dqjf'.tr(context: context) + value.toString(),
          ),
        ),
        SizedBox(height: 13.w),
        Expanded(child: _ExpArea(expOfVipList: widget.expOfVIP.list)),
      ],
    );
  }
}

class _UserInfoArea extends StatelessWidget {
  const _UserInfoArea();

  @override
  Widget build(BuildContext context) {
    final member = context.watch<UserNotifier>().member;
    final expiredTime = member.expiredAt.toString().split(' ')[0];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
      child: Row(
        children: [
          MyAvatar(
            thumb: member.thumb,
            margin: 2,
            size: 67.w,
            gradient: const LinearGradient(
              colors: [Color(0xffdfab8f), Color(0xffcf8856)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          SizedBox(width: 13.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                        child:
                            Text(member.nickname, style: MyTheme.white255_14)),
                    SizedBox(width: 10.w),
                    MemberVipWidget(showText: member.vipStr),
                    if (member.vipUpgrade == 1)
                      Padding(
                        padding: EdgeInsets.only(left: 6.w),
                        child: GestureDetector(
                          onTap: () {
                            const VipUpgradeRoute().push(context);
                          },
                          child: const MyImage.asset(
                            MyImagePaths.appVipUpgrade,
                            width: 65,
                            height: 22,
                          ),
                        ),
                      )
                  ],
                ),
                SizedBox(height: 10.w),
                Row(
                  children: [
                    Text(
                      member.vipLevel < 2
                          ? 'khykp'.tr(context: context)
                          : '${'dqrq'.tr(context: context)} $expiredTime',
                      style: MyTheme.gray163_12,
                    ),
                    SizedBox(width: 5.w),
                    Text(
                      "${'syxzcs'.tr(context: context)}${member.videoDownloadValue}",
                      style: MyTheme.gray163_12,
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _TitleHintText extends StatelessWidget {
  const _TitleHintText({
    required this.title,
    required this.subTitle,
  });

  final String title;
  final String subTitle;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(color: Colors.white, fontSize: 15.sp),
          ),
          Text(
            subTitle,
            style: TextStyle(color: Colors.white, fontSize: 15.sp),
          )
        ],
      ),
    );
  }
}

class _ProductCardArea extends StatelessWidget {
  const _ProductCardArea({
    required this.products,
    required this.selectedNotifier,
    required this.isUpgrade,
  });

  final List<Product> products;
  final ValueNotifier selectedNotifier;
  final bool isUpgrade;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 130.w,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
        separatorBuilder: (context, index) => SizedBox(width: 15.w),
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: products.length,
        itemBuilder: (context, index) => GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () => selectedNotifier.value = index,
          child: ValueListenableBuilder(
            valueListenable: selectedNotifier,
            builder: (context, isSelected, child) {
              return _ProductItem(
                product: products[index],
                isSelected: isSelected == index,
                isUpgrade: isUpgrade,
              );
            },
          ),
        ),
      ),
    );
  }
}

class _ProductItem extends StatelessWidget {
  const _ProductItem({
    required this.product,
    required this.isSelected,
    required this.isUpgrade,
  });

  final Product product;
  final bool isSelected;
  final bool isUpgrade;

  @override
  Widget build(BuildContext context) {
    final promoPrice = product.promoPriceYuan.split('.').first;
    final price = '¥${product.priceYuan.split('.').first}';

    return Stack(
      children: [
        Column(
          children: [
            SizedBox(height: 8.w),
            Container(
              width: 114.w,
              height: 120.w,
              padding: EdgeInsets.symmetric(vertical: 10.w),
              decoration: BoxDecoration(
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xfff8c6a3)
                        : Colors.transparent,
                    width: 2.0,
                  ),
                  gradient: LinearGradient(
                    colors: isSelected
                        ? [const Color(0xff3d342b), const Color(0xff463c36)]
                        : [const Color(0xff272727), const Color(0xff323435)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(7)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    product.pName,
                    style: TextStyle(
                      fontSize: 18.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  isUpgrade
                      ? Text(
                          '${product.payCoins}${'jb'.tr(context: context)}',
                          style: TextStyle(
                            fontSize: 18.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          textBaseline: TextBaseline.alphabetic,
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          children: [
                            Text(
                              '¥',
                              style: TextStyle(
                                  fontSize: 18.sp,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              promoPrice,
                              style: TextStyle(
                                fontSize: 30.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                  Text(
                    price,
                    style: TextStyle(
                      fontSize: 15.sp,
                      color: const Color(0xfffbad7f),
                      decoration: TextDecoration.lineThrough,
                      decorationColor: const Color(0xfffbad7f),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
        if (product.giveTip.isNotEmpty)
          Positioned(
            top: 0,
            left: 0,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              height: 20.w,
              decoration: BoxDecoration(
                gradient: MyTheme.gradient_vip,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10.w),
                  bottomRight: Radius.circular(10.w),
                ),
              ),
              child: Center(
                child: Text(
                  product.giveTip,
                  style: TextStyle(
                    color: const Color(0xff331f15),
                    fontSize: 10.sp,
                    decoration: TextDecoration.none,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          )
      ],
    );
  }
}

class _DescriptionArea extends StatelessWidget {
  const _DescriptionArea({required this.notifier, required this.products});
  final ValueNotifier<int> notifier;
  final List<Product> products;
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: notifier,
        builder: (context, selectedIndex, child) {
          final productDesc = products[selectedIndex].description;
          if (productDesc.trim().isEmpty) return const SizedBox.shrink();
          final splitted = productDesc.split('#');
          return splitted.isEmpty
              ? const SizedBox.shrink()
              : Padding(
                  padding: EdgeInsets.only(bottom: 20.w),
                  child: Column(
                    children: splitted
                        .map((e) => Center(
                              child: Text(e, style: MyTheme.white14Medium),
                            ))
                        .toList(),
                  ),
                );
        });
  }
}

class _RightArea extends StatelessWidget {
  const _RightArea({
    required this.notifier,
    required this.products,
  });

  final ValueNotifier<int> notifier;
  final List<Product> products;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: notifier,
        builder: (context, selectedIndex, child) {
          return GridView.builder(
            padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
            shrinkWrap: true,
            itemCount: products[selectedIndex].rights.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 160 / 43,
              crossAxisSpacing: 10.w,
              mainAxisSpacing: 10.w,
            ),
            primary: false,
            itemBuilder: (context, index) => _RightItem(
              logo: products[selectedIndex].rights[index].img,
              title: products[selectedIndex].rights[index].name,
              subTitle: products[selectedIndex].rights[index].desc,
            ),
          );
        });
  }
}

class _RightItem extends StatelessWidget {
  const _RightItem({
    required this.title,
    required this.subTitle,
    required this.logo,
  });
  final String title;
  final String subTitle;
  final String logo;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          EdgeInsets.symmetric(vertical: 6.w, horizontal: MyTheme.pagePadding),
      decoration: BoxDecoration(
        color: MyTheme.white008Color,
        borderRadius: BorderRadius.circular(5.w),
      ),
      child: Row(
        children: [
          SizedBox(
              width: 30.w,
              height: 30.w,
              child: MyImage.network(
                logo,
                fit: BoxFit.fill,
              )),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    child: Text(
                      title,
                      style: MyTheme.white12,
                      maxLines: 1,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    child: Text(
                      subTitle,
                      style: MyTheme.white06_10,
                      maxLines: 1,
                      textAlign: TextAlign.center,
                    ),
                  )
                ]),
          )
        ],
      ),
    );
  }
}

class _ExpArea extends StatelessWidget {
  const _ExpArea({
    required this.expOfVipList,
  });

  final List<ExpOfVIPModel> expOfVipList;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
      separatorBuilder: (_, __) => SizedBox(width: 15.w),
      physics: const BouncingScrollPhysics(),
      itemCount: expOfVipList.length,
      itemBuilder: (context, index) => _ExpItem(exp: expOfVipList[index]),
    );
  }
}

class _ExpItem extends StatefulWidget {
  final ExpOfVIPModel exp;
  const _ExpItem({
    required this.exp,
  });

  @override
  State<_ExpItem> createState() => _ExpItemState();
}

class _ExpItemState extends State<_ExpItem> {
  late final signDomain = context.read<SignDomain>();
  late final userNotifier = context.read<UserNotifier>();

  Future<void> _sendExpCoverVIP() async {
    if (userNotifier.member.exp != 0) {
      MyToast.showLoading(text: 'gmdd'.tr(context: context));
      final result = await signDomain.expConvertVIP(id: widget.exp.id);
      BotToast.closeAllLoading();
      if (result.status == 1) {
        await userNotifier.init();
        if (mounted) {
          context.pop();
        }
      }
      MyToast.showText(text: result.msg ?? '');
    } else {
      MyToast.showText(text: 'jfyebz'.tr(context: context));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: MyTheme.gradient_vip,
        borderRadius: BorderRadius.circular(5.w),
      ),
      margin: EdgeInsets.only(bottom: MyTheme.pagePadding),
      padding: EdgeInsets.all(MyTheme.pagePadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.exp.vipStr,
            style: TextStyle(
              color: const Color(0xff3e1700),
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            widget.exp.expStr,
            style: TextStyle(
              color: const Color(0xff3e1700),
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: _sendExpCoverVIP,
            child: Container(
              height: 34.w,
              width: 92.w,
              decoration: BoxDecoration(
                color: const Color(0xff282828),
                borderRadius: BorderRadius.all(Radius.circular(17.w)),
              ),
              child: Center(
                child: RichText(
                  text: TextSpan(
                    text: 'dh'.tr(context: context),
                    style: TextStyle(
                      color: Color(0xfff7b489),
                      fontSize: 14.sp,
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
