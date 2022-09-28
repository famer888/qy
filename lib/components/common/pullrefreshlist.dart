import 'dart:async';

import 'package:flutter/material.dart'
    hide RefreshIndicator, RefreshIndicatorState;
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qypj/utils/loading_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:qypj/theme/default.dart';
import 'package:qypj/utils/common.dart';
import 'package:qypj/utils/images_anim.dart';

class GifHeader extends RefreshIndicator {
  GifHeader()
      : super(
            height: ScreenUtil().setWidth(80),
            refreshStyle: RefreshStyle.Follow);
  @override
  State<StatefulWidget> createState() {
    return GifHeaderState();
  }
}

class GifHeaderState extends RefreshIndicatorState<GifHeader> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void onModeChange(RefreshStatus mode) {
    if (mode == RefreshStatus.refreshing) {}
    super.onModeChange(mode);
  }

  @override
  Future<void> endRefresh() {
    return Future.delayed(new Duration(microseconds: 500), () {});
  }

  @override
  void resetValue() {
    super.resetValue();
  }

  // Map<int, Image> _mapsR() {
  //   Map<int, Image> _maps = {};
  //   for (int i = 0; i < 15; i++) {
  //     _maps[i] = Image.asset("assets/images/refresh/header_$i.png",
  //         gaplessPlayback: true);
  //   }
  //   return _maps;
  // }

  @override
  Widget buildContent(BuildContext context, RefreshStatus mode) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: ScreenUtil().setWidth(15)),
      child:
          // LImage("ref_data_n",
          //     width: ScreenUtil().setWidth(40),
          //     height: ScreenUtil().setWidth(40),
          //     ext: ".gif")

          Column(
        children: [
          SizedBox(
            height: ScreenUtil().setWidth(20),
            width: ScreenUtil().setWidth(20),
            child: CircularProgressIndicator(
              color: GQStyle.jellyCyanColor103224185,
              strokeWidth: 2,
            ),
          )
          // LineLoadingBadge()
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

// ignore: must_be_immutable
class PullRefreshList extends StatefulWidget {
  PullRefreshList({
    Key key,
    this.child,
    this.onRefresh,
    this.onLoading,
    this.isAll = false,
    this.dbtip,
  }) : super(key: key);
  Widget child;
  Function onRefresh;
  Function onLoading;
  bool isAll = false;
  String dbtip;
  @override
  _PullRefreshListState createState() => _PullRefreshListState();
}

class _PullRefreshListState extends State<PullRefreshList> {
  RefreshController _refreshController;
  Timer _timerout;
  Timer _timer;
  bool startReq = false;
  @override
  void initState() {
    super.initState();
    _refreshController = RefreshController(initialRefresh: false);
  }

  @override
  void dispose() {
    super.dispose();
    _refreshController.dispose();
    if (_timer != null) {
      _timer.cancel();
    }
    if (_timerout != null) {
      _timerout.cancel();
    }
  }

  void _onRefresh() async {
    // 下拉刷新数据
    if (widget.onRefresh != null) {
      startReq = true;
      _timerout = Timer.periodic(Duration(seconds: 10), (time) {
        time.cancel();
        if (_timer.isActive) {
          _timer.cancel();
        }
        CommonUtils.showText(CommonUtils.txt('wlcs'));
        _refreshController.refreshCompleted(resetFooterState: true);
      });
      _timer = Timer.periodic(Duration(milliseconds: 1500), (time) {
        if (!startReq) {
          if (_timerout.isActive) {
            _timerout.cancel();
          }
          time.cancel();
          _refreshController.refreshCompleted(resetFooterState: true);
        }
      });
      await widget.onRefresh();
      startReq = false;
    }
  }

  void _onLoading() async {
    // 加载更多数据
    if (widget.onLoading != null) {
      widget.onLoading();
      _refreshController.loadComplete();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isAll)
      _refreshController.loadNoData();
    else
      _refreshController.resetNoData();
    return SmartRefresher(
      enablePullDown: widget.onRefresh != null,
      enablePullUp: widget.onLoading != null,
      header: GifHeader(),
      footer: CustomFooter(
        builder: (BuildContext context, LoadStatus mode) {
          Widget body;
          if (mode == LoadStatus.idle) {
            body = Text(CommonUtils.txt('zlyd'), style: GQStyle.gray173);
          } else if (mode == LoadStatus.loading) {
            body = CupertinoActivityIndicator();
          } else if (mode == LoadStatus.failed) {
            body = Text(CommonUtils.txt('djjz'), style: GQStyle.gray173);
          } else if (mode == LoadStatus.canLoading) {
            body = Text(CommonUtils.txt('ssjz'), style: GQStyle.gray173);
          } else {
            body = Text(
                widget.dbtip == null ? CommonUtils.txt('wydx') : widget.dbtip,
                style: GQStyle.gray173);
          }
          return Container(
            height: 50.0,
            child: Center(child: body),
          );
        },
      ),
      controller: _refreshController,
      onRefresh: _onRefresh,
      onLoading: _onLoading,
      child: widget.child,
    );
  }
}
