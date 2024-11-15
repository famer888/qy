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
import '../../../../domain/type_def.dart';
import '../../../notifiers/user_notifier.dart';
import '../../../router/routes.dart';
import '../../../utils/my_toast.dart';
import '../../common_widgets/fixed_buy_button.dart';
import '../../common_widgets/member_vip.dart';
import '../../common_widgets/my_app_bar.dart';
import '../../common_widgets/my_avatar.dart';
import '../../common_widgets/my_image.dart';
import '../../common_widgets/screen_background.dart';
import '../../common_widgets/status/loading.dart';
import '../../common_widgets/status/network_error.dart';
import '../../theme.dart';

class VipCenterScreen extends StatefulWidget {
  const VipCenterScreen({super.key});

  @override
  State<VipCenterScreen> createState() => _VipCenterScreenState();
}

class _VipCenterScreenState extends State<VipCenterScreen> {
  final _type = MyProductType.vip;
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
      _orderDomain.getProduct(type: _type),
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
    return ScreenBackground(
      child: Scaffold(
        appBar: MyAppBar(
          title: 'hyzx'.tr(context: context),
          rightWidget: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () => RechargeRecordRoute(_type.id.toString()).push(context),
            child: Text(
              'czjl'.tr(context: context),
              style: MyTheme.gray150_14,
            ),
          ),
        ),
        body: _asyncValue.maybeWhen(
          data: (value) => _Body(
            productOfVIP: value.$1,
            expOfVIP: value.$2,
          ),
          error: (_, __) => NetworkErrorView(onTap: _init),
          orElse: () => const LoadingView(),
        ),
      ),
    );
  }
}

class _Body extends StatefulWidget {
  const _Body({required this.productOfVIP, required this.expOfVIP});

  final ProductOfVipOrCoin productOfVIP;
  final ExpOfVIPListModel expOfVIP;

  @override
  State<_Body> createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  final productSelectedNotifier = ValueNotifier(0);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const _UserInfoArea(),
                SizedBox(height: 20.w),
                _TitleHintText(
                  title: 'ktvpxs'.tr(context: context),
                  subTitle: 'zmzxs'.tr(context: context),
                ),
                SizedBox(height: 13.w),
                _ProductCardArea(
                  products: widget.productOfVIP.products,
                  selectedNotifier: productSelectedNotifier,
                ),
                SizedBox(height: 20.w),
                _DescriptionArea(
                  notifier: productSelectedNotifier,
                  products: widget.productOfVIP.products,
                ),
                _RightArea(
                  notifier: productSelectedNotifier,
                  products: widget.productOfVIP.products,
                ),
                SizedBox(height: 25.w),
                Selector<UserNotifier, int>(
                  selector: (_, userNotifier) => userNotifier.member.exp ?? 0,
                  builder: (BuildContext context, value, Widget? child) =>
                      _TitleHintText(
                    title: 'jfdh'.tr(context: context),
                    subTitle: 'dqjf'.tr(context: context) + value.toString(),
                  ),
                ),
                SizedBox(height: 13.w),
                _ExpArea(expOfVipList: widget.expOfVIP.list),
                SizedBox(height: 25.w),
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(member.nickname, style: MyTheme.white255_14),
                  SizedBox(width: 10.w),
                  MemberVipWidget(showText: member.vipStr)
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
  });

  final List<Product> products;
  final ValueNotifier selectedNotifier;

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
              );
            },
          ),
        ),
      ),
    );
  }
}

class _ProductItem extends StatelessWidget {
  final Product product;
  final bool isSelected;
  const _ProductItem({
    required this.product,
    required this.isSelected,
  });

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
                          ? const Color(0xFFdaa78b)
                          : Colors.transparent,
                      width: 2.0),
                  // color: widget.product == widget.selP
                  //     ? Color(0xFFFFEFDC)
                  //     : Color(0xFF36394A),
                  gradient: LinearGradient(
                    colors: isSelected
                        ? [const Color(0xFFffefdc), const Color(0xFFf7dcbc)]
                        : [const Color(0xFF2a2a42), const Color(0xFF2a2a42)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(7)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    product.pName,
                    style:
                        isSelected ? MyTheme.brown72_18 : MyTheme.brown248_18,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '¥',
                        style: TextStyle(
                            fontSize: 18.sp,
                            color: isSelected
                                ? const Color(0xFF48170e)
                                : const Color(0xFFffffff),
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        promoPrice,
                        style: TextStyle(
                            fontSize: 30.sp,
                            color: isSelected
                                ? const Color(0xFF48170e)
                                : const Color(0xFFffffff),
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Text(
                    price,
                    style: TextStyle(
                      fontSize: 15.sp,
                      color: isSelected
                          ? const Color(0xFF7f3b29)
                          : const Color(0xFFa1a1b2),
                      decoration: TextDecoration.lineThrough,
                      decorationColor: isSelected
                          ? const Color(0xFF7f3b29)
                          : const Color(0xFFa1a1b2),
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
                gradient: MyTheme.gradient_228_246,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10.w),
                  bottomRight: Radius.circular(10.w),
                ),
              ),
              child: Center(
                child: Text(
                  product.giveTip,
                  style: TextStyle(
                    color: const Color.fromRGBO(46, 24, 12, 1),
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
              crossAxisCount: 4,
              childAspectRatio: 0.65,
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
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
            width: 50.w,
            height: 50.w,
            child: MyImage.network(
              logo,
              fit: BoxFit.fitHeight,
            )),
        SizedBox(height: 6.5.w),
        SizedBox(
          height: 20.sp,
          child: Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: 7.w),
        SizedBox(
          height: 35.w,
          child: Text(
            subTitle,
            style: TextStyle(
              color: const Color(0xFFadadad),
              fontSize: 12.sp,
            ),
            maxLines: 2,
            textAlign: TextAlign.center,
          ),
        )
      ],
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
    return SizedBox(
      height: 154.w,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
        separatorBuilder: (_, __) => SizedBox(width: 15.w),
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: expOfVipList.length,
        itemBuilder: (context, index) => _ExpItem(exp: expOfVipList[index]),
      ),
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
    return Stack(
      children: [
        Column(
          children: [
            Container(
              width: 114.w,
              height: 120.w,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFFffefdc),
                    Color(0xFFf5e4d4),
                    Color(0xFFf7dcbc)
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(7.w),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.exp.vipStr,
                    style: TextStyle(
                      color: const Color(0xFF48170e),
                      fontSize: 15.sp,
                    ),
                  ),
                  SizedBox(height: 10.w),
                  Text(
                    widget.exp.expStr,
                    style: TextStyle(
                      color: const Color(0xFF7f3b29),
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10.w),
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: _sendExpCoverVIP,
              child: Container(
                height: 24.w,
                width: 114.w,
                decoration: BoxDecoration(
                  color: const Color(0xFF3d4255),
                  borderRadius: BorderRadius.all(Radius.circular(12.w)),
                ),
                child: Center(
                  child: RichText(
                      text: TextSpan(
                          text: 'dh'.tr(context: context),
                          style: MyTheme.white255_12)),
                ),
              ),
            )
          ],
        ),
      ],
    );
  }
}
