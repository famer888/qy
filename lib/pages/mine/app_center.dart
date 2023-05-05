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
import 'package:qypj/views/general_banner.dart';

class AppCenter extends StatefulWidget {
  AppCenter({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _AppCenterState();
  }
}

class _AppCenterState extends State<AppCenter> {
  bool isHud = true;
  bool netError = false;
  List banner = [];
  List recommend = [];

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() {
    getAppCenter().then((value) {
      if (value.status == 1) {
        banner = List.from(value.data['banner']);
        recommend = List.from(value.data['apps']['recommend']) +
            List.from(value.data['apps']['common']);
        isHud = false;
      } else {
        netError = true;
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return isHud
        ? PageStatus.loading(mounted)
        : PullRefreshList(
            onRefresh: () {
              getData();
            },
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: GQStyle.pagePadding),
              child: Column(
                children: [
                  banner.isEmpty
                      ? Container()
                      : Padding(
                          padding: EdgeInsets.only(bottom: 10.w),
                          child: GeneralBanner(
                            data: banner,
                            height: 161,
                            bottom: 0,
                            radius: 5.0,
                          ),
                        ),
                  recommend.isEmpty
                      ? Container()
                      : GridView.builder(
                          shrinkWrap: true,
                          padding: EdgeInsets.only(top: 10.w),
                          itemCount: recommend.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            mainAxisSpacing: 20.w,
                            crossAxisSpacing: 15.w,
                            childAspectRatio: 100 / 140,
                          ),
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            dynamic e = recommend[index];
                            // double w = (ScreenUtil().screenWidth -
                            //         15.w * 3 -
                            //         13.w * 2) /
                            //     4;
                            return GestureDetector(
                              onTap: () {
                                reqAdClickCount(
                                    id: e['report_id'], type: e['report_type']);
                                CommonUtils.launchURL(e['link_url']);
                              },
                              child: Column(
                                children: [
                                  SizedBox(
                                    width: 60.w,
                                    height: 60.w,
                                    child: PlatformAwareNetworkImage(
                                      url: CommonUtils.getThumb(e),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(14.w)),
                                    ),
                                  ),
                                  SizedBox(height: 5.w),
                                  Text(
                                    e['title'],
                                    style: GQStyle.white15,
                                    maxLines: 1,
                                  )
                                ],
                              ),
                            );
                          }),
                ],
              ),
            ),
          );
  }
}
