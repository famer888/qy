import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../app_global.dart';
import '../../../../domain/domain.dart';
import '../../../../domain/model/girl/girl_list_model.dart';
import '../../../../domain/model/girl/girl_option_model.dart';
import '../../../router/routes.dart';
import '../../../utils/common_utils.dart';
import '../../bit/comic/di/notifier.dart';
import '../../image_paths.dart';
import '../../theme.dart';
import '../my_button.dart';
import '../my_image.dart';

class GirlListCard extends StatelessWidget {
  const GirlListCard({
    super.key,
    required this.data,
    double imageRatio = 165 / 213,
  });
  final GirlListGirlModel data;

  final double imageRatio = 165 / 213;

  @override
  Widget build(BuildContext context) {
    // return Container();
    GirlCacheDomain cache = context.read<GirlCacheDomain>();

    // final comicChangeNotifier = context.read<ComicChangeNotifier>();

    // CacheDomain.readGirlClasses();

    List<GirlOptionItemModel> girlClassList = AppGlobal.girlClassList;

    // return Container(
    //   width: 100,
    //   height: 100,
    //   color: Colors.red,
    // );
    return LayoutBuilder(builder: (context, constrains) {
      double _w = constrains.maxWidth;
      return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          // if (disalbleTap) {
          //   return;
          // }
          // Utils.navTo(
          //   context,
          //   '/homedatedetailpage/${data["id"]}',
          // );

          GirlDetailRoute(data.id ?? 0).push(context);
        },
        child: Container(
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(5.w)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  List.from(data.medias ?? []).isEmpty
                      ? Container(
                          decoration: BoxDecoration(
                            color: MyTheme.blackColor38,
                            // borderRadius: BorderRadius.vertical(
                            //     top: Radius.circular(5.w)),
                          ),
                          width: _w,
                          height: _w / imageRatio,
                          child: Center(
                              child: MyImage.asset(
                            MyImagePaths.app2024ComFenxiangOn,
                            width: 25.w,
                            height: 25.w,
                          )),
                        )
                      : SizedBox(
                          width: _w,
                          height: _w / imageRatio,
                          child: MyImage.network(
                            data.medias!.first.mediaUrl!,
                          ),
                        ),
                  Positioned(
                      left: 0,
                      top: 0,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        decoration: BoxDecoration(
                          color: MyTheme.blackColor25.withOpacity(0.5),
                          borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(5.w)),
                        ),
                        child: Text(
                            CommonUtils.renderFixedNumber(data.payCt ?? 0) +
                                'ryg'.tr(),
                            style: MyTheme.white255_15),
                      )),
                  // Positioned(
                  //   left: 0,
                  //   right: 0,
                  //   bottom: 0,
                  //   child: Container(
                  //       height: 45.w,
                  //       padding: EdgeInsets.symmetric(
                  //           horizontal: MyTheme.pagePadding),
                  //       alignment: Alignment.centerRight,
                  //       decoration: const BoxDecoration(
                  //         gradient: LinearGradient(
                  //           colors: [
                  //             Color.fromRGBO(0, 0, 0, 0.0),
                  //             Color.fromRGBO(0, 0, 0, 0.6),
                  //           ],
                  //           begin: Alignment.topCenter,
                  //           end: Alignment.bottomCenter,
                  //         ),
                  //       ),
                  //       child: Text(
                  //         '¥' + (data.price ?? ''),
                  //         style: MyTheme.jellyCyan_15,
                  //       )),
                  // ),
                  // Positioned(left: 0, top: 0, child: videoType(data)),
                ],
              ),
              Expanded(
                child: Container(
                  // margin: EdgeInsets.symmetric(horizontal: 8.w),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                            maxLines: 2,
                            text: TextSpan(children: [
                              WidgetSpan(child: Builder(builder: (context) {
                                String classString = '';

                                if (girlClassList.isNotEmpty) {
                                  for (var element in girlClassList) {
                                    if (element.value == data.class_) {
                                      classString = element.name ?? '';
                                      break;
                                    }
                                  }
                                }
                                return classString.isEmpty
                                    ? Container()
                                    : Container(
                                        // height: 18.w,
                                        margin: EdgeInsets.only(right: 5.w),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 7.w, vertical: 2.w),
                                        decoration: BoxDecoration(
                                            color: MyTheme.jellyCyanColor,
                                            borderRadius:
                                                BorderRadius.circular(9.w)),
                                        child: Text(
                                          classString,
                                          style: MyTheme.white12medium,
                                          maxLines: 1,
                                        ),
                                      );
                              })),
                              TextSpan(
                                text: data.title ?? "",
                                style: MyTheme.white255_14_M,
                              )
                            ])),
                        // Align(
                        //     alignment: Alignment.topLeft,
                        //     child: Text(
                        //       data["name"] ?? "",
                        //       style: StyleTheme.font_white_255_14_medium,
                        //       maxLines: 1,
                        //     )),
                        SizedBox(height: 5.w),
                        Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              '${data.age}' +
                                  'sold'.tr() +
                                  '/' +
                                  '${data.cup}' +
                                  'bzcup'.tr() +
                                  '/' +
                                  '${data.height}' +
                                  'c'.tr(),
                              style: MyTheme.white08_14,
                              maxLines: 1,
                            )),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
