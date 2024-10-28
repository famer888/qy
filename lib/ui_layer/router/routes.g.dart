// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'routes.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
      $welcomeRoute,
      $statefulShellRoute,
      $webViewRoute,
      $bitPostDetailRoute,
      $vipCenterRoute,
      $coinRechargeRoute,
      $coinDetailRoute,
      $rechargeRecordRoute,
      $communityIssueRoute,
      $communityModuleRoute,
      $communityPostDetailRoute,
      $loginRoute,
      $mineSetupRoute,
      $mineShareToUserRoute,
      $mineShareToUserRecordRoute,
      $mineAgentRoute,
      $mineAgentProfitRoute,
      $mineAgentPromoteDataRoute,
      $mineCustomerServiceRoute,
      $mineWithdrawalRoute,
      $mineWithdrawalRecordRoute,
      $mineWithdrawalBankListRoute,
      $mineWelfareRoute,
      $minePostRoute,
      $mineIncomeDetailRoute,
      $mineCollectionRoute,
      $userCenterRoute,
      $chatMessageRoute,
      $mineFollowingRoute,
      $originalEnterRoute,
      $communityTagDetailRoute,
      $mineBuyRoute,
      $videoDetailRoute,
      $mineDownloadRoute,
      $mineFillCodeRoute,
      $mineHelpRoute,
      $mineOfficialGroupRoute,
      $searchRoute,
      $searchResultRoute,
      $moreVideoRoute,
      $messageCenterRoute,
      $systemMessageRoute,
      $mediaViewerRoute,
      $localVideoRoute,
      $homeAIRoute,
    ];

RouteBase get $welcomeRoute => GoRouteData.$route(
      path: '/',
      factory: $WelcomeRouteExtension._fromState,
    );

extension $WelcomeRouteExtension on WelcomeRoute {
  static WelcomeRoute _fromState(GoRouterState state) => const WelcomeRoute();

  String get location => GoRouteData.$location(
        '/',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $statefulShellRoute => StatefulShellRouteData.$route(
      factory: $StatefulShellRouteExtension._fromState,
      branches: [
        StatefulShellBranchData.$branch(
          routes: [
            GoRouteData.$route(
              path: '/home',
              factory: $HomeRouteExtension._fromState,
            ),
          ],
        ),
        StatefulShellBranchData.$branch(
          routes: [
            GoRouteData.$route(
              path: '/jq',
              factory: $RestrictedRouteExtension._fromState,
            ),
          ],
        ),
        StatefulShellBranchData.$branch(
          routes: [
            GoRouteData.$route(
              path: '/qz',
              factory: $QzRouteExtension._fromState,
            ),
          ],
        ),
        StatefulShellBranchData.$branch(
          routes: [
            GoRouteData.$route(
              path: '/community',
              factory: $CommunityRouteExtension._fromState,
            ),
          ],
        ),
        StatefulShellBranchData.$branch(
          routes: [
            GoRouteData.$route(
              path: '/xz',
              factory: $BitRouteExtension._fromState,
            ),
          ],
        ),
        StatefulShellBranchData.$branch(
          routes: [
            GoRouteData.$route(
              path: '/mine',
              factory: $MineRouteExtension._fromState,
            ),
          ],
        ),
      ],
    );

extension $StatefulShellRouteExtension on StatefulShellRoute {
  static StatefulShellRoute _fromState(GoRouterState state) =>
      const StatefulShellRoute();
}

extension $HomeRouteExtension on HomeRoute {
  static HomeRoute _fromState(GoRouterState state) => const HomeRoute();

  String get location => GoRouteData.$location(
        '/home',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $RestrictedRouteExtension on RestrictedRoute {
  static RestrictedRoute _fromState(GoRouterState state) =>
      const RestrictedRoute();

  String get location => GoRouteData.$location(
        '/jq',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $QzRouteExtension on QzRoute {
  static QzRoute _fromState(GoRouterState state) => const QzRoute();

  String get location => GoRouteData.$location(
        '/qz',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $CommunityRouteExtension on CommunityRoute {
  static CommunityRoute _fromState(GoRouterState state) =>
      const CommunityRoute();

  String get location => GoRouteData.$location(
        '/community',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $BitRouteExtension on BitRoute {
  static BitRoute _fromState(GoRouterState state) => const BitRoute();

  String get location => GoRouteData.$location(
        '/xz',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $MineRouteExtension on MineRoute {
  static MineRoute _fromState(GoRouterState state) => const MineRoute();

  String get location => GoRouteData.$location(
        '/mine',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $webViewRoute => GoRouteData.$route(
      path: '/ktloadwebview/:url',
      factory: $WebViewRouteExtension._fromState,
    );

extension $WebViewRouteExtension on WebViewRoute {
  static WebViewRoute _fromState(GoRouterState state) => WebViewRoute(
        state.pathParameters['url']!,
      );

  String get location => GoRouteData.$location(
        '/ktloadwebview/${Uri.encodeComponent(url)}',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $bitPostDetailRoute => GoRouteData.$route(
      path: '/bitPostDetail/:id',
      parentNavigatorKey: BitPostDetailRoute.$parentNavigatorKey,
      factory: $BitPostDetailRouteExtension._fromState,
    );

extension $BitPostDetailRouteExtension on BitPostDetailRoute {
  static BitPostDetailRoute _fromState(GoRouterState state) =>
      BitPostDetailRoute(
        state.pathParameters['id']!,
      );

  String get location => GoRouteData.$location(
        '/bitPostDetail/${Uri.encodeComponent(id)}',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $vipCenterRoute => GoRouteData.$route(
      path: '/mineVipCenter',
      parentNavigatorKey: VipCenterRoute.$parentNavigatorKey,
      factory: $VipCenterRouteExtension._fromState,
    );

extension $VipCenterRouteExtension on VipCenterRoute {
  static VipCenterRoute _fromState(GoRouterState state) =>
      const VipCenterRoute();

  String get location => GoRouteData.$location(
        '/mineVipCenter',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $coinRechargeRoute => GoRouteData.$route(
      path: '/mineCoinRecharge',
      parentNavigatorKey: CoinRechargeRoute.$parentNavigatorKey,
      factory: $CoinRechargeRouteExtension._fromState,
    );

extension $CoinRechargeRouteExtension on CoinRechargeRoute {
  static CoinRechargeRoute _fromState(GoRouterState state) =>
      const CoinRechargeRoute();

  String get location => GoRouteData.$location(
        '/mineCoinRecharge',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $coinDetailRoute => GoRouteData.$route(
      path: '/mineCoinDetail',
      parentNavigatorKey: CoinDetailRoute.$parentNavigatorKey,
      factory: $CoinDetailRouteExtension._fromState,
    );

extension $CoinDetailRouteExtension on CoinDetailRoute {
  static CoinDetailRoute _fromState(GoRouterState state) =>
      const CoinDetailRoute();

  String get location => GoRouteData.$location(
        '/mineCoinDetail',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $rechargeRecordRoute => GoRouteData.$route(
      path: '/mineRechargeRecord/:type',
      parentNavigatorKey: RechargeRecordRoute.$parentNavigatorKey,
      factory: $RechargeRecordRouteExtension._fromState,
    );

extension $RechargeRecordRouteExtension on RechargeRecordRoute {
  static RechargeRecordRoute _fromState(GoRouterState state) =>
      RechargeRecordRoute(
        state.pathParameters['type']!,
      );

  String get location => GoRouteData.$location(
        '/mineRechargeRecord/${Uri.encodeComponent(type)}',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $communityIssueRoute => GoRouteData.$route(
      path: '/communityIssue/:type/:circle',
      parentNavigatorKey: CommunityIssueRoute.$parentNavigatorKey,
      factory: $CommunityIssueRouteExtension._fromState,
    );

extension $CommunityIssueRouteExtension on CommunityIssueRoute {
  static CommunityIssueRoute _fromState(GoRouterState state) =>
      CommunityIssueRoute(
        type: _$CommunityIssueTypeEnumMap
            ._$fromName(state.pathParameters['type']!),
        circle: _$boolConverter(state.pathParameters['circle']!),
      );

  String get location => GoRouteData.$location(
        '/communityIssue/${Uri.encodeComponent(_$CommunityIssueTypeEnumMap[type]!)}/${Uri.encodeComponent(circle.toString())}',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

const _$CommunityIssueTypeEnumMap = {
  CommunityIssueType.image: 'image',
  CommunityIssueType.video: 'video',
  CommunityIssueType.imageAndText: 'image-and-text',
};

bool _$boolConverter(String value) {
  switch (value) {
    case 'true':
      return true;
    case 'false':
      return false;
    default:
      throw UnsupportedError('Cannot convert "$value" into a bool.');
  }
}

extension<T extends Enum> on Map<T, String> {
  T _$fromName(String value) =>
      entries.singleWhere((element) => element.value == value).key;
}

RouteBase get $communityModuleRoute => GoRouteData.$route(
      path: '/communityModule',
      parentNavigatorKey: CommunityModuleRoute.$parentNavigatorKey,
      factory: $CommunityModuleRouteExtension._fromState,
    );

extension $CommunityModuleRouteExtension on CommunityModuleRoute {
  static CommunityModuleRoute _fromState(GoRouterState state) =>
      CommunityModuleRoute(
        id: int.parse(state.uri.queryParameters['id']!),
        type: state.uri.queryParameters['type']!,
      );

  String get location => GoRouteData.$location(
        '/communityModule',
        queryParams: {
          'id': id.toString(),
          'type': type,
        },
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $communityPostDetailRoute => GoRouteData.$route(
      path: '/communityTieztDetail/:id',
      parentNavigatorKey: CommunityPostDetailRoute.$parentNavigatorKey,
      factory: $CommunityPostDetailRouteExtension._fromState,
    );

extension $CommunityPostDetailRouteExtension on CommunityPostDetailRoute {
  static CommunityPostDetailRoute _fromState(GoRouterState state) =>
      CommunityPostDetailRoute(
        state.pathParameters['id']!,
      );

  String get location => GoRouteData.$location(
        '/communityTieztDetail/${Uri.encodeComponent(id)}',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $loginRoute => GoRouteData.$route(
      path: '/login',
      parentNavigatorKey: LoginRoute.$parentNavigatorKey,
      factory: $LoginRouteExtension._fromState,
    );

extension $LoginRouteExtension on LoginRoute {
  static LoginRoute _fromState(GoRouterState state) => const LoginRoute();

  String get location => GoRouteData.$location(
        '/login',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $mineSetupRoute => GoRouteData.$route(
      path: '/mineSetup',
      parentNavigatorKey: MineSetupRoute.$parentNavigatorKey,
      factory: $MineSetupRouteExtension._fromState,
    );

extension $MineSetupRouteExtension on MineSetupRoute {
  static MineSetupRoute _fromState(GoRouterState state) =>
      const MineSetupRoute();

  String get location => GoRouteData.$location(
        '/mineSetup',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $mineShareToUserRoute => GoRouteData.$route(
      path: '/mineShareToUser',
      parentNavigatorKey: MineShareToUserRoute.$parentNavigatorKey,
      factory: $MineShareToUserRouteExtension._fromState,
    );

extension $MineShareToUserRouteExtension on MineShareToUserRoute {
  static MineShareToUserRoute _fromState(GoRouterState state) =>
      const MineShareToUserRoute();

  String get location => GoRouteData.$location(
        '/mineShareToUser',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $mineShareToUserRecordRoute => GoRouteData.$route(
      path: '/mineShareToUserRecord',
      parentNavigatorKey: MineShareToUserRecordRoute.$parentNavigatorKey,
      factory: $MineShareToUserRecordRouteExtension._fromState,
    );

extension $MineShareToUserRecordRouteExtension on MineShareToUserRecordRoute {
  static MineShareToUserRecordRoute _fromState(GoRouterState state) =>
      const MineShareToUserRecordRoute();

  String get location => GoRouteData.$location(
        '/mineShareToUserRecord',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $mineAgentRoute => GoRouteData.$route(
      path: '/mineAgent',
      parentNavigatorKey: MineAgentRoute.$parentNavigatorKey,
      factory: $MineAgentRouteExtension._fromState,
    );

extension $MineAgentRouteExtension on MineAgentRoute {
  static MineAgentRoute _fromState(GoRouterState state) =>
      const MineAgentRoute();

  String get location => GoRouteData.$location(
        '/mineAgent',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $mineAgentProfitRoute => GoRouteData.$route(
      path: '/mineAgentProfit',
      parentNavigatorKey: MineAgentProfitRoute.$parentNavigatorKey,
      factory: $MineAgentProfitRouteExtension._fromState,
    );

extension $MineAgentProfitRouteExtension on MineAgentProfitRoute {
  static MineAgentProfitRoute _fromState(GoRouterState state) =>
      const MineAgentProfitRoute();

  String get location => GoRouteData.$location(
        '/mineAgentProfit',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $mineAgentPromoteDataRoute => GoRouteData.$route(
      path: '/mineAgentPromoteData',
      parentNavigatorKey: MineAgentPromoteDataRoute.$parentNavigatorKey,
      factory: $MineAgentPromoteDataRouteExtension._fromState,
    );

extension $MineAgentPromoteDataRouteExtension on MineAgentPromoteDataRoute {
  static MineAgentPromoteDataRoute _fromState(GoRouterState state) =>
      const MineAgentPromoteDataRoute();

  String get location => GoRouteData.$location(
        '/mineAgentPromoteData',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $mineCustomerServiceRoute => GoRouteData.$route(
      path: '/customerService',
      parentNavigatorKey: MineCustomerServiceRoute.$parentNavigatorKey,
      factory: $MineCustomerServiceRouteExtension._fromState,
    );

extension $MineCustomerServiceRouteExtension on MineCustomerServiceRoute {
  static MineCustomerServiceRoute _fromState(GoRouterState state) =>
      const MineCustomerServiceRoute();

  String get location => GoRouteData.$location(
        '/customerService',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $mineWithdrawalRoute => GoRouteData.$route(
      path: '/mineWithdrawal/:isAgent',
      parentNavigatorKey: MineWithdrawalRoute.$parentNavigatorKey,
      factory: $MineWithdrawalRouteExtension._fromState,
    );

extension $MineWithdrawalRouteExtension on MineWithdrawalRoute {
  static MineWithdrawalRoute _fromState(GoRouterState state) =>
      MineWithdrawalRoute(
        _$boolConverter(state.pathParameters['isAgent']!),
      );

  String get location => GoRouteData.$location(
        '/mineWithdrawal/${Uri.encodeComponent(isAgent.toString())}',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $mineWithdrawalRecordRoute => GoRouteData.$route(
      path: '/mineWithdrawalRecord',
      parentNavigatorKey: MineWithdrawalRecordRoute.$parentNavigatorKey,
      factory: $MineWithdrawalRecordRouteExtension._fromState,
    );

extension $MineWithdrawalRecordRouteExtension on MineWithdrawalRecordRoute {
  static MineWithdrawalRecordRoute _fromState(GoRouterState state) =>
      const MineWithdrawalRecordRoute();

  String get location => GoRouteData.$location(
        '/mineWithdrawalRecord',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $mineWithdrawalBankListRoute => GoRouteData.$route(
      path: '/mineWithdrawalBankList',
      parentNavigatorKey: MineWithdrawalBankListRoute.$parentNavigatorKey,
      factory: $MineWithdrawalBankListRouteExtension._fromState,
    );

extension $MineWithdrawalBankListRouteExtension on MineWithdrawalBankListRoute {
  static MineWithdrawalBankListRoute _fromState(GoRouterState state) =>
      const MineWithdrawalBankListRoute();

  String get location => GoRouteData.$location(
        '/mineWithdrawalBankList',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $mineWelfareRoute => GoRouteData.$route(
      path: '/mineWelfare/:index',
      parentNavigatorKey: MineWelfareRoute.$parentNavigatorKey,
      factory: $MineWelfareRouteExtension._fromState,
    );

extension $MineWelfareRouteExtension on MineWelfareRoute {
  static MineWelfareRoute _fromState(GoRouterState state) => MineWelfareRoute(
        index: int.parse(state.pathParameters['index']!) ?? 0,
      );

  String get location => GoRouteData.$location(
        '/mineWelfare/${Uri.encodeComponent(index.toString())}',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $minePostRoute => GoRouteData.$route(
      path: '/minePost',
      parentNavigatorKey: MinePostRoute.$parentNavigatorKey,
      factory: $MinePostRouteExtension._fromState,
    );

extension $MinePostRouteExtension on MinePostRoute {
  static MinePostRoute _fromState(GoRouterState state) => const MinePostRoute();

  String get location => GoRouteData.$location(
        '/minePost',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $mineIncomeDetailRoute => GoRouteData.$route(
      path: '/mineIncomeDetail',
      parentNavigatorKey: MineIncomeDetailRoute.$parentNavigatorKey,
      factory: $MineIncomeDetailRouteExtension._fromState,
    );

extension $MineIncomeDetailRouteExtension on MineIncomeDetailRoute {
  static MineIncomeDetailRoute _fromState(GoRouterState state) =>
      const MineIncomeDetailRoute();

  String get location => GoRouteData.$location(
        '/mineIncomeDetail',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $mineCollectionRoute => GoRouteData.$route(
      path: '/mineCollection',
      parentNavigatorKey: MineCollectionRoute.$parentNavigatorKey,
      factory: $MineCollectionRouteExtension._fromState,
    );

extension $MineCollectionRouteExtension on MineCollectionRoute {
  static MineCollectionRoute _fromState(GoRouterState state) =>
      const MineCollectionRoute();

  String get location => GoRouteData.$location(
        '/mineCollection',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $userCenterRoute => GoRouteData.$route(
      path: '/userCenter/:aff',
      parentNavigatorKey: UserCenterRoute.$parentNavigatorKey,
      factory: $UserCenterRouteExtension._fromState,
    );

extension $UserCenterRouteExtension on UserCenterRoute {
  static UserCenterRoute _fromState(GoRouterState state) => UserCenterRoute(
        state.pathParameters['aff']!,
      );

  String get location => GoRouteData.$location(
        '/userCenter/${Uri.encodeComponent(aff)}',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $chatMessageRoute => GoRouteData.$route(
      path: '/chatMessage/:toUuid/:nickName/:thumb',
      parentNavigatorKey: ChatMessageRoute.$parentNavigatorKey,
      factory: $ChatMessageRouteExtension._fromState,
    );

extension $ChatMessageRouteExtension on ChatMessageRoute {
  static ChatMessageRoute _fromState(GoRouterState state) => ChatMessageRoute(
        nickName: state.pathParameters['nickName']!,
        toUuid: state.pathParameters['toUuid']!,
        thumb: state.pathParameters['thumb']!,
      );

  String get location => GoRouteData.$location(
        '/chatMessage/${Uri.encodeComponent(toUuid)}/${Uri.encodeComponent(nickName)}/${Uri.encodeComponent(thumb)}',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $mineFollowingRoute => GoRouteData.$route(
      path: '/mineFollowing',
      parentNavigatorKey: MineFollowingRoute.$parentNavigatorKey,
      factory: $MineFollowingRouteExtension._fromState,
    );

extension $MineFollowingRouteExtension on MineFollowingRoute {
  static MineFollowingRoute _fromState(GoRouterState state) =>
      const MineFollowingRoute();

  String get location => GoRouteData.$location(
        '/mineFollowing',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $originalEnterRoute => GoRouteData.$route(
      path: '/originalEnter',
      parentNavigatorKey: OriginalEnterRoute.$parentNavigatorKey,
      factory: $OriginalEnterRouteExtension._fromState,
    );

extension $OriginalEnterRouteExtension on OriginalEnterRoute {
  static OriginalEnterRoute _fromState(GoRouterState state) =>
      const OriginalEnterRoute();

  String get location => GoRouteData.$location(
        '/originalEnter',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $communityTagDetailRoute => GoRouteData.$route(
      path: '/communityTagDetail/:id',
      parentNavigatorKey: CommunityTagDetailRoute.$parentNavigatorKey,
      factory: $CommunityTagDetailRouteExtension._fromState,
    );

extension $CommunityTagDetailRouteExtension on CommunityTagDetailRoute {
  static CommunityTagDetailRoute _fromState(GoRouterState state) =>
      CommunityTagDetailRoute(
        state.pathParameters['id']!,
      );

  String get location => GoRouteData.$location(
        '/communityTagDetail/${Uri.encodeComponent(id)}',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $mineBuyRoute => GoRouteData.$route(
      path: '/mineBuy',
      parentNavigatorKey: MineBuyRoute.$parentNavigatorKey,
      factory: $MineBuyRouteExtension._fromState,
    );

extension $MineBuyRouteExtension on MineBuyRoute {
  static MineBuyRoute _fromState(GoRouterState state) => const MineBuyRoute();

  String get location => GoRouteData.$location(
        '/mineBuy',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $videoDetailRoute => GoRouteData.$route(
      path: '/videoDetail',
      parentNavigatorKey: VideoDetailRoute.$parentNavigatorKey,
      factory: $VideoDetailRouteExtension._fromState,
    );

extension $VideoDetailRouteExtension on VideoDetailRoute {
  static VideoDetailRoute _fromState(GoRouterState state) => VideoDetailRoute(
        state.extra as String,
      );

  String get location => GoRouteData.$location(
        '/videoDetail',
      );

  void go(BuildContext context) => context.go(location, extra: $extra);

  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: $extra);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: $extra);

  void replace(BuildContext context) =>
      context.replace(location, extra: $extra);
}

RouteBase get $mineDownloadRoute => GoRouteData.$route(
      path: '/mineDownload',
      parentNavigatorKey: MineDownloadRoute.$parentNavigatorKey,
      factory: $MineDownloadRouteExtension._fromState,
    );

extension $MineDownloadRouteExtension on MineDownloadRoute {
  static MineDownloadRoute _fromState(GoRouterState state) =>
      const MineDownloadRoute();

  String get location => GoRouteData.$location(
        '/mineDownload',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $mineFillCodeRoute => GoRouteData.$route(
      path: '/mineFillCode/:title',
      parentNavigatorKey: MineFillCodeRoute.$parentNavigatorKey,
      factory: $MineFillCodeRouteExtension._fromState,
    );

extension $MineFillCodeRouteExtension on MineFillCodeRoute {
  static MineFillCodeRoute _fromState(GoRouterState state) => MineFillCodeRoute(
        state.pathParameters['title']!,
      );

  String get location => GoRouteData.$location(
        '/mineFillCode/${Uri.encodeComponent(title)}',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $mineHelpRoute => GoRouteData.$route(
      path: '/mineHelp',
      parentNavigatorKey: MineHelpRoute.$parentNavigatorKey,
      factory: $MineHelpRouteExtension._fromState,
    );

extension $MineHelpRouteExtension on MineHelpRoute {
  static MineHelpRoute _fromState(GoRouterState state) => const MineHelpRoute();

  String get location => GoRouteData.$location(
        '/mineHelp',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $mineOfficialGroupRoute => GoRouteData.$route(
      path: '/mineOfficialGroup',
      parentNavigatorKey: MineOfficialGroupRoute.$parentNavigatorKey,
      factory: $MineOfficialGroupRouteExtension._fromState,
    );

extension $MineOfficialGroupRouteExtension on MineOfficialGroupRoute {
  static MineOfficialGroupRoute _fromState(GoRouterState state) =>
      const MineOfficialGroupRoute();

  String get location => GoRouteData.$location(
        '/mineOfficialGroup',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $searchRoute => GoRouteData.$route(
      path: '/search',
      parentNavigatorKey: SearchRoute.$parentNavigatorKey,
      factory: $SearchRouteExtension._fromState,
    );

extension $SearchRouteExtension on SearchRoute {
  static SearchRoute _fromState(GoRouterState state) => const SearchRoute();

  String get location => GoRouteData.$location(
        '/search',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $searchResultRoute => GoRouteData.$route(
      path: '/searchResult/:title',
      parentNavigatorKey: SearchResultRoute.$parentNavigatorKey,
      factory: $SearchResultRouteExtension._fromState,
    );

extension $SearchResultRouteExtension on SearchResultRoute {
  static SearchResultRoute _fromState(GoRouterState state) => SearchResultRoute(
        state.pathParameters['title']!,
      );

  String get location => GoRouteData.$location(
        '/searchResult/${Uri.encodeComponent(title)}',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $moreVideoRoute => GoRouteData.$route(
      path: '/moreVideo/:name/:id',
      parentNavigatorKey: MoreVideoRoute.$parentNavigatorKey,
      factory: $MoreVideoRouteExtension._fromState,
    );

extension $MoreVideoRouteExtension on MoreVideoRoute {
  static MoreVideoRoute _fromState(GoRouterState state) => MoreVideoRoute(
        name: state.pathParameters['name']!,
        id: state.pathParameters['id']!,
      );

  String get location => GoRouteData.$location(
        '/moreVideo/${Uri.encodeComponent(name)}/${Uri.encodeComponent(id)}',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $messageCenterRoute => GoRouteData.$route(
      path: '/mineMessageCenter',
      parentNavigatorKey: MessageCenterRoute.$parentNavigatorKey,
      factory: $MessageCenterRouteExtension._fromState,
    );

extension $MessageCenterRouteExtension on MessageCenterRoute {
  static MessageCenterRoute _fromState(GoRouterState state) =>
      const MessageCenterRoute();

  String get location => GoRouteData.$location(
        '/mineMessageCenter',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $systemMessageRoute => GoRouteData.$route(
      path: '/mineSystemMessage',
      parentNavigatorKey: SystemMessageRoute.$parentNavigatorKey,
      factory: $SystemMessageRouteExtension._fromState,
    );

extension $SystemMessageRouteExtension on SystemMessageRoute {
  static SystemMessageRoute _fromState(GoRouterState state) =>
      const SystemMessageRoute();

  String get location => GoRouteData.$location(
        '/mineSystemMessage',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $mediaViewerRoute => GoRouteData.$route(
      path: '/mediaViewer',
      parentNavigatorKey: MediaViewerRoute.$parentNavigatorKey,
      factory: $MediaViewerRouteExtension._fromState,
    );

extension $MediaViewerRouteExtension on MediaViewerRoute {
  static MediaViewerRoute _fromState(GoRouterState state) => MediaViewerRoute(
        state.extra as Map<dynamic, dynamic>,
      );

  String get location => GoRouteData.$location(
        '/mediaViewer',
      );

  void go(BuildContext context) => context.go(location, extra: $extra);

  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: $extra);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: $extra);

  void replace(BuildContext context) =>
      context.replace(location, extra: $extra);
}

RouteBase get $localVideoRoute => GoRouteData.$route(
      path: '/localVideo',
      parentNavigatorKey: LocalVideoRoute.$parentNavigatorKey,
      factory: $LocalVideoRouteExtension._fromState,
    );

extension $LocalVideoRouteExtension on LocalVideoRoute {
  static LocalVideoRoute _fromState(GoRouterState state) => LocalVideoRoute(
        state.extra as VideoData,
      );

  String get location => GoRouteData.$location(
        '/localVideo',
      );

  void go(BuildContext context) => context.go(location, extra: $extra);

  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: $extra);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: $extra);

  void replace(BuildContext context) =>
      context.replace(location, extra: $extra);
}

RouteBase get $homeAIRoute => GoRouteData.$route(
      path: '/ai',
      parentNavigatorKey: HomeAIRoute.$parentNavigatorKey,
      factory: $HomeAIRouteExtension._fromState,
    );

extension $HomeAIRouteExtension on HomeAIRoute {
  static HomeAIRoute _fromState(GoRouterState state) => const HomeAIRoute();

  String get location => GoRouteData.$location(
        '/ai',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}
