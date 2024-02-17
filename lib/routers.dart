import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:qypj/pages/community/community_post_bit_detail.dart';
import 'package:qypj/pages/community/community_seltag_page.dart';
import 'package:qypj/pages/mine/collect_page.dart';
import 'package:qypj/pages/mine/imtochat_page.dart';
import 'package:qypj/pages/mine/mine_post_page.dart';
import 'package:qypj/pages/mine/original_enter.dart';
import 'package:qypj/pages/welfare/welfare_page.dart';
import 'package:qypj/pages/welfare/welfare_task_alone_page.dart';
import 'package:go_router/go_router.dart';
import 'package:qypj/acg_page/category/home_category_page.dart';
import 'package:qypj/acg_page/home/home_comic_choose_chapter_download_page.dart';
import 'package:qypj/acg_page/home/home_comic_download_page.dart';
import 'package:qypj/acg_page/home/home_comic_info_page.dart';
import 'package:qypj/acg_page/home/home_more_and_more_page.dart';
import 'package:qypj/acg_page/home/home_recently_updated_page.dart';
import 'package:qypj/acg_page/home/home_sign_page.dart';
import 'package:qypj/acg_page/home/home_video_collect_page.dart';
import 'package:qypj/page/action_trailer_story.dart';
import 'package:qypj/page/ktload_webview.dart';
import 'package:qypj/page/local_video_detail.dart';
import 'package:qypj/page/more_and_more_carton.dart';
import 'package:qypj/page/more_and_more_png.dart';
import 'package:qypj/page/more_and_more_normal.dart';
import 'package:qypj/page/more_and_more_nvel.dart';
import 'package:qypj/pages/community/community_issue.dart';
import 'package:qypj/pages/community/community_post_detail.dart';
import 'package:qypj/pages/community/community_tag_detail.dart';
import 'package:qypj/pages/community/community_tags_all.dart';
import 'package:qypj/pages/mine/agent/mine_agent_apply_page.dart';
import 'package:qypj/pages/mine/agent/mine_agent_bankcard_list_page.dart';
import 'package:qypj/pages/mine/agent/mine_agent_cash_record_page.dart';
import 'package:qypj/pages/mine/agent/mine_agent_invite_record_page.dart';
import 'package:qypj/pages/mine/agent/mine_agent_page.dart';
import 'package:qypj/pages/mine/agent/mine_agent_profit_list_page.dart';
import 'package:qypj/pages/mine/agent/mine_agent_promotedata_page.dart';
import 'package:qypj/pages/mine/agent/mine_agent_rule_page.dart';
import 'package:qypj/pages/mine/agent/mine_agent_tocash_page.dart';
import 'package:qypj/pages/mine/buy_page.dart';
import 'package:qypj/pages/mine/mine_creater_apply.dart';
import 'package:qypj/pages/mine/mine_creater_center.dart';
import 'package:qypj/pages/mine/fans_follow_index.dart';
import 'package:qypj/pages/mine/mine_creater_collect.dart';
import 'package:qypj/pages/mine/mine_creater_collect_detail.dart';
import 'package:qypj/pages/mine/mine_creater_collect_rate.dart';
import 'package:qypj/pages/mine/mine_creater_issue.dart';
import 'package:qypj/pages/mine/mine_creater_issue_rule.dart';
import 'package:qypj/pages/mine/mine_ncome_detailed.dart';
import 'package:qypj/pages/mine/mine_post_status.dart';
import 'package:qypj/pages/mine/mine_user_center_episode.dart';
import 'package:qypj/pages/rank/rank.dart';
import 'package:qypj/pages/search_main_page.dart';
import 'package:qypj/pages/search_result_page.dart';
import 'package:qypj/pages/community/pic_view_page.dart';
import 'package:qypj/utils/app_route_observer.dart';
import 'package:qypj/global.dart';
import 'package:qypj/pages/details/atlas_detail.dart';
import 'package:qypj/pages/details/atlas_list.dart';
import 'package:qypj/pages/details/video_detail.dart';
import 'package:qypj/pages/login/index.dart';
import 'package:qypj/pages/mine/down_page.dart';
import 'package:qypj/pages/mine/fill_code.dart';
import 'package:qypj/pages/mine/invite_recored.dart';
import 'package:qypj/pages/mine/message_center.dart';
import 'package:qypj/pages/mine/notice_message.dart';
import 'package:qypj/page/kwantsharetousers.dart';
import 'package:qypj/pages/mine/vip_page.dart';
import 'package:qypj/pages/mine/app_center.dart';
import 'package:qypj/pages/mine/coinrecharge.dart';
import 'package:qypj/pages/mine/coin_detail.dart';
import 'package:qypj/pages/mine/contact_official.dart';
import 'package:qypj/pages/mine/customer_service.dart';
import 'package:qypj/pages/mine/online_service.dart';
import 'package:qypj/pages/mine/recharg_record.dart';
import 'package:qypj/pages/mine/setup.dart';
import 'package:qypj/pages/welcome.dart';
import 'package:qypj/pages/mine/invite_friends.dart';
import 'package:qypj/utils/common.dart';
import 'package:qypj/utils/index.dart';
import 'package:qypj/pages/mine/mine_user_center.dart';
import 'package:universal_html/html.dart';

class Routes {
  static String mineUserCenter = 'mineUserCenter/:aff';
  static String rank = 'rank/:type/:time';
  static String category = 'category'; // 分类
  static String ranklist = 'ranklist'; // 排行榜
  static String recentlyupdate = 'recentlyupdate'; // 最近更新
  static String kwantsharetousers = 'kwantsharetousers'; // 去推广
  static String vip = 'vip'; //会员充值页面

  static String search = 'search';
  static String searchResult = 'searchResult/:title';
  static String sign = 'sign';

  static String secondlist = "list/:id/:title/:morePageType";
  static String shangmenPage = 'shangmenPage'; //官方认证上门=》更多
  static String luoliaoPage = 'luoliaoPage'; //真是裸聊=》更多

  static String login = 'login/:type'; //登录
  static String setup = 'setup'; //设置
  static String fillcode = 'fillcode'; //填写邀请码兑换码

  static String collect = 'collect'; //我的收藏
  static String buy = 'buy'; //购买记录
  static String down = 'down'; //下载缓存
  static String fansfollow = 'fansfollow'; //粉丝关注界面

  static String coinRecharge = 'coinRecharge'; //扣币充值
  static String rechargeRecord = 'RechargeRecord/:type'; //充值记录
  static String coinDetail = 'coinDetail'; //扣币明细
  static String onlineService = 'onlineService'; //在线客服
  static String contactOfficial = 'contactOfficial'; //联系官方
  static String appCenter = 'appCenter'; //应用推荐

  static String invitefriend = 'invitefriend'; // 邀请好友
  static String inviterecored = 'inviterecored'; // 邀请记录

  static String messagecenter = 'messagecenter'; // 消息中心
  static String noticemessage = 'noticemessage'; // 系统消息
  static String customerService = 'customerService'; //客服

  static String shangmenDetail = 'shangmenDetail/:id'; //上门详情
  static String luoliaoDetail = 'luoliaoDetail/:id'; //裸聊详情
  static String luoliaoConnect = 'luoliaoConnect/:orderid'; //裸聊妹妹联系方式
  static String atlasDetail = 'atlasDetail/:id'; //图集详情
  static String atlasList = 'atlasList/:index'; //图集列表展示
  static String audiobookDetail = 'audiobookDetail/:id'; //有声小说详情
  static String novelDetail = 'novelDetail/:id'; //小说详情
  static String novelReader = 'novelReader/:id'; //小说阅读器
  static String videoDetail = 'videoDetail/:id'; //长视频详情页
  static String localVideoDetail = 'localVideoDetail/:videoInfo'; //长视频本地详情页
  static String comicsdetail = 'comicsdetail/:id'; // 漫画详情
  static String comicChooseDownload = 'comicChooseDownload'; // 漫画下载
  static String comicDownloadStatusPage = 'comicDownloadStatusPage'; // 漫画进度查看页

  static String comicReader = 'comicReader/:id/:episode/:title'; // 漫画阅读器
  static String smallvideodetail = 'smallvideodetail/:id'; //小视频详情页
  static String topicsmallvideodetail = 'topicsmallvideodetail/:id'; //合集小视频详情页
  static String moreandmorecollect = 'more_and_more_collect/:id/:mv_type';
  static String moreandmorenormal = 'more_and_more_normal/:id';
  static String moreandmorecase = 'more_and_more_case/:id';
  static String moreandmorecomc = 'more_and_more_comc/:id';
  static String moreandmorenvel = 'more_and_more_nvel/:sort/:type/:categories';
  static String moreandmorepng = 'more_and_more_png/:id';
  static String moreandmorecarton = 'more_and_more_carton/:id';
  static String moreandmorepage = 'more_and_more_page'; // 点击更多进这个
  static String actiontrailerstory = 'actiontrailerstory'; //海报
  static String webview = 'ktloadwebview'; //H5

  static String nakedchatDetailPage = 'nakedchatDetailPage/:id'; //裸聊详情页
  static String nakedchatReservePage = 'nakedchatReservePage'; //裸聊预约页
  static String ncmanage = 'ncmanage'; // 裸聊管理
  static String nakedchatToCashPage = 'nakedchatToCashPage/:isbance'; // 裸聊管理的体现

  static String bameiAcademicPage = 'bameiAcademicPage/:id'; // pua学院页
  static String bameiLessonPage = 'bameiLessonPage/:id';

  static String picViewPage = 'picViewPage';
  static String yuemeiDetailPage = 'yuemeiDetailPage/:id';
  static String yuemeiSellerPage = 'yuemeiSellerPage/:id';
  static String yuemeiFilterCityPage = 'yuemeiFilterCityPage'; // 约妹 选择城市
  static String yuemeiCityPage = 'yuemeiCityPage'; // 约妹 选择城市
  static String yuemeiSellerListPage = 'yuemeiSellerListPage'; // 约妹 商家列表
  static String ymmanage = 'ymmanage'; // 约妹 商家管理
  static String yuemeiSellerEditMeiziPage =
      'yuemeiSellerEditMeiziPage'; // 约妹 商家 编辑/发布 妹子信息
  static String yuemeiSellerProflieEditPage =
      'yuemeiSellerProflieEditPage'; // 约妹 商家 编辑 信息
  static String yuemeiSellerChooseCityPage =
      'yuemeiSellerChooseCityPage'; // 约妹 商家 选择城市
  static String yuemeiSellerMeiziChooseCityPage =
      'yuemeiSellerMeiziChooseCityPage'; // 约妹 商家 发布妹子信息 选择城市

  static String mineAgentPage = 'mineAgentPage'; // 代理赚钱
  static String mineAgentToCashPage = 'mineAgentToCashPage/:isbance';
  static String mineAgentBankcardListPage =
      'mineAgentBankcardListPage'; // 银行卡列表

  static String mineAgentCashRecordPage = 'mineAgentCashRecordPage'; // 代理 提现记录
  static String mineAgentInviteRecordPage =
      'mineAgentInviteRecordPage'; // 代理 邀请记录

  static String mineAgentApplyPage = 'mineAgentApplyPage'; // 代理申请
  static String mineAgentRulePage = 'mineAgentRulePage'; // 代理规则

  static String mineAgentProfitListPage =
      'mineAgentProfitListPage'; // 收益明细 业绩明细
  static String mineAgentPromoteDataPage =
      'mineAgentPromoteDataPage'; // 代理 推广数据

  static String mineOrderPage = 'mineOrderPage'; // 我的订单
  static String mineOrderPublishReportPage =
      'mineOrderPublishReportPage/:id'; // 发布验车报告
  static String mineOrderPublishNakedchatReportPage =
      'mineOrderPublishNakedchatReportPage/:id'; // 发布裸聊评价

  static String servicetimetochat = 'servicetimetochat'; //IM

  static String communityissue = 'communityissue/:type/:circle'; //社区发布
  static String communitytagdetail = 'communitytagdetail/:topic_id'; //话题详情
  static String communitytagsall = 'communitytagsall/:type'; //全部标签
  static String communitypostdetail = 'communitypostdetail/:id'; //帖子详情
  static String minecreaterapply = 'minecreaterapply'; //申请创作者
  static String minecreatercenter = 'minecreatercenter'; //创作中心
  static String minecreatercollect = 'minecreatercollect'; //创建合集
  static String minecreatercollectdetail =
      'minecreatercollectdetail/:id'; //合集详情
  static String minecreaterissue = 'minecreaterissue/:id'; //视频发布
  static String minecreaterissuerule = 'minecreaterissuerule'; //发布规则
  static String minecreatercollectrate = 'minecreatercollectrate/:id'; //视频收益详情
  static String minepoststatus = 'minepoststatus'; //我的帖子
  static String mineusercenterepisode = 'mineusercenterepisode/:aff'; //剧集列表
  static String minencomedetailed = 'minencomedetailed'; //收益明细

  static String welfaretaskpage = 'welfaretaskpage'; //福利任务
  static String communityseltagpage = 'communityseltagpage/:id/:type'; //选择帖子板块
  static String minepostpage = 'minepostpage'; //我的帖子
  static String originalenter = 'originalenter'; //申请入驻
  static String picview = 'picview'; //预览图片
  static String imtochatpage = 'imtochatpage/:touid/:nick/:thumb'; //私信

  static String communitypostbitdetail = 'communitypostbitdetail/:id'; //种子帖子详情

  static String welfarepage = 'welfarePage'; //福利

  static List<GoRoute> getDetailRoutes() {
    return [
      GoRoute(
        path: communityseltagpage,
        builder: (context, state) => CommunitySeltagPage(
          id: int.parse(state.params['id'] ?? "0"),
          type: int.parse(state.params['type'] ?? "0"),
        ),
      ),
      GoRoute(
        path: picview,
        builder: (context, state) => PicViewPage(pramas: AppGlobal.picMap),
      ),
      GoRoute(
        path: minencomedetailed,
        builder: (context, state) => MineNcomeDetailed(),
      ),
      GoRoute(
        path: coinDetail,
        builder: (context, state) => CoinDetail(),
      ),
      GoRoute(
        path: mineusercenterepisode,
        builder: (context, state) {
          return MineUserCenterEpisode(
            aff: state.params['aff'],
          );
        },
      ),
      GoRoute(
          path: minecreatercollectdetail,
          builder: (context, state) {
            return MineCreaterCollectDetail(
              id: state.params["id"] == null
                  ? "0"
                  : state.params["id"].toString(),
            );
          },
          routes: [
            GoRoute(
                path: minecreatercollectrate,
                builder: (context, state) {
                  return MineCreaterCollectRate(
                    id: state.params["id"] == null
                        ? "0"
                        : state.params["id"].toString(),
                  );
                }),
            GoRoute(
              path: minecreaterissue,
              builder: (context, state) {
                return MineCreaterIssue(
                  id: state.params["id"] == null
                      ? "0"
                      : state.params["id"].toString(),
                );
              },
              routes: [
                GoRoute(
                    path: minecreaterissuerule,
                    builder: (context, state) {
                      return MineCreaterIssueRule();
                    }),
                GoRoute(
                  path: communityseltagpage,
                  builder: (context, state) => CommunitySeltagPage(
                    id: int.parse(state.params['id'] ?? "0"),
                    type: int.parse(state.params['type'] ?? "0"),
                  ),
                ),
              ],
            )
          ]),
      GoRoute(
        path: moreandmorecollect,
        builder: (context, state) {
          return HomeVideoCollectPage(
            id: state.params["id"] == null
                ? "0"
                : state.params["id"].toString(),
          );
        },
        routes: [
          GoRoute(
            path: videoDetail,
            builder: (context, state) {
              return VideoDetail(
                id: state.params == null || state.params['id'] == null
                    ? null
                    : int.parse(state.params['id'].toString()),
              );
            },
            routes: [
              GoRoute(
                path: kwantsharetousers,
                builder: (context, state) => KWantShareToUsers(),
              ),
              GoRoute(
                path: welfaretaskpage,
                builder: (context, state) => WelfareTaskAlonePage(),
              ),
            ],
          )
        ],
      ),
      GoRoute(
        path: minecreatercollect,
        builder: (context, state) {
          return MineCreaterCollect();
        },
      ),
      GoRoute(
          path: moreandmorepng,
          builder: (context, state) {
            return MoreAndMorePNG(
                id: state.params["id"] == null
                    ? "0"
                    : state.params["id"].toString());
          },
          routes: [
            GoRoute(
                path: atlasDetail,
                builder: (context, state) {
                  return AtlasDetail(
                      id: state.params == null || state.params['id'] == null
                          ? null
                          : int.parse(state.params['id'].toString()));
                },
                routes: [
                  GoRoute(
                    path: atlasList,
                    builder: (context, state) {
                      final args = AppGlobal.currentReaderRouteExtra;
                      return AtilasList(pramas: args);
                    },
                  ),
                  GoRoute(
                    path: kwantsharetousers,
                    builder: (context, state) => KWantShareToUsers(),
                  )
                ])
          ]),
      GoRoute(
        path: moreandmorenormal,
        builder: (context, state) {
          return MoreAndMoreNormal(
              id: state.params["id"] == null
                  ? "0"
                  : state.params["id"].toString());
        },
        routes: [
          GoRoute(
            path: videoDetail,
            builder: (context, state) {
              return VideoDetail(
                id: state.params == null || state.params['id'] == null
                    ? null
                    : int.parse(state.params['id'].toString()),
              );
            },
            routes: [
              GoRoute(
                path: kwantsharetousers,
                builder: (context, state) => KWantShareToUsers(),
              )
            ],
          )
        ],
      ),
      GoRoute(
          path: moreandmorepage,
          builder: (context, state) {
            return HomeMoreAndMorePage(
              data: state.extra,
            );
          },
          routes: [
            GoRoute(
                path: atlasDetail,
                builder: (context, state) {
                  return AtlasDetail(
                      id: state.params == null || state.params['id'] == null
                          ? null
                          : int.parse(state.params['id'].toString()));
                },
                routes: [
                  GoRoute(
                    path: atlasList,
                    builder: (context, state) {
                      final args = AppGlobal.currentReaderRouteExtra;
                      return AtilasList(pramas: args);
                    },
                  ),
                  GoRoute(
                    path: kwantsharetousers,
                    builder: (context, state) => KWantShareToUsers(),
                  )
                ]),
            GoRoute(
                path: videoDetail,
                builder: (context, state) {
                  return VideoDetail(
                    id: state.params == null || state.params['id'] == null
                        ? null
                        : int.parse(state.params['id'].toString()),
                  );
                },
                routes: [
                  GoRoute(
                    path: kwantsharetousers,
                    builder: (context, state) => KWantShareToUsers(),
                  ),
                  GoRoute(
                      path: welfaretaskpage,
                      builder: (context, state) => WelfareTaskAlonePage(),
                      routes: [
                        GoRoute(
                          path: kwantsharetousers,
                          builder: (context, state) => KWantShareToUsers(),
                        )
                      ])
                ]),
            GoRoute(
                path: comicsdetail,
                builder: (context, state) {
                  return HomeComicInfoPage(
                      id: state.params == null || state.params['id'] == null
                          ? null
                          : int.parse(state.params['id'].toString()));
                },
                routes: [
                  GoRoute(
                      path: comicChooseDownload,
                      builder: (context, state) =>
                          HomeComicChooseChapterDownloadPage(),
                      routes: [
                        GoRoute(
                          path: comicDownloadStatusPage,
                          builder: (context, state) => HomeComicDownloadPage(),
                        )
                      ]),
                  GoRoute(
                    path: kwantsharetousers,
                    builder: (context, state) => KWantShareToUsers(),
                  )
                ]),
            GoRoute(
              path: kwantsharetousers,
              builder: (context, state) => KWantShareToUsers(),
            )
          ]),
      GoRoute(
          path: moreandmorecomc,
          builder: (context, state) {
            return HomeCategoryPage(
                id: state.params["id"] == null
                    ? "0"
                    : state.params["id"].toString());
          },
          routes: [
            GoRoute(
                path: comicsdetail,
                builder: (context, state) {
                  return HomeComicInfoPage(
                      id: state.params == null || state.params['id'] == null
                          ? null
                          : int.parse(state.params['id'].toString()));
                },
                routes: [
                  GoRoute(
                    path: kwantsharetousers,
                    builder: (context, state) => KWantShareToUsers(),
                  )
                ])
          ]),
      GoRoute(
          path: moreandmorenvel,
          builder: (context, state) {
            return MoreAndMoreNvel(
              sort: state.params["sort"] == null
                  ? "new"
                  : state.params["sort"].toString(),
              type: state.params["type"] == null
                  ? ""
                  : state.params["type"].toString(),
              categories: state.params["categories"] == null
                  ? ""
                  : state.params["categories"].toString(),
            );
          },
          routes: []),
      GoRoute(
        path: moreandmorecarton,
        builder: (context, state) {
          return MoreAndMoreCarton(
              id: state.params["id"] == null
                  ? "0"
                  : state.params["id"].toString());
        },
        routes: [
          GoRoute(
            path: videoDetail,
            builder: (context, state) {
              return VideoDetail(
                id: state.params == null || state.params['id'] == null
                    ? null
                    : int.parse(state.params['id'].toString()),
              );
            },
            routes: [
              GoRoute(
                path: kwantsharetousers,
                builder: (context, state) => KWantShareToUsers(),
              )
            ],
          )
        ],
      ),
      GoRoute(
        path: actiontrailerstory,
        builder: (context, state) {
          return ActionTrailerStory();
        },
      ),
      GoRoute(
        path: picViewPage,
        builder: (context, state) {
          final args = AppGlobal.currentReaderRouteExtra;
          return PicViewPage(pramas: args);
        },
      ),
      GoRoute(
        path: mineAgentPage,
        builder: (context, state) {
          return MineAgentPage();
        },
      ),
      GoRoute(
        path: imtochatpage,
        builder: (context, state) {
          return IMToChatPage(
            touid: state.params["touid"] ?? "0",
            nick: state.params["nick"] ?? "",
            thumb: state.params["thumb"] ?? "",
          );
        },
      ),
      GoRoute(
        path: mineAgentToCashPage,
        builder: (context, state) {
          return MineAgentToCashPage(
            isbance: state.params["isbance"] == null
                ? "0"
                : state.params["isbance"].toString(),
          );
        },
      ),
      GoRoute(
        path: mineAgentBankcardListPage,
        builder: (context, state) {
          return MineAgentBankcardListPage();
        },
      ),
      GoRoute(
        path: mineAgentCashRecordPage,
        builder: (context, state) {
          return MineAgentCashRecordPage();
        },
      ),
      GoRoute(
        path: mineAgentInviteRecordPage,
        builder: (context, state) {
          return MineAgentInviteRecordPage();
        },
      ),
      GoRoute(
        path: customerService,
        builder: (context, state) => CustomerService(),
      ),
      GoRoute(
        path: mineAgentProfitListPage,
        builder: (context, state) {
          return MineAgentProfitListPage();
        },
      ),
      GoRoute(
          path: rechargeRecord,
          builder: (context, state) {
            return RechargeRecord(args: state.params);
          },
          routes: [
            GoRoute(
              path: customerService,
              builder: (context, state) => CustomerService(),
            ),
          ]),
      GoRoute(
        path: mineAgentApplyPage,
        builder: (context, state) {
          return MineAgentApplyPage();
        },
      ),
      GoRoute(
        path: mineAgentRulePage,
        builder: (context, state) {
          return MineAgentRulePage();
        },
      ),
      GoRoute(
        path: mineAgentPromoteDataPage,
        builder: (context, state) {
          return MineAgentPromoteDataPage();
        },
      ),
      GoRoute(
          path: atlasDetail,
          builder: (context, state) {
            return AtlasDetail(
                id: state.params == null || state.params['id'] == null
                    ? null
                    : int.parse(state.params['id'].toString()));
          },
          routes: [
            GoRoute(
              path: atlasList,
              builder: (context, state) {
                final args = AppGlobal.currentReaderRouteExtra;
                return AtilasList(pramas: args);
              },
            ),
            GoRoute(
              path: kwantsharetousers,
              builder: (context, state) => KWantShareToUsers(),
            )
          ]),
      GoRoute(
          path: videoDetail,
          builder: (context, state) {
            return VideoDetail(
              id: state.params == null || state.params['id'] == null
                  ? null
                  : int.parse(state.params['id'].toString()),
            );
          },
          routes: [
            GoRoute(
              path: kwantsharetousers,
              builder: (context, state) => KWantShareToUsers(),
            ),
            GoRoute(
                path: welfaretaskpage,
                builder: (context, state) => WelfareTaskAlonePage(),
                routes: [
                  GoRoute(
                    path: kwantsharetousers,
                    builder: (context, state) => KWantShareToUsers(),
                  )
                ]),
          ]),
      GoRoute(
          path: comicsdetail,
          builder: (context, state) {
            return HomeComicInfoPage(
                id: state.params == null || state.params['id'] == null
                    ? null
                    : int.parse(state.params['id'].toString()));
          },
          routes: [
            GoRoute(
                path: comicChooseDownload,
                builder: (context, state) =>
                    HomeComicChooseChapterDownloadPage(),
                routes: [
                  GoRoute(
                    path: comicDownloadStatusPage,
                    builder: (context, state) => HomeComicDownloadPage(),
                  )
                ]),
            GoRoute(
              path: kwantsharetousers,
              builder: (context, state) => KWantShareToUsers(),
            )
          ]),
      GoRoute(
        path: kwantsharetousers,
        builder: (context, state) => KWantShareToUsers(),
      )
    ];
  }

  static GoRouter init() {
    List<GoRoute> rootRoutes = [
      GoRoute(
        path: welfarepage,
        builder: (context, state) {
          return WelfarePage();
        },
        routes: getDetailRoutes(),
      ),
      GoRoute(
        path: communitypostbitdetail,
        builder: (context, state) {
          return CommunityPostBitDetail(
            id: state.params["id"] == null
                ? "0"
                : state.params["id"].toString(),
          );
        },
        routes: getDetailRoutes(),
      ),
      GoRoute(
          path: minepostpage,
          builder: (context, state) => MinePostPage(),
          routes: getDetailRoutes()),
      GoRoute(
          path: minepoststatus,
          builder: (context, state) => MinePostStatus(),
          routes: getDetailRoutes()),
      GoRoute(
          path: mineUserCenter,
          builder: (context, state) => MineUserCenter(aff: state.params['aff']),
          routes: getDetailRoutes()),
      GoRoute(
        path: minecreatercenter,
        builder: (context, state) {
          return MineCreaterCenter();
        },
        routes: getDetailRoutes(),
      ),
      GoRoute(
        path: minecreaterapply,
        builder: (context, state) {
          return MineCreaterApply();
        },
        routes: getDetailRoutes(),
      ),
      GoRoute(
          path: collect,
          builder: (context, state) => CollectPage(),
          routes: getDetailRoutes()),
      GoRoute(
        path: communitypostdetail,
        builder: (context, state) {
          return CommunityPostDetail(
            id: state.params["id"] == null
                ? "0"
                : state.params["id"].toString(),
          );
        },
        routes: getDetailRoutes(),
      ),
      GoRoute(
        path: communitytagsall,
        builder: (context, state) {
          return CommunityTagsAll(
            type: int.parse(state.params["type"].toString()),
          );
        },
        routes: getDetailRoutes(),
      ),
      GoRoute(
        path: communityissue,
        builder: (context, state) {
          return CommunityIssue(
            type: state.params["type"] == null
                ? 0
                : int.parse(state.params["type"].toString()),
            circle: state.params["circle"] == null
                ? 0
                : int.parse(state.params["circle"].toString()),
          );
        },
        routes: getDetailRoutes(),
      ),
      GoRoute(
        path: communitytagdetail,
        builder: (context, state) {
          return CommunityTagDetail(
            topic_id: state.params["topic_id"] == null
                ? "0"
                : state.params["topic_id"].toString(),
          );
        },
        routes: getDetailRoutes(),
      ),
      GoRoute(
        path: webview,
        builder: (context, state) {
          return KtLoadWebview();
        },
        routes: getDetailRoutes(),
      ),
      GoRoute(
          path: ranklist,
          builder: (context, state) => Builder(builder: (context) {
                return RankPage();
              }),
          routes: getDetailRoutes()),
      GoRoute(
          path: search,
          builder: (context, state) => SearchMainPage(),
          routes: getDetailRoutes()),
      GoRoute(
          path: searchResult,
          builder: (context, state) => Builder(builder: (context) {
                return SearchResultPage(
                  title: state.params['title'],
                );
              }),
          routes: getDetailRoutes()),
      GoRoute(
          path: category,
          builder: (context, state) {
            return HomeCategoryPage(id: "0");
          },
          routes: getDetailRoutes()),
      GoRoute(
          path: recentlyupdate,
          builder: (context, state) {
            return HomeRecentlyUpdatedPage();
          },
          routes: getDetailRoutes()),
      GoRoute(
          path: sign,
          builder: (context, state) => HomeSignPage(),
          routes: getDetailRoutes()),
      GoRoute(
        path: fansfollow,
        builder: (context, state) => FansFollowIndex(),
        routes: [],
      ),
      GoRoute(
          path: coinRecharge,
          builder: (context, state) => CoinRecharge(),
          routes: [
            GoRoute(
                path: rechargeRecord,
                builder: (context, state) {
                  return RechargeRecord(args: state.params);
                },
                routes: [
                  GoRoute(
                    path: customerService,
                    builder: (context, state) => CustomerService(),
                  ),
                ]),
            GoRoute(
              path: coinDetail,
              builder: (context, state) => CoinDetail(),
            ),
            GoRoute(
              path: customerService,
              builder: (context, state) => CustomerService(),
            )
          ]),
      GoRoute(path: vip, builder: (context, state) => VipPage(), routes: [
        GoRoute(
            path: rechargeRecord,
            builder: (context, state) {
              return RechargeRecord(args: state.params);
            },
            routes: [
              GoRoute(
                path: customerService,
                builder: (context, state) => CustomerService(),
              ),
            ]),
        GoRoute(
          path: customerService,
          builder: (context, state) => CustomerService(),
        ),
      ]),
      GoRoute(
        path: appCenter,
        builder: (context, state) => AppCenter(),
      ),
      GoRoute(
          path: onlineService,
          builder: (context, state) => OnlineService(),
          routes: [
            GoRoute(
              path: customerService,
              builder: (context, state) => CustomerService(),
            ),
          ]),
      GoRoute(
        path: contactOfficial,
        builder: (context, state) => ContactOfficial(),
      ),
      GoRoute(
        path: setup,
        builder: (context, state) => SetupPage(),
        routes: [
          GoRoute(
            path: fillcode,
            builder: (context, state) {
              final args = state.extra as Map<String, dynamic>;
              return FillCodePage(args: args);
            },
          ),
        ],
      ),
      GoRoute(
        path: fillcode,
        builder: (context, state) {
          final args = state.extra as Map<String, dynamic>;
          return FillCodePage(args: args);
        },
      ),
      GoRoute(
        path: originalenter,
        builder: (context, state) {
          return OriginalEnter();
        },
      ),
      GoRoute(
        path: down,
        builder: (context, state) => DownPage(),
        routes: [
          GoRoute(
            path: localVideoDetail,
            builder: (context, state) {
              final args = state.extra as Map<String, dynamic>;
              return LocalVideoDetail(
                videoInfo: args == null || args['videoInfo'] == null
                    ? null
                    : args['videoInfo'],
              );
            },
          ),
        ],
      ),
      GoRoute(
        path: buy,
        builder: (context, state) => BuyPage(),
        routes: getDetailRoutes(),
      ),
      GoRoute(
        path: login,
        builder: (context, state) {
          final args = state.extra as Map<String, dynamic>;
          return LoginPage(
              type: args == null || args['type'] == null
                  ? 0
                  : int.parse(args['type'].toString()));
        },
      ),
      GoRoute(
          path: invitefriend,
          builder: (context, state) => InviteFriend(),
          routes: [
            GoRoute(
              path: kwantsharetousers,
              builder: (context, state) => KWantShareToUsers(),
            ),
            GoRoute(
              path: inviterecored,
              builder: (context, state) => InviteRecored(),
            ),
          ]),
      GoRoute(
        path: messagecenter,
        builder: (context, state) => MessageCenter(),
        routes: [
          GoRoute(
            path: noticemessage,
            builder: (context, state) {
              final args = state.extra as Map<String, dynamic>;
              return NoticeMessage(args: args);
            },
          ),
          GoRoute(
            path: customerService,
            builder: (context, state) => CustomerService(),
          ),
        ],
      ),
      GoRoute(
        path: noticemessage,
        builder: (context, state) {
          final args = state.extra as Map<String, dynamic>;
          return NoticeMessage(args: args);
        },
      ),
    ];
    rootRoutes.addAll(getDetailRoutes());
    return GoRouter(routerNeglect: true, routes: [
      GoRoute(
          path: '/', builder: (context, state) => Welcome(), routes: rootRoutes)
    ], observers: [
      BotToastNavigatorObserver(),
      MyNavObserver(),
      AppRouteObserver().routeObserver,
    ]);
  }
}

class MyNavObserver extends NavigatorObserver {
  MyNavObserver() {
    //
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic> previousRoute) {
    if (route != null && route.settings != null && route.settings.name != '/') {
      AppGlobal.routerReplace = true;
    }

    CommonUtils.debugPrint(
        'didPush: ${CommonUtils.txt('dqlu')}=${route.settings.name}, previousRoute= ${previousRoute?.settings?.name}');

    //状态栏统一处理
    String cname = previousRoute?.settings?.name;
    String name = route.settings.name;
    if (name == "/videoDetail/:id") {}
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic> previousRoute) {
    if (route.str.indexOf('/login') != -1 ||
        route.str.indexOf('/${Routes.setup}') != -1) {
      route.popped.then((value) {
        EventBus().emit('need-update-login-state', value);
      });
    }
    if (route.str.indexOf('noticemessage') != -1 ||
        route.str.indexOf('customerService') != -1) {
      CommonUtils.updateSystemNotice(AppGlobal.appContext);
    }
    if (previousRoute != null &&
        previousRoute.settings != null &&
        previousRoute.settings.name == '/') {
      AppGlobal.routerReplace = false;
    }

    CommonUtils.debugPrint(
        'didPop: ${route.str} result: ${route?.settings?.name}, ${CommonUtils.txt('dqlu')}= ${previousRoute?.settings?.name}');
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic> previousRoute) =>
      CommonUtils.debugPrint(
          'didRemove: ${route.str}, previousRoute= ${previousRoute?.str}');

  @override
  void didReplace({Route<dynamic> newRoute, Route<dynamic> oldRoute}) =>
      CommonUtils.debugPrint(
          'didReplace: new= ${newRoute?.str}, old= ${oldRoute?.str}');

  @override
  void didStartUserGesture(
    Route<dynamic> route,
    Route<dynamic> previousRoute,
  ) =>
      CommonUtils.debugPrint('didStartUserGesture: ${route.str}, '
          'previousRoute= ${previousRoute?.str}');

  @override
  void didStopUserGesture() => CommonUtils.debugPrint('didStopUserGesture');
}

extension on Route<dynamic> {
  String get str => 'route(${settings.name}: ${settings.arguments})';
}
