import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swiper_null_safety_flutter3/flutter_swiper_null_safety_flutter3.dart';
import '../../../domain/model/banner_model.dart';
import '../../utils/common_utils.dart';
import 'my_image.dart';

class GeneralBanner extends StatefulWidget {
  const GeneralBanner({
    super.key,
    required this.data,
    this.radius = 5,
    this.aspectRatio = 7 / 3,
  });
  final List<BannerModel> data;
  final double radius;
  final double aspectRatio;

  @override
  State<GeneralBanner> createState() => _GeneralBannerState();
}

class _GeneralBannerState extends State<GeneralBanner> {
  @override
  Widget build(BuildContext context) {
    final length = widget.data.length;

    return ClipRRect(
      borderRadius: BorderRadius.circular(widget.radius),
      child: AspectRatio(
        aspectRatio: widget.aspectRatio,
        child: Swiper(
          autoplay: length > 1,
          itemBuilder: (BuildContext context, int index) {
            precacheImage(
                NetworkImage(CommonUtils.getThumb(
                    widget.data[(index + 1).clamp(0, length - 1)].toJson())),
                context);

            return GestureDetector(
              onTap: () {
                FocusManager.instance.primaryFocus?.unfocus();
                CommonUtils.openRoute(context, widget.data[index].toJson());
              },
              child: MyImage.network(
                CommonUtils.getThumb(widget.data[index].toJson()),
                fit: BoxFit.cover,
              ),
            );
          },
          itemCount: length,
          pagination: SwiperPagination(
            builder: SwiperCustomPagination(
              builder: (context, config) => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  length,
                  (index) {
                    bool isActive = config.activeIndex == index;
                    return Container(
                      width: 5.w,
                      height: 5.w,
                      margin: EdgeInsets.only(right: 7.w),
                      decoration: BoxDecoration(
                        color: isActive
                            ? Colors.white
                            : Colors.white.withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
