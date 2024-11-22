import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:utils/utils.dart';

import 'data_layer/repo/repo.dart';
import 'domain/domain.dart';
import 'domain/remote_domain/domains/ai.dart';
import 'domain/remote_domain/domains/comic.dart';
import 'domain/remote_domain/domains/index.dart';
import 'domain/remote_domain/domains/live.dart';
import 'domain/remote_domain/domains/monitor.dart';
import 'domain/remote_domain/domains/novel.dart';
import 'domain/remote_domain/domains/rank.dart';
import 'logger.dart';
import 'ui_layer/notifiers/chat_notifier.dart';
import 'ui_layer/notifiers/home_config_notifier.dart';
import 'ui_layer/notifiers/user_notifier.dart';
import 'ui_layer/router/router.dart';
import 'ui_layer/screens/theme.dart';
import 'ui_layer/utils/common_utils.dart';
import 'ui_layer/utils/download_utils.dart';

void main() async {
  /// 初始化仓库，必须放在最前面
  final appRepo = AppRepo();
  await appRepo.init();
  disableUrlStrategy();

  /// 初始化多语系
  await EasyLocalization.ensureInitialized();

  /// 强制竖屏
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  /// 设置屏幕状态栏、导航列底色
  CommonUtils.setStatusBar(isLight: true);

  runApp(
    MultiProvider(
      providers: [
        Provider<AppDomain>.value(value: appRepo),
        Provider<CacheDomain>.value(value: appRepo.cache),
        Provider<HomeDomain>.value(value: appRepo),
        Provider<UserDomain>.value(value: appRepo),
        Provider<ElementDomain>.value(value: appRepo),
        Provider<DynamicDomain>.value(value: appRepo),
        Provider<CommunityDomain>.value(value: appRepo),
        Provider<GirlDomain>.value(value: appRepo),
        Provider<ChatDomain>.value(value: appRepo),
        Provider<SeedDomain>.value(value: appRepo),
        Provider<OrderDomain>.value(value: appRepo),
        Provider<SignDomain>.value(value: appRepo),
        Provider<AccountDomain>.value(value: appRepo),
        Provider<ProxyDomain>.value(value: appRepo),
        Provider<WithdrawDomain>.value(value: appRepo),
        Provider<SearchDomain>.value(value: appRepo),
        Provider<MvDomain>.value(value: appRepo),
        Provider<MessageDomain>.value(value: appRepo),
        Provider<PrivilegeDomain>.value(value: appRepo),
        Provider<AIDomain>.value(value: appRepo),
        Provider<LiveDomain>.value(value: appRepo),
        Provider<MonitorDomain>.value(value: appRepo),
        Provider<ComicDomain>.value(value: appRepo),
        Provider<NovelDomain>.value(value: appRepo),
        Provider<IndexDomain>.value(value: appRepo),
        Provider<RankDomain>.value(value: appRepo),
        Provider<DownloadUtil>(
          lazy: false,
          create: (_) => DownloadUtil(cache: appRepo.cache),
        ),
        ChangeNotifierProvider(create: (_) => HomeConfigNotifier(appRepo)),
        ChangeNotifierProvider(create: (_) => UserNotifier(appRepo)),
        ChangeNotifierProxyProvider<UserNotifier, ChatNotifier?>(
          lazy: false,
          update: (context, value, previous) {
            if (!value.isInit) {
              return null;
            }

            return previous?.member.uuid == value.member.uuid
                ? previous!
                : ChatNotifier(
                    cache: appRepo.cache,
                    member: value.member,
                    oauthType: appRepo.getOAuthType(),
                    oauthId: appRepo.getOAuthId(),
                  );
          },
          create: (_) => null,
        ),
      ],
      child: EasyLocalization(
        supportedLocales: const [Locale('zh', 'CN')],
        fallbackLocale: const Locale('zh', 'CN'),
        path: 'assets/translations',
        child: ScreenUtilInit(
          designSize: const Size(375, 667),
          child: const MyApp(),
          builder: (_, child) => child!,
        ),
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    final botToastBuilder = BotToastInit();

    logger.e('123');
    return MaterialApp.router(
      routerConfig: AppRouter.router,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      onGenerateTitle: (context) => 'yybt'.tr(context: context),
      theme: ThemeData(
        primaryColor: MyTheme.bgColor,
        progressIndicatorTheme: const ProgressIndicatorThemeData(
            color: MyTheme.jellyCyanColor103224185),
        splashColor: Colors.transparent,
        scaffoldBackgroundColor: MyTheme.bgColor,
        highlightColor: Colors.transparent,
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: MyTheme.cyanColor00edfd,
          selectionColor: MyTheme.cyanColor00edfd.withOpacity(0.5),
          selectionHandleColor: MyTheme.cyanColor00edfd,
        ),
        inputDecorationTheme: InputDecorationTheme(
          disabledBorder: MyTheme.inputBorder,
          focusedBorder: MyTheme.inputBorder,
          enabledBorder: MyTheme.inputBorder,
          border: MyTheme.inputBorder,
          isDense: true,
          contentPadding: EdgeInsets.symmetric(horizontal: 8.w),
        ),
        primarySwatch: const MaterialColor(
          0xFF000000, //改了不好看
          <int, Color>{
            50: Color(0xFF000000),
            100: Color(0xFF000000),
            200: Color(0xFF000000),
            300: Color(0xFF000000),
            400: Color(0xFF000000),
            500: Color(0xFF000000),
            600: Color(0xFF000000),
            700: Color(0xFF000000),
            800: Color(0xFF000000),
            900: Color(0xFF000000),
          },
        ),
      ),
      builder: (context, widget) {
        widget = botToastBuilder(context, widget!);
        widget = MediaQuery(
          //设置文字大小不随系统设置改变
          data: MediaQuery.of(context)
              .copyWith(textScaler: const TextScaler.linear(1.0)),
          child: widget,
        );
        return widget;
      },
      scrollBehavior: ScrollConfiguration.of(context).copyWith(
        physics: const BouncingScrollPhysics(),
      ),
    );
  }
}
