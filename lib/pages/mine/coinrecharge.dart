import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qypj/utils/extensionlibrary.dart';
import 'package:provider/provider.dart';
import 'package:qypj/components/common/pagetitlebar.dart';
import 'package:qypj/components/page_status.dart';
import 'package:qypj/mixin/payMixin.dart';
import 'package:qypj/model/basic.dart';
import 'package:qypj/store/homeConfig.dart';
import 'package:qypj/theme/default.dart';
import 'package:qypj/utils/api.dart';
import 'package:qypj/utils/common.dart';

class CoinRecharge extends StatefulWidget {
  CoinRecharge({Key key}) : super(key: key);

  @override
  _CoinRechargeState createState() => _CoinRechargeState();
}

class _CoinRechargeState extends State<CoinRecharge> with PayMixin {
  String pageStatus = 'loading';
  List products;
  dynamic selectP;
  bool networkErr = false;
  String product_vip_text = "";
  @override
  void initState() {
    super.initState();
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
  Widget build(BuildContext context) {
    int money = Provider.of<HomeConfig>(context).member.money ?? 0;
    return Scaffold(
        body: SafeArea(
            child: Column(
      children: [
        PageTitleBar(
          title: CommonUtils.txt('jbgm'),
          rightWidget: GestureDetector(
            onTap: () {
              context.push(CommonUtils.getRealHash('RechargeRecord/1'));
            },
            child: Text(
              CommonUtils.txt('czjl'),
              style: GQStyle.gray150_14,
            ),
          ),
        ),
        networkErr
            ? Expanded(child: PageStatus.noNetWork(onTap: () {
                networkErr = false;
                setState(() {});
                _initPage();
              }))
            : pageStatus == 'loading'
                ? Expanded(child: PageStatus.loading(mounted))
                : Expanded(
                    child: Column(
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
                                          gradient: LinearGradient(
                                            colors: [
                                              Color.fromRGBO(5, 42, 54, 1.0),
                                              Color.fromRGBO(5, 42, 54, 1.0)
                                            ],
                                            begin: Alignment.centerLeft,
                                            end: Alignment.centerRight,
                                          ),
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
                                                width:
                                                    ScreenUtil().setWidth(20)),
                                            Text(
                                              CommonUtils.txt('jbye'),
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize:
                                                      ScreenUtil().setSp(15),
                                                  fontFamily: GQStyle.hanyi),
                                            ),
                                            SizedBox(
                                                width:
                                                    ScreenUtil().setWidth(10)),
                                            SizedBox(
                                              height: ScreenUtil().setWidth(24),
                                              width: ScreenUtil().setWidth(0.5),
                                              child: Container(
                                                  color: Colors.white),
                                            ),
                                            SizedBox(
                                                width:
                                                    ScreenUtil().setWidth(10)),
                                            Expanded(
                                              child: Text(
                                                money.toString(),
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize:
                                                      ScreenUtil().setSp(38),
                                                  fontWeight: FontWeight.bold,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                maxLines: 1,
                                              ),
                                            ),
                                            SizedBox(
                                                width:
                                                    ScreenUtil().setWidth(10)),
                                            GestureDetector(
                                              behavior:
                                                  HitTestBehavior.translucent,
                                              onTap: () {
                                                context.push(
                                                    CommonUtils.getRealHash(
                                                        'coinDetail'));
                                              },
                                              child: Text(
                                                CommonUtils.txt('jbmx'),
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize:
                                                      ScreenUtil().setSp(15),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                                width:
                                                    ScreenUtil().setWidth(20))
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
                            colors: [Color(0xFF1d212b), Color(0xFF363c51)],
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
                                    gradient:
                                        GQStyle.btnGradient_ff00edfd_ffbbe954,
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(
                                            ScreenUtil().setWidth(20)))),
                                width: ScreenUtil().screenWidth -
                                    GQStyle.pagePadding * 2,
                                height: ScreenUtil().setWidth(40),
                                child: Center(
                                  child: Text(
                                    CommonUtils.txt('ljzf') +
                                        " ¥${selectP["promo_price_yuan"].split(".").first}",
                                    style: GQStyle.white255_15,
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
                                          color: Color(0xFF00edfd),
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
                  )),
      ],
    )));
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
            SizedBox(
              height: ScreenUtil().setWidth(8),
            ),
            Container(
              decoration: BoxDecoration(
                  border: Border.all(
                      color: widget.product == widget.selP
                          ? Color(0xFF006077)
                          : Colors.transparent,
                      width: 1.0),
                  color: Color(0xFF052a36),
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
                      style: GQStyle.white255_18_M,
                    ),
                    // SizedBox(height: ScreenUtil().setWidth(14)),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Text(
                        "¥",
                        style: TextStyle(
                            fontSize: ScreenUtil().setWidth(18.2),
                            color: Color(0xFF00edfb),
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        widget.product["promo_price_yuan"].split(".").first,
                        style: TextStyle(
                            fontSize: ScreenUtil().setWidth(25),
                            color: Color(0xFF00edfb),
                            fontWeight: FontWeight.bold),
                      )
                    ]),
                    // SizedBox(height: ScreenUtil().setWidth(9)),
                    Text(
                      widget.product["price_yuan"].split(".").first,
                      style: TextStyle(
                        fontSize: ScreenUtil().setWidth(12),
                        color: Color(0xffffffff),
                        fontWeight: FontWeight.w500,
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
                    color: Color(0xFF006077),
                    // gradient: LinearGradient(
                    //   colors: [Color(0xFFbbe954), Color(0xFF00edfd)],
                    //   begin: Alignment.centerLeft,
                    //   end: Alignment.centerRight,
                    // ),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(ScreenUtil().setWidth(10)),
                        bottomRight:
                            Radius.circular(ScreenUtil().setWidth(10))),
                  ),
                  child: Center(
                    child: Text(
                      "${widget.product["give_tip"] ?? "未知"}",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: ScreenUtil().setSp(11),
                        decoration: TextDecoration.none,
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
