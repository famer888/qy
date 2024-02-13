import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qypj/base/baseWidget.dart';
import 'package:qypj/page/flj_slider_nav.dart';
import 'package:qypj/page/gen_custom_nav.dart';
import 'package:qypj/page/jelly_slider_nav.dart';
import 'package:qypj/utils/api.dart';
import 'package:qypj/utils/extensionlibrary.dart';
import 'package:qypj/components/page_status.dart';
import 'package:qypj/components/search_list.dart';
import 'package:qypj/global.dart';
import 'package:qypj/theme/default.dart';
import 'package:qypj/utils/common.dart';
import 'package:qypj/utils/pageviewmixin.dart';
import 'package:qypj/views/general_banner.dart';

class SearchResultPage extends BaseWidget {
  SearchResultPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  State<StatefulWidget> cState() {
    // TODO: implement cState
    return _SearchResultPageState();
  }
}

class _SearchResultPageState extends BaseWidgetState<SearchResultPage> {
  int pageStatus = 0;
  int currentTab = 0;
  String _searchText;
  bool loading = false;
  double top = 0.0;

  int selectIndex = 0;

  List tabList = [
    {'id': 1, 'name': CommonUtils.txt('shp')},
    {'id': 7, 'name': CommonUtils.txt('tiezt')},
    {'id': 8, 'name': CommonUtils.txt('zhoz')},
  ];

  @override
  void onCreate() {
    _searchText = widget.title;
    setAppTitle(title: CommonUtils.txt('ssjg'));
  }

  @override
  void onDestroy() {
    // TODO: implement onDestroy
  }

  @override
  Widget pageBody(BuildContext context) {
    return JellySliderNav(
      titles: tabList.map<String>((e) => e["name"]).toList(),
      pages: tabList
          .map(
            (e) => PageViewMixin(
              child: SearchList(type: e['id'], value: _searchText),
            ),
          )
          .toList(),
      inedxFunc: (index) {
        if (index == 0) {
          setAppTitle(title: CommonUtils.txt('ssjg'));
        } else {
          setAppTitle(title: CommonUtils.txt('ssjg'));
        }
      },
    );
  }
}
