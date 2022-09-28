import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qypj/base/baseWidget.dart';
import 'package:qypj/components/common/pullrefreshlist.dart';
import 'package:qypj/components/page_status.dart';
import 'package:qypj/theme/default.dart';
import 'package:qypj/utils/api.dart';
import 'package:qypj/utils/extensionlibrary.dart';
import 'package:qypj/utils/networkImage.dart';
import 'package:qypj/views/general_banner.dart';

typedef Function PushAct(String name);

class NakedChatPage extends BaseWidget {
  NakedChatPage({Key key, this.isShow}) : super(key: key);

  bool isShow = false;
  // PushAct _pushact;
  @override
  BaseWidgetState<NakedChatPage> cState() {
    return _NakedChatPageState();
  }
}

class _NakedChatPageState extends BaseWidgetState<NakedChatPage> {
  bool _isShow;
  int page = 1;
  bool isAll = false;
  bool isHud = true;
  bool netWorkErr = false;
  List bannerList = [];
  List itemList = [];

  getList() {
    Map param = {'limit': 20, 'page': page};
    getNakedchatList(param).then((res) {
      if (res == null) {
        netWorkErr = true;
        setState(() {});
        return;
      }

      if (page == 1) {
        isAll = false;
        itemList.clear();
        bannerList.clear();
      }
      List resList = res['data']['item'];
      if (resList.length > 0) {
        itemList.addAll(resList);
      } else {
        isAll = true;
      }

      bannerList = res['data']['banner'];

      isHud = false;
      setState(() {});
    });
  }

  @override
  void didUpdateWidget(covariant NakedChatPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isShow && isHud && !netWorkErr) {
      getList();
    }
  }

  @override
  void onCreate() {
    _isShow = widget.isShow;
    // if (_isShow) getList();
    // TODO: implement onCreate
  }

  @override
  void onDestroy() {
    // TODO: implement onDestroy
  }

  // Color _itemColor = Colors.green;
  @override
  Widget pageBody(BuildContext context) {
    return netWorkErr
        ? PageStatus.noNetWork(onTap: () {})
        : isHud
            ? PageStatus.loading(mounted)
            : PullRefreshList(
                onRefresh: () {
                  page = 1;
                  getList();
                },
                onLoading: () {
                  page++;
                  getList();
                },
                isAll: isAll,
                child: ListView(
                  children: [
                    bannerList.length > 0
                        ? GeneralBanner(
                            data: bannerList,
                            height: 161,
                          )
                        : Container(),
                    Container(
                      margin: EdgeInsets.all(10),
                      child: Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: itemList.map((e) {
                            return LayoutBuilder(
                                builder: (context, constaints) {
                              return SizedBox(
                                width: constaints.maxWidth / 2 - 5,
                                child: NakedchatItemWidget(
                                  item: e,
                                ),
                              );
                            });
                          }).toList()),
                    ),
                  ],
                ),
              );
  }
}

class NakedchatItemWidget extends StatelessWidget {
  NakedchatItemWidget({this.item}) : super();
  dynamic item;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constaints) {
      return GestureDetector(
          onTap: () {
            // _itemColor = Colors.cyan;
            // setState(() {});
            var id = item['id'];
            context.push('/nakedchatDetailPage/$id');
          },
          child: Column(
            children: [
              Container(
                width: constaints.minWidth,
                height: constaints.minWidth * 224.0 / 169.0,
                child: PlatformAwareNetworkImage(
                  url: item['cover'],
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
              ),
              Container(
                height: ScreenUtil().setWidth(8.8),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  item['desc'],
                  style: GQStyle.white14Medium,
                ),
              ),
              Container(
                height: ScreenUtil().setWidth(13),
              )
            ],
          ));
    });
  }
}
