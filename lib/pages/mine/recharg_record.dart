import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qypj/utils/extensionlibrary.dart';
import 'package:qypj/components/common/pagetitlebar.dart';
import 'package:qypj/components/common/pullrefreshlist.dart';
import 'package:qypj/components/page_status.dart';
import 'package:qypj/model/coinorvip.dart';
import 'package:qypj/routers.dart';
import 'package:qypj/theme/default.dart';
import 'package:qypj/utils/api.dart';
import 'package:qypj/utils/common.dart';

class RechargeRecord extends StatefulWidget {
  final Map args;
  RechargeRecord({Key key, this.args}) : super(key: key);

  @override
  _RechargeRecordState createState() => _RechargeRecordState();
}

class _RechargeRecordState extends State<RechargeRecord> {
  List recordList = [];
  bool isLoading = true;
  bool networkErr = false;
  bool isAll = false;
  int page = 1;
  int limit = 15;
  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    if (widget?.args['type'] == null) {
      isLoading = false;
      recordList = [];
      setState(() {});
      // 1 vip 2 扣币
      CommonUtils.showText(CommonUtils.txt('qcr') + 'type');
      return;
    }
    CoinOrVipModel result = await getOrderList(
        page: page, type: widget?.args['type'], limit: limit);
    if (result == null) {
      networkErr = true;
      setState(() {});
      return;
    }
    if (result.status != 0) {
      List resData = result.data == null ? [] : result.data;
      isAll = resData.length < limit;
      if (page == 1) {
        recordList = resData;
      } else {
        recordList.addAll(resData);
      }
      isLoading = false;
      setState(() {});
    } else {
      CommonUtils.showText(result.msg);
    }
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
            title: CommonUtils.txt('czjl'),
            rightWidget: GestureDetector(
              onTap: () {
                context.push(CommonUtils.getRealHash('customerService'));
              },
              child: Text(
                CommonUtils.txt('lxkf'),
                style: GQStyle.gray150_14,
              ),
            ),
          ),
          Expanded(
            child: networkErr
                ? Container(
                    width: double.infinity,
                    child: PageStatus.noNetWork(onTap: () {
                      networkErr = false;
                      setState(() {});
                      getData();
                    }),
                  )
                : isLoading
                    ? PageStatus.loading(mounted)
                    : PullRefreshList(
                        onRefresh: () {
                          page = 1;
                          getData();
                        },
                        onLoading: () {
                          if (isAll) {
                            CommonUtils.showText(CommonUtils.txt('mgdjl'));
                            return;
                          }
                          page++;
                          getData();
                        },
                        child: recordList.length == 0
                            ? PageStatus.noData(text: CommonUtils.txt('mczjl'))
                            : ListView.builder(
                                padding: EdgeInsets.all(
                                    ScreenUtil().setWidth(GQStyle.pagePadding)),
                                itemCount: recordList.length,
                                itemBuilder:
                                    (BuildContext contenxt, int index) {
                                  return OrderItem(
                                    orderData: recordList[index],
                                  );
                                },
                              ),
                      ),
          ),
        ],
      )),
    );
  }
}

class OrderItem extends StatelessWidget {
  final Datum orderData;
  const OrderItem({Key key, this.orderData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: ScreenUtil().setWidth(16)),
      padding: EdgeInsets.symmetric(
          vertical: ScreenUtil().setWidth(18.5),
          horizontal: ScreenUtil().setWidth(14)),
      decoration: BoxDecoration(
        color: Color.fromRGBO(21, 21, 42, 1),
        borderRadius: BorderRadius.circular(ScreenUtil().setWidth(5)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                CommonUtils.txt('ddbh') + '：${orderData?.id}',
                style: GQStyle.white23_12,
              ),
              GestureDetector(
                onTap: () {
                  Clipboard.setData(ClipboardData(
                      text: CommonUtils.txt('ddbh') + '：${orderData?.id}'));
                  CommonUtils.showText(CommonUtils.txt('fzcgl'));
                },
                child: Row(
                  children: [
                    LImage(
                      'wd_fzbh_n',
                      width: ScreenUtil().setWidth(15),
                      height: ScreenUtil().setWidth(10),
                    ),
                    SizedBox(
                      width: ScreenUtil().setWidth(6),
                    ),
                    Text(
                      CommonUtils.txt('fzdh'),
                      style: TextStyle(
                          color: Color.fromRGBO(0, 72, 255, 1),
                          fontSize: ScreenUtil().setSp(12),
                          overflow: TextOverflow.ellipsis,
                          decoration: TextDecoration.none),
                    ),
                  ],
                ),
              )
            ],
          ),
          SizedBox(
            height: ScreenUtil().setWidth(10),
          ),
          CustomPaint(
            size: Size(double.infinity, ScreenUtil().setWidth(0.5)),
            painter: CurvePainter(),
          ),
          SizedBox(
            height: ScreenUtil().setWidth(14.5),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${orderData?.descp}',
                style: GQStyle.gray168_16_M,
              ),
              Text('${orderData?.amount}', style: GQStyle.gray168_16_M),
            ],
          ),
          SizedBox(
            height: ScreenUtil().setWidth(11.5),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${orderData?.createdAt}', style: GQStyle.gray153_12),
              Text(
                '${orderData?.statusText}',
                style: GQStyle.gray153_12,
              ),
            ],
          )
        ],
      ),
    );
  }
}

class CurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = Colors.black12;
    paint.style = PaintingStyle.fill; // Change this to fill

    var path = Path();

    path.moveTo(0, 0);
    path.quadraticBezierTo(size.width / 2, size.height / 2, size.width, 0);
    path.quadraticBezierTo(size.width / 2, -size.height / 2, 0, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
