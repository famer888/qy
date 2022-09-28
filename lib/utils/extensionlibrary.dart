// ignore_for_file: implementation_imports
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:qypj/utils/fluro_routes.dart';
import 'package:qypj/utils/navigator_util.dart';
// import 'package:video_player/video_player.dart';
// import 'package:video_player_platform_interface/video_player_platform_interface.dart';

// extension VideoPlayerPlatformExt on VideoPlayerPlatform {
//   //add new meth func
//   void requestFullScreen(int textureId) {
//     throw UnimplementedError('requestFullScreen() has not been implemented.');
//   }

//   void exitFullScreen(int textureId) {
//     throw UnimplementedError('exitFullScreen() has not been implemented.');
//   }
// }

// ignore: mixin_inherits_from_not_object
// extension VideoPlayerControllerExt on VideoPlayerController {
//   //add new methd func
//   void requestFullScreen() async {
//     VideoPlayerPlatform.instance.requestFullScreen(textureId);
//   }

//   void exitFullScreen() async {
//     VideoPlayerPlatform.instance.exitFullScreen(textureId);
//   }
// }

//扩展GoRouter pop带参数返回
extension ExtraE on GoRouter {
  /// Pop the top page off the Navigator's page stack by calling
  /// [Navigator.pop].
  void _popE(BuildContext context, [dynamic result]) =>
      Navigator.pop(context, result);
  void _pushE(String location, {Object extra, bool replace}) =>
      routerDelegate.push(location, extra: extra, replace: replace);
}

extension GoRouterE on BuildContext {
  void pop([dynamic result]) => GoRouter.of(this)._popE(this, result);
  void push(String location, {Object extra, bool replace = false}) =>
      GoRouter.of(this)._pushE(location, extra: extra, replace: replace);
  // void push(String location, {Object extra, bool replace = false}) =>
  //     NavigatorUtil.jump(context, FluroRoutes.search);
}
