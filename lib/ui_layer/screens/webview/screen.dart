import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../common_widgets/screen_background.dart';
import '../common_widgets/my_image.dart';
import '../image_paths.dart';
import '../theme.dart';

class WebViewScreen extends StatefulWidget {
  const WebViewScreen({super.key, required this.url});
  final String url;
  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  String titleText = '';
  late final controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setBackgroundColor(const Color(0x00000000))
    ..setNavigationDelegate(
      NavigationDelegate(
        onProgress: (int progress) {
          // Update loading bar.
        },
        onPageStarted: (String url) {},
        onPageFinished: onPageFinished,
        onWebResourceError: (WebResourceError error) {},
      ),
    )
    ..loadRequest(
      Uri.parse(Uri.decodeComponent(widget.url)),
    );

  void onPageFinished(String url) {
    controller.runJavaScriptReturningResult('document.title').then((result) {
      setState(() {
        if (result case final String title) {
          setState(() {
            titleText = title.replaceAll(r'"', '');
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScreenBackground(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            titleText,
            style: MyTheme.white255_18_B,
          ),
          backgroundColor: Colors.transparent,
          leading: GestureDetector(
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
        ),
        body: WebViewWidget(
          controller: controller,
        ),
      ),
    );
  }
}
