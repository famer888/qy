import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swiper_null_safety_flutter3/flutter_swiper_null_safety_flutter3.dart';
import 'package:qypj/ui_layer/screens/theme.dart';
import '../../../domain/model/banner_model.dart';
import '../../utils/common_utils.dart';
import 'my_image.dart';

class GeneralAppListSwiper extends StatefulWidget {
  GeneralAppListSwiper({
    super.key,
    required this.data,
    this.radius = 5,
    this.aspectRatio = 7 / 3,
    this.maxWidth = 375,
    this.columnNumber = 5,
    this.useMargin = false,
  });

  List<BannerModel> data;
  final double radius;
  final double aspectRatio;

  final double maxWidth;
  final int columnNumber;
  bool useMargin = false;

  @override
  State<GeneralAppListSwiper> createState() => _GeneralAppListSwiperState();
}

class _GeneralAppListSwiperState extends State<GeneralAppListSwiper> {
  double _childAspectRatio = 57 / 76;

  int _ColumeNumber = 5;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _ColumeNumber = widget.columnNumber;
  }

  @override
  Widget build(BuildContext context) {
    List<List<BannerModel>> pages = [];
    List<BannerModel> page = [];
    for (var element in widget.data ?? []) {
      if (page.length >= _ColumeNumber * 2) {
        pages.add(page);
        page = [];
      }
      page.add(element);
    }

    if (page.isNotEmpty) {
      pages.add(page);
    }

    return Container(
        child: widget.data.isEmpty
            ? Container()
            : LayoutBuilder(builder: (context, constrains) {
                double width = constrains.maxWidth;
                double itemWidth =
                    (width - (_ColumeNumber - 1) * 10.w) / _ColumeNumber;
                double itemHeight = itemWidth / _childAspectRatio;
                double bannerHeight = (itemHeight *
                        (pages.first.length <= _ColumeNumber ? 1 : 2)) +
                    (pages.first.length > _ColumeNumber ? 10.w : 0);

                return Container(
                  // color: Colors.amberAccent,
                  width: width,
                  height: bannerHeight,
                  child: widget.data.isEmpty
                      ? Container()
                      : Swiper(
                          autoplay: pages.length > 1,
                          loop: pages.length > 1,
                          itemBuilder: (BuildContext context, int index) {
                            double w = itemWidth;
                            return SizedBox(
                              width: width,
                              child: GridView.count(
                                  padding: EdgeInsets.only(bottom: 10.w),
                                  crossAxisCount: _ColumeNumber,
                                  mainAxisSpacing: 10.w,
                                  crossAxisSpacing: 10.w,
                                  physics: const NeverScrollableScrollPhysics(),
                                  childAspectRatio: _childAspectRatio,
                                  shrinkWrap: true,
                                  children: pages[index].map((e) {
                                    // return Container();

                                    return GestureDetector(
                                        behavior: HitTestBehavior.translucent,
                                        onTap: () {
                                          FocusManager.instance.primaryFocus
                                              ?.unfocus();
                                          CommonUtils.openRoute(
                                              context, e.toJson());
                                        },
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              width: w,
                                              height: w,
                                              child: MyImage.network(
                                                CommonUtils.getThumb(
                                                    e.toJson()),
                                                fit: BoxFit.cover,
                                                borderRadius: 8.w,
                                              ),
                                            ),
                                            // SizedBox(height: 8.w),
                                            Expanded(
                                              child: Container(
                                                alignment: Alignment.center,
                                                // color: Colors.blue,
                                                child: Text(
                                                  e.name ?? e.title ?? "",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      decoration:
                                                          TextDecoration.none,
                                                      height: 1,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 9.sp),
                                                ),
                                              ),
                                            )
                                          ],
                                        ));
                                  }).toList()

                                  // pages[index].map((e) {
                                  //   return Container();
                                  // }).toList(),
                                  ),
                            );
                          },
                          itemCount: pages.length,
                          pagination: pages.length > 1 || true
                              ? SwiperPagination(
                                  margin: EdgeInsets.zero,
                                  builder: SwiperCustomPagination(
                                      builder: (context, config) {
                                    int count = pages.length;
                                    return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: List.generate(count, (index) {
                                        return config.activeIndex == index
                                            ? Container(
                                                width: 10.w,
                                                height: 4.w,
                                                margin:
                                                    EdgeInsets.only(right: 4.w),
                                                decoration: BoxDecoration(
                                                  // color: StyleTheme.white255Color,
                                                  gradient:
                                                      MyTheme.gradient_90_114,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(2.w)),
                                                ),
                                              )
                                            : Container(
                                                width: 4.w,
                                                height: 4.w,
                                                margin:
                                                    EdgeInsets.only(right: 4.w),
                                                decoration: BoxDecoration(
                                                  color: MyTheme.white08Color,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(2.w)),
                                                ),
                                              );
                                      }),
                                    );
                                  }))
                              : null,
                        ),
                );
              }));
  }
}
