import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../domain/api_validator.dart';
import '../../../domain/model/product_vip_coin_model.dart';
import '../../../domain/remote_domain/domains/user.dart';
import '../../notifiers/user_notifier.dart';
import '../../router/routes.dart';
import '../../utils/my_toast.dart';
import '../theme.dart';
import 'dialog/my_dialog.dart';
import 'dialog/widgets/pay_dialog.dart';
import 'dialog/widgets/png_dialog.dart';
import 'dialog/widgets/regular_dialog.dart';
import 'localization_text.dart';
import 'my_button.dart';

class FixedBuyButton extends StatefulWidget {
  const FixedBuyButton({
    super.key,
    required this.notifier,
    required this.products,
    required this.vipText,
    this.isUpgrade = false,
  });

  final ValueNotifier<int> notifier;
  final List<Product> products;
  final String vipText;
  final bool isUpgrade;

  @override
  State<FixedBuyButton> createState() => _FixedBuyButtonState();
}

class _FixedBuyButtonState extends State<FixedBuyButton> {
  Future<void> _showPay(int selectedIndex) => showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) => PayDialog(
          product: widget.products[selectedIndex],
          tip: widget.vipText,
        ),
      );

  Future<void> _showUpgrade(int selectedIndex) async {
    final userNotifier = context.read<UserNotifier>();
    final member = userNotifier.member;
    final product = widget.products[selectedIndex];
    final isInsufficient = member.money < (product.payCoins ?? 0);
    if (isInsufficient) {
      MyDialog.showDialog(
        context: context,
        child: PNGDialog(
          title: tr('ts'),
          cancelText: tr('qx'),
          buttonText: tr('qwcz'),
          confirmOnTap: () {
            const CoinRechargeRoute().push(context);
          },
          content: Text('jbbzqcz'.tr(), style: MyTheme.white15),
        ),
      );
      return;
    }
    MyToast.showLoading(text: tr('gmzz'));

    final domain = context.read<UserDomain>();
    final res = await domain.userUpgrade(id: product.id);
    MyToast.closeAllLoading();
    if (res.isValid && mounted) {
      userNotifier.init();
      MyDialog.showDialog(
        context: context,
        child: RegularDialog(
          title: tr('sjcg'),
          buttonText: tr('qd'),
          content: Text(
              '${'sjcgtipb'.tr(context: context)}${product.pName}${'sjcgtiph'.tr(context: context)}',
              style: MyTheme.white15,
              textAlign: TextAlign.center),
        ),
      );
    } else {
      MyToast.showText(text: res.msg ?? '');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF111127),
      ),
      child: ValueListenableBuilder(
        valueListenable: widget.notifier,
        builder: (context, selectedIndex, child) {
          return SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: MyTheme.pagePadding, vertical: 5.w),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              widget.isUpgrade
                                  ? '${'bjb'.tr(context: context)}: '
                                  : '${'xhj'.tr(context: context)}: ',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 23.sp,
                                fontWeight: FontWeight.w600,
                                height: 1.0,
                              ),
                            ),
                            if (!widget.isUpgrade)
                              Text(
                                '¥',
                                strutStyle: const StrutStyle(height: 1.0),
                                style: TextStyle(
                                  color: const Color(0xfff7c2a8),
                                  fontSize: 15.sp,
                                  height: 1.0,
                                ),
                              ),
                            Text(
                              widget.isUpgrade
                                  ? '${widget.products[selectedIndex].payCoins ?? 0}'
                                  : widget
                                      .products[selectedIndex].promoPriceYuan
                                      .split('.')
                                      .first,
                              style: TextStyle(
                                color: const Color(0xfff7c2a8),
                                fontSize: 25.sp,
                                height: 1.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5.w),
                        GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () =>
                              const MineCustomerServiceRoute().push(context),
                          child: Text.rich(
                            TextSpan(
                              text: 'zflx'.tr(context: context),
                              style: TextStyle(
                                color: const Color(0xFFc6c7c9),
                                fontSize: 10.sp,
                              ),
                              children: [
                                TextSpan(
                                  text: 'zxkf'.tr(context: context),
                                  style: TextStyle(
                                    color: const Color(0xFF9dbbf9),
                                    fontSize: 10.sp,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  MyButton.gradient(
                    onPressed: () {
                      if (widget.isUpgrade) {
                        _showUpgrade(selectedIndex);
                      } else {
                        _showPay(selectedIndex);
                      }
                    },
                    minimumSize: Size(110.w, 40.w),
                    gradient: const LinearGradient(
                      colors: MyTheme.gradient_vip_colors,
                      begin: Alignment.centerRight,
                      end: Alignment.centerLeft,
                    ),
                    child: LocalizationText(
                      widget.isUpgrade ? 'ljsj' : 'ljzf',
                      style: TextStyle(
                        color: const Color(0xFF60260c),
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
