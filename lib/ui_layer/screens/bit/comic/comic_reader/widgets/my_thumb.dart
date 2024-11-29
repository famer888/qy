import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyThumb extends SliderComponentShape {
  MyThumb({required this.progressNotifier});

  final ValueNotifier<(int, int)> progressNotifier;

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return const Size(15, 40);
  }

  TextPainter labelTextPainter = TextPainter()
    ..textDirection = TextDirection.ltr;

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final canvas = context.canvas;
    final paint = Paint();

    final colorTween = ColorTween(
      begin: sliderTheme.disabledThumbColor,
      end: sliderTheme.thumbColor,
    );

    final color = colorTween.evaluate(enableAnimation)!;
    paint.color = color;
    paint.isAntiAlias = true;

    canvas.drawCircle(center, 5.w, paint);

    final value = progressNotifier.value;
    labelTextPainter.text = TextSpan(
      text: '${value.$1}/${value.$2}',
      style: TextStyle(
        fontSize: 12.sp,
        color: Colors.white.withOpacity(0.7),
      ),
    );
    labelTextPainter.layout();
    labelTextPainter.paint(
        canvas, center.translate(-labelTextPainter.width / 2, 9));
  }
}
