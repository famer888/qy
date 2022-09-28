import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:qypj/base/baseWidget.dart';
import 'package:qypj/components/common/pagetitlebar.dart';
import 'package:qypj/components/common/pullrefreshlist.dart';
import 'package:qypj/components/page_status.dart';
import 'package:qypj/model/appcenter.dart';
import 'package:qypj/model/feedback.dart';
import 'package:qypj/theme/default.dart';
import 'package:qypj/utils/api.dart';
import 'package:qypj/utils/common.dart';
import 'package:qypj/utils/networkImage.dart';

class AppCenter extends BaseWidget {
  AppCenter({Key key}) : super(key: key);

  @override
  _AppCenterState cState() => _AppCenterState();
}

class _AppCenterState extends BaseWidgetState<AppCenter> {
  bool isLoading = true;
  List banner = [];
  List appList = [];

  @override
  void onCreate() {
    setAppTitle(title: CommonUtils.txt('yyzx'));
    getData();
  }

  getData() async {
    AppCenterModel result = await getAppCenter();
    if (result != null && result.data != null) {
      setState(() {
        banner.addAll(result.data.banner);
        appList.addAll(result.data.apps);
        isLoading = false;
      });
    }
  }

  onRefreshPost() {
    banner = [];
    appList = [];
    setState(() {});
    getData();
  }

  Widget applicationColumn() {
    List<Widget> tiles = [];
    Widget content;
    for (int i = 0; i < appList.length; i++) {
      tiles.add(
        ApplicationItem(
          id: appList[i].id,
          appname: appList[i].title,
          iconurl: appList[i].imgUrl,
          des: appList[i].description,
          clicked: appList[i].clicked,
          link: appList[i].linkUrl,
        ),
      );
    }
    content = new Column(
      children: tiles,
    );
    return content;
  }

  @override
  void onDestroy() {
    // TODO: implement onDestroy
  }

  @override
  Widget pageBody(BuildContext context) {
    return isLoading
        ? PageStatus.loading(mounted)
        : PullRefreshList(
            onRefresh: onRefreshPost,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SwiperContainer(
                  banner: banner,
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: GQStyle.pagePadding,
                    top: ScreenUtil().setWidth(44),
                    bottom: ScreenUtil().setWidth(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      LImage(
                        'wd_dayqw_n',
                        width: ScreenUtil().setWidth(20),
                        height: ScreenUtil().setWidth(20),
                      ),
                      SizedBox(
                        width: ScreenUtil().setWidth(5),
                      ),
                      Text(
                        CommonUtils.txt('djzw'),
                        style: GQStyle.white255_16_M,
                      )
                    ],
                  ),
                ),
                Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: ScreenUtil().setWidth(16)),
                    child: applicationColumn()),
              ],
            ),
          );
  }
}

class SwiperContainer extends StatefulWidget {
  final List banner;
  SwiperContainer({Key key, this.banner}) : super(key: key);

  @override
  _SwiperContainerState createState() => _SwiperContainerState();
}

class _SwiperContainerState extends State<SwiperContainer> {
  List _banner = [];
  @override
  void initState() {
    super.initState();
    _banner = widget.banner;
  }

  _onTapSwiper(int index) {
    if (_banner.length == 0) return;
    var item = _banner[index];
    var type = item.type;
    var _adsUrl = item.url;
    if (['', null, false].contains(_adsUrl)) {
      BotToast.showText(text: CommonUtils.txt('wplj'), align: Alignment(0, 0));
      return;
    }
    switch (type) {
      case 1:
        // 外部浏览器
        CommonUtils.launchURL("$_adsUrl");
        break;
      case 3:
        // 外部浏览器
        CommonUtils.launchURL("$_adsUrl");
        break;
      case 4:
        // 外部浏览器
        CommonUtils.launchURL("$_adsUrl");
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return _banner.length > 1
        ? SizedBox(
            height: ScreenUtil().setWidth(160),
            child: Swiper(
              onTap: (index) {
                _onTapSwiper(index);
              },
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  width: ScreenUtil().setWidth(315),
                  height: ScreenUtil().setWidth(150),
                  child: ClipRRect(
                    borderRadius:
                        BorderRadius.circular(ScreenUtil().setWidth(10)),
                    child: PlatformAwareNetworkImage(
                      url: _banner[index].imgUrl,
                    ),
                  ),
                );
              },
              itemCount: _banner.length,
              autoplay: _banner.length > 1,
              viewportFraction: 0.8,
              scale: 0.9,
            ))
        : Container(
            width: double.infinity,
            height: _banner.length == 1 ? ScreenUtil().setWidth(150) : 0,
            child: _banner.length == 1
                ? GestureDetector(
                    onTap: () {
                      CommonUtils.launchURL("${_banner[0].url}");
                    },
                    child: PlatformAwareNetworkImage(
                      url: _banner[0].imgUrl,
                    ),
                  )
                : SizedBox(),
          );
  }
}

class ApplicationItem extends StatefulWidget {
  final int id;
  final String appname;
  final String iconurl;
  final String des;
  final int clicked;
  final String link;
  ApplicationItem(
      {Key key,
      this.appname,
      this.iconurl,
      this.des,
      this.link,
      this.clicked,
      this.id})
      : super(key: key);

  @override
  _ApplicationItemState createState() => _ApplicationItemState();
}

class _ApplicationItemState extends State<ApplicationItem> {
  dynamic clickNumber;

  renderFixedNumber(double value) {
    var tips;
    if (value >= 10000) {
      var newvalue = (value / 1000) / 10.round();
      tips = formatNum(newvalue, 2) + CommonUtils.txt('w');
    } else if (value >= 1000) {
      var newvalue = (value / 100) / 10.round();
      tips = formatNum(newvalue, 2) + CommonUtils.txt('qa');
    } else {
      tips = value.toString();
    }
    return tips;
  }

  formatNum(double number, int postion) {
    if ((number.toString().length - number.toString().lastIndexOf(".") - 1) <
        postion) {
      //小数点后有几位小数
      return number
          .toStringAsFixed(postion)
          .substring(0, number.toString().lastIndexOf(".") + postion + 1)
          .toString();
    } else {
      return number
          .toString()
          .substring(0, number.toString().lastIndexOf(".") + postion + 1)
          .toString();
    }
  }

  @override
  void initState() {
    super.initState();
    clickNumber = renderFixedNumber(widget.clicked * 1.0);
  }

  _onTapSwiper() {
    var _adsUrl = widget.link;
    if (['', null, false].contains(_adsUrl)) {
      BotToast.showText(text: CommonUtils.txt('wplj'), align: Alignment(0, 0));
      return;
    }
    // 外部浏览器
    CommonUtils.launchURL("$_adsUrl");
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        _onTapSwiper();
      },
      child: Padding(
        padding: EdgeInsets.only(bottom: ScreenUtil().setWidth(26.5)),
        child: Row(
          children: [
            Expanded(
                child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: EdgeInsets.only(right: ScreenUtil().setWidth(13)),
                  height: ScreenUtil().setWidth(64),
                  width: ScreenUtil().setWidth(64),
                  child: ClipRRect(
                    borderRadius:
                        BorderRadius.circular(ScreenUtil().setWidth(10)),
                    child: PlatformAwareNetworkImage(url: widget.iconurl),
                  ),
                ),
                Expanded(
                    child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${widget.appname}',
                        style: GQStyle.white255_14_B,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        '$clickNumber' + CommonUtils.txt('cxz'),
                        style: GQStyle.gray150_12,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        '${widget.des}',
                        style: GQStyle.gray150_12,
                      ),
                    ],
                  ),
                ))
              ],
            )),
            Container(
              width: ScreenUtil().setWidth(60),
              height: ScreenUtil().setWidth(25),
              decoration: BoxDecoration(
                gradient: GQStyle.btnGradient_ff00edfd_ffbbe954,
                borderRadius: BorderRadius.all(
                    Radius.circular(ScreenUtil().setWidth(12.5))),
              ),
              child: Center(
                child: Text(
                  CommonUtils.txt('xz'),
                  style: GQStyle.white255_14,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
