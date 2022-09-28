import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qypj/base/baseWidget.dart';
import 'package:qypj/components/common/pagetitlebar.dart';
import 'package:qypj/components/common/pullrefreshlist.dart';
import 'package:qypj/components/page_status.dart';
import 'package:qypj/model/basic.dart';
import 'package:qypj/routers.dart';
import 'package:qypj/theme/default.dart';
import 'package:qypj/utils/api.dart';
import 'package:qypj/utils/common.dart';
import 'package:qypj/utils/extensionlibrary.dart';

/// 邀请记录-代理
class MineAgentInviteRecordPage extends BaseWidget {
  cState() => _MineAgentInviteRecordPageState();
}

class _MineAgentInviteRecordPageState extends BaseWidgetState {
  int page = 1;
  bool isAll = false;
  bool networkErr = false;
  bool isHud = true;
  List _dataList;

  _toCustomerService() {
    context.push('/' + 'customerService');
  }

  _getData() async {
    Map param = {
      'page': page,
      'limit': 10,
    };

    try {
      Basic res = await getProxyInviteRecord(param);
      if (res.status != 1) {
        CommonUtils.showText(res.msg);
        networkErr = true;
      } else {
        networkErr = false;

        dynamic a = res.data['list'];
        List list = List.from(a);
        if (page == 1) {
          _dataList = list;
        } else {
          _dataList.addAll(list);
        }
        if (list.length == 0 && _dataList.length > 0) {
          isAll = true;
        }
      }
    } catch (e) {
      isHud = false;

      networkErr = true;
    }
    isHud = false;
// _dataList.add({
//       "log_date": "2022-03-02 03:02",
//       "aff_code": "asdf",
//       "reg_status": 1,
//       "phone": 1342123124541,
//     });
//     _dataList.add({
//       "log_date": "2022-03-02 03:02",
//       "aff_code": "asdf",
//       "reg_status": 1,
//       "phone": 1342123124541,
//     }
    setState(() {});
  }

  @override
  Widget appbar() {
    return Stack(children: [
      super.appbar(),
      Positioned(
          right: 0,
          bottom: 0,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: GQStyle.pagePadding),
            alignment: Alignment.centerRight,
            height: GQStyle.navbarHegiht,
            child: GestureDetector(
              onTap: () {
                context.push('/' + Routes.customerService);
              },
              child: Text(
                CommonUtils.txt('lxkf'),
                style: GQStyle.gray15,
              ),
            ),
          ))
    ]);
    return super.appbar();
  }

  @override
  void onCreate() {
    // TODO: implement onCreate
    _getData();
    setAppTitle(title: CommonUtils.txt('yqjl'));
  }

  @override
  void onDestroy() {
    // TODO: implement onDestroy
  }
  @override
  pageBody(BuildContext context) {
    return networkErr
        ? PageStatus.noNetWork(onTap: _getData)
        : isHud == true
            ? PageStatus.loading(mounted)
            : _dataList.length == 0
                ? PageStatus.noData()
                : PullRefreshList(
                    onRefresh: () {
                      page = 1;
                      isAll = false;
                      _getData();
                    },
                    onLoading: () {
                      page++;
                      _getData();
                    },
                    isAll: isAll,
                    child: Wrap(
                      // runSpacing: ScreenUtil().setWidth(10),
                      spacing: ScreenUtil().setWidth(10),
                      children: _dataList.map(
                        (e) {
                          Widget widget = MineAgentInviteRecordListWidget(
                            data: e,
                          );
                          return widget;
                        },
                      ).toList()
                        ..insert(
                            0,
                            Container(
                              height: ScreenUtil().setWidth(32),
                              child: DefaultTextStyle(
                                textAlign: TextAlign.center,
                                style: GQStyle.white255_15,
                                child: Row(
                                  // mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Expanded(
                                        child: Text(
                                      CommonUtils.txt('tgm'),
                                    )),
                                    Expanded(
                                        child: Text(
                                      CommonUtils.txt('sjh'),
                                    )),
                                    Expanded(
                                        child: Text(
                                      CommonUtils.txt('zt'),
                                    )),
                                    Expanded(
                                        child: Text(
                                      CommonUtils.txt('sj'),
                                    )),
                                  ],
                                ),
                              ),
                            ))
                        ..add(SizedBox(height: ScreenUtil().setWidth(44))),
                    ),
                  );
  }
}

class MineAgentInviteRecordListWidget extends StatefulWidget {
  MineAgentInviteRecordListWidget({this.data});
  Map data;

  @override
  State<StatefulWidget> createState() =>
      _MineAgentInviteRecordListWidgetState();
}

class _MineAgentInviteRecordListWidgetState
    extends State<MineAgentInviteRecordListWidget> {
  dynamic _data;

  @override
  void initState() {
    super.initState();
    _data = widget.data;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(vertical: GQStyle.pagePadding / 2.0),
        // height: ScreenUtil().setWidth(32),
        child: DefaultTextStyle(
          style: GQStyle.gray153_13,
          textAlign: TextAlign.center,
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                  child: Text(
                '${_data['aff_code']}',
                style: TextStyle(
                  color: Color.fromRGBO(153, 153, 153, 1),
                ),
              )),
              Expanded(
                  child: Text(
                '${_data['phone']}',
                style: TextStyle(
                  color: Color.fromRGBO(153, 153, 153, 1),
                ),
              )),
              Expanded(
                  child: Text(
                '${_data['reg_status']}',
                style: TextStyle(
                  color: Color.fromRGBO(153, 153, 153, 1),
                ),
              )),
              Expanded(
                  child: Text(
                '${_data['log_date']}',
                maxLines: 2,
                style: TextStyle(
                  color: Color.fromRGBO(153, 153, 153, 1),
                ),
              )),
            ],
          ),
        ));
  }
}
