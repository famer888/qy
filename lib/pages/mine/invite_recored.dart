import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qypj/components/common/pullrefreshlist.dart';
import 'package:qypj/components/page_status.dart';
import 'package:qypj/model/invitionlist.dart';
import 'package:qypj/utils/api.dart';
import 'package:qypj/utils/common.dart';

class InviteRecored extends StatefulWidget {
  InviteRecored({Key key}) : super(key: key);

  final Color baseColor = Color(0xff333333);

  @override
  _InviteRecoredState createState() => _InviteRecoredState();
}

class _InviteRecoredState extends State<InviteRecored> {
  List list = [];
  int currentPage = 1;
  int limit = 24;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _getMoreData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  _getMoreData() async {
    var result = await getListInvition(page: currentPage, limit: limit);
    if (result?.status == 1) {
      isLoading = false;
      List resData = result.data.list == null ? [] : result.data.list;
      if (currentPage == 1) {
        list = resData;
      } else {
        list.addAll(resData);
      }
      setState(() {});
    }
  }

  _onRefreshPost() async {
    currentPage = 1;
    _getMoreData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: widget.baseColor),
        title: Text(CommonUtils.txt('yqjl'),
            style: TextStyle(color: widget.baseColor)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: isLoading
          ? PageStatus.loading(mounted)
          : Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(ScreenUtil().setWidth(12.5)),
                  child: Row(
                    children: [
                      RecoredHeader(title: CommonUtils.txt('yhm')),
                      RecoredHeader(title: CommonUtils.txt('zt')),
                      RecoredHeader(title: CommonUtils.txt('sj')),
                    ],
                  ),
                ),
                Flexible(
                  child: PullRefreshList(
                    onRefresh: _onRefreshPost,
                    onLoading: () {
                      currentPage++;
                      _getMoreData();
                    },
                    child: list.length == 0
                        ? SingleChildScrollView(
                            child: PageStatus.noData(
                                text: CommonUtils.txt('wyqjl')),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: AlwaysScrollableScrollPhysics(),
                            itemCount: list.length,
                            itemBuilder: (context, index) {
                              return RecoredItem(
                                item: list[index],
                              );
                            }),
                  ),
                ),
              ],
            ),
    );
  }
}

class RecoredItem extends StatelessWidget {
  final ListElement item;
  const RecoredItem({Key key, this.item}) : super(key: key);

  // String handleTime(time) {
  //   getTime(int _num) {
  //     return _num < 10 ? '0' + _num.toString() : _num;
  //   }

  //   var times = new DateTime.fromMillisecondsSinceEpoch(time * 1000);
  //   String cTime =
  //       '${getTime(times.hour)}-${getTime(times.minute)} ${getTime(times.minute)}:${getTime(times.second)}';
  //   return '$cTime';
  // }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(ScreenUtil().setWidth(12.5)),
      child: Row(
        children: [
          RecoredValue(value: '${item.nickname}'),
          RecoredValue(value: '${item.register}'),
          RecoredValue(value: item.createdAt),
        ],
      ),
    );
  }
}

class RecoredValue extends StatelessWidget {
  final String value;
  const RecoredValue({Key key, this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Text(
        value,
        textAlign: TextAlign.center,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
            fontSize: ScreenUtil().setSp(13),
            fontWeight: FontWeight.w400,
            color: Color(0xff999999)),
      ),
    );
  }
}

class RecoredHeader extends StatelessWidget {
  final String title;
  const RecoredHeader({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Text(
        title,
        textAlign: TextAlign.center,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
            fontSize: ScreenUtil().setSp(15),
            fontWeight: FontWeight.w500,
            color: Color(0xff333333)),
      ),
    );
  }
}
