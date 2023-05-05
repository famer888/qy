import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qypj/base/baseWidget.dart';
import 'package:qypj/components/page_status.dart';
import 'package:qypj/components/yy_dialog.dart';
import 'package:qypj/model/basic.dart';
import 'package:qypj/pages/mine/agent/mine_agent_bankcard_list_page.dart';
import 'package:qypj/routers.dart';
import 'package:qypj/theme/default.dart';
import 'package:qypj/utils/api.dart';
import 'package:qypj/utils/common.dart';
import 'package:qypj/utils/extensionlibrary.dart';
import 'package:qypj/utils/index.dart';

class MineAgentToCashPage extends BaseWidget {
  MineAgentToCashPage({this.isbance = "0"}) : super();
  String isbance;
  cState() => _MineAgentToCashPageState();
}

class _MineAgentToCashPageState extends BaseWidgetState<MineAgentToCashPage> {
  bool networkErr = false;
  bool isHud = true;

  bool _isBalance = false;

  ///提现成功
  bool _applySuccessed = false;
  dynamic _applySuccessedTip;

  dynamic _currentBankcard;
  TextEditingController _textController;
  String _rule; // 规则
  String _scale_tip; //汇率
  dynamic _proxy_money; //扣币余额
  double _proxy_rate = 0; // 代理提现 手续费
  int _sumAllResultMoney = 0; // 计算后所有需要扣除的money
  int _sumResultMoney = 0; // 提现到账money
  int _allUsedCoin = 0; // 收益手续费

  @override
  void onCreate() {
    setAppTitle(
        title: widget.isbance == '0'
            ? CommonUtils.txt('sytx')
            : CommonUtils.txt('dltx'));

    EventBus().on('cash_choose_bankcard', (arg) {
      _setBankCard(arg);
    });

    _textController = TextEditingController()
      ..addListener(() {
        if (_textController.text.length > 8) {
          _textController.text = _textController.text.substring(0, 8);
          _textController.selection =
              TextSelection.fromPosition(TextPosition(offset: 8));
        }
        setState(() {});
      });

    _isBalance = widget.isbance == "0";

    _getWithDrawRule();

    _getBankList();
  }

  _getWithDrawRule() async {
    try {
      Basic res = await cashWithdrawRule({});
      if (res.status != 1) {
        CommonUtils.showText(res.msg);
        isHud = false;
        networkErr = true;
      } else {
        if (_isBalance) {
          _rule = res.data['rule_coins_text'] ?? res.data['rule_text'];
        } else {
          _rule = res.data['rule_proxy_text'] ?? res.data['rule_text'];
        }

        _scale_tip = res.data['scale_tip'];
        _proxy_money =
            _isBalance ? res.data['income_money'] : res.data['proxy_money'];
        _proxy_rate =
            _isBalance ? res.data['income_rate'] : res.data['proxy_rate'];
        isHud = false;
        networkErr = false;
      }
      setState(() {});
    } catch (e) {
      isHud = false;
      networkErr = true;
      setState(() {});
    }
  }

  _getBankList() async {
    Map param = {"page": 1, "limit": 10};
    try {
      Basic res = await cashBankCardList(param);
      if (res.status != 1) {
        CommonUtils.showText(res.msg);
      } else {
        List _bankList = res.data['list'];
        for (var item in _bankList) {
          if (item['is_default'] == 1) {
            _setBankCard(item);
            break;
          }
        }
      }
    } catch (e) {}

    setState(() {});
  }

  _withdrawAct() async {
    dynamic card = _currentBankcard;
    BotToast.showLoading();

    int amount = int.parse(_textController.text);

    //  "withdraw_from": 1, // 提现类型 1 全民代理，2收益

    Map param = {
      'card_id': card['id'],
      'amount': amount,
      'withdraw_from': _isBalance ? 2 : 1
    };

    try {
      Basic res;
      if (_isBalance) {
        res = await incomeApplyWithdraw(param);
      } else {
        res = await cashApplyWithdraw(param);
      }

      print(res.data);
      if (res.status != 1) {
        CommonUtils.showText(res.msg);
      } else {
        // CommonUtils.showText(res.msg);
        _applySuccessedTip = res.msg;
        _applySuccessed = true;
        // _getBankList();
        setState(() {});
      }
      BotToast.closeAllLoading();
    } catch (e) {
      BotToast.closeAllLoading();
    }
  }

  _askWithdraw() {
    FocusScope.of(context).requestFocus(FocusNode());
    if (_textController.text.length == 0) {
      CommonUtils.showText(CommonUtils.txt("srje"));
      return;
    }
    if (_currentBankcard == null) {
      CommonUtils.showText(CommonUtils.txt("xzc"));
      return;
    }
    YyShowDialog.showdialog(context,
        content: (setDialogState) {
          return Container(
            child: Text(
              CommonUtils.txt('sftxd') +
                  '\n' +
                  '${_currentBankcard['bank']}' +
                  ' ' +
                  subStringFour('${_currentBankcard['card']}'),
              style: GQStyle.graya3a2a2_15,
              maxLines: 3,
              textAlign: TextAlign.center,
            ),
          );
        },
        title: CommonUtils.txt('ts'),
        cancelText: CommonUtils.txt('qx'),
        btnText: CommonUtils.txt('qr'),
        callBack: () {
          _withdrawAct();
        });
  }

  _setBankCard(dynamic card) {
    _currentBankcard = card;
    setState(() {});
  }

  @override
  void onDestroy() {
    EventBus().off('cash_choose_bankcard');
  }

  @override
  Widget appbar() {
    return !(networkErr == false && isHud == false)
        ? super.appbar()
        : Stack(children: [
            super.appbar(),
            Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: GQStyle.pagePadding),
                  alignment: Alignment.centerRight,
                  height: GQStyle.navbarHegiht,
                  child: GestureDetector(
                    onTap: () {
                      context.push('/' + Routes.mineAgentCashRecordPage);
                    },
                    child: Text(
                      CommonUtils.txt('txjl'),
                      style: GQStyle.gray15,
                    ),
                  ),
                ))
          ]);
    // TODO: implement appbar
    return super.appbar();
  }

  @override
  pageBody(BuildContext context) {
    return networkErr
        ? PageStatus.noNetWork(onTap: _getWithDrawRule)
        : isHud
            ? PageStatus.loading(mounted)
            : !_applySuccessed
                ? GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: GQStyle.pagePadding),
                      child: Stack(
                        children: [
                          Positioned.fill(
                              child: SingleChildScrollView(
                            physics: AlwaysScrollableScrollPhysics(),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: ScreenUtil().setWidth(28)),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Column(
                                      children: [
                                        Text.rich(TextSpan(children: [
                                          TextSpan(
                                              text: CommonUtils.txt('ktye') +
                                                  ': ',
                                              style: GQStyle.hexa3a2a2_13),
                                          TextSpan(
                                            text: '$_proxy_money',
                                            style: GQStyle.jellyCyan_18_M,
                                          ),
                                          TextSpan(
                                              text: CommonUtils.txt("y"),
                                              style: GQStyle.hexa3a2a2_13),
                                          // TextSpan(
                                          //     text:
                                          //         ' (${CommonUtils.txt("hl")}：$_scale_tip)',
                                          //     style: GQStyle.hexa3a2a2_13),
                                        ])),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(height: ScreenUtil().setHeight(15)),
                                Text(CommonUtils.txt("txye"),
                                    style: GQStyle.white255_15_M),
                                SizedBox(height: ScreenUtil().setWidth(10)),
                                Container(
                                    height: ScreenUtil().setWidth(60),
                                    decoration: BoxDecoration(
                                      color: Color(0xff2f2f42),
                                      borderRadius: BorderRadius.circular(
                                          ScreenUtil().setWidth(5)),
                                    ),
                                    child: Container(
                                      margin: EdgeInsets.only(
                                        left: GQStyle.pagePadding,
                                        right: GQStyle.pagePadding,
                                      ),
                                      child: TextField(
                                        onChanged: (value) {
                                          if (int.parse(value) > 0) {
                                            setState(() {
                                              _sumResultMoney =
                                                  int.parse(value);
                                              _sumAllResultMoney =
                                                  (int.parse(value) *
                                                          (1 + _proxy_rate))
                                                      .floor();
                                            });
                                          }
                                        },
                                        keyboardType: TextInputType.number,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.digitsOnly
                                        ],
                                        controller: _textController,
                                        style: GQStyle.copper25,
                                        cursorColor: Colors.white,
                                        decoration: InputDecoration(
                                          hintText: CommonUtils.txt('srje'),
                                          hintStyle: GQStyle.hexa3a2a2_15,
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.transparent),
                                          ),
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.transparent),
                                          ),
                                        ),
                                      ),
                                    )),
                                SizedBox(height: ScreenUtil().setWidth(11.5)),
                                RichText(
                                    maxLines: 1,
                                    text: TextSpan(children: [
                                      TextSpan(
                                          text: CommonUtils.txt('xhj') +
                                              CommonUtils.txt('kc'),
                                          style: GQStyle.gray143_13),
                                      TextSpan(
                                          text: '$_sumAllResultMoney',
                                          style: GQStyle.jellyCyan_13),
                                      // TextSpan(
                                      //     text: CommonUtils.txt('bs'),
                                      //     style: GQStyle.jellyCyan_13),
                                      TextSpan(text: ' '),
                                      TextSpan(
                                          text: CommonUtils.txt('dzhj') + ': ',
                                          style: GQStyle.gray143_13),
                                      TextSpan(
                                          text: '$_sumResultMoney',
                                          style: GQStyle.jellyCyan_13),
                                      TextSpan(
                                          text: CommonUtils.txt('y'),
                                          style: GQStyle.jellyCyan_13)
                                    ])),

                                // Expanded(
                                //     child: Container(
                                //   child: Row(
                                //     // mainAxisAlignment:
                                //     //     MainAxisAlignment.spaceBetween,
                                //     children: [
                                //       _isForNakedChat
                                //           ? RichText(
                                //               maxLines: 1,
                                //               text: TextSpan(children: [
                                //                 TextSpan(
                                //                     text: CommonUtils.txt(
                                //                             'xhj') +
                                //                         CommonUtils.txt('kc'),
                                //                     style: GQStyle.white244_13),
                                //                 TextSpan(
                                //                     text: '$_allUsedCoin',
                                //                     style: GQStyle.copper13),
                                //                 TextSpan(
                                //                     text: CommonUtils.txt('jb'),
                                //                     style: GQStyle.copper13),
                                //                 TextSpan(text: ' '),
                                //                 TextSpan(
                                //                     text: CommonUtils.txt(
                                //                             'dzhj') +
                                //                         ': ',
                                //                     style: GQStyle.white244_13),
                                //                 TextSpan(
                                //                     text: '$_sumResultMoney',
                                //                     style: GQStyle.copper13),
                                //                 TextSpan(
                                //                     text: CommonUtils.txt('y'),
                                //                     style: GQStyle.copper13)
                                //               ]))
                                //           : RichText(
                                //               maxLines: 1,
                                //               text: TextSpan(children: [
                                //                 TextSpan(
                                //                     text: CommonUtils.txt(
                                //                             'xhj') +
                                //                         CommonUtils.txt('kc'),
                                //                     style: GQStyle.white244_13),
                                //                 TextSpan(
                                //                     text: '$_sumAllResultMoney',
                                //                     style: GQStyle.copper13),
                                //                 TextSpan(
                                //                     text: CommonUtils.txt('y'),
                                //                     style: GQStyle.copper13),
                                //                 TextSpan(text: ' '),
                                //                 TextSpan(
                                //                     text: CommonUtils.txt(
                                //                             'dzhj') +
                                //                         ': ',
                                //                     style: GQStyle.white244_13),
                                //                 TextSpan(
                                //                     text: '$_sumResultMoney',
                                //                     style: GQStyle.copper13),
                                //                 TextSpan(
                                //                     text: CommonUtils.txt('y'),
                                //                     style: GQStyle.copper13)
                                //               ]))
                                //       //   ConstrainedBox(
                                //       //   constraints: BoxConstraints(
                                //       //       maxWidth: ScreenUtil()
                                //       //           .setWidth(150)),
                                //       //   child: RichText(
                                //       //       maxLines: 1,
                                //       //       text:
                                //       //           TextSpan(children: [
                                //       //         TextSpan(
                                //       //             text: _isForNakedChat
                                //       //                 ? CommonUtils.txt(
                                //       //                         'xhj') +
                                //       //                     '：'
                                //       //                 : CommonUtils.txt(
                                //       //                         'dzhj') +
                                //       //                     ': ',
                                //       //             style: GQStyle
                                //       //                 .white244_13),
                                //       //         TextSpan(
                                //       //             text:
                                //       //                 '$_sumResultMoney',
                                //       //             style: GQStyle
                                //       //                 .copper13),
                                //       //         TextSpan(
                                //       //             text: CommonUtils
                                //       //                 .txt('y'),
                                //       //             style: GQStyle
                                //       //                 .copper13)
                                //       //       ])),
                                //       // ),
                                //       // Text(_scale_tip,
                                //       //     style: GQStyle.white244_13)
                                //     ],
                                //   ),
                                // )),
                                SizedBox(
                                  height: ScreenUtil().setWidth(25),
                                ),
                                // Container(
                                //   alignment: Alignment.topLeft,
                                //   padding: EdgeInsets.symmetric(
                                //       vertical: ScreenUtil().setWidth(15)),
                                //   child: Text(
                                //     CommonUtils.txt('txsk'),
                                //     style: GQStyle.white244_14semibold,
                                //   ),
                                // ),
                                GestureDetector(
                                  onTap: () {
                                    context.push(
                                        '/' + Routes.mineAgentBankcardListPage);
                                  },
                                  child: Container(
                                    height: ScreenUtil().setWidth(60),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: GQStyle.pagePadding),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          ScreenUtil().setWidth(5)),
                                      color: Color(0xff2f2f42),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        _currentBankcard != null
                                            ? Text(
                                                '${_currentBankcard['bank']}' +
                                                    ' ' +
                                                    subStringFour(
                                                        '${_currentBankcard['card']}'),
                                                style: GQStyle.white244_14)
                                            : Text(CommonUtils.txt('xztx'),
                                                style: GQStyle.hexa3a2a2_15),
                                        LImage(
                                          'yjt',
                                          width: ScreenUtil().setWidth(6),
                                          height: ScreenUtil().setWidth(10),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: ScreenUtil().setWidth(24),
                                ),
                                Text(CommonUtils.txt("txgz"),
                                    style: GQStyle.white255_15_M),
                                SizedBox(height: ScreenUtil().setHeight(5)),
                                Container(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    // CommonUtils.txt('txgzd'),
                                    _rule,
                                    style: GQStyle.black118_12,
                                    strutStyle: StrutStyle(
                                        forceStrutHeight: true,
                                        height: ScreenUtil().setWidth(1),
                                        leading: 0.9),
                                  ),
                                )
                              ],
                            ),
                          )),
                          SafeArea(
                              child: Container(
                            alignment: Alignment.bottomCenter,
                            margin: EdgeInsets.only(
                                bottom: ScreenUtil().setWidth(20)),
                            child: Offstage(
                              child: GestureDetector(
                                onTap: () {
                                  _askWithdraw();
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  width: ScreenUtil().setWidth(328),
                                  height: ScreenUtil().setWidth(44),
                                  decoration: BoxDecoration(
                                      gradient:
                                          GQStyle.btnGradient_ff00edfd_ffbbe954,
                                      borderRadius: BorderRadius.circular(
                                          ScreenUtil().setWidth(5))),
                                  child: Text(
                                    _isBalance
                                        ? CommonUtils.txt('fqtz')
                                        : CommonUtils.txt('qrtz'),
                                    style: GQStyle.white234_15_M,
                                  ),
                                ),
                              ),
                              offstage: false,
                            ),
                          ))
                        ],
                      ),
                    ))
                : Stack(children: [
                    Container(
                      // padding: EdgeInsets.all(
                      //   ScreenUtil().setWidth(20),
                      // ),
                      alignment: Alignment.center,
                      child: UnconstrainedBox(
                        child: Column(
                          children: [
                            SizedBox.square(
                              dimension: 150,
                              child: LImage('sucess_wait_bg'),
                            ),
                            SizedBox(height: ScreenUtil().setWidth(39)),
                            Align(
                              // alignment: Alignment.bottomCenter,
                              child: Text(CommonUtils.txt('txsqcg'),
                                  textAlign: TextAlign.center,
                                  style: GQStyle.white20medium),
                            ),
                            SizedBox(height: ScreenUtil().setWidth(21)),
                            Container(
                              alignment: Alignment.bottomCenter,
                              child: Text(CommonUtils.txt('txsqcgd1'),
                                  textAlign: TextAlign.center,
                                  style: GQStyle.gray95_13),
                            ),
                            SizedBox(height: ScreenUtil().setWidth(10)),
                            Container(
                              alignment: Alignment.bottomCenter,
                              child: Text(CommonUtils.txt('txsqcgd2'),
                                  textAlign: TextAlign.center,
                                  style: GQStyle.gray95_13),
                            ),
                            _applySuccessedTip != null
                                ? Container(
                                    padding: EdgeInsets.only(
                                        top: ScreenUtil().setWidth(10)),
                                    alignment: Alignment.bottomCenter,
                                    child: Text('$_applySuccessedTip',
                                        textAlign: TextAlign.center,
                                        style: GQStyle.white95_15_semibold),
                                  )
                                : Container(),
                            SizedBox(height: ScreenUtil().setWidth(220)),
                          ],
                        ),
                      ),
                    ),
                    SafeArea(
                        child: Container(
                      alignment: Alignment.bottomCenter,
                      child: GestureDetector(
                        onTap: () {
                          context.pop();
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: ScreenUtil().setWidth(324),
                          height: ScreenUtil().setWidth(40),
                          decoration: BoxDecoration(
                              gradient: GQStyle.btnGradient_ff00edfd_ffbbe954,
                              borderRadius: BorderRadius.circular(
                                  ScreenUtil().setWidth(5))),
                          child: Text(
                            CommonUtils.txt('wc'),
                            style: GQStyle.white255_15_semibold,
                          ),
                        ),
                      ),
                    ))
                  ]);
  }
}
