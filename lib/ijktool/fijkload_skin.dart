import 'dart:async';
import 'dart:math';

import 'package:fijkplayer/fijkplayer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qypj/global.dart';
import 'package:qypj/ijktool/fijkplayer_skin.dart';
import 'package:qypj/ijktool/slider.dart';
import 'package:qypj/model/animationDetail.dart';
import 'package:qypj/model/homedata.dart';
import 'package:qypj/store/homeConfig.dart';
import 'package:qypj/theme/default.dart';
import 'package:qypj/utils/common.dart';
import 'package:qypj/utils/extensionlibrary.dart';
import 'package:provider/provider.dart';
import 'package:visibility_detector/visibility_detector.dart';

class FijkLoadSkin extends StatefulWidget {
  final FijkPlayer player;
  final Size viewSize;
  final Rect texturePos;
  final BuildContext pageContent;
  final String playerTitle;
  final Function changeLockState;
  final ShowConfigAbs showConfig;
  final DetailData info;
  final Function skiPreview;
  final Function shareVp;
  final Function nowToVp;
  final Function nowByKb;
  final bool noback;

  FijkLoadSkin({
    Key key,
    this.player,
    this.viewSize,
    this.texturePos,
    this.pageContent,
    this.playerTitle = "",
    this.showConfig,
    this.changeLockState,
    this.info,
    this.skiPreview,
    this.shareVp,
    this.nowToVp,
    this.nowByKb,
    this.noback,
  }) : super(key: key);

  @override
  _FijkLoadSkinState createState() => _FijkLoadSkinState();
}

class _FijkLoadSkinState extends State<FijkLoadSkin>
    with WidgetsBindingObserver {
  FijkPlayer get player => widget.player;
  ShowConfigAbs get showConfig => widget.showConfig;

  Duration _duration = Duration();
  Duration _currentPos = Duration();
  Duration _bufferPos = Duration();

  // 滑动后值
  Duration _dargPos = Duration();

  bool _isTouch = false;

  bool _playing = false;
  bool _prepared = false;
  String _exception;

  double updatePrevDx;
  double updatePrevDy;
  int updatePosX;

  bool isDargVerLeft;

  double updateDargVarVal;

  bool varTouchInitSuc = false;

  bool _buffering = false;

  double _seekPos = -1.0;

  StreamSubscription _currentPosSubs;
  StreamSubscription _bufferPosSubs;
  StreamSubscription _bufferingSubs;

  Timer _hideTimer;
  bool _hideStuff = true;

  bool _hideSpeedStu = true;
  double _speed = speed;

  bool _isHorizontalMove = false;

  Map<String, double> speedList = {
    "2.0": 2.0,
    "1.8": 1.8,
    "1.5": 1.5,
    "1.2": 1.2,
    "1.0": 1.0,
  };

  bool _isPreview = false;

  // 初始化构造函数
  _FijkLoadSkinState();

  void initEvent() {
    // 设置初始化的值，全屏与半屏切换后，重设
    setState(() {
      _speed = speed;
      // 每次重绘的时候，判断是否已经开始播放
      _hideStuff = !_playing ? false : true;
    });
    // 延时隐藏
    _startHideTimer();
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);

    _hideTimer?.cancel();

    player.removeListener(_playerValueChanged);
    _currentPosSubs?.cancel();
    _bufferPosSubs?.cancel();
    _bufferingSubs?.cancel();
  }

  @override
  void initState() {
    super.initState();

    initEvent();

    WidgetsBinding.instance.addObserver(this);

    _duration = player.value.duration;
    _currentPos = player.currentPos;
    _bufferPos = player.bufferPos;
    _prepared = player.state.index >= FijkState.prepared.index;
    _playing = player.state == FijkState.started;
    _exception = player.value.exception.message;
    _buffering = player.isBuffering;

    player.addListener(_playerValueChanged);

    _currentPosSubs = player.onCurrentPosUpdate.listen((v) {
      setState(() {
        _currentPos = v;
        // 后加入，处理fijkplay reset后状态对不上的bug，
        _playing = true;
        _prepared = true;
      });
    });

    _bufferPosSubs = player.onBufferPosUpdate.listen((v) {
      setState(() {
        _bufferPos = v;
      });
    });

    _bufferingSubs = player.onBufferStateUpdate.listen((v) {
      setState(() {
        _buffering = v;
      });
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.inactive: // 处于这种状态的应用程序应该假设它们可能在任何时候暂停。
        break;
      case AppLifecycleState.resumed: //从后台切换前台，界面可见
        break;
      case AppLifecycleState.paused: // 界面不可见，后台
        if (player.isPlayable() && _playing) {
          player.pause();
        }
        break;
      case AppLifecycleState.detached: // APP结束时调用
        break;
    }
  }

  void _playerValueChanged() async {
    FijkValue value = player.value;
    if (value.duration != _duration) {
      setState(() {
        _duration = value.duration;
      });
    }
    CommonUtils.debugPrint(
        '++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++');
    CommonUtils.debugPrint(
        '++++++++ 是否开始播放 => ${value.state == FijkState.started} ++++++++');
    CommonUtils.debugPrint(
        '+++++++++++++++++++ 播放器状态 => ${value.state} ++++++++++++++++++++');
    CommonUtils.debugPrint(
        '++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++');
    // 新状态
    bool playing = value.state == FijkState.started;
    bool prepared = value.prepared;
    String exception = value.exception.message;
    // 状态不一致，修改
    if (playing != _playing ||
        prepared != _prepared ||
        exception != _exception) {
      setState(() {
        _playing = playing;
        _prepared = prepared;
        _exception = exception;
      });
    }
  }

  _onHorizontalDragStart(detills) {
    setState(() {
      updatePrevDx = detills.globalPosition.dx;
      updatePosX = _currentPos.inMilliseconds;
    });
  }

  _onHorizontalDragUpdate(detills) {
    double curDragDx = detills.globalPosition.dx;
    // 确定当前是前进或者后退
    int cdx = curDragDx.toInt();
    int pdx = updatePrevDx.toInt();
    bool isBefore = cdx > pdx;

    // 计算手指滑动的比例
    int newInterval = pdx - cdx;
    double playerW = MediaQuery.of(context).size.width;
    int curIntervalAbs = newInterval.abs();
    double movePropCheck = (curIntervalAbs / playerW) * 100;

    // 计算进度条的比例
    double durProgCheck = _duration.inMilliseconds.toDouble() / 100;
    int checkTransfrom = (movePropCheck * durProgCheck).toInt();
    int dragRange =
        isBefore ? updatePosX + checkTransfrom : updatePosX - checkTransfrom;

    // 是否溢出 最大
    int lastSecond = _duration.inMilliseconds;
    if (dragRange >= _duration.inMilliseconds) {
      dragRange = lastSecond;
    }
    // 是否溢出 最小
    if (dragRange <= 0) {
      dragRange = 0;
    }
    //
    this.setState(() {
      _isHorizontalMove = true;
      _hideStuff = false;
      _isTouch = true;
      // 更新下上一次存的滑动位置
      updatePrevDx = curDragDx;
      // 更新时间
      updatePosX = dragRange.toInt();
      _dargPos = Duration(milliseconds: updatePosX.toInt());
    });
  }

  _onHorizontalDragEnd(detills) {
    player.seekTo(_dargPos.inMilliseconds);
    this.setState(() {
      _isHorizontalMove = false;
      _isTouch = false;
      _hideStuff = true;
      _currentPos = _dargPos;
    });
  }

  _onVerticalDragStart(detills) async {
    double clientW = widget.viewSize.width;
    double curTouchPosX = detills.globalPosition.dx;

    setState(() {
      // 更新位置
      updatePrevDy = detills.globalPosition.dy;
      // 是否左边
      isDargVerLeft = (curTouchPosX > (clientW / 2)) ? false : true;
    });
    // 大于 右边 音量 ， 小于 左边 亮度
    if (!isDargVerLeft) {
      // 音量
      await FijkVolume.getVol().then((double v) {
        varTouchInitSuc = true;
        setState(() {
          updateDargVarVal = v;
        });
      });
    } else {
      // 亮度
      await FijkPlugin.screenBrightness().then((double v) {
        varTouchInitSuc = true;
        setState(() {
          updateDargVarVal = v;
        });
      });
    }
  }

  _onVerticalDragUpdate(detills) {
    if (!varTouchInitSuc) return null;
    double curDragDy = detills.globalPosition.dy;
    // 确定当前是前进或者后退
    int cdy = curDragDy.toInt();
    int pdy = updatePrevDy.toInt();
    bool isBefore = cdy < pdy;
    // + -, 不满足, 上下滑动合法滑动值，> 3
    if (isBefore && pdy - cdy < 3 || !isBefore && cdy - pdy < 3) return null;
    // 区间
    double dragRange =
        isBefore ? updateDargVarVal + 0.03 : updateDargVarVal - 0.03;
    // 是否溢出
    if (dragRange > 1) {
      dragRange = 1.0;
    }
    if (dragRange < 0) {
      dragRange = 0.0;
    }
    setState(() {
      updatePrevDy = curDragDy;
      varTouchInitSuc = true;
      updateDargVarVal = dragRange;
      // 音量
      if (!isDargVerLeft) {
        FijkVolume.setVol(dragRange);
      } else {
        FijkPlugin.setScreenBrightness(dragRange);
      }
    });
  }

  _onVerticalDragEnd(detills) {
    setState(() {
      varTouchInitSuc = false;
    });
  }

  // 切换播放源
  Future<void> changeCurPlayVideo() async {
    // await player.seekTo(0);
    await player.stop();
    setState(() {
      _buffering = false;
    });
    // player.reset().then((_) {
    //   _speed = speed = 1.0;
    //   String curTabActiveUrl =
    //       _videoSourceTabs.video[tabIdx].list[activeIdx].url;
    //   player.setDataSource(
    //     curTabActiveUrl,
    //     autoPlay: true,
    //   );
    //   // 回调
    //   widget.onChangeVideo(tabIdx, activeIdx);
    // });
  }

  void _playOrPause() {
    if (player.state == FijkState.completed && _isPreview == false) {
      player.seekTo(0);
      player.start();
      return;
    }
    if (_playing == true) {
      player.pause();
    } else {
      player.start();
    }
  }

  void _cancelAndRestartTimer() {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      FocusManager.instance.primaryFocus.unfocus();
    }
    if (!currentFocus.hasPrimaryFocus) return;
    if (_hideStuff == true) {
      _startHideTimer();
    }

    setState(() {
      _hideStuff = !_hideStuff;
      if (_hideStuff == true) {
        _hideSpeedStu = true;
      }
    });
  }

  void _startHideTimer() {
    _hideTimer?.cancel();
    _hideTimer = Timer(const Duration(seconds: 5), () {
      setState(() {
        _hideStuff = true;
        _hideSpeedStu = true;
      });
    });
  }

  // 底部控制栏 - 播放按钮
  Widget _buildPlayStateBtn(IconData iconData, Function cb) {
    return Ink(
      child: InkWell(
        onTap: () => cb(),
        child: Container(
          height: 30,
          child: Padding(
            padding: EdgeInsets.only(left: 5, right: 5),
            child: Icon(
              iconData,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  // 控制器ui 底部
  Widget _buildBottomBar(BuildContext context) {
    // 计算进度时间
    double duration = _duration.inMilliseconds.toDouble();
    double currentValue = _seekPos > 0
        ? _seekPos
        : (_isHorizontalMove
            ? _dargPos.inMilliseconds.toDouble()
            : _currentPos.inMilliseconds.toDouble());
    currentValue = min(currentValue, duration);
    currentValue = max(currentValue, 0);

    // 计算底部吸底进度
    double curConWidth = MediaQuery.of(context).size.width;
    double curTimePro = (currentValue / duration) * 100;
    double curBottomProW = (curConWidth / 100) * curTimePro;

    double vWidth = widget.texturePos?.width ?? 0;
    double vHeight = widget.texturePos?.height ?? 0;

    return Container(
      height: barHeight,
      child: Stack(
        children: [
          // 底部UI控制器
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: AnimatedOpacity(
              opacity: _hideStuff ? 0.0 : 1.0,
              duration: Duration(milliseconds: 400),
              child: Container(
                height: barHeight,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomLeft,
                    colors: [
                      Color.fromRGBO(0, 0, 0, 0),
                      Color.fromRGBO(0, 0, 0, 0.4),
                    ],
                  ),
                ),
                child: Row(
                  children: <Widget>[
                    SizedBox(width: 7),
                    // 已播放时间
                    Padding(
                      padding: EdgeInsets.only(right: 5.0, left: 5),
                      child: Text(
                        '${_duration2String(_currentPos)}',
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    // 播放进度 if 没有开始播放 占满，空ui， else fijkSlider widget
                    _duration.inMilliseconds == 0
                        ? Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(right: 5, left: 5),
                              child: NewFijkSlider(
                                colors: NewFijkSliderColors(
                                  cursorColor: Color(0xff67e0b9),
                                  playedColor: Color(0xff67e0b9),
                                ),
                                onChangeEnd: (double value) {},
                                value: 0,
                                onChanged: (double value) {},
                              ),
                            ),
                          )
                        : Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(right: 5, left: 5),
                              child: NewFijkSlider(
                                colors: NewFijkSliderColors(
                                  cursorColor: Color(0xff67e0b9),
                                  playedColor: Color(0xff67e0b9),
                                ),
                                value: currentValue,
                                cacheValue:
                                    _bufferPos.inMilliseconds.toDouble(),
                                min: 0.0,
                                max: duration,
                                onChanged: (v) {
                                  _startHideTimer();
                                  setState(() {
                                    _seekPos = v;
                                  });
                                },
                                onChangeEnd: (v) {
                                  setState(() {
                                    player.seekTo(v.toInt());
                                    CommonUtils.debugPrint("seek to $v");
                                    _currentPos = Duration(
                                        milliseconds: _seekPos.toInt());
                                    _seekPos = -1;
                                  });
                                },
                              ),
                            ),
                          ),

                    // 总播放时间
                    _duration.inMilliseconds == 0
                        ? Container(
                            child: const Text(
                              "00:00",
                              style: TextStyle(color: Colors.white),
                            ),
                          )
                        : Padding(
                            padding: EdgeInsets.only(right: 5.0, left: 5),
                            child: Text(
                              '${_duration2String(_duration)}',
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.white,
                              ),
                            ),
                          ),
                    // 倍数按钮
                    widget.player.value.fullScreen && showConfig.speedBtn
                        ? Ink(
                            padding: EdgeInsets.all(5),
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  _hideSpeedStu = !_hideSpeedStu;
                                });
                              },
                              child: Container(
                                alignment: Alignment.center,
                                width: 40,
                                height: 30,
                                child: Text(
                                  _speed.toString() + " X",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          )
                        : Container(),
                    // 按钮 - 预览关闭 全屏/退出全屏
                    _isPreview
                        ? Container()
                        : !widget.noback
                            ? _buildPlayStateBtn(
                                widget.player.value.fullScreen
                                    ? Icons.fullscreen_exit
                                    : Icons.fullscreen,
                                () {
                                  if (widget.player.value.fullScreen) {
                                    player.exitFullScreen();
                                  } else {
                                    player.enterFullScreen();
                                  }
                                },
                              )
                            : vWidth > vHeight
                                ? _buildPlayStateBtn(
                                    widget.player.value.fullScreen
                                        ? Icons.fullscreen_exit
                                        : Icons.fullscreen,
                                    () {
                                      if (widget.player.value.fullScreen) {
                                        player.exitFullScreen();
                                      } else {
                                        player.enterFullScreen();
                                      }
                                    },
                                  )
                                : Container(),
                    SizedBox(width: 7),
                    //
                  ],
                ),
              ),
            ),
          ),
          // 隐藏进度条，ui隐藏时出现
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: showConfig.bottomPro &&
                    _hideStuff &&
                    _duration.inMilliseconds != 0
                ? Container(
                    alignment: Alignment.bottomLeft,
                    color: Colors.white24,
                    child: Container(
                      color: Color.fromRGBO(103, 224, 185, .7),
                      width: curBottomProW is double ? curBottomProW : 0,
                      height: 2,
                    ),
                  )
                : Container(),
          )
        ],
      ),
    );
  }

  // 返回按钮
  Widget _topBackBtn() {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.2),
              offset: Offset(0, 0),
              blurRadius: 16)
        ],
      ),
      child: widget.noback
          ? Container()
          : IconButton(
              icon: LImage('nav_back_w_n', width: 22, height: 22),
              splashColor: Colors.transparent,
              highlightColor: Colors.red,
              hoverColor: Colors.red,
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

  // 播放器顶部 返回 + 标题
  Widget _buildTopBar() {
    return AnimatedOpacity(
      opacity: widget.player.value.fullScreen == false
          ? 1.0
          : (_hideStuff && widget.player.value.fullScreen ? 0.0 : 1.0),
      duration: Duration(milliseconds: 400),
      child: Container(
        height: barHeight,
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          gradient: widget.player.value.fullScreen
              ? const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomLeft,
                  colors: [
                    Color.fromRGBO(0, 0, 0, 0.5),
                    Color.fromRGBO(0, 0, 0, 0),
                  ],
                )
              : null,
        ),
        child: Container(
          height: barHeight,
          child: Row(
            children: <Widget>[
              _topBackBtn(),
              widget.player.value.fullScreen
                  ? Expanded(
                      child: Container(
                        child: Text(
                          widget.playerTitle,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )
                  : Container()
            ],
          ),
        ),
      ),
    );
  }

  // 居中播放按钮
  Widget _buildCenterPlayBtn() {
    return Container(
      color: Colors.transparent,
      height: double.infinity,
      width: double.infinity,
      child: Center(
        child: (_prepared && !_buffering)
            ? AnimatedOpacity(
                opacity: _hideStuff ? 0.0 : 1.0,
                duration: Duration(milliseconds: 400),
                child: IconButton(
                  iconSize: 40,
                  icon: LImage(player.state == FijkState.completed
                      ? 'v_replay_n'
                      : (_playing ? 'v_pause_n' : 'v_play_n')),
                  onPressed: _playOrPause,
                ),
              )
            : SizedBox(
                width: 40,
                height: 40,
                child: const CircularProgressIndicator(
                  backgroundColor: Colors.white30,
                  valueColor: AlwaysStoppedAnimation(Color(0xff67e0b9)),
                  strokeWidth: 1.5,
                ),
              ),
      ),
    );
  }

  // build 滑动进度时间显示
  Widget _buildDargProgressTime() {
    return _isTouch
        ? Container(
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(5),
              ),
              color: Color.fromRGBO(0, 0, 0, 0.8),
            ),
            child: Padding(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: Text(
                '${_duration2String(_dargPos)} / ${_duration2String(_duration)}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
          )
        : Container();
  }

  String _duration2String(Duration duration) {
    if (duration.inMilliseconds < 0) return "-: negtive";

    String twoDigits(int n) {
      if (n >= 10) return "$n";
      return "0$n";
    }

    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    int inHours = duration.inHours;
    return inHours > 0
        ? "$inHours:$twoDigitMinutes:$twoDigitSeconds"
        : "$twoDigitMinutes:$twoDigitSeconds";
  }

  // build 显示垂直亮度，音量
  Widget _buildDargVolumeAndBrightness() {
    // 不显示
    if (!varTouchInitSuc) return Container();

    IconData iconData;
    // 判断当前值范围，显示的图标
    if (updateDargVarVal <= 0) {
      iconData = !isDargVerLeft ? Icons.volume_mute : Icons.brightness_low;
    } else if (updateDargVarVal < 0.5) {
      iconData = !isDargVerLeft ? Icons.volume_down : Icons.brightness_medium;
    } else {
      iconData = !isDargVerLeft ? Icons.volume_up : Icons.brightness_high;
    }
    // 显示，亮度 || 音量
    return Card(
      color: Color.fromRGBO(0, 0, 0, 0.8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              iconData,
              color: Colors.white,
            ),
            Container(
              width: 100,
              height: 2,
              margin: EdgeInsets.only(left: 8),
              child: LinearProgressIndicator(
                value: updateDargVarVal,
                backgroundColor: Colors.white54,
                valueColor: AlwaysStoppedAnimation(Color(0xff67e0b9)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // build 倍数列表
  List<Widget> _buildSpeedListWidget() {
    List<Widget> columnChild = [];
    speedList.forEach((String mapKey, double speedVals) {
      columnChild.add(
        Ink(
          child: InkWell(
            onTap: () {
              if (_speed == speedVals) return null;
              setState(() {
                _speed = speed = speedVals;
                _hideSpeedStu = true;
                player.setSpeed(speedVals);
              });
            },
            child: Container(
              alignment: Alignment.center,
              width: 50,
              height: 30,
              child: Text(
                mapKey + " X",
                style: TextStyle(
                  color: _speed == speedVals ? Color(0xff67e0b9) : Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
      );
      columnChild.add(
        Padding(
          padding: EdgeInsets.only(top: 5, bottom: 5),
          child: Container(
            width: 50,
            height: 1,
            color: Colors.white54,
          ),
        ),
      );
    });
    columnChild.removeAt(columnChild.length - 1);
    return columnChild;
  }

  // 播放器控制器 ui
  Widget _buildGestureDetector() {
    return GestureDetector(
      onTap: _cancelAndRestartTimer,
      behavior: HitTestBehavior.opaque,
      onHorizontalDragStart: widget.noback ? null : _onHorizontalDragStart,
      onHorizontalDragUpdate: widget.noback ? null : _onHorizontalDragUpdate,
      onHorizontalDragEnd: widget.noback ? null : _onHorizontalDragEnd,
      onVerticalDragStart: _onVerticalDragStart,
      onVerticalDragUpdate: _onVerticalDragUpdate,
      onVerticalDragEnd: _onVerticalDragEnd,
      child: AbsorbPointer(
        absorbing: _hideStuff,
        child: Column(
          children: <Widget>[
            // 播放器顶部控制器
            showConfig.topBar
                ? _buildTopBar()
                : Container(
                    height: barHeight,
                  ),
            // 中间按钮
            Expanded(
              child: Stack(
                children: <Widget>[
                  // 顶部显示
                  Positioned(
                    top: widget.player.value.fullScreen ? 20 : 0,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // 显示左右滑动快进时间的块
                        _buildDargProgressTime(),
                        // 显示上下滑动音量亮度
                        _buildDargVolumeAndBrightness()
                      ],
                    ),
                  ),
                  // 中间按钮
                  Align(
                    alignment: Alignment.center,
                    child: _buildCenterPlayBtn(),
                  ),
                  // 倍数选择
                  Positioned(
                    right: 35,
                    bottom: 0,
                    child: !_hideSpeedStu
                        ? Container(
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child: Column(
                                children: _buildSpeedListWidget(),
                              ),
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black45,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          )
                        : Container(),
                  ),
                  // 锁按钮
                  showConfig.lockBtn && widget.player.value.fullScreen
                      ? Align(
                          alignment: Alignment.centerLeft,
                          child: AnimatedOpacity(
                            opacity: _hideStuff ? 0.0 : 1.0,
                            duration: Duration(milliseconds: 400),
                            child: Padding(
                              padding: EdgeInsets.only(left: 20),
                              child: IconButton(
                                iconSize: 30,
                                onPressed: () {
                                  // 更改 ui显示状态
                                  widget.changeLockState(true);
                                },
                                icon: Icon(Icons.lock_open),
                                color: Colors.white,
                              ),
                            ),
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
            // 播放器底部控制器
            _buildBottomBar(context),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.info.source240.length > 0) {
      _isPreview = false;
    } else if (widget.info.preview_url.length > 0) {
      _isPreview = true;
    }
    return VisibilityDetector(
      key: ObjectKey(player),
      onVisibilityChanged: (visibility) {
        if (visibility.visibleFraction == 0 && this.mounted) {
          if (player.state == FijkState.completed) return;
          if (player.isPlayable()) {
            player.pause();
          }
        } else if (visibility.visibleFraction == 1) {
          if (player.state == FijkState.completed) return;
          if (player.isPlayable()) {
            player.start();
          }
        }
      },
      child: (player.state == FijkState.completed && _isPreview)
          ? _conditionWidget(context)
          : Stack(
              children: [
                _buildGestureDetector(),
                _isPreview
                    ? Positioned(
                        right: 0,
                        bottom: ScreenUtil().setWidth(40),
                        child: GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () {
                            if (widget.skiPreview != null) widget.skiPreview();
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: ScreenUtil().setWidth(8)),
                            height: ScreenUtil().setWidth(30),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color(0xff67e0b9)
                                      .withAlpha((0.6 * 255).toInt()),
                                  Color(0xff67e0b9)
                                      .withAlpha((0.6 * 255).toInt()),
                                ],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              borderRadius: BorderRadius.only(
                                topLeft:
                                    Radius.circular(ScreenUtil().setWidth(15)),
                                bottomLeft:
                                    Radius.circular(ScreenUtil().setWidth(15)),
                              ),
                            ),
                            child: Center(
                              child: Text.rich(
                                TextSpan(
                                    text: widget.info.isfree == 2
                                        ? "${AppGlobal.vipLevel > 0 ? widget.info.discountCoins : widget.info.coins}${CommonUtils.txt("kbtgyl")}"
                                        : CommonUtils.txt("ktvptgyl"),
                                    style: GQStyle.white255_12_B),
                              ),
                            ),
                          ),
                        ),
                      )
                    : Container()
              ],
            ),
    );
  }

  Widget _conditionWidget(BuildContext context) {
    Widget dgt = Container();
    var vflag = false;
    Member member = Provider.of<HomeConfig>(context, listen: false).member;
    if (AppGlobal.vipLevel < 1 && widget.info.isfree == 1) {
      if (member.exp > 0) {
        dgt = DefaultTextStyle(
          style: GQStyle.white255_14_N,
          child: Text.rich(
            TextSpan(children: [
              TextSpan(text: "${member.exp_con}", style: GQStyle.blue80_14_M),
              TextSpan(text: CommonUtils.txt('jbjsw') + "，"),
              TextSpan(text: CommonUtils.txt('ktvpzk') + "${member.exp}")
            ]),
          ),
        );
        vflag = true;
      } else {
        //需要VIP
        dgt = Text(CommonUtils.txt('kvbw'), style: GQStyle.white255_14_M);
        vflag = false;
      }
    }
    return Container(
      color: Colors.black87,
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            alignment: Alignment.centerLeft,
            height: ScreenUtil().setWidth(22),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.2),
                          offset: Offset(0, 0),
                          blurRadius: ScreenUtil().setWidth(16))
                    ],
                  ),
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    child: LImage("nav_back_w_n"),
                    onTap: () {
                      context.pop();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            top: ScreenUtil().setWidth(20),
            left: ScreenUtil().setWidth(50),
            right: ScreenUtil().setWidth(50),
          ),
          child: Column(
            children: [
              Text(CommonUtils.txt("skjs"), style: GQStyle.white255_14_M),
              SizedBox(height: ScreenUtil().setWidth(10)),
              dgt,
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            top: ScreenUtil().setWidth(16),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  if (vflag) {
                    if (widget.nowByKb != null) {
                      widget.nowByKb();
                    }
                  } else {
                    if (widget.nowToVp != null) {
                      widget.nowToVp();
                    }
                  }
                },
                child: Container(
                  height: ScreenUtil().setWidth(32),
                  width: ScreenUtil().setWidth(100),
                  decoration: BoxDecoration(
                    gradient: GQStyle.btnGradient_ff00edfd_ffbbe954,
                    borderRadius: BorderRadius.all(
                        Radius.circular(ScreenUtil().setWidth(3))),
                  ),
                  child: Center(
                    child: Text(
                        vflag
                            ? CommonUtils.txt("gmgk")
                            : CommonUtils.txt("ljkv"),
                        style: GQStyle.white255_13_M),
                  ),
                ),
              ),
              SizedBox(width: ScreenUtil().setWidth(37)),
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  if (widget.shareVp != null) widget.shareVp();
                },
                child: Container(
                  height: ScreenUtil().setWidth(32),
                  width: ScreenUtil().setWidth(100),
                  decoration: BoxDecoration(
                    gradient: GQStyle.btnGradient_ff00edfd_ffbbe954,
                    borderRadius: BorderRadius.all(
                        Radius.circular(ScreenUtil().setWidth(3))),
                  ),
                  child: Center(
                    child: Text(CommonUtils.txt("fxdv"),
                        style: GQStyle.white255_13_M),
                  ),
                ),
              )
            ],
          ),
        )
      ]),
    );
  }
}
