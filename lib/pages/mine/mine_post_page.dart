import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qypj/base/baseWidget.dart';
import 'package:qypj/model/homedata.dart';
import 'package:qypj/pages/mine/mine_user_center_post.dart';
import 'package:qypj/store/homeConfig.dart';
import 'package:qypj/theme/default.dart';
import 'package:qypj/utils/common.dart';
import 'package:qypj/utils/extensionlibrary.dart';
import 'package:provider/provider.dart';

class MinePostPage extends BaseWidget {
  MinePostPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> cState() {
    // TODO: implement cState
    return _MinePostPageState();
  }
}

class _MinePostPageState extends BaseWidgetState<MinePostPage> {
  @override
  void onCreate() {
    // TODO: implement onCreate
    setAppTitle(title: CommonUtils.txt("fbdtz"));
  }

  @override
  void onDestroy() {
    // TODO: implement onDestroy
  }

  @override
  Widget pageBody(BuildContext context) {
    // TODO: implement pageBody
    Member member = Provider.of<HomeConfig>(context, listen: true).member;
    return Column(
      children: [
        SizedBox(height: 10.w),
        Container(
          margin: EdgeInsets.symmetric(horizontal: GQStyle.pagePadding),
          padding: EdgeInsets.symmetric(horizontal: GQStyle.pagePadding),
          height: 100.w,
          decoration: BoxDecoration(
              color: Color(0xFF2a2a42),
              borderRadius: BorderRadius.all(Radius.circular(8.w))),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                  CommonUtils.txt('ktxsy') +
                      "：${member.incomeMoney}${CommonUtils.txt('bs')}",
                  style: GQStyle.white15),
              SizedBox(height: 10.w),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      context.push('/mineAgentToCashPage/0');
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: ScreenUtil().setWidth(100),
                      height: ScreenUtil().setWidth(30),
                      decoration: BoxDecoration(
                          gradient: GQStyle.btnGradient_ff00edfd_ffbbe954,
                          borderRadius:
                              BorderRadius.circular(ScreenUtil().setWidth(15))),
                      child: Text(
                        CommonUtils.txt('ljtx'),
                        style: GQStyle.white14,
                      ),
                    ),
                  ),
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      context.push('/minencomedetailed');
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: ScreenUtil().setWidth(100),
                      height: ScreenUtil().setWidth(30),
                      decoration: BoxDecoration(
                          gradient: GQStyle.btnGradient_ff00edfd_ffbbe954,
                          borderRadius:
                              BorderRadius.circular(ScreenUtil().setWidth(15))),
                      child: Text(
                        CommonUtils.txt('symx'),
                        style: GQStyle.white14,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        SizedBox(height: 10.w),
        Expanded(child: MineUserCenterPost())
      ],
    );
  }
}
