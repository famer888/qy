import 'package:flutter/material.dart';
import 'package:qypj/theme/default.dart';

class MoreRightArrowWidget extends StatelessWidget {
  const MoreRightArrowWidget({this.width = 100});

  final double width;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: width * (11 / 7.5),
      child: CustomPaint(
        painter: _MoreRightArrowPaiter(),
      ),
    );
  }
}

class _MoreRightArrowPaiter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double width = size.height / 6.0;
    double height = size.width / 3.0;

    // width = 40;
    // double width = size.height / 6.0;

    Path path = Path();
    path.moveTo(0, 0);
    path.lineTo(
      size.width,
      size.height / 2.0,
    );
    path.lineTo(0, size.height);
    path.lineTo(0, size.height - width);
    path.lineTo(
      size.width - height,
      size.height / 2.0,
    );
    path.lineTo(0, width);
    Paint paint = Paint();
    paint.style = PaintingStyle.fill;
    paint.color = GQStyle.cyanColor00edfd;

    canvas.drawPath(path, paint);

    path = Path();
    path.moveTo(0, size.height / 2.0 - width);
    path.lineTo(
      height,
      size.height / 2.0,
    );
    path.lineTo(0, size.height / 2.0 + width);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
