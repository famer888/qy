// ignore_for_file: must_call_super, camel_case_types
import 'dart:async';
import 'dart:math';

import 'package:bot_toast/bot_toast.dart';
import 'package:fijkplayer/fijkplayer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qypj/components/yy_dialog.dart';
import 'package:qypj/global.dart';
import 'package:qypj/ijktool/fijkload_skin.dart';
import 'package:qypj/model/animationDetail.dart';
import 'package:qypj/model/homedata.dart';
import 'package:qypj/routers.dart';
import 'package:qypj/store/homeConfig.dart';
import 'package:qypj/theme/default.dart';
import 'package:qypj/utils/api.dart';
import 'package:qypj/utils/common.dart';
import 'package:qypj/utils/extensionlibrary.dart';
import 'package:qypj/utils/networkImage.dart';
import 'package:qypj/utils/shelf_proxy.dart';
import 'package:provider/provider.dart';
import 'package:wakelock/wakelock.dart';

double speed = 1.0;
bool lockStuff = false;
bool hideLockStuff = false;
final double barHeight = 50.0;

abstract class ShowConfigAbs {
  bool speedBtn;
  bool lockBtn;
  bool topBar;
  bool bottomPro;
  bool stateAuto;
  bool isAutoPlay;
}

class WithPlayerChangeSource {}

class CustomFijkPanel extends StatefulWidget {
  final FijkPlayer player;
  final Size viewSize;
  final Rect texturePos;
  final BuildContext pageContent;
  Future<String> onChangeVideo;
  final ShowConfigAbs showConfig;
  final DetailData videoInfo;
  final isLocal;
  final bool noback;
  CustomFijkPanel({
    this.player,
    this.viewSize,
    this.texturePos,
    this.pageContent,
    this.showConfig,
    this.onChangeVideo,
    this.videoInfo,
    this.isLocal,
    this.noback = false,
  });

  @override
  _CustomFijkPanelState createState() => _CustomFijkPanelState();
}

class _CustomFijkPanelState extends State<CustomFijkPanel>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  FijkPlayer get player => widget.player;
  ShowConfigAbs get showConfig => widget.showConfig;

  bool _lockStuff = lockStuff;
  bool _hideLockStuff = hideLockStuff;
  Timer _hideLockTimer;

  FijkState _playerState;
  bool _isPlaying = false;

  StreamSubscription _currentPosSubs;

  AnimationController _animationController;
  Animation<Offset> _animation;

  String _purl = "";

  void initEvent() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 280),
      vsync: this,
    );
    // init animation
    _animation = Tween(
      begin: Offset(1, 0),
      end: Offset.zero,
    ).animate(_animationController);

    // init plater state
    setState(() {
      _playerState = player.value.state;
    });
    if (player.value.duration.inMilliseconds > 0 && !_isPlaying) {
      setState(() {
        _isPlaying = true;
      });
    }
    // autoplay and existurl
    if (showConfig.isAutoPlay && !_isPlaying) {
      initURL();
    }
    player.addListener(_playerValueChanged);
    Wakelock.enable();
  }

  initURL() {
    if (widget.videoInfo.source240.length > 0) {
      _purl = widget.videoInfo.source240;
    } else if (widget.videoInfo.preview_url.length > 0) {
      _purl = widget.videoInfo.preview_url;
    }
    if (!widget.isLocal) {
      if (AppGlobal.m3u8_encrypt == '1') {
        createServer(_purl).then((proxyConfig) {
          String proxyurl = _purl.replaceAll(
              proxyConfig['origin'], proxyConfig['localproxy']);
          changeCurPlayVideo(proxyurl);
        });
      } else {
        changeCurPlayVideo(_purl);
      }
    } else {
      // 创建本地播放服务
      createStaticServer(_purl).then((url) => changeCurPlayVideo(url));
    }
  }

  @override
  void initState() {
    super.initState();
    initEvent();
  }

  @override
  void dispose() {
    _currentPosSubs?.cancel();
    _hideLockTimer?.cancel();
    player.removeListener(_playerValueChanged);
    _animationController.dispose();
    Wakelock.disable();
    super.dispose();
  }

  // 获得播放器状态
  void _playerValueChanged() {
    if (player.value.duration.inMilliseconds > 0 && !_isPlaying) {
      setState(() {
        _isPlaying = true;
      });
    }
    setState(() {
      _playerState = player.value.state;
    });
  }

  // 切换UI 播放列表显示状态
  void changeDrawerState(bool state) {
    Future.delayed(Duration(milliseconds: 100), () {
      _animationController.forward();
    });
  }

  // 切换UI lock显示状态
  void changeLockState(bool state) {
    setState(() {
      _lockStuff = state;
      if (state == true) {
        _hideLockStuff = true;
        _cancelAndRestartLockTimer();
      }
    });
  }

  // 切换播放源
  Future<void> changeCurPlayVideo(String url) async {
    CommonUtils.debugPrint("soure = ${player.dataSource} \n url = $url");
    await player.reset().then((_) {
      player.setDataSource(url, autoPlay: true);
    });
  }

  void _cancelAndRestartLockTimer() {
    if (_hideLockStuff == true) {
      _startHideLockTimer();
    }
    setState(() {
      _hideLockStuff = !_hideLockStuff;
    });
  }

  void _startHideLockTimer() {
    _hideLockTimer?.cancel();
    _hideLockTimer = Timer(const Duration(seconds: 5), () {
      setState(() {
        _hideLockStuff = true;
      });
    });
  }

  // 锁 组件
  Widget _buidLockStateDetctor() {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _cancelAndRestartLockTimer,
      child: Container(
        child: AnimatedOpacity(
          opacity: _hideLockStuff ? 0.0 : 1.0,
          duration: Duration(milliseconds: 400),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(
                left: 20,
                top: 0,
              ),
              child: IconButton(
                iconSize: 30,
                onPressed: () {
                  setState(() {
                    _lockStuff = false;
                    _hideLockStuff = true;
                  });
                },
                icon: Icon(Icons.lock_outline),
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // 返回按钮
  Widget _buildTopBackBtn() {
    return widget.noback
        ? Container()
        : Container(
            height: barHeight,
            alignment: Alignment.centerLeft,
            child: IconButton(
              icon: LImage('nav_back_w_n', width: 22, height: 22),
              padding: EdgeInsets.only(
                left: 10.0,
                right: 10.0,
              ),
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              color: Colors.white,
              onPressed: () {
                // 判断当前是否全屏，如果全屏，退出
                if (widget.player.value.fullScreen) {
                  player.exitFullScreen();
                } else {
                  if (widget.pageContent == null) return null;
                  player.stop();
                  Navigator.pop(widget.pageContent);
                }
              },
            ),
          );
  }

  // 可以共用的架子
  Widget _buildPublicFrameWidget({
    Widget slot,
    Color bgColor,
  }) {
    return Container(
      color: bgColor,
      child: Stack(
        children: [
          PlatformAwareNetworkImage(
              url: widget.videoInfo.coverThumbHorizontal ??
                  widget.videoInfo.coverThumbVerticle),
          Container(color: Colors.black87),
          showConfig.topBar
              ? Positioned(
                  left: 0,
                  top: 0,
                  right: 0,
                  child: Container(
                    alignment: Alignment.bottomLeft,
                    child: Container(
                      height: barHeight,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          _buildTopBackBtn(),
                          widget.player.value.fullScreen
                              ? Expanded(
                                  child: Container(
                                    child: Text(
                                      widget.videoInfo.title,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                )
                              : Container(),
                        ],
                      ),
                    ),
                  ),
                )
              : Container(),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            top: 0,
            child: Center(
              child: Padding(
                padding: EdgeInsets.only(top: 0),
                child: slot,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 错误slot
  Widget _buildErrorStateSlotWidget() {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 0,
          ),
          // 失败图标
          Icon(
            Icons.error,
            size: 30,
            color: Colors.white,
          ),
          // 错误信息
          Text(
            "播放失败404，反馈给客服！",
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 5),
          // 重试
          ElevatedButton(
            style: ButtonStyle(
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              elevation: MaterialStateProperty.all(0),
              backgroundColor: MaterialStateProperty.all(Colors.white),
            ),
            onPressed: () {
              initURL();
            },
            child: Text(
              "点击重试",
              style: TextStyle(color: Colors.black, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  // 加载中slot
  Widget _buildLoadingStateSlotWidget() {
    return SizedBox(
      width: 40,
      height: 40,
      child: const CircularProgressIndicator(
        backgroundColor: Colors.white30,
        valueColor: AlwaysStoppedAnimation(Color(0xff67e0b9)),
        strokeWidth: 1.5,
      ),
    );
  }

  // 未开始slot
  Widget _buildIdleStateSlotWidget() {
    return IconButton(
      iconSize: barHeight * 1.2,
      icon: LImage('v_play_n', width: 40, height: 40),
      onPressed: () async {
        initURL();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Rect rect = player.value.fullScreen
        ? Rect.fromLTWH(
            0,
            0,
            widget.viewSize.width,
            widget.viewSize.height,
          )
        : Rect.fromLTWH(
            0,
            0,
            widget.viewSize.width,
            widget.viewSize.height,
          );
    //  Rect.fromLTRB(
    //     max(0.0, widget.texturePos.left),
    //     max(0.0, widget.texturePos.top),
    //     min(widget.viewSize.width, widget.texturePos.right),
    //     min(widget.viewSize.height, widget.texturePos.bottom),
    //   );

    List<Widget> ws = [];

    if (_playerState == FijkState.error) {
      ws.add(
        _buildPublicFrameWidget(
          slot: _buildErrorStateSlotWidget(),
          bgColor: Colors.black,
        ),
      );
    } else if ((_playerState == FijkState.asyncPreparing ||
            _playerState == FijkState.initialized) &&
        !_isPlaying) {
      ws.add(
        _buildPublicFrameWidget(
          slot: _buildLoadingStateSlotWidget(),
          bgColor: Colors.black,
        ),
      );
    } else if (_playerState == FijkState.idle && !_isPlaying) {
      ws.add(
        _buildPublicFrameWidget(
          slot: _buildIdleStateSlotWidget(),
          bgColor: Colors.black,
        ),
      );
    } else {
      if (_lockStuff == true &&
          showConfig.lockBtn &&
          widget.player.value.fullScreen) {
        ws.add(
          _buidLockStateDetctor(),
        );
      } else {
        ws.add(
          FijkLoadSkin(
            noback: widget.noback,
            player: widget.player,
            texturePos: widget.texturePos,
            showConfig: widget.showConfig,
            pageContent: widget.pageContent,
            playerTitle: widget.videoInfo.title,
            viewSize: widget.viewSize,
            changeLockState: changeLockState,
            info: widget.videoInfo,
            shareVp: () {
              context.push(CommonUtils.getRealHash('welfaretaskpage'));
            },
            skiPreview: () {
              showAlertVp();
            },
            nowToVp: () {
              context.push('/${Routes.vip}');
            },
            nowByKb: () {
              showAlertVp(goby: true);
            },
          ),
        );
      }
    }

    return WillPopScope(
      child: Positioned.fromRect(
        rect: rect,
        child: Stack(
          children: ws,
        ),
      ),
      onWillPop: () async {
        if (!widget.player.value.fullScreen) widget.player.stop();
        return true;
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
  showAlertVp({bool goby = false}) {
    Member member = Provider.of<HomeConfig>(context, listen: false).member;
    bool isInsufficient = member.money < widget.videoInfo.coins;
    if (goby && !isInsufficient) {
      byVideoRes(member.money - widget.videoInfo.coins); //直接购买
      return;
    }
    if (widget.videoInfo.isfree == 2) {
      YyShowDialog.showdialog(
        context,
        title: CommonUtils.txt('ts'),
        cancelText:
            isInsufficient ? CommonUtils.txt('qwcz') : CommonUtils.txt('gmgk'),
        btnText: CommonUtils.txt('fxdv'),
        callBack: () {
          context.push(CommonUtils.getRealHash('welfaretaskpage'));
        },
        cancelBack: () {
          if (isInsufficient) {
            context.push('/${Routes.coinRecharge}');
          } else {
            byVideoRes(member.money - widget.videoInfo.coins);
          }
        },
        content: (setDialogState) {
          return DefaultTextStyle(
            style: GQStyle.gray203_13,
            child: Column(
              children: [
                Text(CommonUtils.txt('gmspkwz'),
                    style: GQStyle.gray203_13, maxLines: 3),
                SizedBox(height: ScreenUtil().setWidth(15)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("${widget.videoInfo.coins}" + CommonUtils.txt('jb'),
                        style: GQStyle.blue80_13_M),
                  ],
                ),
                SizedBox(height: ScreenUtil().setWidth(15)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                        CommonUtils.txt('kyje') +
                            "：${member.money}" +
                            CommonUtils.txt('jb'),
                        style: GQStyle.gray203_13),
                  ],
                ),
              ],
            ),
          );
        },
      );
    } else {
      YyShowDialog.showdPNGDiaog(
        context,
        title: CommonUtils.txt('ts'),
        cancelText: CommonUtils.txt('cv'),
        btnText: CommonUtils.txt('fxdv'),
        cancelBack: () {
          context.push('/${Routes.vip}');
        },
        callBack: () {
          context.push(CommonUtils.getRealHash('welfaretaskpage'));
        },
        content: (setDialogState) {
          return DefaultTextStyle(
            style: GQStyle.gray203_13,
            child: Column(
              children: [
                Text(CommonUtils.txt('gmvkwz'), style: GQStyle.gray203_13),
                SizedBox(
                  height: ScreenUtil().setWidth(15),
                ),
                Text(
                  Provider.of<HomeConfig>(context, listen: false)
                      .config
                      .tips_share_text,
                  style: GQStyle.gray203_13,
                  maxLines: 3,
                ),
              ],
            ),
          );
        },
      );
    }
  }

  byVideoRes(int coins) {
    CommonUtils.startLoadGIF(tip: CommonUtils.txt("dhz"));
    buyVideo(id: widget.videoInfo.id, coins: coins, context: context)
        .then((res) {
      //关闭加载动画
      BotToast.closeAllLoading();
      if (res.status != 0) {
        widget.videoInfo.source240 = res.data["url"];
        initURL();
      } else {
        CommonUtils.showText(res.msg);
      }
    });
  }
}
