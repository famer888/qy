import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qypj/theme/default.dart';
import 'package:qypj/utils/common.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class LineLoadingBadge extends StatefulWidget {
  LineLoadingBadge({Key key}) : super(key: key);
  @override
  State<LineLoadingBadge> createState() => _LineLoadingBadgeState();
}

const double fadeBegin = 0.0; //0.6
const double fadeEnd = 1;

const double scaleBegin = 0.5; //0.95
const double scaleEnd = 1;

const double lineBegin = 0.0; //0.95
const double lineEnd = 1;

class _LineLoadingBadgeState extends State<LineLoadingBadge>
    with TickerProviderStateMixin {
  AnimationController _controller;
  Animation _fadeAnimation;

  AnimationController _scaleController;
  Animation _scaleAnimation;

  AnimationController _lineWidthController;
  Animation _lineWidthAnimation;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 800));
    _fadeAnimation = Tween<double>(begin: fadeBegin, end: fadeEnd)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    // ..addListener(() {
    //   if (_fadeAnimation.value == fadeBegin) {
    //     _controller.forward();
    //     _scaleController.forward();
    //   } else if (_fadeAnimation.value == fadeEnd) {
    //     _controller.reverse();
    //     _scaleController.reverse();
    //   }
    // });

    _scaleController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 800))
          ..addListener(() {
            setState(() {});
          });
    _scaleAnimation = Tween<double>(begin: scaleBegin, end: scaleEnd).animate(
        CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut));

    _lineWidthController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 800))
          ..addListener(() {
            setState(() {});
          });
    _lineWidthAnimation = Tween<double>(begin: lineBegin, end: lineEnd).animate(
        CurvedAnimation(parent: _lineWidthController, curve: Curves.easeInOut));

    _controller.repeat(reverse: true);
    _scaleController.repeat(reverse: true);
    _lineWidthController.repeat(reverse: true);
  }

  @override
  void didUpdateWidget(covariant LineLoadingBadge oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double fullWidth = ScreenUtil().setWidth(158);

    return Container(
      child: Stack(
        children: [
          LImage(
            '',
            // color: GQStyle.grayColor180,
            width: ScreenUtil().setWidth(158),
          ),
          // FadeTransition(
          //   opacity: _fadeAnimation,
          //   child: LImage(
          //     'loading_holder',
          //     // color: GQStyle.grayColor180,
          //     width: ScreenUtil().setWidth(158),
          //   ),
          // ),
          ClipPath(
            clipper: MyClipper(left: _lineWidthAnimation.value * fullWidth),
            child: Container(
              decoration: BoxDecoration(
                  // borderRadius: Border
                  ),
              width: ScreenUtil().setWidth(158),
              height: ScreenUtil().setWidth(55.5),
              child: LImage(
                '',
                // color: GQStyle.grayColor180,
                width: ScreenUtil().setWidth(158),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class MyClipper extends CustomClipper<Path> {
  MyClipper({this.left = 0}) : super();
  double left;
  @override
  Path getClip(Size size) {
    Path path = Path();

    path.moveTo(0, 0);
    path.lineTo(left, 0);
    path.lineTo(left, size.height);

    path.lineTo(left - 20, size.height);
    path.lineTo(left - 20, 0);

    // path.lineTo(0, size.height);
    // path.lineTo(0, 0);

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}

// class NakedchatBreathBadge extends StatefulWidget {
//   NakedchatBreathBadge({Key key}) : super(key: key);
//   @override
//   State<NakedchatBreathBadge> createState() => _NakedchatBreathBadgeState();
// }

// const double fadeBegin = 0.6; //0.6
// const double fadeEnd = 1;

// const double scaleBegin = 0.5; //0.95
// const double scaleEnd = 1;

// class _NakedchatBreathBadgeState extends State<NakedchatBreathBadge>
//     with TickerProviderStateMixin {
//   AnimationController _controller;
//   Animation _fadeAnimation;

//   AnimationController _scaleController;
//   Animation _scaleAnimation;

//   @override
//   void initState() {
//     super.initState();
//     _controller =
//         AnimationController(vsync: this, duration: Duration(milliseconds: 800));
//     _fadeAnimation = Tween<double>(begin: fadeBegin, end: fadeEnd)
//         .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

//     // ..addListener(() {
//     //   if (_fadeAnimation.value == fadeBegin) {
//     //     _controller.forward();
//     //     _scaleController.forward();
//     //   } else if (_fadeAnimation.value == fadeEnd) {
//     //     _controller.reverse();
//     //     _scaleController.reverse();
//     //   }
//     // });

//     _scaleController =
//         AnimationController(vsync: this, duration: Duration(milliseconds: 800))
//           ..addListener(() {
//             setState(() {});
//           });
//     _scaleAnimation = Tween<double>(begin: scaleBegin, end: scaleEnd).animate(
//         CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut));

//     _controller.repeat(reverse: true);
//     _scaleController.repeat(reverse: true);
//   }

//   @override
//   void didUpdateWidget(covariant NakedchatBreathBadge oldWidget) {
//     super.didUpdateWidget(oldWidget);
//   }

//   @override
//   void dispose() {
//     _scaleController.dispose();
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: FadeTransition(
//         opacity: _fadeAnimation,
//         child: Transform.scale(
//           scale: _scaleAnimation.value,

//           child: SizedBox.square(
//               dimension: ScreenUtil().setWidth(64), child: LImage('figure_n')),
//           // child: Container(
//           //   // color: Color.fromRGBO(130, 255, 141, 1),
//           //   width: 12,
//           //   height: 12,
//           //   child: CustomPaint(
//           //     painter: NakedchatLiveBadge(),
//           //   ),
//           // ),
//         ),
//       ),
//     );
//   }
// }

class NakedchatLiveBadge extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..isAntiAlias = true
      ..color = Color.fromRGBO(130, 255, 141, 1)
      ..strokeWidth = 1;

    double width = 12;
    canvas.drawOval(
        Offset(size.width / 2.0 - width / 2.0,
                size.height / 2.0 - width / 2.0) &
            Size(width, width),
        paint);

    double centerWidth = width - 5;

    paint.style = PaintingStyle.fill;
    canvas.drawOval(
        Offset(size.width / 2.0 - centerWidth / 2.0,
                size.height / 2.0 - centerWidth / 2.0) &
            Size(centerWidth, centerWidth),
        paint);

    // canvas.d)
    // canvas.drawArc(Offset(0, 0) & size, startAngle, sweepAngle, useCenter, paint)
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
