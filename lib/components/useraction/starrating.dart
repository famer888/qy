import 'package:flutter/material.dart';

typedef void RatingChangeCallback(double rating);

class StarRating extends StatelessWidget {
  final int starCount;
  final double rating;
  final RatingChangeCallback onRatingChanged;
  final Color color;
  final Color borderColor;
  final double size;
  final double spacing;
  final bool disable;

  StarRating({
    this.starCount = 5,
    this.spacing = 15.0,
    this.rating = 0.0,
    this.onRatingChanged,
    this.color,
    this.borderColor,
    this.size = 20,
    this.disable = false,
  }) {
    assert(this.rating != null);
  }

  Widget buildStar(BuildContext context, int index) {
    ImageIcon icon;
    if (index >= rating) {
      icon = new ImageIcon(
        AssetImage("assets/images/yuepao/star_border.png"),
        color: Color(0xFFFF4149),
        size: size,
      );
    } else {
      icon = new ImageIcon(
        AssetImage("assets/images/yuepao/star.png"),
        color: Color(0xFFFF4149),
        size: size,
      );
    }
    return new GestureDetector(
      onTap: () {
        if (this.onRatingChanged != null && this.disable == false)
          onRatingChanged(index + 1.0);
      },
      onHorizontalDragUpdate: (dragDetails) {
        RenderBox box = context.findRenderObject();
        var _pos = box.globalToLocal(dragDetails.globalPosition);
        var i = _pos.dx / size;
        var newRating = i.round().toDouble();
        if (newRating > starCount) {
          newRating = starCount.toDouble();
        }
        if (newRating < 0) {
          newRating = 0.0;
        }
        if (this.onRatingChanged != null) onRatingChanged(newRating);
      },
      child: icon,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Material(
      color: Colors.transparent,
      child: new Wrap(
          alignment: WrapAlignment.start,
          spacing: spacing,
          children: new List.generate(
              starCount, (index) => buildStar(context, index))),
    );
  }
}
