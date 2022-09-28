import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qypj/components/common/pagetitlebar.dart';
import 'package:qypj/components/common/pullrefreshlist.dart';
import 'package:qypj/components/page_status.dart';
import 'package:qypj/model/coindetail.dart';
import 'package:qypj/theme/default.dart';
import 'package:qypj/utils/api.dart';
import 'package:qypj/utils/common.dart';

class CoinDetail extends StatefulWidget {
  CoinDetail({Key key}) : super(key: key);

  @override
  _CoinDetailState createState() => _CoinDetailState();
}

class _CoinDetailState extends State<CoinDetail> {
  String type = '';
  int limit = 15;
  bool filterShow = false;
  bool noMore = false;
  List fiterList = [
    {'name': CommonUtils.txt('qb'), 'sort': ''},
    {'name': CommonUtils.txt('shr'), 'sort': '1'},
    {'name': CommonUtils.txt('zhc'), 'sort': '2'}
  ];
  List arrayDetial = [];
  bool isLoading = true;
  bool isAll = false;
  int page = 1;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    CoinDetialModel result =
        await getListMoneyDetail(page: page, type: type, limit: limit);
    if (result.status != 0) {
      isAll = result.data.length < limit;
      List resdata = result.data == null ? [] : result.data;
      isLoading = false;
      if (page == 1) {
        noMore = false;
        arrayDetial = resdata;
      } else if (resdata.length > 0) {
        arrayDetial.addAll(resdata);
      } else {
        noMore = true;
      }
      setState(() {});
    } else {
      CommonUtils.showText(result.msg);
    }
  }

  onChangeType(int index) async {
    isLoading = true;
    filterShow = false;
    page = 1;
    type = fiterList[index]['sort'];
    setState(() {});
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GQStyle.bgColor,
      body: SafeArea(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PageTitleBar(
            title: CommonUtils.txt('jbmxwa'),
            rightWidget: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                filterShow = !filterShow;
                setState(() {});
              },
              child: Text(
                CommonUtils.txt('sx'),
                style: GQStyle.gray150_14,
              ),
            ),
          ),
          Expanded(
              child: isLoading
                  ? PageStatus.loading(mounted)
                  : arrayDetial.length == 0
                      ? PageStatus.noData()
                      : Stack(clipBehavior: Clip.none, children: [
                          Column(
                            children: [
                              Expanded(
                                child: PullRefreshList(
                                  isAll: noMore,
                                  onRefresh: () {
                                    page = 1;
                                    getData();
                                  },
                                  onLoading: () {
                                    page++;
                                    getData();
                                  },
                                  child: ListView.builder(
                                    padding: EdgeInsets.all(ScreenUtil()
                                        .setWidth(GQStyle.pagePadding)),
                                    itemCount: arrayDetial.length,
                                    itemBuilder:
                                        (BuildContext contenxt, int index) {
                                      return CoinItem(
                                        itemdata: arrayDetial[index],
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          AnimatedPositioned(
                            duration: Duration(milliseconds: 300),
                            top: 0,
                            right: ScreenUtil().setWidth(filterShow ? 13 : -68),
                            child: AnimatedOpacity(
                              opacity: filterShow ? 1.0 : 0.0,
                              duration: Duration(milliseconds: 300),
                              child: Container(
                                width: ScreenUtil().setWidth(68),
                                height: ScreenUtil().setWidth(98),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        ScreenUtil().setWidth(5)),
                                    color: Color(0xff191919)),
                                child: Column(
                                  children: fiterList
                                      .asMap()
                                      .keys
                                      .map((e) => Expanded(
                                            flex: 1,
                                            child: GestureDetector(
                                                onTap: () {
                                                  onChangeType(e);
                                                },
                                                child: Center(
                                                  child: Text(
                                                    fiterList[e]['name'],
                                                    style: type ==
                                                            fiterList[e]['sort']
                                                        ? GQStyle.white16bold
                                                        : GQStyle.white14,
                                                  ),
                                                )),
                                          ))
                                      .toList(),
                                ),
                              ),
                            ),
                          )
                        ]))
        ],
      )),
    );
  }
}

class CoinItem extends StatelessWidget {
  final Datum itemdata;
  const CoinItem({Key key, this.itemdata}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: ScreenUtil().setWidth(16)),
      padding: EdgeInsets.symmetric(
          horizontal: GQStyle.pagePadding, vertical: GQStyle.pagePadding),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${itemdata.sourceStr}",
                style: GQStyle.white244_16,
              ),
              Text('${itemdata?.type == 1 ? '+' : '-'} ${itemdata?.coin}',
                  style: GQStyle.white244_20_M),
            ],
          ),
          SizedBox(
            height: ScreenUtil().setWidth(11.5),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  '${itemdata.desc}',
                  style: GQStyle.gray153_12,
                  maxLines: 1,
                ),
              ),
              Spacer(),
              Text('${itemdata.createdAt}', style: GQStyle.gray153_12),
            ],
          )
        ],
      ),
    );
  }
}
