import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qypj/theme/default.dart';
import 'package:qypj/utils/common.dart';
import 'package:qypj/utils/extensionlibrary.dart';

//发现标签_更多
class CommunityTags extends StatefulWidget {
  CommunityTags({Key key, this.data, this.isMore = true}) : super(key: key);
  final List<dynamic> data;
  final bool isMore; //是否更多

  @override
  State<CommunityTags> createState() => _CommunityTagsState();
}

class _CommunityTagsState extends State<CommunityTags> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          top: ScreenUtil().setWidth(20),
          bottom: ScreenUtil().setWidth(15),
          left: GQStyle.pagePadding,
          right: GQStyle.pagePadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(CommonUtils.txt("fxbq"), style: GQStyle.white255_18_M),
              widget.isMore
                  ? GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        context.push("/communitytagsall/0");
                      },
                      child: Row(
                        children: [
                          Text(CommonUtils.txt("gd"), style: GQStyle.blue80_11),
                          LImage(
                            "more_arrow_n",
                            width: ScreenUtil().setWidth(18),
                            height: ScreenUtil().setWidth(18),
                          )
                        ],
                      ),
                    )
                  : Container()
            ],
          ),
          SizedBox(height: ScreenUtil().setWidth(15)),
          Wrap(
            alignment: WrapAlignment.start,
            crossAxisAlignment: WrapCrossAlignment.start,
            runSpacing: GQStyle.pagePadding,
            spacing: GQStyle.pagePadding,
            children: widget.data
                .map((e) => GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        context.push("/communitytagdetail/${e["id"]}");
                      },
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text.rich(TextSpan(children: [
                              WidgetSpan(
                                alignment: PlaceholderAlignment.middle,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      right: ScreenUtil().setWidth(5.5)),
                                  child: LImage(
                                    "comm_tag_n",
                                    width: ScreenUtil().setWidth(16),
                                    height: ScreenUtil().setWidth(14),
                                  ),
                                ),
                              ),
                              TextSpan(
                                  text: '${e['name']}',
                                  style: GQStyle.white255_13)
                            ]))
                          ],
                        ),
                      ),
                    ))
                .toList(),
          )
        ],
      ),
    );
  }
}
