import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../utils/common_utils.dart';
import '../../../image_paths.dart';
import '../../../theme.dart';
import '../../link_text.dart';
import '../../my_image.dart';

class AnnouncementDialog extends StatelessWidget {
  const AnnouncementDialog(
      {super.key,
      required this.confirm,
      required this.cancel,
      required this.text});
  final VoidCallback confirm;
  final VoidCallback cancel;
  final String text;
  List<String> get textList => text.split('#');
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: GestureDetector(
            onTap: () => cancel.call(),
            child: const ColoredBox(color: Colors.black38),
          ),
        ),
        Center(
          child: Stack(
            children: [
              Container(
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  color: Colors.black38,
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: EdgeInsets.symmetric(horizontal: 35.w),
                height: 450.w,
                child: Stack(
                  children: [
                    const MyImage.asset(MyImagePaths.appAnnouncementUpBg),
                    Container(
                      margin:
                          EdgeInsets.only(top: (1.sw - 70.w) / 305 * 117 - 2.w),
                      color: const Color(0xFFFCFCFC),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(height: 10.w),
                          Expanded(
                            child: SingleChildScrollView(
                              padding: EdgeInsets.symmetric(horizontal: 20.w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  for (final text in textList)
                                    LinkText(
                                      text,
                                      textAlign: TextAlign.left,
                                      onLinkTap: (url) {
                                        CommonUtils.launchUrl(url);
                                      },
                                      textStyle: TextStyle(
                                        color: const Color(0xff636363),
                                        fontSize: 15.sp,
                                        decoration: TextDecoration.none,
                                        fontWeight: FontWeight.normal,
                                      ),
                                      linkStyle: TextStyle(
                                        color: const Color.fromRGBO(
                                            25, 103, 210, 1),
                                        fontSize: 15.sp,
                                        decoration: TextDecoration.none,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 15.w),
                          Padding(
                            padding: EdgeInsets.only(
                                left: MyTheme.pagePadding,
                                right: MyTheme.pagePadding,
                                bottom: 15.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () => confirm.call(),
                                  child: Container(
                                    width: 110.w,
                                    height: 32.w,
                                    decoration: BoxDecoration(
                                        gradient: MyTheme
                                            .btnGradient_ff00edfd_ffbbe954,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(16.w))),
                                    child: Center(
                                      child: RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                                text: tr('wygq'),
                                                style: MyTheme.white255_14_M),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Positioned(
                top: 30.w,
                left: 0,
                right: 0,
                child: MyImage.asset(
                  MyImagePaths.appAnnouncement,
                  width: 119.w,
                  height: 29.w,
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
