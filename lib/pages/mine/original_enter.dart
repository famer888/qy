import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qypj/base/baseWidget.dart';
import 'package:qypj/model/homedata.dart';
import 'package:qypj/store/homeConfig.dart';
import 'package:qypj/theme/default.dart';
import 'package:qypj/utils/common.dart';
import 'package:provider/provider.dart';

class OriginalEnter extends BaseWidget {
  OriginalEnter({Key key}) : super(key: key);

  @override
  State<StatefulWidget> cState() {
    // TODO: implement cState
    return _OriginalEnterState();
  }
}

class _OriginalEnterState extends BaseWidgetState<OriginalEnter> {
  @override
  void onCreate() {
    // TODO: implement onCreatez
    setAppTitle(title: CommonUtils.txt('ycrz'));
  }

  @override
  void onDestroy() {
    // TODO: implement onDestroy
  }

  @override
  Widget pageBody(BuildContext context) {
    // TODO: implement pageBody
    Config config = Provider.of<HomeConfig>(context, listen: false).config;
    return Stack(
      children: [
        LImage(
          "me_original_n",
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
        ),
        Positioned(
            left: 70.w,
            right: 70.w,
            bottom: 180.w,
            child: Column(
              children: [
                Text(
                  '请通过以下方式添加官方审核账号',
                  style: GQStyle.black15,
                  maxLines: 2,
                ),
                SizedBox(height: 20.w),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        CommonUtils.launchURL(config.potato_group);
                      },
                      child: Column(
                        children: [
                          LImage('wd_lxpotao', width: 39.w, height: 39.w),
                          SizedBox(height: 10.w),
                          Text(CommonUtils.txt('gfqtd'), style: GQStyle.black15)
                        ],
                      ),
                    ),
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        CommonUtils.launchURL(config.tg_group);
                      },
                      child: Column(
                        children: [
                          LImage('wd_lxtg_n', width: 39.w, height: 39.w),
                          SizedBox(height: 10.w),
                          Text(CommonUtils.txt('gfqfj'), style: GQStyle.black15)
                        ],
                      ),
                    )
                  ],
                )
              ],
            ))
      ],
    );
  }
}
