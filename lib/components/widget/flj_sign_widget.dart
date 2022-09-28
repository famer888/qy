import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qypj/utils/common.dart';
import 'package:qypj/utils/extensionlibrary.dart';

/// 签到 widget
class FljSignWidget extends StatelessWidget {
  const FljSignWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _GradientPainter _painter = _GradientPainter(
        strokeWidth: 1.5,
        radius: ScreenUtil().setWidth(8),
        gradient:
            LinearGradient(colors: [Color(0xfffcfb31), Color(0xff01f8e2)]));

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        context.push('/sign');
      },
      child: Container(
        width: ScreenUtil().setWidth(70),
        height: ScreenUtil().setWidth(44),
        child: IndexedStack(
          index: 0,
          children: [
            LImage('wode_qd'),
          ],
        ),
      ),
    );
  }
}

class _GradientPainter extends CustomPainter {
  final Paint _paint = Paint();
  final double radius;
  final double strokeWidth;
  final Gradient gradient;

  _GradientPainter(
      {@required double strokeWidth,
      @required double radius,
      @required Gradient gradient})
      : this.strokeWidth = strokeWidth,
        this.radius = radius,
        this.gradient = gradient;

  @override
  void paint(Canvas canvas, Size size) {
    // create outer rectangle equals size
    Rect outerRect = Offset.zero & size;
    var outerRRect =
        RRect.fromRectAndRadius(outerRect, Radius.circular(radius));

    // create inner rectangle smaller by strokeWidth
    Rect innerRect = Rect.fromLTWH(strokeWidth, strokeWidth,
        size.width - strokeWidth * 2, size.height - strokeWidth * 2);
    var innerRRect = RRect.fromRectAndRadius(
        innerRect, Radius.circular(radius - strokeWidth));

    // apply gradient shader
    _paint.shader = gradient.createShader(outerRect);

    // create difference between outer and inner paths and draw it
    Path path1 = Path()..addRRect(outerRRect);
    Path path2 = Path()..addRRect(innerRRect);
    var path = Path.combine(PathOperation.difference, path1, path2);
    canvas.drawPath(path, _paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => oldDelegate != this;
}
