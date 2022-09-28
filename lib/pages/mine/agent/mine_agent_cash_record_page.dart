import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qypj/base/baseWidget.dart';
import 'package:qypj/components/common/pullrefreshlist.dart';
import 'package:qypj/components/page_status.dart';
import 'package:qypj/model/basic.dart';
import 'package:qypj/theme/default.dart';
import 'package:qypj/utils/api.dart';
import 'package:qypj/utils/common.dart';

class MineAgentCashRecordPage extends BaseWidget {
  cState() => _MineAgentCashRecordPageState();
}

class _MineAgentCashRecordPageState extends BaseWidgetState {
  int page = 1;
  bool isAll = false;
  bool networkErr = false;
  bool isHud = false;
  List _dataList = [];

  _getData() async {
    // var t = {
    //   "updated_at": "2019-03-01   03:02",
    //   "status_str": "成功",
    //   "amount": "100.00"
    // };

    // var t2 = {
    //   "updated_at": "2019-03-02   03:02",
    //   "status_str": "失败",
    //   "amount": "50.00"
    // };
    // var t3 = {
    //   "updated_at": "2019-03-03   03:02",
    //   "status_str": "成功",
    //   "amount": "50"
    // };
    // _dataList = [t, t2, t3];
    // return;
    int status = 1;
    Map param = {'page': page, 'limit': 10, 'status': status};

    try {
      Basic res = await cashWithdrawList(param);

      isHud = false;

      if (res.status != 1) {
        CommonUtils.showText(res.msg);
        networkErr = true;
        setState(() {});
        return;
      }

      if (page == 1) {
        _dataList = res.data;
      } else {
        _dataList.addAll(res.data);
      }

      if (res.data.length < 10 && _dataList.length > 0) {
        isAll = true;
      }

      setState(() {});
    } catch (e) {
      isHud = false;
      networkErr = true;
      setState(() {});
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _getData();
  }

  @override
  void onCreate() {
    // TODO: implement onCreate
    // _getData();
    setAppTitle(title: CommonUtils.txt('txjl'));
  }

  @override
  void onDestroy() {
    // TODO: implement onDestroy
  }
  @override
  pageBody(BuildContext context) {
    return networkErr
        ? PageStatus.noNetWork()
        : (_dataList != null && _dataList.length == 0)
            ? PageStatus.noData()
            : Container(
                margin: EdgeInsets.symmetric(horizontal: GQStyle.pagePadding),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.only(
                          left: GQStyle.pagePadding,
                          right: GQStyle.pagePadding),
                      height: ScreenUtil().setWidth(30),
                      // color: Color(0xff26313a),
                      child: DefaultTextStyle(
                        textAlign: TextAlign.center,
                        style: GQStyle.white15,
                        child: Row(
                          // mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Expanded(
                                flex: 80,
                                child: Text(
                                  CommonUtils.txt('sj'),
                                  textAlign: TextAlign.left,
                                )),
                            // Spacer(
                            //   flex: 80,
                            // ),
                            Expanded(
                                flex: 40,
                                child: Text(
                                  CommonUtils.txt('zt'),
                                  textAlign: TextAlign.center,
                                  // textAlign: TextAlign.center,
                                )),
                            // Spacer(
                            //   flex: 80,
                            // ),
                            Expanded(
                                flex: 80,
                                child: Text(
                                  CommonUtils.txt('je2'),
                                  textAlign: TextAlign.right,
                                )),
                            // Expanded(
                            //   flex: 1,
                            //   child: Container(),
                            // ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: PullRefreshList(
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
                                Widget widget = MineAgentCashRecordListWidget(
                                  data: e,
                                );
                                return widget;
                              },
                            ).toList()),
                      ),
                    ),
                  ],
                ),
              );
  }
}

class MineAgentCashRecordListWidget extends StatelessWidget {
  MineAgentCashRecordListWidget({this.data});
  dynamic data;

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: EdgeInsets.symmetric(horizontal: GQStyle.pagePadding),
      padding: EdgeInsets.only(
          left: GQStyle.pagePadding, right: GQStyle.pagePadding),
      height: ScreenUtil().setWidth(50),
      child: Column(
        children: [
          Expanded(
            child: DefaultTextStyle(
              textAlign: TextAlign.center,
              style: GQStyle.hexa3a2a2_12,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      flex: 80,
                      child: FittedBox(
                        child: Text(
                          '${data['updated_at']}',
                          style: GQStyle.gray208_13,
                          maxLines: 1,
                          textAlign: TextAlign.left,
                        ),
                      )),
                  // Spacer(
                  //   flex: 80,
                  // ),
                  Expanded(
                      flex: 40,
                      child: Center(
                        child: Text('${data['status_str']}',
                            textAlign: TextAlign.center,
                            style: (data['status_str'] == "成功")
                                ? GQStyle.gray208_13
                                : GQStyle.hexff2a8a_12),
                      )),
                  // Text('${data['status_str']}',
                  //     textAlign: TextAlign.center,
                  //     style: (data['status_str'] == "成功")
                  //         ? GQStyle.white_13
                  //         : GQStyle.hexff2a8a_12),
                  // Spacer(
                  //   flex: 80,
                  // ),
                  Expanded(
                    flex: 80,
                    child: Container(
                        // flex: 54,
                        width: ScreenUtil().setWidth(60),
                        // height: ScreenUtil().setWidth(15),
                        child: Container(
                          // color: Colors.red,
                          alignment: Alignment.centerRight,
                          child: Text('${data['amount']}',
                              textAlign: TextAlign.center,
                              style: GQStyle.teal103224185_18_M),
                        )),
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: 0.5,
            color: Color.fromRGBO(21, 21, 42, 1),
          )
        ],
      ),
    );
  }
}
