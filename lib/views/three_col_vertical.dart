import 'package:flutter/material.dart';
import 'package:flutter_html/shims/dart_ui_real.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qypj/theme/default.dart';
import 'package:qypj/utils/common.dart';
import 'package:qypj/utils/extensionlibrary.dart';
import 'package:qypj/utils/networkImage.dart';
import 'package:qypj/views/double_col_vertical.dart';

//三列竖屏 type = 13
class ThreeColVertical extends StatefulWidget {
  ThreeColVertical({Key key, this.data, this.innerWidget = false})
      : super(key: key);
  dynamic data;
  bool innerWidget;
  @override
  State<ThreeColVertical> createState() => _ThreeColVerticalState();
}

class _ThreeColVerticalState extends State<ThreeColVertical> {
  double _w = (ScreenUtil().screenWidth -
          GQStyle.pagePadding * 2 -
          ScreenUtil().setWidth(20)) /
      3;
  List<dynamic> _values;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.data == null) return;
    _values = widget.data["value"];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SectionTitleWidget(
          title: widget.data["title"] ?? "loading",
          subTitle: "loading",
          showMoreButton: widget.data["more_button"] == 1,
          moreActionBlock: () {
            // CommonUtils.debugPrint('点击了更多');
            if (widget.data["content_type"] == 2) {
              context.push("/more_and_more_comc/${widget.data["id"] ?? "0"}");
            } else if (widget.data["content_type"] == 3) {
              context
                  .push("/more_and_more_nvel/0/0/${widget.data["id"] ?? "0"}");
            }
          },
        ),
        SizedBox(height: ScreenUtil().setWidth(5.5)),
        GridView.count(
          padding: EdgeInsets.symmetric(horizontal: GQStyle.pagePadding),
          shrinkWrap: true,
          crossAxisCount: 3,
          mainAxisSpacing: ScreenUtil().setWidth(10),
          crossAxisSpacing: ScreenUtil().setWidth(10),
          childAspectRatio:
              110 / (widget.data["content_type"] == 6 ? 180 : 200),
          scrollDirection: Axis.vertical,
          physics: NeverScrollableScrollPhysics(),
          children: _values.map((e) => getCellItem(e)).toList(),
        ),
        SizedBox(height: ScreenUtil().setWidth(16.5))
      ],
    );
  }

  Widget getCellItem(dynamic e) {
    return GestureDetector(
        onTap: () {
          if (widget.data["content_type"] == 2) {
            context.push(
                CommonUtils.getRealHash('comicsdetail/${e["id"] ?? "0"}'));
          } else if (widget.data["content_type"] == 6) {
            context
                .push(CommonUtils.getRealHash('atlasDetail/${e["id"] ?? "0"}'));
          } else if (widget.data["content_type"] == 3) {
            context
                .push(CommonUtils.getRealHash('novelDetail/${e["id"] ?? "0"}'));
          }
        },
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: _w / 111 * 152,
                  child: PlatformAwareNetworkImage(
                      url: clipImageUrl(CommonUtils.getThumb(e),
                          inputWidth: ScreenUtil().setWidth(111)),
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                ),
                SizedBox(height: ScreenUtil().setWidth(3.5)),
                Text(e["title"] ?? "loading", style: GQStyle.white255_13),
                SizedBox(height: ScreenUtil().setWidth(3.5)),
                widget.data["content_type"] == 6 //美图标识
                    ? Container()
                    : Text(
                        widget.innerWidget
                            ? (e["finished"] == 1
                                ? "${CommonUtils.txt("wj")} ${CommonUtils.txt("gng")}${e["series"]}${CommonUtils.txt("hua")}"
                                : "${CommonUtils.txt("gxz")}${e["series"]}${CommonUtils.txt("hua")}")
                            : e["sub_title"] ?? "loading",
                        style: GQStyle.gray128_11,
                        strutStyle: StrutStyle(height: 1),
                      )
              ],
            ),
            Positioned(
                right: 0,
                top: 0,
                child: CommonUtils.identiWget(e,
                    isHideCoin: widget.data["content_type"] == 2 ||
                        widget.data["content_type"] == 6))
          ],
        ));
  }
}

class SectionTitleWidget extends StatefulWidget {
  SectionTitleWidget(
      {Key key,
      this.title = "loading",
      this.subTitle = "",
      this.showMoreButton = false,
      this.moreActionBlock})
      : super(key: key);

  String title;
  String subTitle;
  bool showMoreButton;
  Function moreActionBlock;

  @override
  State<SectionTitleWidget> createState() => _SectionTitleWidgetState();
}

class _SectionTitleWidgetState extends State<SectionTitleWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Padding(
        padding: EdgeInsets.symmetric(horizontal: GQStyle.pagePadding),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              LImage(
                "max_triangle_n",
                width: ScreenUtil().setWidth(18),
                height: ScreenUtil().setWidth(18),
              ),
              SizedBox(width: ScreenUtil().setWidth(3.5)),
              Expanded(
                  child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(widget.title, style: GQStyle.white255_20_M),
                  SizedBox(width: ScreenUtil().setWidth(8.5)),
                  Expanded(
                    child: Text("", style: GQStyle.gray168_12),
                  ),
                  SizedBox(width: ScreenUtil().setWidth(8.5)),
                ],
              )),
              widget.showMoreButton == false
                  ? Container()
                  : GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        widget.moreActionBlock();
                      },
                      child: Row(
                        children: [
                          Text(CommonUtils.txt("gdjc"),
                              style: GQStyle.hex00edfd_11),
                          SizedBox(width: ScreenUtil().setWidth(1)),
                          LImage("more_arrow_n",
                              width: ScreenUtil().setWidth(17),
                              height: ScreenUtil().setWidth(17))
                        ],
                      ),
                    )
            ]),
      ),
      SizedBox(height: ScreenUtil().setWidth(5.5)),
      (widget.subTitle.length == 0 || widget.subTitle == null)
          ? Container()
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(width: GQStyle.pagePadding),
                Expanded(
                  child: Text(widget.subTitle, style: GQStyle.gray168_13),
                ),
              ],
            ),
    ]);
  }
}

class ThreeColVerticalItem extends StatefulWidget {
  ThreeColVerticalItem({Key key}) : super(key: key);

  @override
  State<ThreeColVerticalItem> createState() => _ThreeColVerticalItemState();
}

class _ThreeColVerticalItemState extends State<ThreeColVerticalItem> {
  @override
  Widget build(BuildContext context) {}
}

mixin titleSectionMixin {}
