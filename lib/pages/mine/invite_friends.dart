import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qypj/theme/default.dart';
import 'package:qypj/utils/extensionlibrary.dart';
import 'package:qypj/components/page_status.dart';
import 'package:qypj/model/myinvitation.dart';
import 'package:qypj/model/myreward.dart';
import 'package:qypj/routers.dart';
import 'package:qypj/utils/api.dart';
import 'package:qypj/utils/common.dart';

class InviteFriend extends StatefulWidget {
  InviteFriend({Key key}) : super(key: key);

  @override
  _InviteFriendState createState() => _InviteFriendState();
}

class _InviteFriendState extends State<InviteFriend> {
  ScrollController _scrollController = ScrollController();
  List incomeList = [];
  bool isLoading = true;
  Data myInvition;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        var list2 = [1, 1, 1, 1, 1, 1];
        setState(() {
          incomeList.addAll(list2);
        });
      }
    });
    initData();
  }

  initData() async {
    MyInvitationModel result = await myInvitation();
    MyRewardModel reward = await getMyReward();
    if (result != null && result.data != null) {
      setState(() {
        myInvition = result.data;
        isLoading = false;
      });
    }
    if (reward != null && reward.data != null) {
      setState(() {
        incomeList.addAll(reward.data);
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(color: Color(0xfff04b3e)),
        ),
        SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: ScreenUtil().setWidth(493),
                child: GestureDetector(
                  onTap: () {
                    context.push(CommonUtils.getRealHash('promote'));
                  },
                  child: Image.asset('assets/images/mine/invite_header.png'),
                ),
              ),
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(0)),
                child: Container(
                  width: ScreenUtil().screenWidth,
                  height: isLoading
                      ? ScreenUtil().setWidth(250)
                      : ScreenUtil().screenWidth * 162 / 375,
                  padding: EdgeInsets.only(
                      top: ScreenUtil().setWidth(70),
                      bottom: ScreenUtil().setWidth(15),
                      left: ScreenUtil().setWidth(37),
                      right: ScreenUtil().setWidth(37)),
                  decoration: isLoading
                      ? BoxDecoration(color: Colors.white)
                      : BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(
                                  "assets/images/mine/wod_invate_hbg.png"))),
                  child: isLoading
                      ? PageStatus.loading(mounted)
                      : Container(
                          color: Color(0xFFffeeee),
                          padding: EdgeInsets.only(
                              left: ScreenUtil().setWidth(20),
                              right: ScreenUtil().setWidth(20),
                              top: ScreenUtil().setWidth(10)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              MyInviteNumber(
                                  number: '${myInvition?.allNum}',
                                  label: CommonUtils.txt('wdyq')),
                              SizedBox(
                                height: ScreenUtil().setWidth(48),
                                width: ScreenUtil().setWidth(0.5),
                                child: Container(
                                  color: Color(0xFFffc7c9),
                                ),
                              ),
                              MyInviteNumber(
                                  number: '${myInvition?.regNum}',
                                  label: CommonUtils.txt('zcs')),
                              // SizedBox(
                              //   height: ScreenUtil().setWidth(48),
                              //   width: ScreenUtil().setWidth(0.5),
                              //   child: Container(
                              //     color: Color(0xFFffc7c9),
                              //   ),
                              // ),
                              // MyInviteNumber(
                              //     number: '${myInvition?.moneyNum}',
                              //     label: '累积扣币'),
                            ],
                          ),
                        ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: ScreenUtil().setWidth(20),
                    right: ScreenUtil().setWidth(20),
                    bottom: ScreenUtil().setWidth(20)),
                child: Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(top: ScreenUtil().setWidth(24.5)),
                  padding: EdgeInsets.all(ScreenUtil().setWidth(16)),
                  decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(ScreenUtil().setWidth(10)),
                      color: Colors.white),
                  child: isLoading
                      ? PageStatus.loading(mounted)
                      : incomeList.length == 0
                          ? PageStatus.noData(text: CommonUtils.txt('wsyjl'))
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                  child: Image.asset(
                                      "assets/images/mine/wod_sy_hbg.png"),
                                ),
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: BouncingScrollPhysics(),
                                  controller: _scrollController,
                                  itemCount: incomeList.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return IncomeItem(
                                      incomeListItem: incomeList[index],
                                    );
                                  },
                                )
                              ],
                            ),
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: GQStyle.pagePadding),
            width: ScreenUtil().screenWidth,
            height: kIsWeb ? ScreenUtil().setWidth(44) : GQStyle.navbarHegiht,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    context.pop();
                  },
                  child: Image.asset(
                    'assets/images/details/icon_w_back.png',
                    width: ScreenUtil().setWidth(22),
                    fit: BoxFit.fitWidth,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    context.push(CommonUtils.getRealHash('inviterecored'));
                  },
                  child: Text(CommonUtils.txt('yqjl'), style: GQStyle.white15),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class IncomeItem extends StatelessWidget {
  final Datum incomeListItem;
  const IncomeItem({Key key, this.incomeListItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: ScreenUtil().setWidth(12.5)),
      decoration: BoxDecoration(
          border:
              Border(bottom: BorderSide(width: 1, color: Color(0xffeeeeee)))),
      child: Row(
        children: [
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${incomeListItem?.nickname}',
                  style: TextStyle(
                      fontSize: ScreenUtil().setSp(16),
                      color: Color(0xff333333))),
              Text('${incomeListItem?.createdAt}',
                  style: TextStyle(
                      fontSize: ScreenUtil().setSp(12),
                      color: Color(0xff999999))),
            ],
          )),
          Text('+20G',
              style: TextStyle(
                  fontSize: ScreenUtil().setSp(24), color: Color(0xff333333))),
        ],
      ),
    );
  }
}

class MyInviteNumber extends StatelessWidget {
  final String number;
  final String label;
  const MyInviteNumber({Key key, this.number, this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label,
            style: TextStyle(
                fontSize: ScreenUtil().setSp(13),
                color: Color(0xff666666),
                decoration: TextDecoration.none)),
        SizedBox(height: ScreenUtil().setWidth(13)),
        Text(number,
            style: TextStyle(
                fontSize: ScreenUtil().setSp(24),
                color: Color(0xffff3f43),
                decoration: TextDecoration.none)),
      ],
    );
  }
}

class ActionImage extends StatelessWidget {
  final String url;
  final GestureTapCallback onTap;
  const ActionImage({Key key, this.url, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Image.asset(url,
          width: ScreenUtil().setWidth(125), height: ScreenUtil().setWidth(42)),
    );
  }
}
