import 'package:flutter/material.dart';
import 'package:qypj/base/baseWidget.dart';
import 'package:qypj/components/page_status.dart';
import 'package:qypj/global.dart';
import 'package:qypj/routers.dart';
import 'package:qypj/theme/default.dart';
import 'package:qypj/utils/common.dart';
import 'package:qypj/utils/extensionlibrary.dart';
import 'package:webview_flutter/webview_flutter.dart';

class KtLoadWebview extends BaseWidget {
  KtLoadWebview({Key key}) : super(key: key);

  @override
  State<KtLoadWebview> createState() => _KtLoadWebviewState();

  @override
  State<StatefulWidget> cState() {
    // TODO: implement cState
    return _KtLoadWebviewState();
  }
}

class _KtLoadWebviewState extends BaseWidgetState<KtLoadWebview> {
  WebViewController _controller;
  String url = Uri.decodeComponent(AppGlobal.webExtra["url"].toString());

  @override
  Widget pageBody(BuildContext context) {
    return url.length == 0
        ? PageStatus.noData()
        : Center(
            child: WebView(
              backgroundColor: GQStyle.bgColor,
              initialUrl: url,
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (controller) {
                // controller.clearCache();
                _controller = controller;
              },
              onPageFinished: (url) {
                _controller
                    .runJavascriptReturningResult("document.title")
                    .then((result) {
                  CommonUtils.debugPrint("====$result");
                  setAppTitle(title: result.replaceAll(r'"', ''));
                });
              },
              javascriptChannels: [
                JavascriptChannel(
                    name: "openRecharge",
                    onMessageReceived: (JavascriptMessage message) {
                      context.push('/${Routes.coinRecharge}');
                    }),
                JavascriptChannel(
                    name: "openVip",
                    onMessageReceived: (JavascriptMessage message) {
                      context.push('/${Routes.vip}');
                    }),
                JavascriptChannel(
                    name: "toInvite",
                    onMessageReceived: (JavascriptMessage message) {
                      context.push('/${Routes.kwantsharetousers}');
                    })
              ].toSet(),
            ),
          );
  }

  @override
  void onCreate() {
    // TODO: implement onCreate
  }

  @override
  void onDestroy() {
    // TODO: implement onDestroy
  }
}
