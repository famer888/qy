import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qypj/theme/default.dart';
import 'package:qypj/utils/app_route_observer.dart';
import 'package:qypj/utils/common.dart';

abstract class BaseWidget extends StatefulWidget {
  final Key key;
  BaseWidget({this.key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => cState();

  State<StatefulWidget> cState();
}

abstract class BaseWidgetState<T extends BaseWidget> extends State<T>
    with RouteAware {
  String _appTitle = "";
  Color _bgColor = GQStyle.bgColor;
  Color _navColor = GQStyle.bgColor;
  bool _navBack = false;
  BuildContext _mContext;
  Widget _rightW;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();

    /// 路由订阅
    AppRouteObserver().routeObserver.subscribe(this, ModalRoute.of(context));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    onCreate();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build 统一布局基础页面
    _mContext = context;
    int type = CommonUtils.platform();
    if (type == 2) {
      return Scaffold(
        body: Stack(children: [
          backGroundView(),
          Column(
            children: [appbar(), Expanded(child: pageBody(context))],
          )
        ]),
        backgroundColor: _bgColor,
      );
    } else if (type == 0) {
      return Scaffold(
        primary: false,
        appBar: PreferredSize(child: Container(), preferredSize: Size.zero),
        body: SafeArea(
            child: Stack(children: [
          backGroundView(),
          Column(
            children: [appbar(), Expanded(child: pageBody(context))],
          )
        ])),
        backgroundColor: _bgColor,
      );
    } else {
      return Scaffold(
        body: Stack(children: [
          backGroundView(),
          Column(
            children: [appbar(), Expanded(child: pageBody(context))],
          )
        ]),
        backgroundColor: _bgColor,
      );
    }
  }

  @override
  void dispose() {
    /// 取消路由订阅
    AppRouteObserver().routeObserver.unsubscribe(this);
    beforeDispose();
    super.dispose();
    onDestroy();
  }

  //页面初始化
  void onCreate();
  //页面布局
  Widget pageBody(BuildContext context);
  //页面销毁
  void onDestroy();
  //初始化之前的操作
  void beforeInit() {}
  //销毁之前的操作
  void beforeDispose() {}
  /*
    销毁页面
   */
  void finish() {
    Navigator.pop(context);
  }

  Widget backGroundView() {
    return Container();
  }

  /*
   *  公用的AppBar的title
   */
  void setAppTitle(
      {String title = "",
      Color navColor = const Color.fromRGBO(11, 11, 33, 1),
      Color bgColor = const Color.fromRGBO(11, 11, 33, 1),
      Widget rightW}) {
    _appTitle = title;
    _rightW = rightW;
    _navColor = navColor;
    _bgColor = bgColor;
    setState(() {});
  }

  //加载动画
  void initLoadGIF({String tip = "发布中"}) {
    BotToast.showCustomLoading(toastBuilder: (cancelFunc) {
      return Container(
        padding: const EdgeInsets.all(15),
        decoration: const BoxDecoration(
          color: Color.fromRGBO(54, 54, 54, 0.8),
          borderRadius: BorderRadius.all(Radius.circular(4)),
        ),
        height: ScreenUtil().setWidth(110),
        width: ScreenUtil().setWidth(110),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // LImage("ref_data_n",
            //     width: ScreenUtil().setWidth(40),
            //     height: ScreenUtil().setWidth(40),
            //     ext: ".gif"),
            CircularProgressIndicator(
              color: GQStyle.jellyCyanColor103224185,
            ),
            SizedBox(
              height: ScreenUtil().setWidth(12),
            ),
            Text(tip, style: GQStyle.white255_14)
          ],
        ),
      );
    });
  }

  /*
   * 继承该基类的公用的AppBar 
   * 1.有标题默认正常标题栏；
   * 2.无标题为空，可以根据自身组件写标题组件或则调用appbar重写标题
   */
  Widget appbar() {
    return _navBack
        ? Column(
            children: [
              Container(
                height: MediaQuery.of(context).padding.top,
                color: _navColor,
              ),
              Container(
                color: _navColor,
                padding: EdgeInsets.symmetric(horizontal: GQStyle.pagePadding),
                height: GQStyle.navbarHegiht,
                child: Stack(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          child: SizedBox(
                            height: double.infinity,
                            child: LImage(
                              "nav_back_n",
                              width: ScreenUtil().setWidth(20),
                              height: ScreenUtil().setWidth(20),
                            ),
                          ),
                          onTap: () {
                            finish();
                          },
                        ),
                        _rightW == null ? Container() : _rightW
                      ],
                    ),
                    Center(
                      child: Text(_appTitle, style: GQStyle.white255_18_B),
                    ),
                    SizedBox(
                      width: ScreenUtil().setWidth(20),
                      height: ScreenUtil().setWidth(20),
                    )
                  ],
                ),
              )
            ],
          )
        : Container();
  }

  // Called when the current route has been pushed.
  // 当前的页面被push显示到用户面前 viewWillAppear.
  @override
  void didPush() {
    if (Navigator.canPop(context)) {
      _navBack = true;
      setState(() {});
    }
  }

  /// Called when the current route has been popped off.
  /// 当前的页面被pop viewWillDisappear.
  @override
  void didPop() {}

  /// Called when the top route has been popped off, and the current route
  /// shows up.
  /// 上面的页面被pop后当前页面被显示时 viewWillAppear.
  @override
  void didPopNext() {}

  /// Called when a new route has been pushed, and the current route is no
  /// longer visible.
  /// 从当前页面push到另一个页面 viewWillDisappear.
  @override
  void didPushNext() {}
}
