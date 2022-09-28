import 'package:flutter/material.dart';

class ImagesAnim extends StatefulWidget {
  ImagesAnim({
    Key key,
    this.imageCaches,
    this.width,
    this.height,
    this.backColor,
  }) : super(key: key);

  final Map<int, Image> imageCaches;
  final double width;
  final double height;
  final Color backColor;

  @override
  _ImagesAnimState createState() => _ImagesAnimState();
}

class _ImagesAnimState extends State<ImagesAnim> {
  bool _disposed;
  Duration _duration;
  int _imageIndex;
  Container _container;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _disposed = false;
    _duration = Duration(milliseconds: 100);
    _imageIndex = 0;
    _container = Container(height: widget.height, width: widget.width);
    // print("init ========== $_disposed ====$mounted");
    _updateImage();
  }

  void _updateImage() {
    // print("$_imageIndex ========== $_disposed ====$mounted");
    if (_disposed || widget.imageCaches.isEmpty || mounted == false) {
      return;
    }
    setState(() {
      if (_imageIndex > widget.imageCaches.length) {
        _imageIndex = 0;
      }
      _container = Container(
          color: widget.backColor,
          child: widget.imageCaches[_imageIndex],
          height: widget.height,
          width: widget.width);
      _imageIndex++;
      // print("$_imageIndex ========== $_disposed");
    });
    Future.delayed(_duration, () {
      _updateImage();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _disposed = true;
    widget.imageCaches.clear();
    // print(" ========== $_disposed");
  }

  @override
  Widget build(BuildContext context) {
    return _container;
  }
}

extension ImagesAnimExt on ImagesAnim {
  static Map<int, Image> _mapsR() {
    Map<int, Image> _maps = {};
    for (int i = 0; i < 15; i++) {
      _maps[i] = Image.asset("assets/images/refresh/header_$i.png",
          gaplessPlayback: true);
    }
    return _maps;
  }

  static Map<int, Image> _mapsC() {
    Map<int, Image> _maps = {};
    for (int i = 0; i < 14; i++) {
      _maps[i] = Image.asset("assets/images/refresh/center_$i.png",
          gaplessPlayback: true);
    }
    return _maps;
  }

  ///type 1:刷新 2:加载 3:播放加载
  static Widget load({int type = 2}) {
    if (type == 1) {
      return ImagesAnim(
          imageCaches: _mapsR(),
          width: 76.0,
          height: 22.0,
          backColor: Colors.transparent);
    } else if (type == 2) {
      // return Container();
      return ImagesAnim(
          imageCaches: _mapsR(),
          width: 160,
          height: 46.5,
          backColor: Colors.transparent);
    } else {
      return ImagesAnim(
          imageCaches: _mapsC(),
          width: 107,
          height: 31,
          backColor: Colors.transparent);
    }
  }
}
