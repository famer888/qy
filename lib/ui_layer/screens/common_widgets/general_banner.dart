import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swiper_null_safety_flutter3/flutter_swiper_null_safety_flutter3.dart';
import 'package:provider/provider.dart';
import '../../notifiers/home_config_notifier.dart';
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

class GeneralAppsListVidget extends StatefulWidget {
  const GeneralAppsListVidget({
    super.key,
    required this.data,
    this.radius = 5,
    this.aspectRatio = 7 / 3,
  });
  final List<BannerModel> data;
  final double radius;
  final double aspectRatio;
  State<GeneralAppsListVidget> createState() => _GeneralAppsListVidgetState();
}

class _GeneralAppsListVidgetState extends State<GeneralAppsListVidget> {
  late final homeConfigNotifier = context.read<HomeConfigNotifier>();
  List<BannerModel> apps = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (widget.data != null) {
      apps = widget.data ?? [];
    } else {
      // apps = homeConfigNotifier.homeData.adsDetailBlock ?? [];
    }
  }

  @override
  Widget build(BuildContext context) {
    if (homeConfigNotifier.config.adVersion != 1) {
      return GeneralBanner(
        data: widget.data,
        radius: widget.radius,
        aspectRatio: widget.aspectRatio,
      );
    }
    return apps.isEmpty
        ? Container()
        : GridView.builder(
            shrinkWrap: true,
            addRepaintBoundaries: false,
            addAutomaticKeepAlives: false,
            physics: const BouncingScrollPhysics(),
            itemCount: apps.length,
            padding: EdgeInsets.symmetric(vertical: 5.w),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 6,
              mainAxisSpacing: 10.w,
              crossAxisSpacing: 10.w,
              childAspectRatio: 57 / 77,
            ),
            itemBuilder: (context, index) {
              BannerModel? model = apps[index];
              return GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  final json = model.toJson() ?? {};
                  CommonUtils.openRoute(context, json);
                },
                child: Column(
                  children: [
                    AspectRatio(
                      aspectRatio: 1,
                      child: MyImage.network(
                        CommonUtils.getThumb(widget.data[index].toJson()),
                        fit: BoxFit.fill,
                        borderRadius: 6.w,
                      ),
                    ),
                    SizedBox(height: 5.w),
                    Text(
                      model.name ?? model.title ?? '',
                      style: TextStyle(
                          color: Colors.white,
                          overflow: TextOverflow.ellipsis,
                          decoration: TextDecoration.none,
                          height: 1,
                          fontWeight: FontWeight.w600,
                          fontSize: 10.sp),
                      maxLines: 1,
                    ),
                  ],
                ),
              );
            });
  }
}
