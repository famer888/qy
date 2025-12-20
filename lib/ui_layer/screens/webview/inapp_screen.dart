import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../router/routes.dart';
import '../../utils/common_utils.dart';
import '../../utils/my_toast.dart';
import '../common_widgets/screen_background.dart';
import '../common_widgets/my_image.dart';
import '../image_paths.dart';
import '../theme.dart';

import 'package:image_picker/image_picker.dart';
import "package:universal_html/html.dart" as html;
import 'package:webview_flutter_android/webview_flutter_android.dart';
import '../../../report/ui_layer/report_gesture_detector.dart';

import 'fake_native_widget.dart' if (dart.library.html) 'real_web_widget.dart'
    as ui;

class InAppWebViewScreen extends StatefulWidget {
  const InAppWebViewScreen({super.key, required this.url, this.needNav = true});
  final String url;
  final bool? needNav;

  @override
  State<InAppWebViewScreen> createState() => _InAppWebViewScreenState();
}

class _InAppWebViewScreenState extends State<InAppWebViewScreen> {
  String titleText = '';
  late WebViewController _controller;

  late html.EventListener _listener;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (kIsWeb) {
      _listener = (event) {
        if (event is! html.MessageEvent) return;
        jumpToPage(event.data.toString());
      };
    }
  }

  @override
  void dispose() {
    if (kIsWeb) {
      _listener = (event) {
        if (event is! html.MessageEvent) return;
        jumpToPage(event.data.toString());
      };
    }
    html.window.removeEventListener('message', _listener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenBackground(
      child: Scaffold(
        appBar: widget.needNav == true
            ? AppBar(
                title: Text(
                  titleText,
                  style: MyTheme.white255_18_B,
                ),
                backgroundColor: MyTheme.bgColor,
                leading: ReportGestureDetector(
                  onTap: () {
                    context.pop();
                  },
                  child: Center(
                    child: MyImage.asset(
                      width: 20.w,
                      height: 20.w,
                      MyImagePaths.appBackIcon,
                    ),
                  ),
                ),
                iconTheme: const IconThemeData(color: Colors.white),
              )
            : null,
        backgroundColor: MyTheme.bgColor,
        body: _buildNativeWidget(),
      ),
    );
  }

  Widget _buildNativeWidget() {
    return InAppWebView(
      initialSettings: InAppWebViewSettings(javaScriptEnabled: true),
      initialUrlRequest: URLRequest(url: WebUri(widget.url)),
      onWebViewCreated: (controller) {
        // _controller = controller;

        // 监听 JS 调用：window.flutter_inappwebview.callHandler("jumpOutLink", l)
        // controller.addJavaScriptHandler(
        //   handlerName: 'jumpOutLink',
        //   callback: (args) async {
        //     final link = args.isNotEmpty ? (args[0] as String?) : null;
        //     if (link == null) return 'no-link';

        //     // TODO: 根据你的业务处理，比如外跳
        //     // final uri = Uri.parse(link);
        //     // if (await canLaunchUrl(uri)) {
        //     //   await launchUrl(uri, mode: LaunchMode.externalApplication);
        //     // }
        //     jumpOutLink(link);
        //     return 'ok'; // 可返回给 JS
        //   },
        // );
      },

      // 可选：拦截 window.open 的新窗口
      onCreateWindow: (controller, createWindowAction) async {
        final url = createWindowAction.request.url?.toString();
        if (url != null) {
          jumpOutLink(url);

          // final uri = Uri.parse(url);
          // launchUrl(uri, mode: LaunchMode.externalApplication);
        }
        return true; // 自己处理了
      },
    );
  }

  Widget _buildHtmlWidget() {
    final String viewType =
        'iframeElement-${DateTime.now().millisecondsSinceEpoch}';
    final html.IFrameElement element = html.IFrameElement();
    element.src = Uri.decodeComponent(widget.url);
    element.style.border = 'none';
    element.style.width = '100%';
    element.style.height = '100%';

    html.window.addEventListener('message', _listener);

    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(
      viewType,
      (int viewId) => element,
    );
    Widget current = HtmlElementView(
      viewType: viewType,
      key: UniqueKey(),
    );
    return Stack(children: [
      IgnorePointer(
        ignoring: true,
        child: Center(child: current),
      ),
    ]);
  }

  void jumpToPage(String msg) {
    switch (msg) {
      case 'openRecharge':
        const CoinRechargeRoute().push(context);
        break;
      case 'openVip':
        const VipCenterRoute().push(context);
        break;
      case 'toInvite':
        const MineShareToUserRoute().push(context);
        break;
      default:
        MyToast.showText(text: msg.toString());
    }
  }

  void jumpOutLink(String msg) {
    CommonUtils.launchUrl(msg);
  }

  Uint8List? _snapshot;
  bool _showSnapshot = false;

  bool _exiting = false;
}
