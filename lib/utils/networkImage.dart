import 'package:flutter/material.dart';
// import 'package:flutter/foundation.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:qypj/utils/common.dart';

class PlatformAwareNetworkImage extends StatefulWidget {
  PlatformAwareNetworkImage({
    Key key,
    this.url,
    this.fit = BoxFit.cover,
    this.isVideoThumb = false,
    this.noVisibilityDetector = false,
    this.borderRadius,
    this.clipBehavior = Clip.hardEdge,
    this.filterQuality = FilterQuality.high,
    this.background = const Color(0xff262631),
    this.nofigure = false,
    this.imageName = "figure_n",
  }) : super(key: key);
  final dynamic url;
  final BoxFit fit;
  final bool isVideoThumb;
  final bool noVisibilityDetector;
  final BorderRadius borderRadius;
  final Clip clipBehavior;
  final FilterQuality filterQuality;
  final Color background;
  final bool nofigure;
  final String imageName;
  @override
  _PlatformAwareNetworkImageState createState() =>
      _PlatformAwareNetworkImageState();
}

class _PlatformAwareNetworkImageState extends State<PlatformAwareNetworkImage> {
  dynamic _url;
  GlobalKey _key = GlobalKey();
  bool isAnimated = true;
  bool isLoad = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.noVisibilityDetector) {
      setImgUrl();
    }
  }

  void setImgUrl() {
    if (widget.isVideoThumb) return;
    CommonUtils.getRealImage(
        url: widget.url,
        imgUrl: _url,
        setUrl: (e) {
          if (!mounted) return;
          setState(() {
            _url = e;
          });
        });
  }

  @override
  void didUpdateWidget(PlatformAwareNetworkImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.url != oldWidget.url) {
      setImgUrl();
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  void _handleVisibilityChanged(VisibilityInfo info) {
    if (isLoad) return;
    isLoad = true;
    CommonUtils.getRealImage(
        url: widget.url,
        imgUrl: _url,
        setUrl: (e) {
          if (!mounted) return;
          setState(() {
            _url = e;
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return widget.isVideoThumb
        ? imageWidget()
        : VisibilityDetector(
            key: _key,
            onVisibilityChanged: _handleVisibilityChanged,
            child: imageWidget());
  }

  Widget imageWidget() {
    bool isShow = (widget.isVideoThumb ? widget.url != null : _url != null);
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      double w = constraints.maxWidth / 3;
      return Container(
        width: double.infinity,
        height: double.infinity,
        clipBehavior: widget.clipBehavior,
        decoration: BoxDecoration(
          color: widget.nofigure ? Colors.transparent : widget.background,
          borderRadius: widget.borderRadius ?? null,
        ),
        child: widget.borderRadius == null
            ? _imageWidget(isShow, w)
            : ClipRRect(
                borderRadius: widget.borderRadius,
                child: _imageWidget(isShow, w),
              ),
      );
    });
  }

  Widget _imageWidget(isShow, w) {
    return Stack(
      children: [
        widget.nofigure
            ? Container()
            : Center(
                child: LImage(
                  widget.imageName,
                  width: widget.imageName == "figure_n" ? w : double.infinity,
                  height: widget.imageName == "figure_n"
                      ? w / 117 * 40
                      : double.infinity,
                ),
              ),
        Positioned(
          top: 0,
          right: 0,
          bottom: 0,
          left: 0,
          child: !isAnimated
              ? (isShow
                  ? Image.memory(widget.isVideoThumb ? widget.url : _url,
                      fit: widget.fit)
                  : Container())
              : AnimatedOpacity(
                  curve: Curves.easeInOut,
                  opacity: isShow ? 1 : 0,
                  child: isShow
                      ? Image.memory(widget.isVideoThumb ? widget.url : _url,
                          fit: widget.fit)
                      : Container(),
                  duration: Duration(milliseconds: 100)),
        )
      ],
    );
  }
}
