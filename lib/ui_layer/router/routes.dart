import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../domain/model/video_detail_model.dart';
import '../screens/bit/live/detail/screen.dart';
import '../screens/bit/monitor/detail/screen.dart';
import '../screens/community/circle_screen.dart';
import '../screens/community/module/screen.dart';
import '../screens/bit/screen.dart';
import '../screens/bit/detail/screen.dart';
import '../screens/bottom_navi_bar.dart';
import '../screens/community/detail/screen.dart';
import '../screens/community/issue/screen.dart';
import '../screens/community/screen.dart';
import '../screens/community/tag_detail/screen.dart';
import '../screens/home/ai/screen.dart';
import '../screens/home/screen.dart';
import '../screens/local_video/screen.dart';
import '../screens/login/screen.dart';
import '../screens/media_viewer/screen.dart';
import '../screens/mine/agent/profit/screen.dart';
import '../screens/mine/agent/promote_data/screen.dart';
import '../screens/mine/agent/screen.dart';
import '../screens/mine/buy/screen.dart';
import '../screens/mine/coin_recharge/coin_detail/screen.dart';
import '../screens/mine/coin_recharge/screen.dart';
import '../screens/mine/collection/screen.dart';
import '../screens/mine/download/screen.dart';
import '../screens/mine/fill_code/screen.dart';
import '../screens/mine/follow/screen.dart';
import '../screens/mine/help/screen.dart';
import '../screens/mine/income_detail/screen.dart';
import '../screens/mine/message_center/chat_message/screen.dart';
import '../screens/mine/message_center/customer_service/screen.dart';
import '../screens/mine/message_center/screen.dart';
import '../screens/mine/message_center/system_message/screen.dart';
import '../screens/mine/official_group/screen.dart';
import '../screens/mine/original_enter/screen.dart';
import '../screens/mine/posts/screen.dart';
import '../screens/mine/recharge_record/screen.dart';
import '../screens/mine/screen.dart';
import '../screens/mine/setup/screen.dart';
import '../screens/mine/share_to_user/record/screen.dart';
import '../screens/mine/share_to_user/screen.dart';
import '../screens/mine/vip_center/screen.dart';
import '../screens/mine/welfare/screen.dart';
import '../screens/mine/withdrawal/bank_list/screen.dart';
import '../screens/mine/withdrawal/record/screen.dart';
import '../screens/mine/withdrawal/screen.dart';
import '../screens/more_video/screen.dart';
import '../screens/restricted/screen.dart';
import '../screens/search/result/screen.dart';
import '../screens/search/screen.dart';
import '../screens/user_center/screen.dart';
import '../screens/video_detail/screen.dart';
import '../screens/webview/screen.dart';
import '../screens/welcome.dart';
import 'paths.dart';
import 'router.dart';
part 'routes.g.dart';

@TypedGoRoute<WelcomeRoute>(path: AppRouterPaths.root)
class WelcomeRoute extends GoRouteData {
  const WelcomeRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const WelcomeScreen();
  }
}

@TypedStatefulShellRoute<StatefulShellRoute>(
  branches: [
    TypedStatefulShellBranch(
      routes: [
        TypedGoRoute<HomeRoute>(
          path: AppRouterPaths.home,
        ),
      ],
    ),
    TypedStatefulShellBranch(
      routes: [
        TypedGoRoute<RestrictedRoute>(
          path: AppRouterPaths.jq,
        ),
      ],
    ),
    TypedStatefulShellBranch(
      routes: [
        TypedGoRoute<QzRoute>(
          path: AppRouterPaths.qz,
        ),
      ],
    ),
    TypedStatefulShellBranch(
      routes: [
        TypedGoRoute<CommunityRoute>(
          path: AppRouterPaths.community,
        ),
      ],
    ),
    TypedStatefulShellBranch(
      routes: [
        TypedGoRoute<BitRoute>(
          path: AppRouterPaths.xz,
        ),
      ],
    ),
    TypedStatefulShellBranch(
      routes: [
        TypedGoRoute<MineRoute>(
          path: AppRouterPaths.mine,
        ),
      ],
    ),
  ],
)
class StatefulShellRoute extends StatefulShellRouteData {
  const StatefulShellRoute();

  @override
  Widget builder(BuildContext context, GoRouterState state,
      StatefulNavigationShell navigationShell) {
    return BottomNaviBar(navigationShell: navigationShell);
  }
}

class HomeRoute extends GoRouteData {
  const HomeRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const HomeScreen();
}

class RestrictedRoute extends GoRouteData {
  const RestrictedRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const RestrictedScreen();
}

class BitRoute extends GoRouteData {
  const BitRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const BitScreen();
}

class QzRoute extends GoRouteData {
  const QzRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const CircleCommunityScreen();
}

class CommunityRoute extends GoRouteData {
  const CommunityRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const CommunityScreen();
}

class MineRoute extends GoRouteData {
  const MineRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const MineScreen();
}

@TypedGoRoute<WebViewRoute>(path: AppRouterPaths.webView)
class WebViewRoute extends GoRouteData {
  const WebViewRoute(this.url);
  final String url;
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return WebViewScreen(url: url);
  }
}

@TypedGoRoute<BitPostDetailRoute>(path: AppRouterPaths.bitPostDetail)
class BitPostDetailRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      AppRouter.rootNavigatorKey;

  const BitPostDetailRoute(this.id);

  final String id;
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return BitPostDetailScreen(
      id: id,
    );
  }
}

@TypedGoRoute<VipCenterRoute>(path: AppRouterPaths.mineVipCenter)
class VipCenterRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      AppRouter.rootNavigatorKey;

  const VipCenterRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const VipCenterScreen();
  }
}

@TypedGoRoute<CoinRechargeRoute>(path: AppRouterPaths.mineCoinRecharge)
class CoinRechargeRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      AppRouter.rootNavigatorKey;

  const CoinRechargeRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const CoinRechargeScreen();
  }
}

@TypedGoRoute<CoinDetailRoute>(path: AppRouterPaths.mineCoinDetail)
class CoinDetailRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      AppRouter.rootNavigatorKey;

  const CoinDetailRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const CoinDetailScreen();
  }
}

@TypedGoRoute<RechargeRecordRoute>(path: AppRouterPaths.mineRechargeRecord)
class RechargeRecordRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      AppRouter.rootNavigatorKey;

  const RechargeRecordRoute(this.type);
  final String type;
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return RechargeRecordScreen(type: type);
  }
}

@TypedGoRoute<CommunityIssueRoute>(path: AppRouterPaths.communityIssue)
class CommunityIssueRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      AppRouter.rootNavigatorKey;

  const CommunityIssueRoute({
    required this.type,
    required this.circle,
  });

  final CommunityIssueType type;
  final bool circle;
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return CommunityIssueScreen(
      type: type,
      circle: circle,
    );
  }
}

@TypedGoRoute<CommunityModuleRoute>(path: AppRouterPaths.communityModule)
class CommunityModuleRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      AppRouter.rootNavigatorKey;

  const CommunityModuleRoute({
    required this.id,
    required this.type,
  });
  final int id;
  final String type;
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return CommunityModuleScreen(id: id, type: type);
  }
}

@TypedGoRoute<CommunityPostDetailRoute>(
    path: AppRouterPaths.communityTieztDetail)
class CommunityPostDetailRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      AppRouter.rootNavigatorKey;

  const CommunityPostDetailRoute(this.id);

  final String id;
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return CommunityPostDetailScreen(id: id);
  }
}

@TypedGoRoute<LoginRoute>(path: AppRouterPaths.login)
class LoginRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      AppRouter.rootNavigatorKey;

  const LoginRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return const MaterialPage(
      fullscreenDialog: true,
      child: LoginScreen(),
    );
  }
}

@TypedGoRoute<MineSetupRoute>(path: AppRouterPaths.mineSetup)
class MineSetupRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      AppRouter.rootNavigatorKey;

  const MineSetupRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const MineSetupScreen();
  }
}

@TypedGoRoute<MineShareToUserRoute>(path: AppRouterPaths.mineShareToUser)
class MineShareToUserRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      AppRouter.rootNavigatorKey;

  const MineShareToUserRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const MineShareToUserScreen();
  }
}

@TypedGoRoute<MineShareToUserRecordRoute>(
    path: AppRouterPaths.mineShareToUserRecord)
class MineShareToUserRecordRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      AppRouter.rootNavigatorKey;

  const MineShareToUserRecordRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const MineShareToUserRecordScreen();
  }
}

@TypedGoRoute<MineAgentRoute>(path: AppRouterPaths.mineAgent)
class MineAgentRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      AppRouter.rootNavigatorKey;

  const MineAgentRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const MineAgentScreen();
  }
}

@TypedGoRoute<MineAgentProfitRoute>(path: AppRouterPaths.mineAgentProfit)
class MineAgentProfitRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      AppRouter.rootNavigatorKey;

  const MineAgentProfitRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const MineAgentProfitScreen();
  }
}

@TypedGoRoute<MineAgentPromoteDataRoute>(
    path: AppRouterPaths.mineAgentPromoteData)
class MineAgentPromoteDataRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      AppRouter.rootNavigatorKey;

  const MineAgentPromoteDataRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const MineAgentPromoteDataScreen();
  }
}

@TypedGoRoute<MineCustomerServiceRoute>(path: AppRouterPaths.customerService)
class MineCustomerServiceRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      AppRouter.rootNavigatorKey;

  const MineCustomerServiceRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const MineCustomerServiceScreen();
  }
}

@TypedGoRoute<MineWithdrawalRoute>(path: AppRouterPaths.mineWithdrawal)
class MineWithdrawalRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      AppRouter.rootNavigatorKey;

  const MineWithdrawalRoute(this.isAgent);

  final bool isAgent;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return MineWithdrawalScreen(isAgent: isAgent);
  }
}

@TypedGoRoute<MineWithdrawalRecordRoute>(
    path: AppRouterPaths.mineWithdrawalRecord)
class MineWithdrawalRecordRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      AppRouter.rootNavigatorKey;

  const MineWithdrawalRecordRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const MineWithdrawalRecordScreen();
  }
}

@TypedGoRoute<MineWithdrawalBankListRoute>(
    path: AppRouterPaths.mineWithdrawalBankList)
class MineWithdrawalBankListRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      AppRouter.rootNavigatorKey;

  const MineWithdrawalBankListRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const MineWithdrawalBankListScreen();
  }
}

@TypedGoRoute<MineWelfareRoute>(path: AppRouterPaths.mineWelfare)
class MineWelfareRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      AppRouter.rootNavigatorKey;

  const MineWelfareRoute({this.index = 0});
  final int index;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return MineWelfareScreen(index: index);
  }
}

@TypedGoRoute<MinePostRoute>(path: AppRouterPaths.minePost)
class MinePostRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      AppRouter.rootNavigatorKey;

  const MinePostRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const MinePostScreen();
  }
}

@TypedGoRoute<MineIncomeDetailRoute>(path: AppRouterPaths.mineIncomeDetail)
class MineIncomeDetailRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      AppRouter.rootNavigatorKey;

  const MineIncomeDetailRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const MineIncomeDetailScreen();
  }
}

@TypedGoRoute<MineCollectionRoute>(path: AppRouterPaths.mineCollection)
class MineCollectionRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      AppRouter.rootNavigatorKey;

  const MineCollectionRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const MineCollectionScreen();
  }
}

@TypedGoRoute<UserCenterRoute>(path: AppRouterPaths.userCenter)
class UserCenterRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      AppRouter.rootNavigatorKey;

  const UserCenterRoute(this.aff);

  final String aff;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return UserCenterScreen(aff: aff);
  }
}

@TypedGoRoute<ChatMessageRoute>(path: AppRouterPaths.chatMessage)
class ChatMessageRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      AppRouter.rootNavigatorKey;

  const ChatMessageRoute(
      {required this.nickName, required this.toUuid, required this.thumb});

  final String nickName;
  final String toUuid;
  final String thumb;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return ChatMessageScreen(
      toUuid: toUuid,
      nickName: nickName,
      thumb: thumb,
    );
  }
}

@TypedGoRoute<MineFollowingRoute>(path: AppRouterPaths.mineFollowing)
class MineFollowingRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      AppRouter.rootNavigatorKey;

  const MineFollowingRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const MineFollowingScreen();
  }
}

@TypedGoRoute<OriginalEnterRoute>(path: AppRouterPaths.originalEnter)
class OriginalEnterRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      AppRouter.rootNavigatorKey;

  const OriginalEnterRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const OriginalEnterScreen();
  }
}

@TypedGoRoute<CommunityTagDetailRoute>(path: AppRouterPaths.communityTagDetail)
class CommunityTagDetailRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      AppRouter.rootNavigatorKey;

  const CommunityTagDetailRoute(this.id);

  final String id;

  Future<T?> push<T>(BuildContext context) =>
      context.removeDuplicatePush(location);

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return CommunityTagDetailScreen(id: id);
  }
}

@TypedGoRoute<MineBuyRoute>(path: AppRouterPaths.mineBuy)
class MineBuyRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      AppRouter.rootNavigatorKey;

  const MineBuyRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const MineBuyScreen();
  }
}

@TypedGoRoute<VideoDetailRoute>(path: AppRouterPaths.videoDetail)
class VideoDetailRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      AppRouter.rootNavigatorKey;

  const VideoDetailRoute(this.$extra);
  final String $extra;

  Future<T?> push<T>(BuildContext context) =>
      context.removeDuplicatePush(location, extra: $extra);

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return VideoDetailScreen(id: $extra);
  }
}

@TypedGoRoute<MineDownloadRoute>(path: AppRouterPaths.mineDownload)
class MineDownloadRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      AppRouter.rootNavigatorKey;

  const MineDownloadRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const MineDownloadScreen();
  }
}

@TypedGoRoute<MineFillCodeRoute>(path: AppRouterPaths.mineFillCode)
class MineFillCodeRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      AppRouter.rootNavigatorKey;

  const MineFillCodeRoute(this.title);
  final String title;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return MineFillCodeScreen(title: title);
  }
}

@TypedGoRoute<MineHelpRoute>(path: AppRouterPaths.mineHelp)
class MineHelpRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      AppRouter.rootNavigatorKey;

  const MineHelpRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const MineHelpScreen();
  }
}

@TypedGoRoute<MineOfficialGroupRoute>(path: AppRouterPaths.mineOfficialGroup)
class MineOfficialGroupRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      AppRouter.rootNavigatorKey;

  const MineOfficialGroupRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const MineOfficialGroupScreen();
  }
}

@TypedGoRoute<SearchRoute>(path: AppRouterPaths.search)
class SearchRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      AppRouter.rootNavigatorKey;

  const SearchRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const SearchScreen();
  }
}

@TypedGoRoute<SearchResultRoute>(path: AppRouterPaths.searchResult)
class SearchResultRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      AppRouter.rootNavigatorKey;

  const SearchResultRoute(this.title);

  final String title;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return SearchResultScreen(title: title);
  }
}

@TypedGoRoute<MoreVideoRoute>(path: AppRouterPaths.moreVideo)
class MoreVideoRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      AppRouter.rootNavigatorKey;

  const MoreVideoRoute({
    required this.name,
    required this.id,
  });

  final String name;
  final String id;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return MoreVideoScreen(name: name, id: id);
  }
}

@TypedGoRoute<MessageCenterRoute>(path: AppRouterPaths.mineMessageCenter)
class MessageCenterRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      AppRouter.rootNavigatorKey;

  const MessageCenterRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const MessageCenterScreen();
  }
}

@TypedGoRoute<SystemMessageRoute>(path: AppRouterPaths.mineSystemMessage)
class SystemMessageRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      AppRouter.rootNavigatorKey;

  const SystemMessageRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const SystemMessageScreen();
  }
}

@TypedGoRoute<MediaViewerRoute>(path: AppRouterPaths.mediaViewer)
class MediaViewerRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      AppRouter.rootNavigatorKey;

  const MediaViewerRoute(this.$extra);
  final Map $extra;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return MediaViewerScreen(pramas: $extra);
  }
}

@TypedGoRoute<LocalVideoRoute>(path: AppRouterPaths.localVideo)
class LocalVideoRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      AppRouter.rootNavigatorKey;

  const LocalVideoRoute(this.$extra);
  final VideoData $extra;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return LocalVideoScreen(data: $extra);
  }
}

@TypedGoRoute<HomeAIRoute>(path: AppRouterPaths.ai)
class HomeAIRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      AppRouter.rootNavigatorKey;

  const HomeAIRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const HomeAiScreen();
  }
}

@TypedGoRoute<LiveVideoDetailRoute>(path: AppRouterPaths.liveVideoDetail)
class LiveVideoDetailRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      AppRouter.rootNavigatorKey;

  const LiveVideoDetailRoute(this.id);
  final String id;

  Future<T?> push<T>(BuildContext context) =>
      context.removeDuplicatePush(location);

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return LiveVideoDetailScreen(id: id);
  }
}

@TypedGoRoute<MonitorVideoDetailRoute>(path: AppRouterPaths.monitorVideoDetail)
class MonitorVideoDetailRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      AppRouter.rootNavigatorKey;

  const MonitorVideoDetailRoute(this.id);
  final String id;

  Future<T?> push<T>(BuildContext context) =>
      context.removeDuplicatePush(location);

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return MonitorVideoDetailScreen(id: id);
  }
}

extension _MyPushHelper on BuildContext {
  Future<T?> removeDuplicatePush<T>(String location, {Object? extra}) async {
    final router = GoRouter.of(this);

    final matchList = router.routerDelegate.currentConfiguration.matches;
    final newMatchList = matchList
        .where((element) => element.matchedLocation != location)
        .toList();
    matchList.clear();
    matchList.addAll(newMatchList);

    return push<T>(location, extra: extra);
  }
}
