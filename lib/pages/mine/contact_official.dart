import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:qypj/base/baseWidget.dart';
import 'package:qypj/model/homedata.dart';
import 'package:qypj/store/homeConfig.dart';
import 'package:qypj/utils/extensionlibrary.dart';
import 'package:universal_html/html.dart' as html;
import 'package:qypj/components/common/pagetitlebar.dart';
import 'package:qypj/components/page_status.dart';
import 'package:qypj/theme/default.dart';
import 'package:qypj/utils/api.dart';
import 'package:qypj/utils/common.dart';

class ContactOfficial extends BaseWidget {
  ContactOfficial({Key key}) : super(key: key);

  @override
  _ContactOfficialState cState() => _ContactOfficialState();
}

class _ContactOfficialState extends BaseWidgetState<ContactOfficial> {
  List dataList = [];
  bool isLoading = true;

  @override
  void onCreate() {
    setAppTitle(title: CommonUtils.txt('jqkc'));
    initData();
  }

  initData() async {
    var result = await getContactList();
    print(result.toString());
    if (result != null &&
        result['data']["office_contact"] != null &&
        result['data']["office_contact"]["data"] != null) {
      dataList.addAll(result['data']["office_contact"]["data"]);
      isLoading = false;
      setState(() {});
    } else {
      context.pop();
      CommonUtils.showText(CommonUtils.txt('sjkzs'));
    }
  }

  Widget _contactItem({Map itemData}) {
    // 福利姬的年卡会员才显示的 不用了
    // if (itemData['name'].toString().contains(CommonUtils.txt('nk'))) {
    //   Member member = Provider.of<HomeConfig>(context, listen: false).member;
    //   if (member.vipLevel >= 6) {
    //   } else {
    //     return Container();
    //   }
    // }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '${itemData['name']}',
          style: GQStyle.white255_18_M,
        ),
        SizedBox(
          height: ScreenUtil().setWidth(8),
        ),
        Text('${itemData['decs']}', style: GQStyle.gray95_12),
        Container(
          margin: EdgeInsets.only(
              top: ScreenUtil().setWidth(11.5),
              bottom: ScreenUtil().setWidth(20)),
          padding: EdgeInsets.all(ScreenUtil().setWidth(15)),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(ScreenUtil().setWidth(10)),
            color: Color.fromRGBO(21, 21, 42, 1),
          ),
          // boxShadow: [
          //   BoxShadow(
          //       color: Colors.black12,
          //       offset: Offset(0, ScreenUtil().setWidth(1)),
          //       blurRadius: ScreenUtil().setWidth(5))
          // ]

          width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: itemData['list']
                .map<Widget>((value) => AppInfo(
                      info: value,
                    ))
                .toList(),
          ),
        )
      ],
    );
  }

  @override
  void onDestroy() {
    // TODO: implement onDestroy
  }
  @override
  Widget pageBody(BuildContext context) {
    return isLoading
        ? PageStatus.loading(mounted)
        : SingleChildScrollView(
            padding: EdgeInsets.symmetric(
                horizontal: GQStyle.pagePadding,
                vertical: ScreenUtil().setWidth(30)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: dataList
                  .asMap()
                  .keys
                  .map(
                    (e) => _contactItem(itemData: dataList[e]),
                  )
                  .toList(),
            ),
          );
  }
}

class AppInfo extends StatelessWidget {
  final Map info;
  const AppInfo({Key key, this.info}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: ScreenUtil().setWidth(10)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
              child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              LImage(
                info['type'] == 'Telegram' ? 'wd_lxtg_n' : 'wd_lxpotao',
                width: ScreenUtil().setWidth(38.8),
                height: ScreenUtil().setWidth(38.8),
              ),
              SizedBox(
                width: ScreenUtil().setWidth(13),
              ),
              Flexible(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${info['name']}',
                    style: GQStyle.white255_15_M,
                  ),
                  Text(
                    '${info['decs']}',
                    style: GQStyle.gray150_12,
                  ),
                ],
              ))
            ],
          )),
          GestureDetector(
            onTap: () {
              CommonUtils.launchURL(info['url']);
            },
            child: Container(
              height: ScreenUtil().setWidth(30),
              width: ScreenUtil().setWidth(70),
              decoration: BoxDecoration(
                  gradient: GQStyle.btnGradient_ff00edfd_ffbbe954,
                  borderRadius:
                      BorderRadius.circular(ScreenUtil().setWidth(15))),
              child: Center(
                child: Text(
                  CommonUtils.txt('ljjr'),
                  style: GQStyle.white11,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
