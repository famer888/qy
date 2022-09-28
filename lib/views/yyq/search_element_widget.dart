import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qypj/routers.dart';
import 'package:qypj/theme/default.dart';
import 'package:qypj/utils/common.dart';
import 'package:qypj/utils/extensionlibrary.dart';

/// TYPE_1001 => '搜索栏',
class SearchElementWidget extends StatelessWidget {
  const SearchElementWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          left: GQStyle.pagePadding,
          right: GQStyle.pagePadding,
          top: ScreenUtil().setWidth(5),
          bottom: ScreenUtil().setWidth(5)),
      // height: ScreenUtil().setWidth(53),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
              child: GestureDetector(
            onTap: () {
              context.push('/${Routes.search}');
            },
            child: Container(
              height: ScreenUtil().setWidth(35),
              decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(ScreenUtil().setWidth(35 / 2)),
                  color: Color.fromRGBO(47, 47, 66, 1)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(width: ScreenUtil().setWidth(10)),
                  LImage("search_g",
                      width: ScreenUtil().setWidth(12),
                      height: ScreenUtil().setWidth(12)),
                  SizedBox(width: ScreenUtil().setWidth(8)),
                  Text(
                    CommonUtils.txt("stzdmmhbt"),
                    style: GQStyle.gray172_14,
                  ),
                ],
              ),
            ),
          )),
          SizedBox(
            width: ScreenUtil().setWidth(10),
          ),
          LImage(
            'search_icon',
            width: ScreenUtil().setWidth(39.7),
          ),
        ],
      ),
    );
  }
}
