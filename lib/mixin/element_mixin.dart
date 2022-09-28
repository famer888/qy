import 'package:flutter/material.dart';
import 'package:qypj/views/flj_general_banner.dart';
import 'package:qypj/theme/default.dart';
import 'package:qypj/utils/common.dart';
import 'package:qypj/views/general_banner.dart';
import 'package:qypj/views/yyq/acg_double_colume_horizontal.dart';
import 'package:qypj/views/yyq/acg_double_colume_vertical.dart';
import 'package:qypj/views/yyq/acg_double_colume_vertical_small.dart';
import 'package:qypj/views/yyq/acg_triple_colume_vertical.dart';
import 'package:qypj/views/yyq/acg_triple_colume_vertical_backgroud.dart';
import 'package:qypj/views/yyq/acg_triple_colume_vertical_backgroud_open.dart';
import 'package:qypj/views/yyq/acg_triple_colume_vertical_spotlight.dart';
import 'package:qypj/views/yyq/acg_triple_colume_vertical_timeline.dart';
import 'package:qypj/views/yyq/commend_navigation_bar.dart';
import 'package:qypj/views/yyq/list_sort_switch.dart';
import 'package:qypj/views/yyq/picture_double_colume.dart';
import 'package:qypj/views/yyq/picture_single_row.dart';
import 'package:qypj/views/yyq/acg_rank_list.dart';
import 'package:qypj/views/yyq/search_element_widget.dart';
import 'package:qypj/views/yyq/video_double_colume.dart';
import 'package:qypj/views/yyq/video_double_colume_rob.dart';
import 'package:qypj/views/yyq/video_double_colume_spotlight.dart';
import 'package:qypj/views/yyq/video_double_colume_vertical.dart';
import 'package:qypj/views/yyq/video_single_colume.dart';
import 'package:qypj/views/yyq/video_single_row.dart';
import 'package:qypj/views/yyq/video_triple_colume_vertical.dart';

// self::TYPE_0  => '顶部导航',
// self::TYPE_1  => 'banner',
// self::TYPE_2  => '动漫+两列+横屏',
// self::TYPE_3  => '动漫+两列+小竖屏',
// self::TYPE_4  => '动漫-两列+竖屏',
// self::TYPE_5  => '动漫-三列竖屏+背景+开通',
// self::TYPE_12 => '美图-单行',
// self::TYPE_6  => '动漫-三列竖屏+焦点',
// self::TYPE_7  => '动漫-三列竖屏+背景',
// self::TYPE_8  => '动漫-三列竖屏+时间轴',
// self::TYPE_9  => '动漫-三列竖屏',
// self::TYPE_10 => '动漫-排行版',
// self::TYPE_11 => '美图-两列',
// self::TYPE_13 => '视频-单行横屏',
// self::TYPE_14 => '视频-两列',
// self::TYPE_15 => '视频-两列+抢购',
// self::TYPE_16 => '视频-两列+焦点',
// self::TYPE_17 => '视频-三列竖屏',
// self::TYPE_18 => '其他-导航',

mixin ElementMixin<T extends StatefulWidget> on State<T> {
  Widget getElement({dynamic element}) {
    if (element.length == 0 || element == null) {
      return Container();
    }
    Widget widget;
    CommonUtils.debugPrint(
        '---${element['title']}--组件类型:${element['type']}---是否有magin:${element['is_margin'] == 1}--');
    switch (element['type']) {
      case 1:
        widget = GeneralBanner(
          data: element['value'],
          height: 200,
          // radius: 5,
          bottom: 5,
        );
        break;
      case 2:
        // widget = VideoDoubleColumeSpotlight(data: element);
        // widget = VideoDoubleColumeRob(data: element);
        // widget = VideoTripleColumeVertical(data: element);
        // widget = VideoSingleRow(data: element);
        // widget = VideoDoubleColume(data: element);

        // widget = AcgDoubleColumeVertical(data: element);

        widget = AcgDoubleColumeHorizontal(data: element);

        break;
      case 3:
        // widget = SingleColDoubleColHor(data: element);
        widget = AcgDoubleColumeVerticalSmall(data: element);
        break;
      case 4:
        // widget = DoubleColHor(data: element);
        // widget = VideoDoubleColume(data: element);
        // widget = VideoTripleColumeVertical(data: element);
        // widget = VideoSingleRow(data: element);
        widget = AcgDoubleColumeVertical(data: element);
        break;
      case 5:
        // widget = SingleColHorScrollUnlock(data: element);
        widget = AcgTripleColumeVerticalBackgroudOpen(data: element);

        break;
      case 6:
        widget = AcgTripleColumeVerticalSpotlight(data: element);
        break;
      case 7:
        // widget = SingleLandscape(data: element);

        // widget = SinleLandscapeThreeColumeVertical(data: element);
        widget = AcgTripleColumeVerticalBackgroud(data: element);
        break;
      case 8:
        widget = AcgTripleColumeVerticalTimeline(data: element);
        break;
      case 9:
        widget = AcgTripleColumeVertical(data: element);
        break;
      case 10:
        widget = AcgRankList(data: element);
        break;
      case 11:
        widget = PictureDoubleColume(data: element);
        break;
      case 12:
        widget = PictureSingleRow(data: element);
        break;
      case 13: //动漫
        // widget = ThreeColumeVertical(data: element);
        // widget = RankHorizontal(data: element);
        // widget = AcgTripleColumeVertical(data: element);
        // widget = AcgTripleColumeVerticalSpotlight(data: element);
        // widget = AcgTripleColumeVerticalBackgroud(data: element);
        // widget = AcgTripleColumeVerticalBackgroudOpen(data: element);
        // widget = AcgDoubleColumeVertical(data: element);
        // widget = AcgDoubleColumeVerticalSmall(data: element);
        // widget = AcgDoubleColumeHorizontal(data: element);
        // widget = AcgRankList(data: element);
        // widget = AcgTripleColumeVerticalTimeline(data: element);
        widget = VideoSingleRow(data: element);

        break;
      case 14:
        widget = VideoDoubleColume(data: element);

        break;
      // case 101: // 自创的 视频两列竖屏 暂时不用了
      //   widget = VideoDoubleColumeVertical(data: element);
      //   break;
      case 15:
        widget = VideoDoubleColumeRob(data: element);
        break;
      case 16:
        widget = VideoDoubleColumeSpotlight(data: element);
        break;
      case 17:
        widget = VideoTripleColumeVertical(data: element);
        break;
      case 18:
        widget = CommendNavigationBar(data: element);
        break;
      case 1001:
        widget = SearchElementWidget();
        break;
      case 1002:
        widget = ListSortSwitch(
          data: element,
        );
        break;

      default:
        widget = Text(
          CommonUtils.txt('yscw'),
          style: GQStyle.red13,
        );
    }

    if (element['type'] == 10 ||
        element['type'] == 1001 ||
        element['type'] == 1002) {
      // 排行榜直接返回
      // 搜索栏直接返回
      return widget;
    }
    if (element['value'] == null || element['value'].length == 0) {
      return Container();
    } else {
      return widget;
    }
  }
}
