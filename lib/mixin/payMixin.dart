import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qypj/utils/extensionlibrary.dart';
import 'package:qypj/components/page_status.dart';
import 'package:qypj/components/yy_dialog.dart';
import 'package:qypj/model/basic.dart';
import 'package:qypj/theme/default.dart';
import 'package:qypj/utils/api.dart';
import 'package:qypj/utils/common.dart';
import "package:universal_html/html.dart" as html;

Map payIcons = {
  'alipay': 'zf_xfb_n',
  'wechat': 'zf_mx_n',
  'bankcard': 'zf_yt_n',
  'usdt': 'zf_us_n',
  'agent': 'zf_agn_n',
  'money': 'zf_con_n',
  'ecny': 'zf_ecny_n'
};

mixin PayMixin<T extends StatefulWidget> on State<T> {
  html.WindowBase winRef;
  dynamic origin = html.window.location.origin + '/';
  payErr() {
    YyShowDialog.showdialog(context,
        title: CommonUtils.txt('ts'),
        btnText: CommonUtils.txt('zdl'), content: (setDialogState) {
      return DefaultTextStyle(
          style: GQStyle.white233_14,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(CommonUtils.txt('zfsb')),
              SizedBox(
                height: ScreenUtil().setWidth(14),
              ),
              Text(CommonUtils.txt('zfsby')),
              SizedBox(
                height: ScreenUtil().setWidth(14),
              ),
              Text(CommonUtils.txt('zfsbe'))
            ],
          ));
    });
  }

  showPay(Map product, String tip) {
    int currentPay;
    List pays;
    pays = List.from(product['pay']);

    return showModalBottomSheet(
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setBottomSheetState) {
            return Container(
              padding:
                  EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(20)),
              decoration: BoxDecoration(
                  color: GQStyle.bgColor,
                  borderRadius: BorderRadius.vertical(
                      top: Radius.circular(ScreenUtil().setWidth(30)))),
              child: SingleChildScrollView(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.only(
                        top: ScreenUtil().setWidth(24.5),
                        bottom: ScreenUtil().setWidth(19.5)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(),
                        Text(
                          CommonUtils.txt('xzzf'),
                          style: GQStyle.white255_18_M,
                        ),
                        GestureDetector(
                          onTap: () {
                            context.pop();
                          },
                          child: LImage(
                            "alert_close_n",
                            width: ScreenUtil().setWidth(14),
                            height: ScreenUtil().setWidth(14),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text.rich(TextSpan(
                      text: CommonUtils.txt('zfje') + ' ',
                      style: GQStyle.white255_14,
                      children: [
                        TextSpan(
                            text: '${product['promo_price_yuan']}' +
                                CommonUtils.txt('y'),
                            style: TextStyle(
                                color: Color(0xff67e0b9),
                                fontSize: ScreenUtil().setSp(14)))
                      ])),
                  Column(
                    children: pays
                        .asMap()
                        .keys
                        .map((e) => GestureDetector(
                              onTap: () {
                                setBottomSheetState(() {
                                  currentPay = e;
                                });
                              },
                              behavior: HitTestBehavior.translucent,
                              child: Padding(
                                padding: EdgeInsets.only(
                                    top: ScreenUtil().setWidth(20)),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        LImage(
                                          payIcons[pays[e]['channel']],
                                          width: ScreenUtil().setSp(40),
                                          height: ScreenUtil().setSp(40),
                                        ),
                                        SizedBox(
                                          width: ScreenUtil().setSp(10.5),
                                        ),
                                        Text(
                                          pays[e]['name'],
                                          style: GQStyle.white255_15,
                                        )
                                      ],
                                    ),
                                    LImage(
                                      currentPay == e
                                          ? 'wd_radiosel_n'
                                          : 'wd_radio_n',
                                      width: ScreenUtil().setSp(20),
                                      height: ScreenUtil().setSp(20),
                                    )
                                  ],
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                  GestureDetector(
                      onTap: () async {
                        if (currentPay == null)
                          return BotToast.showText(
                              text: CommonUtils.txt('qxzzf'));
                        PageStatus.showLoading(text: CommonUtils.txt('zzqqzf'));
                        if (pays[currentPay]['channel'] == 'money') {
                          try {
                            Basic res = await onOrderExchange(
                                product_id: product['id']);
                            if (res.status == 1) {
                              getUserInfo(context);
                              BotToast.showText(text: CommonUtils.txt('dhhc'));
                            } else {
                              BotToast.showText(text: res.msg);
                            }
                          } catch (err) {
                            BotToast.showText(text: CommonUtils.txt('dhhs'));
                          }
                        } else {
                          if (kIsWeb) {
                            winRef = html.window
                                .open('${origin}waiting.html', "_blank");
                          }
                          try {
                            Basic res = await onCreatePaying(
                                pay_type: 'online',
                                pay_way: pays[currentPay]['channel'],
                                product_id: product['id']);
                            if (kIsWeb) {
                              PageStatus.closeLoading();
                              context.pop();
                            }
                            if (res.status != 1) {
                              if (res.msg != null) {
                                if (kIsWeb) {
                                  winRef.close();
                                  payErr();
                                }
                                BotToast.showText(text: res.msg);
                              }
                            } else {
                              if (res.data != null &&
                                  res.data['payUrl'] != null) {
                                if (kIsWeb) {
                                  winRef.location.href = res.data['payUrl'];
                                } else {
                                  CommonUtils.launchURL(res.data['payUrl']);
                                }
                              } else if (res.msg != null) {
                                if (kIsWeb) {
                                  winRef.close();
                                  payErr();
                                }
                                BotToast.showText(text: res.msg);
                              } else {
                                if (kIsWeb) {
                                  winRef.close();
                                  payErr();
                                }
                                BotToast.showText(
                                    text: CommonUtils.txt('cddsb'));
                              }
                            }
                          } catch (err) {
                            CommonUtils.debugPrint(err);
                          }
                        }
                        PageStatus.closeLoading();
                      },
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: ScreenUtil().setWidth(20),
                        ),
                        child: Container(
                          height: ScreenUtil().setWidth(40),
                          decoration: BoxDecoration(
                            gradient: GQStyle.btnGradient_ff00edfd_ffbbe954,
                            borderRadius: BorderRadius.all(
                                Radius.circular(ScreenUtil().setWidth(20))),
                          ),
                          child: Center(
                            child: Text(CommonUtils.txt('tj'),
                                style: GQStyle.white255_18),
                          ),
                        ),
                      )),
                  SizedBox(height: ScreenUtil().setWidth(10)),
                  Text(
                    CommonUtils.txt('zfxts'),
                    style: TextStyle(
                        color: Color.fromRGBO(173, 173, 173, 1),
                        fontSize: ScreenUtil().setSp(15),
                        decoration: TextDecoration.none),
                  ),
                  SizedBox(height: ScreenUtil().setWidth(5)),
                  Text(
                    tip,
                    style: TextStyle(
                        color: Color.fromRGBO(173, 173, 173, 1),
                        fontSize: ScreenUtil().setSp(12),
                        decoration: TextDecoration.none),
                  ),
                  SizedBox(height: ScreenUtil().setWidth(kIsWeb ? 30 : 10))
                ],
              )),
            );
          });
        });
  }
}
