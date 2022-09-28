import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qypj/base/baseWidget.dart';
import 'package:qypj/components/common/pullrefreshlist.dart';
import 'package:qypj/components/page_status.dart';
import 'package:qypj/model/basic.dart';
import 'package:qypj/theme/default.dart';
import 'package:qypj/utils/api.dart';
import 'package:qypj/utils/common.dart';

class MineAgentProfitListPage extends BaseWidget {
  cState() => _MineAgentProfitListPageState();
}

class _MineAgentProfitListPageState extends BaseWidgetState {
  int page = 1;
  bool isAll = false;
  bool networkErr = false;
  bool isHud = true;
  List _dataList;

  _getData() async {
    int status = 1;
    Map param = {'type': 1, 'page': page, 'limit': 10, 'status': status};

    try {
      Basic res = await getProxyProfitList(param);
      print(res.data);
      if (res.status != 1) {
        CommonUtils.showText(res.msg);
        networkErr = true;
        setState(() {});
        return;
      } else {
        if (res.data.length == 0) {
          isAll = true;
        }
        if (page == 1) {
          _dataList = res.data;

          // for (var i = 0; i < 99; i++) {
          //   try {
          //     for (var item in (res.data as List)) {
          //       _dataList.add(item);
          //     }
          //   } catch (e) {
          //     print(e);
          //   }
          // }
        } else {
          _dataList.addAll(res.data);
        }
      }
    } catch (e) {}

    // _dataList = [
    //   {
    //     "created_at": "2022-03-02 03:02",
    //     "nickname": "nickname_1",
    //     "type": 1,
    //     "source": 2,
    //     "amount": "100"
    //   },
    //   {
    //     "created_at": "2022-03-02 03:02",
    //     "nickname": "nickname_1",
    //     "type": 1,
    //     "source": 2,
    //     "amount": "100"
    //   },
    //   {
    //     "created_at": "2022-03-02 03:02",
    //     "nickname": "nickname_1",
    //     "type": 2,
    //     "source": 3,
    //     "amount": "100"
    //   },
    // ];

    isHud = false;
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void onCreate() {
    // TODO: implement onCreate
    _getData();
    setAppTitle(title: CommonUtils.txt('yjmx'));
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
            : _dataList == null || _dataList.length == 0
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
                    child: ListView.builder(
                        itemCount: _dataList.length,
                        itemBuilder: (context, index) {
                          return MineAgentProfitListWidget(
                            data: _dataList[index],
                          );
                        })
                    //  Wrap(
                    //   // runSpacing: ScreenUtil().setWidth(10),
                    //   spacing: ScreenUtil().setWidth(10),
                    //   children: _dataList
                    //       .map(
                    //         (e) => MineAgentProfitListWidget(
                    //           data: e,
                    //         ),
                    //       )
                    //       .toList(),
                    // ),
                    );
  }
}

class MineAgentProfitListWidget extends StatelessWidget {
  MineAgentProfitListWidget({this.data});
  dynamic data;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          // height: ScreenUtil().setWidth(70),
          padding: EdgeInsets.symmetric(
              horizontal: ScreenUtil().setWidth(GQStyle.pagePadding),
              vertical: ScreenUtil().setWidth(13)),
          child: Container(
            // height: ScreenUtil().setWidth(42),
            // alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${data['nickname']}',
                      style: GQStyle.white244_16,
                    ),
                    Text(
                      (data['type'] == 1
                              ? '+'
                              : data['type'] == 2
                                  ? '-'
                                  : '') +
                          '${data['amount']}',
                      style: GQStyle.teal103224185_20_M,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      data['source'] == 1
                          ? CommonUtils.txt('tx')
                          : data['source'] == 2
                              ? CommonUtils.txt('txtk')
                              : data['source'] == 3
                                  ? CommonUtils.txt('dlfc')
                                  : '',
                      style: GQStyle.gray153_12,
                    ),
                    Text(
                      '${data['created_at']}',
                      style: GQStyle.gray153_12,
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(
              horizontal: ScreenUtil().setWidth(GQStyle.pagePadding)),
          height: ScreenUtil().setWidth(0.5),
          color: Color.fromRGBO(21, 21, 42, 1),
        )
      ],
    );
  }
}
