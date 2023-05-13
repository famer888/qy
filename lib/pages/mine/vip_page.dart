import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/style.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:qypj/base/baseWidget.dart';
import 'package:qypj/pages/mine/setup.dart';
import 'package:qypj/store/homeConfig.dart';
import 'package:qypj/utils/extensionlibrary.dart';
import 'package:provider/provider.dart';
import 'package:universal_html/html.dart' as html;
import 'package:qypj/components/page_status.dart';
import 'package:qypj/model/basic.dart';
import 'package:qypj/routers.dart';
import 'package:qypj/theme/default.dart';
import 'package:qypj/utils/api.dart';
import 'package:qypj/mixin/payMixin.dart';
import 'package:qypj/utils/common.dart';
import 'package:qypj/utils/networkImage.dart';

class VipPage extends BaseWidget {
  VipPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> cState() {
    // TODO: implement cState
    return _VipPageState();
  }
}

class _VipPageState extends BaseWidgetState<VipPage> with PayMixin {
  final tabController = PageController();

  int currentTab = 0;
  String pageStatus = 'loading';
  List<dynamic> products = [];
  List<dynamic> exps = [];
  dynamic selectP;
  bool networkErr = false;
  List rightsList = [];
  String product_vip_text = "";

  _initPage() async {
    try {
      Basic res = await getProductOfVIP();
      if (res == null) {
        networkErr = true;
        setState(() {});
        return;
      }
      CommonUtils.debugPrint(res.data);
      products = res.data["product"];
      product_vip_text = res.data["product_vip_text"];
      selectP = products.first;

      if (products.length > 0) {
        var firse = products[0];
        if (firse['right'] != null) {
          rightsList.addAll(firse['right']);
        }
        _getExp();
      }
    } catch (err) {
      CommonUtils.debugPrint(err);
      pageStatus = 'error';
      setState(() {});
    }
  }

  _getExp() {
    getExpOfVIP().then((res) {
      if (res.status == 1) {
        pageStatus = 'ready';
        exps = List.from(res.data["list"]);
        setState(() {});
      } else {
        pageStatus = 'error';
        setState(() {});
      }
    });
  }

  Widget _qyItem({String logo, String title, String text}) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: ScreenUtil().setWidth(50),
            height: ScreenUtil().setWidth(50),
            child: PlatformAwareNetworkImage(
              url: logo,
              fit: BoxFit.fitHeight,
              background: Colors.transparent,
              nofigure: true,
            ),
          ),
          SizedBox(
            height: ScreenUtil().setWidth(6.5),
          ),
          SizedBox(
            height: ScreenUtil().setSp(20),
            child: Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: ScreenUtil().setSp(13),
                fontWeight: FontWeight.w500,
                fontFamily: GQStyle.hanyi,
              ),
              maxLines: 1,
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: ScreenUtil().setWidth(7),
          ),
          SizedBox(
            height: ScreenUtil().setWidth(35),
            child: Text(
              text,
              style: TextStyle(
                color: Color(0xFFadadad),
                fontSize: ScreenUtil().setSp(12),
              ),
              maxLines: 2,
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
    );
  }

  void onIndexChanged() {
    var firse = selectP;
    rightsList = firse['right'] != null ? firse['right'] : [];
    setState(() {});
  }

  @override
  Widget pageBody(BuildContext context) {
    var members = Provider.of<HomeConfig>(context, listen: true).member;
    String tempTime = members?.expiredAt.toString().split(' ')[0];
    return networkErr
        ? Container(
            width: double.infinity,
            child: PageStatus.noNetWork(onTap: () {
              networkErr = false;
              setState(() {});
              _initPage();
            }),
          )
        : pageStatus == 'loading'
            ? PageStatus.loading(mounted)
            : pageStatus == 'error'
                ? PageStatus.noData()
                : Stack(children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                            child: Container(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: GQStyle.pagePadding),
                                  height: ScreenUtil().setWidth(86),
                                  child: Row(
                                    children: [
                                      Container(
                                        child: ClipRRect(
                                          clipBehavior: Clip.hardEdge,
                                          borderRadius: BorderRadius.circular(
                                              ScreenUtil().setWidth(33.5)),
                                          child: Container(
                                            height: ScreenUtil().setWidth(67),
                                            width: ScreenUtil().setWidth(67),
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: [
                                                  Color(0xffdfab8f),
                                                  Color(0xffcf8856),
                                                ],
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                              ),
                                            ),
                                            child: Center(
                                                child: ClipRRect(
                                              clipBehavior: Clip.hardEdge,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      ScreenUtil()
                                                          .setWidth(31.5)),
                                              child: Container(
                                                width:
                                                    ScreenUtil().setWidth(63),
                                                height:
                                                    ScreenUtil().setWidth(63),
                                                child: UserAvatar(),
                                              ),
                                            )),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                          width: ScreenUtil().setWidth(13)),
                                      Expanded(
                                          child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(members.nickname,
                                                  style: GQStyle.white255_14),
                                              SizedBox(
                                                  width: ScreenUtil()
                                                      .setWidth(10)),
                                              CommonUtils.memberVip(
                                                  members?.vip_str)
                                            ],
                                          ),
                                          SizedBox(
                                              height:
                                                  ScreenUtil().setWidth(10)),
                                          Text(
                                            members.vipLevel < 1
                                                ? CommonUtils.txt('khykp')
                                                : CommonUtils.txt('dqrq') +
                                                    ' $tempTime' +
                                                    " ${kIsWeb ? "" : "${CommonUtils.txt('syxzcs')}：${members.video_download_value}"}",
                                            style: GQStyle.gray163_12,
                                          ),
                                        ],
                                      ))
                                    ],
                                  ),
                                ),
                                Container(
                                  child: Column(
                                    children: [
                                      SizedBox(
                                          height: ScreenUtil().setWidth(20)),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: GQStyle.pagePadding),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              CommonUtils.txt("ktvpxs"),
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize:
                                                    ScreenUtil().setSp(15),
                                              ),
                                            ),
                                            Text(
                                              CommonUtils.txt("zmzxs"),
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize:
                                                    ScreenUtil().setSp(15),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                          height: ScreenUtil().setWidth(13)),
                                      Container(
                                        height: ScreenUtil().setWidth(130),
                                        child: ListView(
                                          physics: BouncingScrollPhysics(),
                                          scrollDirection: Axis.horizontal,
                                          children: products
                                              .map((e) => GestureDetector(
                                                    behavior: HitTestBehavior
                                                        .translucent,
                                                    onTap: () {
                                                      selectP = e;
                                                      onIndexChanged();
                                                    },
                                                    child: Row(children: [
                                                      SizedBox(
                                                          width: ScreenUtil()
                                                              .setWidth(15)),
                                                      VIPItemContainer(
                                                        product: e,
                                                        selP: selectP,
                                                      ),
                                                    ]),
                                                  ))
                                              .toList(),
                                        ),
                                      ),
                                      SizedBox(
                                          height: ScreenUtil().setWidth(20)),
                                      GridView(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: GQStyle.pagePadding),
                                        shrinkWrap: true,
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 4, //横轴三个子widget
                                          childAspectRatio:
                                              0.65, //宽高比为1时，子widget
                                          crossAxisSpacing:
                                              ScreenUtil().setWidth(10),
                                          mainAxisSpacing:
                                              ScreenUtil().setWidth(10),
                                        ),
                                        physics: NeverScrollableScrollPhysics(),
                                        children: rightsList
                                            .asMap()
                                            .keys
                                            .map((e) => Container(
                                                  child: _qyItem(
                                                      logo: rightsList[e]
                                                          ['img'],
                                                      text: rightsList[e]
                                                          ['desc'],
                                                      title: rightsList[e]
                                                          ['name']),
                                                ))
                                            .toList(),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  child: Column(children: [
                                    SizedBox(height: ScreenUtil().setWidth(25)),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: GQStyle.pagePadding),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            CommonUtils.txt("jfdh"),
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: ScreenUtil().setSp(15),
                                            ),
                                          ),
                                          Text(
                                            "${CommonUtils.txt("dqjf")}${members.exp}",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: ScreenUtil().setSp(15),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: ScreenUtil().setWidth(13)),
                                    Container(
                                      height: ScreenUtil().setWidth(154),
                                      child: ListView(
                                        physics: BouncingScrollPhysics(),
                                        scrollDirection: Axis.horizontal,
                                        children: exps
                                            .map((e) => Row(children: [
                                                  SizedBox(
                                                      width: ScreenUtil()
                                                          .setWidth(15)),
                                                  TegItemContainer(
                                                    exp: e,
                                                  ),
                                                ]))
                                            .toList(),
                                      ),
                                    )
                                  ]),
                                ),
                                SizedBox(height: ScreenUtil().setWidth(25)),
                              ],
                            ),
                          ),
                        )),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFF111127), Color(0xFF111127)],
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
                                          GQStyle.btnGradient_e4b191_f6dec7,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(
                                              ScreenUtil().setWidth(20)))),
                                  width: ScreenUtil().screenWidth -
                                      GQStyle.pagePadding * 2,
                                  height: ScreenUtil().setWidth(40),
                                  child: Stack(
                                    children: [
                                      Positioned.fill(
                                        child: Center(
                                          child: RichText(
                                              text: TextSpan(
                                            text: CommonUtils.txt('ljzf') +
                                                " ¥${selectP["promo_price_yuan"].split(".").first}",
                                            style: TextStyle(
                                              color: Color(0xFF60260c),
                                              fontSize:
                                                  ScreenUtil().setSp(17.8),
                                              fontWeight: FontWeight.w500,
                                            ),
                                          )),
                                        ),
                                      ),
                                      // Text(
                                      //   CommonUtils.txt('ljzf') +
                                      //       " ¥${selectP["promo_price_yuan"].split(".").first}",
                                      //   style: TextStyle(
                                      //     color: Color(0xFF60260c),
                                      //     fontSize: ScreenUtil().setSp(17.8),
                                      //     fontWeight: FontWeight.w500,
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: ScreenUtil().setWidth(10)),
                              GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onTap: () {
                                  context.push(CommonUtils.getRealHash(
                                      'customerService'));
                                },
                                child: Text.rich(TextSpan(
                                    text: CommonUtils.txt('zflx'),
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
                              SizedBox(height: ScreenUtil().setWidth(20))
                            ],
                          ),
                        )
                      ],
                    ),
                  ]);
  }

  // @override
  // Widget backGroundView() {
  //   // TODO: implement backGroundView
  //   return Container(
  //     width: ScreenUtil().screenWidth,
  //     height: ScreenUtil().screenWidth / 375 * 378,
  //     child: LImage(
  //       "vp_head_n",
  //       width: double.infinity,
  //       height: double.infinity,
  //     ),
  //   );
  // }

  @override
  void onCreate() {
    // TODO: implement onCreate
    setAppTitle(
      title: CommonUtils.txt('hyzx'),
      rightW: GestureDetector(
        onTap: () {
          String path = CommonUtils.getRealHash('RechargeRecord/1');
          context.push(path);
          // context.push(CommonUtils.getRealHash('RechargeRecord/1'));
        },
        child: Text(
          CommonUtils.txt('czjl'),
          style: GQStyle.gray150_14,
        ),
      ),
      navColor: Colors.transparent,
    );
    _initPage();
  }

  @override
  void onDestroy() {
    // TODO: implement onDestroy
  }
}

class VIPItemContainer extends StatefulWidget {
  final Map product;
  final Map selP;
  VIPItemContainer({
    Key key,
    this.product,
    this.selP,
  }) : super(key: key);

  @override
  _VIPItemContainerState createState() => _VIPItemContainerState();
}

class _VIPItemContainerState extends State<VIPItemContainer> with PayMixin {
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
                          ? Color(0xFFdaa78b)
                          : Colors.transparent,
                      width: 2.0),
                  // color: widget.product == widget.selP
                  //     ? Color(0xFFFFEFDC)
                  //     : Color(0xFF36394A),
                  gradient: LinearGradient(
                    colors: widget.product == widget.selP
                        ? [Color(0xFFffefdc), Color(0xFFf7dcbc)]
                        : [Color(0xFF2a2a42), Color(0xFF2a2a42)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(7))),
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
                      "¥" + widget.product["price_yuan"].split(".").first,
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

class TegItemContainer extends StatefulWidget {
  final Map exp;
  TegItemContainer({
    Key key,
    this.exp,
  }) : super(key: key);

  @override
  _TegItemContainerState createState() => _TegItemContainerState();
}

class _TegItemContainerState extends State<TegItemContainer> with PayMixin {
  @override
  Widget build(BuildContext context) {
    var members = Provider.of<HomeConfig>(context, listen: true).member;
    return Stack(
      children: [
        Column(
          children: [
            Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFFffefdc),
                      Color(0xFFf5e4d4),
                      Color(0xFFf7dcbc)
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(7))),
              width: ScreenUtil().setWidth(114),
              height: ScreenUtil().setWidth(120),
              padding:
                  EdgeInsets.symmetric(vertical: ScreenUtil().setWidth(10)),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.exp["vip_str"] ?? "",
                      style: TextStyle(
                        color: Color(0xFF48170e),
                        fontSize: ScreenUtil().setSp(15),
                      ),
                    ),
                    SizedBox(height: ScreenUtil().setWidth(10)),
                    Text(
                      widget.exp["exp_str"] ?? "",
                      style: TextStyle(
                        color: Color(0xFF7f3b29),
                        fontSize: ScreenUtil().setSp(20),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: ScreenUtil().setWidth(10)),
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                if (members.exp == 0) {
                  CommonUtils.showText(CommonUtils.txt("jfyebz"));
                  return;
                }
                CommonUtils.startLoadGIF(tip: CommonUtils.txt("dhz"));
                expConvertVIP(id: widget.exp["id"] ?? "").then((res) {
                  if (res.status == 1) {
                    CommonUtils.showText(res.msg);

                    getUserInfo(context).then((ult) {
                      BotToast.closeAllLoading();
                      context.pop();
                    });
                  } else {
                    BotToast.closeAllLoading();
                    CommonUtils.showText(res.msg);
                  }
                });
              },
              child: Container(
                height: ScreenUtil().setWidth(24),
                width: ScreenUtil().setWidth(114),
                decoration: BoxDecoration(
                  color: Color(0xFF3d4255),
                  borderRadius: BorderRadius.all(
                      Radius.circular(ScreenUtil().setWidth(12))),
                ),
                child: Center(
                  child: RichText(
                      text: TextSpan(
                    text: CommonUtils.txt("dh"),
                    style: GQStyle.white255_12,
                  )),
                  //  RichText(
                  //   text:
                  //   style: GQStyle.white255_12,
                  //   textAlign: TextAlign.center,
                  // ),
                ),
              ),
            )
          ],
        ),
      ],
    );
  }
}
