import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qypj/theme/default.dart';
import 'package:qypj/utils/common.dart';
import 'package:qypj/utils/networkImage.dart';

// ignore: must_be_immutable
class Avatar extends StatefulWidget {
  Avatar(
      {Key key,
      this.thumbUrl,
      this.title,
      this.tagicoUrl,
      this.size = 50,
      this.direction = Axis.vertical,
      this.followStatus = 0, // 0表示不显示“关注”，1表示已关注，2表示位未关注
      this.margin})
      : super(key: key);
  String thumbUrl;
  String title;
  String tagicoUrl;
  double size;
  Axis direction;
  EdgeInsets margin;
  int followStatus;
  @override
  _AvatarState createState() => _AvatarState();
}

class _AvatarState extends State<Avatar> {
  @override
  void initState() {
    super.initState();
  }

  Widget renderFollow() {
    if (widget.followStatus == 1) {
      return Padding(
        padding: widget.direction == Axis.vertical
            ? EdgeInsets.only(top: ScreenUtil().setWidth(6))
            : EdgeInsets.only(left: ScreenUtil().setWidth(9)),
        child: Text(
          '· ' + CommonUtils.txt('ygz'),
          style: GQStyle.gray13,
        ),
      );
    } else if (widget.followStatus == 2) {
      return Padding(
        padding: widget.direction == Axis.vertical
            ? EdgeInsets.only(top: ScreenUtil().setWidth(6))
            : EdgeInsets.only(left: ScreenUtil().setWidth(9)),
        child: Text(
          '· ' + CommonUtils.txt('gz'),
          style: GQStyle.red13,
        ),
      );
    }
    return Container();
  }

  List<Widget> renderChildren() {
    return [
      Stack(
        children: [
          Container(
            child: PlatformAwareNetworkImage(
                url: widget.thumbUrl,
                borderRadius: BorderRadius.all(
                    Radius.circular(ScreenUtil().setWidth(widget.size / 2))),
                clipBehavior: Clip.hardEdge),
            width: ScreenUtil().setWidth(widget.size),
            height: ScreenUtil().setWidth(widget.size),
          ),
          widget.tagicoUrl != null
              ? Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    child: PlatformAwareNetworkImage(url: widget.tagicoUrl),
                    width: ScreenUtil().setWidth(16),
                    height: ScreenUtil().setWidth(16),
                  ))
              : Container()
        ],
      ),
      widget.title != null
          ? Padding(
              padding: widget.direction == Axis.vertical
                  ? EdgeInsets.only(top: ScreenUtil().setWidth(6))
                  : EdgeInsets.only(left: ScreenUtil().setWidth(10.7)),
              child: widget.direction == Axis.vertical
                  ? Text(
                      widget.title,
                      style: GQStyle.black16bold34,
                    )
                  : Text(
                      widget.title,
                      style: GQStyle.black16bold34,
                    ),
            )
          : Container(),
      renderFollow()
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.margin ?? EdgeInsets.zero,
      child: widget.direction == Axis.vertical
          ? Column(
              children: renderChildren(),
            )
          : Row(
              children: renderChildren(),
            ),
    );
  }
}
