import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qypj/theme/default.dart';
import 'package:qypj/utils/common.dart';
import 'package:qypj/utils/index.dart';
import 'package:qypj/utils/networkImage.dart';

class ComicsImg extends StatefulWidget {
  final String img;
  final double height;
  final double width;
  final int index;
  final int currentIndex; //当前图片在列表中的位置
  final Function setPosition; //用于修改当前漫画进度，返回值为当前进度
  final int length; //共有多少图
  final bool isHorizontal; //左右翻页
  final bool isTap;
  ComicsImg(
      {Key key,
      this.index,
      this.setPosition,
      this.length,
      this.currentIndex,
      this.isTap,
      this.isHorizontal = false,
      this.img,
      this.height,
      this.width})
      : super(key: key);

  @override
  _ComicsImgState createState() => _ComicsImgState();
}

class _ComicsImgState extends State<ComicsImg> {
  GlobalKey _key = GlobalKey();
  double pageOffset;
  @override
  void initState() {
    super.initState();
    var segmet = ScreenUtil().setWidth(295) / widget.length;
    pageOffset = segmet * (widget.index + 1);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      EventBus().on('GETOFFSET', (arg) {
        //利用全局事件总线计算
        _getRenderBox();
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  _getRenderBox() {
    if (!widget.isTap && widget.index != widget.currentIndex) {
//获取`RenderBox`对象
      try {
        if (widget.isHorizontal) {
          RenderBox renderBox = _key.currentContext.findRenderObject();
          Offset offset = renderBox.localToGlobal(Offset(0, 0));
          var leftDx = offset.dx;
          var screenWidth = ScreenUtil().screenWidth;
          if (leftDx + screenWidth / 2 >= 0 &&
              leftDx + renderBox.size.width >= screenWidth &&
              leftDx <= screenWidth / 2) {
            widget.setPosition(widget.index, pageOffset);
          }
        } else {
          RenderBox renderBox = _key.currentContext.findRenderObject();
          Offset offset = renderBox.localToGlobal(Offset(0, 0));
          var topDy = offset.dy;
          var screenHeight =
              ScreenUtil().screenHeight - ScreenUtil().statusBarHeight;
          if (_key.currentContext.size.height + topDy >=
                  ScreenUtil().screenHeight &&
              widget.index == widget.length) {}
          if (topDy < ScreenUtil().screenHeight / 2 &&
              _key.currentContext.size.height + topDy >
                  ScreenUtil().screenHeight / 2) {
            widget.setPosition(widget.index, pageOffset);
          }
        }
      } catch (e) {}
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: _key,
      child: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              color: Colors.black,
              height: (ScreenUtil().screenWidth / widget.width) * widget.height,
              width: ScreenUtil().screenWidth,
              child: PlatformAwareNetworkImage(
                noVisibilityDetector: true,
                url: clipImageUrl(widget.img, inputWidth: widget.width),
                filterQuality: FilterQuality.high,
                fit: BoxFit.cover,
              ),
            ),
            // Text(
            //   'index = ${widget.index}', // \nwidth = ${widget.width}\n height = ${widget.height}',
            //   style: GQStyle.white255_25_B,
            // )
          ],
        ),
      ),
    );
  }
}
