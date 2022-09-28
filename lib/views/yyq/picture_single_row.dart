import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qypj/theme/default.dart';
import 'package:qypj/utils/common.dart';
import 'package:qypj/utils/extensionlibrary.dart';
import 'package:qypj/utils/networkImage.dart';

/// 美图-单行 type=12
class PictureSingleRow extends StatelessWidget {
  PictureSingleRow({Key key, this.data}) : super(key: key);
  dynamic data;

  double _w = (ScreenUtil().screenWidth -
          GQStyle.pagePadding * 2 -
          ScreenUtil().setWidth(20)) /
      3;

  List<dynamic> _values;

  @override
  Widget build(BuildContext context) {
    if (data == null) return Container();
    _values = data["value"];
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: GQStyle.pagePadding),
          child: SizedBox(
            height: ScreenUtil().setWidth(50),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                      child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(data["title"] ?? "loading",
                          style: GQStyle.white20medium),
                      SizedBox(width: ScreenUtil().setWidth(8.5)),
                      Expanded(
                        child: Text(data["sub_title"] ?? "loading",
                            style: GQStyle.graya3a2a2_11),
                      ),
                      SizedBox(width: ScreenUtil().setWidth(8.5)),
                    ],
                  )),
                  data["more_button"] == 0
                      ? Container()
                      : GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            context.push('/more_and_more_page', extra: data);
                          },
                          child: Row(
                            children: [
                              Text(CommonUtils.txt("gdjc"),
                                  style: GQStyle.jellyCyan_11),
                              LImage(
                                'more_arrow_cyan_right',
                                width: ScreenUtil().setWidth(17),
                                height: ScreenUtil().setWidth(17),
                              ),
                            ],
                          ),
                        )
                ]),
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: GQStyle.pagePadding),
            scrollDirection: Axis.horizontal,
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _values
                    .map((e) => Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: ScreenUtil().setWidth(145),
                              child: GestureDetector(
                                onTap: () {
                                  if (data["content_type"] == 2) {
                                    context.push(CommonUtils.getRealHash(
                                        'comicsdetail/${e["id"] ?? "0"}'));
                                  } else if (data["content_type"] == 6) {
                                    context.push(CommonUtils.getRealHash(
                                        'atlasDetail/${e["id"] ?? "0"}'));
                                  }
                                },
                                child: Stack(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: ScreenUtil().setWidth(195),
                                          child: PlatformAwareNetworkImage(
                                              url: clipImageUrl(
                                                  CommonUtils.getThumb(e),
                                                  inputWidth: ScreenUtil()
                                                      .setWidth(145)),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5))),
                                        ),
                                        SizedBox(
                                          height: ScreenUtil().setWidth(25),
                                          child: Center(
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                e["title"] ?? "loading",
                                                style: GQStyle.white13,
                                                maxLines: 1,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Positioned(
                                        left: ScreenUtil().setWidth(7.5),
                                        top: ScreenUtil().setWidth(7.5),
                                        child: CommonUtils.identifyWidget(e,
                                            isHideCoin:
                                                data["content_type"] == 2 ||
                                                    data["content_type"] == 6))
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(width: ScreenUtil().setWidth(10))
                          ],
                        ))
                    .toList()),
          ),
        ),
        SizedBox(
          height: ScreenUtil().setWidth(10),
        )
      ],
    );
  }
}
