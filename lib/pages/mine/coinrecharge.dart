import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qypj/base/baseWidget.dart';
import 'package:qypj/utils/extensionlibrary.dart';
import 'package:provider/provider.dart';
import 'package:qypj/components/page_status.dart';
import 'package:qypj/mixin/payMixin.dart';
import 'package:qypj/model/basic.dart';
import 'package:qypj/store/homeConfig.dart';
import 'package:qypj/theme/default.dart';
import 'package:qypj/utils/api.dart';
import 'package:qypj/utils/common.dart';

class CoinRecharge extends BaseWidget {
  CoinRecharge({Key key}) : super(key: key);

  @override
  State<StatefulWidget> cState() {
    // TODO: implement cState
    return _CoinRechargeState();
  }
}

class _CoinRechargeState extends BaseWidgetState<CoinRecharge> with PayMixin {
  String pageStatus = 'loading';
  List products;
  dynamic selectP;
  bool networkErr = false;
  String product_vip_text = "";

  @override
  void onCreate() {
    setAppTitle(
        title: CommonUtils.txt('jbcz'),
        rightW: GestureDetector(
          onTap: () {
            context.push(CommonUtils.getRealHash('RechargeRecord/1'));
          },
          child: Text(
            CommonUtils.txt('czjl'),
            style: GQStyle.gray150_14,
          ),
        ));
    _initPage();
    getUserInfo(context);
  }

  _initPage() async {
    Basic res = await getProductOfGold(2);
    if (res == null) {
      networkErr = true;
      setState(() {});
      return;
    }
    if (res.status != 0) {
      products = List.from(res.data['product']);
      selectP = products.first;
      product_vip_text = res.data["product_coins_text"];
      pageStatus = 'ready';
      setState(() {});
    } else {
      CommonUtils.showText(res.msg);
    }
  }

  @override
  Widget pageBody(BuildContext context) {
    int money = Provider.of<HomeConfig>(context).member.money ?? 0;
    return networkErr
        ? PageStatus.noNetWork(onTap: () {
            networkErr = false;
            setState(() {});
            _initPage();
          })
        : pageStatus == 'loading'
            ? PageStatus.loading(mounted)
            : Column(
                children: [
                  Expanded(
                      child: Container(
                    color: GQStyle.bgColor,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            height: ScreenUtil().setWidth(100),
                            color: GQStyle.bgColor,
                            padding: EdgeInsets.symmetric(
                              horizontal: GQStyle.pagePadding,
                            ),
                            child: Center(
                              child: Stack(
                                children: [
                                  Container(
                                    margin: EdgeInsets.symmetric(
                                      vertical: ScreenUtil().setWidth(20),
                                    ),
                                    height: ScreenUtil().setWidth(60),
                                    decoration: BoxDecoration(
                                      color: Color(0xFF2a2a42),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(
                                              ScreenUtil().setWidth(30))),
                                    ),
                                  ),
                                  Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                            width: ScreenUtil().setWidth(20)),
                                        Text(
                                          CommonUtils.txt('jbye'),
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: ScreenUtil().setSp(15),
                                              fontFamily: GQStyle.hanyi),
                                        ),
                                        SizedBox(
                                            width: ScreenUtil().setWidth(10)),
                                        SizedBox(
                                          height: ScreenUtil().setWidth(24),
                                          width: ScreenUtil().setWidth(0.5),
                                          child: Container(color: Colors.white),
                                        ),
                                        SizedBox(
                                            width: ScreenUtil().setWidth(10)),
                                        Expanded(
                                          child: Text(
                                            money.toString(),
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: ScreenUtil().setSp(38),
                                              fontWeight: FontWeight.bold,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            maxLines: 1,
                                          ),
                                        ),
                                        SizedBox(
                                            width: ScreenUtil().setWidth(10)),
                                        GestureDetector(
                                          behavior: HitTestBehavior.translucent,
                                          onTap: () {
                                            context.push(
                                                CommonUtils.getRealHash(
                                                    'coinDetail'));
                                          },
                                          child: Text(
                                            CommonUtils.txt('jbmx'),
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: ScreenUtil().setSp(15),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                            width: ScreenUtil().setWidth(20))
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Container(
                            color: GQStyle.bgColor,
                            child: Column(
                              children: [
                                SizedBox(height: ScreenUtil().setWidth(30)),
                                GridView.count(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: GQStyle.pagePadding),
                                  shrinkWrap: true,
                                  crossAxisCount: 3,
                                  mainAxisSpacing: 13,
                                  crossAxisSpacing: 13,
                                  childAspectRatio: 94 / 114,
                                  scrollDirection: Axis.vertical,
                                  physics: NeverScrollableScrollPhysics(),
                                  children: products
                                      .map((e) => GestureDetector(
                                            behavior:
                                                HitTestBehavior.translucent,
                                            onTap: () {
                                              selectP = e;
                                              setState(() {});
                                            },
                                            child: CoinItemContainer(
                                              product: e,
                                              selP: selectP,
                                            ),
                                          ))
                                      .toList(),
                                ),
                                SizedBox(height: ScreenUtil().setWidth(30))
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  )),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color.fromRGBO(27, 27, 32, 1),
                          Color.fromRGBO(31, 32, 40, 1),
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: ScreenUtil().setWidth(10)),
                        GestureDetector(
                          onTap: () {
                            showPay(selectP, product_vip_text);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                gradient: GQStyle.btnGradient_e4b191_f6dec7,
                                borderRadius: BorderRadius.all(Radius.circular(
                                    ScreenUtil().setWidth(20)))),
                            width: ScreenUtil().screenWidth -
                                GQStyle.pagePadding * 2,
                            height: ScreenUtil().setWidth(40),
                            child: Center(
                              child: Text(
                                CommonUtils.txt('ljzf') +
                                    " ¥${selectP["promo_price_yuan"].split(".").first}",
                                style: TextStyle(
                                  color: Color(0xFF60260c),
                                  fontSize: ScreenUtil().setSp(17.8),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: ScreenUtil().setWidth(10)),
                        GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () {
                            context.push(
                                CommonUtils.getRealHash('customerService'));
                          },
                          child: Text.rich(TextSpan(
                              text: CommonUtils.txt('zflx') + ' ',
                              style: TextStyle(
                                color: Color(0xFFc6c7c9),
                                fontSize: ScreenUtil().setSp(10),
                              ),
                              children: [
                                TextSpan(
                                    text: CommonUtils.txt('zxkf'),
                                    style: TextStyle(
                                      color: Color(0xFF9dbbf9),
                                      fontSize: ScreenUtil().setSp(10),
                                    ))
                              ])),
                        ),
                        SizedBox(
                            height: ScreenUtil()
                                .setWidth(ScreenUtil().setWidth(20)))
                      ],
                    ),
                  )
                ],
              );
  }

  @override
  void onDestroy() {
    // TODO: implement onDestroy
  }
}

class CoinItemContainer extends StatefulWidget {
  final Map product;
  final Map selP;
  CoinItemContainer({
    Key key,
    this.product,
    this.selP,
  }) : super(key: key);

  @override
  _CoinItemContainerState createState() => _CoinItemContainerState();
}

class _CoinItemContainerState extends State<CoinItemContainer> with PayMixin {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            SizedBox(height: ScreenUtil().setWidth(8)),
            Container(
              decoration: BoxDecoration(
                  border: Border.all(
                      color: widget.product == widget.selP
                          ? Color(0xFFdaa78b)
                          : Colors.transparent,
                      width: 2.0),
                  gradient: LinearGradient(
                    colors: widget.product == widget.selP
                        ? [Color(0xFFffefdc), Color(0xFFf7dcbc)]
                        : [Color(0xFF2a2a42), Color(0xFF2a2a42)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(13))),
              width: ScreenUtil().setWidth(114),
              height: ScreenUtil().setWidth(120),
              padding:
                  EdgeInsets.symmetric(vertical: ScreenUtil().setWidth(10)),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.product["pname"],
                      style: widget.product == widget.selP
                          ? GQStyle.brown72_18
                          : GQStyle.brown248_18,
                    ),
                    // SizedBox(height: ScreenUtil().setWidth(14)),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Text(
                        "¥",
                        style: TextStyle(
                            fontSize: ScreenUtil().setWidth(18),
                            color: widget.product == widget.selP
                                ? Color(0xFF48170e)
                                : Color(0xFFffffff),
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        widget.product["promo_price_yuan"].split(".").first,
                        style: TextStyle(
                            fontSize: ScreenUtil().setWidth(30),
                            color: widget.product == widget.selP
                                ? Color(0xFF48170e)
                                : Color(0xFFffffff),
                            fontWeight: FontWeight.bold),
                      )
                    ]),
                    // SizedBox(height: ScreenUtil().setWidth(9)),
                    Text(
                      widget.product["price_yuan"].split(".").first,
                      style: TextStyle(
                        fontSize: ScreenUtil().setWidth(15),
                        color: widget.product == widget.selP
                            ? Color(0xFF7f3b29)
                            : Color(0xFFa1a1b2),
                        decoration: TextDecoration.lineThrough,
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
        widget.product["give_tip"] != null &&
                widget.product["give_tip"].length > 0
            ? Positioned(
                top: 0,
                left: 0,
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: ScreenUtil().setWidth(8)),
                  height: ScreenUtil().setWidth(20),
                  decoration: BoxDecoration(
                    gradient: GQStyle.btnGradient_e4b191_f6dec7,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(ScreenUtil().setWidth(10)),
                        bottomRight:
                            Radius.circular(ScreenUtil().setWidth(10))),
                  ),
                  child: Center(
                    child: Text(
                      "${widget.product["give_tip"] ?? "未知"}",
                      style: TextStyle(
                        color: Color.fromRGBO(46, 24, 12, 1),
                        fontSize: ScreenUtil().setSp(10),
                        decoration: TextDecoration.none,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              )
            : Container()
      ],
    );
  }
}
