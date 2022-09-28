import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qypj/components/card/avatar.dart';
import 'package:qypj/components/common/widgetitlebar.dart';
import 'package:qypj/theme/default.dart';
import 'package:qypj/utils/common.dart';

class ScrollAvatar extends StatefulWidget {
  ScrollAvatar({Key key}) : super(key: key);
  @override
  _ScrollAvatarState createState() => _ScrollAvatarState();
}

class _ScrollAvatarState extends State<ScrollAvatar> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: ScreenUtil().setWidth(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          WidgetTitleBar(title: CommonUtils.txt('yhzs')),
          Container(
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [1, 2, 3, 4, 5, 6, 7, 8]
                  .asMap()
                  .keys
                  .map(
                    (e) => Avatar(
                      thumbUrl: 'https://staff.tea123.me/e.jpg',
                      title: CommonUtils.txt('mz') + '1',
                      tagicoUrl: 'https://staff.tea123.me/e.jpg',
                      size: 50,
                      margin: EdgeInsets.only(right: ScreenUtil().setWidth(16)),
                    ),
                  )
                  .toList(),
            ),
            height: ScreenUtil().setWidth(76),
          )
        ],
      ),
    );
  }
}
