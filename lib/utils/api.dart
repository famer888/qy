import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
// import 'package:qypj/components/yy_dialog.dart';
import 'package:qypj/global.dart';
import 'package:qypj/model/animationDetail.dart';
import 'package:qypj/model/appcenter.dart';
import 'package:qypj/model/basic.dart';
import 'package:qypj/model/coindetail.dart';
import 'package:qypj/model/coinorvip.dart';
import 'package:qypj/model/comicReading.dart';
import 'package:qypj/model/comicsDetail.dart';
import 'package:qypj/model/construct.dart';
import 'package:qypj/model/element.dart';
import 'package:qypj/model/feedback.dart';
import 'package:qypj/model/home_package_list_construct.dart';
import 'package:qypj/model/home_pure_list_construct.dart';
import 'package:qypj/model/homedata.dart';
import 'package:qypj/model/invitionlist.dart';
import 'package:qypj/model/myinvitation.dart';
import 'package:qypj/model/myreward.dart';
import 'package:qypj/model/ranklistConstruct.dart';
import 'package:qypj/model/series_model.dart';
import 'package:qypj/model/systemnotice.dart';
import 'package:qypj/model/systemnoticelist.dart';
import 'package:qypj/model/updateNum.dart';
import 'package:qypj/model/videolist.dart';
import 'package:qypj/model/welfare_model.dart';
import 'package:qypj/store/homeConfig.dart';
import 'package:qypj/utils/common.dart';
import 'package:qypj/utils/http.dart';
import 'package:flutter/foundation.dart';

//报告观看记录
Future<Basic> reportVisit({String json}) async {
  try {
    Response<dynamic> res = await PlatformAwareHttp.post('/api/mv/report_visit',
        data: {"json": json});
    CommonUtils.debugPrint(res.data);
    return Basic.fromJson(res.data);
  } catch (e) {
    CommonUtils.debugPrint(e);
    return null;
  }
}

//个人帖子收益
Future<Basic> userPostIncome() async {
  try {
    Response<dynamic> res =
        await PlatformAwareHttp.post('/api/user/post_income');
    CommonUtils.debugPrint(res.data);
    return Basic.fromJson(res.data);
  } catch (e) {
    CommonUtils.debugPrint(e);
    return null;
  }
}

//他人中心_添加标签
Future<Basic> peerCenterAddTags({String aff, String tags}) async {
  try {
    Response<dynamic> res = await PlatformAwareHttp.post(
        '/api/community/peer_center_add_tags',
        data: {"aff": aff, "tags": tags});
    CommonUtils.debugPrint(res.data);
    return Basic.fromJson(res.data);
  } catch (e) {
    CommonUtils.debugPrint(e);
    return null;
  }
}

//剧集列表
Future<Basic> otherUserListOfTopic({
  String aff,
  int page,
  int limit = 15,
  String last_ix,
}) async {
  try {
    Response<dynamic> res =
        await PlatformAwareHttp.post('/api/topic/list_user_topic', data: {
      "aff": aff,
      "page": page,
      "limit": limit,
      "last_ix": last_ix,
    });
    CommonUtils.debugPrint(res.data);
    return Basic.fromJson(res.data);
  } catch (e) {
    CommonUtils.debugPrint(e);
    return null;
  }
}

//他人中心
Future<Basic> peerCenterInfo({String aff}) async {
  try {
    Response<dynamic> res = await PlatformAwareHttp.post(
        '/api/community/peer_center',
        data: {"aff": aff});
    CommonUtils.debugPrint(res.data);
    return Basic.fromJson(res.data);
  } catch (e) {
    CommonUtils.debugPrint(e);
    return null;
  }
}

//他人帖子
Future<Basic> peerCenterPost({
  String aff,
  int page,
  int limit = 15,
  String last_ix,
}) async {
  try {
    Response<dynamic> res =
        await PlatformAwareHttp.post('/api/community/peer_center_post', data: {
      "aff": aff,
      "page": page,
      "limit": limit,
      "last_ix": last_ix,
    });
    CommonUtils.debugPrint(res.data);
    return Basic.fromJson(res.data);
  } catch (e) {
    CommonUtils.debugPrint(e);
    return null;
  }
}

//关注话题
Future<Basic> focusTops({
  int page,
  int limit = 15,
  String last_ix,
}) async {
  try {
    Response<dynamic> res =
        await PlatformAwareHttp.post('/api/community/followTopics', data: {
      "page": page,
      "limit": limit,
      "last_ix": last_ix,
    });
    CommonUtils.debugPrint(res.data);
    return Basic.fromJson(res.data);
  } catch (e) {
    CommonUtils.debugPrint(e);
    return null;
  }
}

//我的关注
Future<Basic> userListFollow({
  int page,
  int limit = 15,
  String last_ix,
}) async {
  try {
    Response<dynamic> res =
        await PlatformAwareHttp.post('/api/user/list_follow', data: {
      "page": page,
      "limit": limit,
      "last_ix": last_ix,
    });
    CommonUtils.debugPrint(res.data);
    return Basic.fromJson(res.data);
  } catch (e) {
    CommonUtils.debugPrint(e);
    return null;
  }
}

//我的帖子
Future<Basic> userMyPosts({
  String cate = "release",
  int page,
  int limit = 15,
}) async {
  try {
    Response<dynamic> res =
        await PlatformAwareHttp.post('/api/user/my_posts', data: {
      "cate": cate,
      "page": page,
      "limit": limit,
    });
    CommonUtils.debugPrint(res.data);
    return Basic.fromJson(res.data);
  } catch (e) {
    CommonUtils.debugPrint(e);
    return null;
  }
}

//视频收益
Future<Basic> mvsEarnInfo({
  String id,
  int page,
  int limit = 15,
  String last_ix,
}) async {
  try {
    Response<dynamic> res =
        await PlatformAwareHttp.post('/api/mv/list_sale_log', data: {
      "id": id,
      "page": page,
      "limit": limit,
      "last_ix": last_ix,
    });
    CommonUtils.debugPrint(res.data);
    return Basic.fromJson(res.data);
  } catch (e) {
    CommonUtils.debugPrint(e);
    return null;
  }
}

//收益汇总
Future<Basic> earnTotalInfo({
  String source = "",
  int page,
  int limit = 15,
  String last_ix,
}) async {
  try {
    Response<dynamic> res =
        await PlatformAwareHttp.post('/api/user/list_income_log', data: {
      "source": source,
      "page": page,
      "limit": limit,
      "last_ix": last_ix,
    });
    CommonUtils.debugPrint(res.data);
    return Basic.fromJson(res.data);
  } catch (e) {
    CommonUtils.debugPrint(e);
    return null;
  }
}

//提交上传视频
Future<Basic> topicCreateVideo({
  String title,
  String thumb,
  String tags,
  String source_240,
  String topic_id,
  String coins,
}) async {
  try {
    Response<dynamic> res =
        await PlatformAwareHttp.post('/api/topic/create_video', data: {
      "title": title,
      "thumb": thumb,
      "tags": tags,
      "source_240": source_240,
      "topic_id": topic_id,
      "coins": coins,
    });
    CommonUtils.debugPrint(res.data);
    return Basic.fromJson(res.data);
  } catch (e) {
    CommonUtils.debugPrint(e);
    return null;
  }
}

//上传规则
Future<Basic> topicUploadInfo() async {
  try {
    Response<dynamic> res =
        await PlatformAwareHttp.post('/api/topic/upload_info');
    CommonUtils.debugPrint(res.data);
    return Basic.fromJson(res.data);
  } catch (e) {
    CommonUtils.debugPrint(e);
    return null;
  }
}

//合集的视频——合集详细
Future<Basic> topicCollectForDetail({String id}) async {
  try {
    Response<dynamic> res =
        await PlatformAwareHttp.post('/api/topic/topic', data: {"id": id});
    CommonUtils.debugPrint(res.data);
    return Basic.fromJson(res.data);
  } catch (e) {
    CommonUtils.debugPrint(e);
    return null;
  }
}

//合集列表
Future<Basic> topicForVideoList({
  String id,
  int page,
  int limit = 15,
  String last_ix,
}) async {
  try {
    Response<dynamic> res = await PlatformAwareHttp.post(
        '/api/cartoon/list_topicvideos_foryou',
        data: {
          "topic_id": id,
          "page": page,
          "limit": limit,
          "last_ix": last_ix,
        });
    CommonUtils.debugPrint(res.data);
    return Basic.fromJson(res.data);
  } catch (e) {
    CommonUtils.debugPrint(e);
    return null;
  }
}

//合集的视频——合集视频
Future<Basic> topicCollectForVideo({
  String id,
  int page,
  int limit = 15,
  String status = "",
  String last_ix,
}) async {
  try {
    Response<dynamic> res =
        await PlatformAwareHttp.post('/api/topic/topic_videos', data: {
      "id": id,
      "page": page,
      "limit": limit,
      "status": status,
      "last_ix": last_ix,
    });
    CommonUtils.debugPrint(res.data);
    return Basic.fromJson(res.data);
  } catch (e) {
    CommonUtils.debugPrint(e);
    return null;
  }
}

//置顶合集 取消置顶
Future<Basic> topicToggleTop({int id}) async {
  try {
    Response<dynamic> res =
        await PlatformAwareHttp.post('/api/topic/toggle_top', data: {"id": id});
    CommonUtils.debugPrint(res.data);
    return Basic.fromJson(res.data);
  } catch (e) {
    CommonUtils.debugPrint(e);
    return null;
  }
}

//删除合集
Future<Basic> topicDeleteTopic({int id}) async {
  try {
    Response<dynamic> res =
        await PlatformAwareHttp.post('/api/topic/delete_topic');
    CommonUtils.debugPrint(res.data);
    return Basic.fromJson(res.data);
  } catch (e) {
    CommonUtils.debugPrint(e);
    return null;
  }
}

//创建合集
Future<Basic> topicCreateTopic({String title, String thumb}) async {
  try {
    Response<dynamic> res = await PlatformAwareHttp.post(
        '/api/topic/create_topic',
        data: {"title": title, "thumb": thumb});
    CommonUtils.debugPrint(res.data);
    return Basic.fromJson(res.data);
  } catch (e) {
    CommonUtils.debugPrint(e);
    return null;
  }
}

//用户自己的合集列表
Future<Basic> topicListMyTopic(
    {String status = "", int page, int limit = 15, String last_ix = ""}) async {
  try {
    Response<dynamic> res =
        await PlatformAwareHttp.post('/api/topic/list_my_topic', data: {
      "status": status,
      "page": page,
      "limit": limit,
      "last_ix": last_ix,
    });
    CommonUtils.debugPrint(res.data);
    return Basic.fromJson(res.data);
  } catch (e) {
    CommonUtils.debugPrint(e);
    return null;
  }
}

//申请创作者条件
Future<Basic> cartoonCreateApply({int id, String content}) async {
  try {
    Response<dynamic> res =
        await PlatformAwareHttp.post('/api/creator/rule_text');
    CommonUtils.debugPrint(res.data);
    return Basic.fromJson(res.data);
  } catch (e) {
    CommonUtils.debugPrint(e);
    return null;
  }
}

//申请创作者
Future<Basic> cartoonCreateCreator({String contact = ""}) async {
  try {
    Response<dynamic> res =
        await PlatformAwareHttp.post('/api/creator/create_creator');
    CommonUtils.debugPrint(res.data);
    return Basic.fromJson(res.data);
  } catch (e) {
    CommonUtils.debugPrint(e);
    return null;
  }
}

//创作数据
Future<Basic> creatorIncomeTotal() async {
  try {
    Response<dynamic> res =
        await PlatformAwareHttp.post('/api/creator/self_income_total');
    CommonUtils.debugPrint(res.data);
    return Basic.fromJson(res.data);
  } catch (e) {
    CommonUtils.debugPrint(e);
    return null;
  }
}

//对视频的评论点赞
Future<Basic> cartoonCommentMvLike({int id}) async {
  try {
    Response<dynamic> res = await PlatformAwareHttp.post(
        '/api/mv/toggle_comment_like',
        data: {"id": id});
    CommonUtils.debugPrint(res.data);
    return Basic.fromJson(res.data);
  } catch (e) {
    CommonUtils.debugPrint(e);
    return null;
  }
}

//获取视频的评论
Future<Basic> cartoonListCommentMv(
    {int id, String last_ix, int page, int limit = 15}) async {
  try {
    Response<dynamic> res =
        await PlatformAwareHttp.post('/api/mv/list_comment_mv', data: {
      "last_ix": last_ix,
      "page": page,
      "limit": limit,
      "id": id,
    });
    CommonUtils.debugPrint(res.data);
    return Basic.fromJson(res.data);
  } catch (e) {
    CommonUtils.debugPrint(e);
    return null;
  }
}

//对视频发布评论
Future<Basic> cartoonCreateCommentMv({int id, String content}) async {
  try {
    Response<dynamic> res =
        await PlatformAwareHttp.post('/api/mv/create_comment_mv', data: {
      "content": content,
      "id": id,
    });
    CommonUtils.debugPrint(res.data);
    return Basic.fromJson(res.data);
  } catch (e) {
    CommonUtils.debugPrint(e);
    return null;
  }
}

//动漫关注
Future<Basic> cartoonFollowForyou(
    {String last_ix, int page, int limit = 15}) async {
  try {
    Response<dynamic> res =
        await PlatformAwareHttp.post('/api/cartoon/list_follow_foryou', data: {
      "last_ix": last_ix,
      "page": page,
      "limit": limit,
    });
    CommonUtils.debugPrint(res.data);
    return Basic.fromJson(res.data);
  } catch (e) {
    CommonUtils.debugPrint(e);
    return null;
  }
}

//动漫推荐
Future<Basic> cartoonForyou({String last_ix, int page, int limit = 15}) async {
  try {
    Response<dynamic> res =
        await PlatformAwareHttp.post('/api/cartoon/foryou', data: {
      "last_ix": last_ix,
      "page": page,
      "limit": limit,
    });
    CommonUtils.debugPrint(res.data);
    return Basic.fromJson(res.data);
  } catch (e) {
    CommonUtils.debugPrint(e);
    return null;
  }
}

//社区数据
Future<Basic> communityListTopic(
    {String cate_id, int page, int limit = 15}) async {
  try {
    Response<dynamic> res =
        await PlatformAwareHttp.post('/api/community/list_topic', data: {
      "cate_id": cate_id,
      "page": page,
      "limit": limit,
    });
    CommonUtils.debugPrint(res.data);
    return Basic.fromJson(res.data);
  } catch (e) {
    CommonUtils.debugPrint(e);
    return null;
  }
}

//帖子打赏
Future<Basic> communityTopicReward(
    {String id, String amount, BuildContext context, int coins}) async {
  try {
    Response<dynamic> res = await PlatformAwareHttp.post(
        '/api/community/reward',
        data: {"id": id, "amount": amount});
    CommonUtils.debugPrint(res.data);
    Basic data = Basic.fromJson(res.data);
    if (data.status != 0) {
      // HomeConfig.setUserExp(context, coins);
    }
    return data;
  } catch (e) {
    CommonUtils.debugPrint(e);
    return null;
  }
}

//帖子详情
Future<Basic> communityTopicDetail({String id}) async {
  try {
    Response<dynamic> res = await PlatformAwareHttp.post(
        '/api/community/post_detail',
        data: {"id": id});
    CommonUtils.debugPrint(res.data);
    return Basic.fromJson(res.data);
  } catch (e) {
    CommonUtils.debugPrint(e);
    return null;
  }
}

//帖子或评论点赞/取消点赞
Future<Basic> communityTopicLike({String type = "post", String id}) async {
  try {
    Response<dynamic> res = await PlatformAwareHttp.post('/api/community/like',
        data: {"type": type, "id": id});
    CommonUtils.debugPrint(res.data);
    return Basic.fromJson(res.data);
  } catch (e) {
    CommonUtils.debugPrint(e);
    return null;
  }
}

//帖子收藏/取消收藏
Future<Basic> communityTopicFavorite({String id}) async {
  try {
    Response<dynamic> res = await PlatformAwareHttp.post(
        '/api/community/favorite',
        data: {"id": id});
    CommonUtils.debugPrint(res.data);
    return Basic.fromJson(res.data);
  } catch (e) {
    CommonUtils.debugPrint(e);
    return null;
  }
}

//一级评论列表
Future<Basic> communityPostComments(
    {String id, int page, int limit = 15}) async {
  try {
    Response<dynamic> res =
        await PlatformAwareHttp.post('/api/community/post_comments', data: {
      "id": id,
      "page": page,
      "limit": limit,
    });
    CommonUtils.debugPrint(res.data);
    return Basic.fromJson(res.data);
  } catch (e) {
    CommonUtils.debugPrint(e);
    return null;
  }
}

//发布评论
Future<Basic> communityPostComment(
    {String post_id, String comment_id, String content}) async {
  try {
    Response<dynamic> res =
        await PlatformAwareHttp.post('/api/community/comment', data: {
      "post_id": post_id,
      "comment_id": comment_id,
      "content": content
    });
    CommonUtils.debugPrint(res.data);
    return Basic.fromJson(res.data);
  } catch (e) {
    CommonUtils.debugPrint(e);
    return null;
  }
}

//评论详情列表
Future<Basic> communityPostCommentsSecond(
    {String comment_id, int page, int limit = 15}) async {
  try {
    Response<dynamic> res =
        await PlatformAwareHttp.post('/api/community/comments', data: {
      "comment_id": comment_id,
      "page": page,
      "limit": limit,
    });
    CommonUtils.debugPrint(res.data);
    return Basic.fromJson(res.data);
  } catch (e) {
    CommonUtils.debugPrint(e);
    return null;
  }
}

//话题关注/取消关注
Future<Basic> communityFollowTopic({String topic_id}) async {
  try {
    Response<dynamic> res = await PlatformAwareHttp.post(
        '/api/community/follow_topic',
        data: {"topic_id": topic_id});
    CommonUtils.debugPrint(res.data);
    return Basic.fromJson(res.data);
  } catch (e) {
    CommonUtils.debugPrint(e);
    return null;
  }
}

//关注用户/取消关注
Future<Basic> communityFollowUser({String aff}) async {
  try {
    Response<dynamic> res = await PlatformAwareHttp.post(
        '/api/user/toggle_follow',
        data: {"aff": aff});
    CommonUtils.debugPrint(res.data);
    return Basic.fromJson(res.data);
  } catch (e) {
    CommonUtils.debugPrint(e);
    return null;
  }
}

//全部类型
Future<Basic> communityListCate() async {
  try {
    Response<dynamic> res =
        await PlatformAwareHttp.post('/api/community/list_cate');
    CommonUtils.debugPrint(res.data);
    return Basic.fromJson(res.data);
  } catch (e) {
    CommonUtils.debugPrint(e);
    return null;
  }
}

//社区数据
Future<Basic> communityList(
    {String cate, int page, int limit = 15, String topic_id}) async {
  try {
    Response<dynamic> res =
        await PlatformAwareHttp.post('/api/community/list_post', data: {
      "cate": cate,
      "page": page,
      "limit": limit,
      "topic_id": topic_id,
    });
    CommonUtils.debugPrint(res.data);
    return Basic.fromJson(res.data);
  } catch (e) {
    CommonUtils.debugPrint(e);
    return null;
  }
}

//话题详情-帖子分页
Future<Basic> communityListTopicPost(
    {String topic_id, String cate, int page, int limit = 15}) async {
  try {
    Response<dynamic> res =
        await PlatformAwareHttp.post('/api/community/list_topic_post', data: {
      "topic_id": topic_id,
      "cate": cate,
      "page": page,
      "limit": limit
    });
    CommonUtils.debugPrint(res.data);
    return Basic.fromJson(res.data);
  } catch (e) {
    CommonUtils.debugPrint(e);
    return null;
  }
}

//发帖获取全部标签
Future<Basic> communityTopics() async {
  try {
    Response<dynamic> res =
        await PlatformAwareHttp.post('/api/community/topics');
    CommonUtils.debugPrint(res.data);
    return Basic.fromJson(res.data);
  } catch (e) {
    CommonUtils.debugPrint(e);
    return null;
  }
}

//话题详情
Future<Basic> communityTopicsDetail({String topic_id}) async {
  try {
    Response<dynamic> res = await PlatformAwareHttp.post(
        '/api/community/topic_detail',
        data: {"topic_id": topic_id});
    CommonUtils.debugPrint(res.data);
    return Basic.fromJson(res.data);
  } catch (e) {
    CommonUtils.debugPrint(e);
    return null;
  }
}

//发布帖子
Future<Basic> communityPost(
    {String topic_id, String title, String content = "", String medias}) async {
  try {
    Response<dynamic> res =
        await PlatformAwareHttp.post('/api/community/post', data: {
      "topic_id": topic_id,
      "title": title,
      "content": content,
      "medias": medias,
    });
    CommonUtils.debugPrint(res.data);
    return Basic.fromJson(res.data);
  } catch (e) {
    CommonUtils.debugPrint(e);
    return null;
  }
}

//获取全局config接口
Future<HomeData> getHomeConfig(BuildContext context) async {
  try {
    Response<dynamic> res = await PlatformAwareHttp.post('/api/home/config');
    CommonUtils.debugPrint(res.data);
    if (res.data['data']['help'] != null) {
      AppGlobal.helpList.clear();
      var help = res.data['data']['help'];
      help.forEach((element) {
        for (var item in element['items']) {
          var problem = {
            'problem': item['question'],
            'reply': item['answer'],
          };
          AppGlobal.helpList.add(problem);
        }
      });
    }
    HomeData result = HomeData.fromJson(res.data);

    if (result.status != 0) {
      Provider.of<HomeConfig>(context, listen: false)
          .setNotice(result.data.notice);
      Provider.of<HomeConfig>(context, listen: false).setAbs(result.data.ads);
      Provider.of<HomeConfig>(context, listen: false)
          .setConfig(result.data.config);
      Provider.of<HomeConfig>(context, listen: false)
          .setVersionMsg(result.data.versionMsg);
      AppGlobal.imgBase = result.data.config.imgBase;
      AppGlobal.uploadImgKey = result.data.config.uploadImgKey;
      AppGlobal.uploadImgUrl = result.data.config.imgUploadUrl;
      AppGlobal.uploadMp4Key = result.data.config.uploadMp4Key;
      AppGlobal.uploadMp4Url = result.data.config.mp4UploadUrl;
      AppGlobal.m3u8_encrypt = result.data.config.m3u8_encrypt;
    }
    return result;
  } catch (e) {
    CommonUtils.debugPrint(e);
    return null;
  }
}

//获取用户接口
Future<Member> getUserInfo(BuildContext context) async {
  try {
    Response<dynamic> res = await PlatformAwareHttp.post('/api/user/userInfo');
    CommonUtils.debugPrint(res.data);
    Member result = Member.fromJson(res.data["data"]);
    if (result != null) {
      Provider.of<HomeConfig>(context, listen: false).setMember(result);
      AppGlobal.vipLevel = result.vipLevel;
      AppGlobal.isSetPassword = result.isSetPassword;

      HomeConfig.setUserExp(context, result.exp);
    }
    return result;
  } catch (e) {
    CommonUtils.debugPrint(e);
    return null;
  }
}

//清除缓存
Future<Basic> clearCached() async {
  try {
    Response<dynamic> res =
        await PlatformAwareHttp.post('/api/user/clear_cached');
    CommonUtils.debugPrint(res);
    return Basic.fromJson(res.data);
  } catch (e) {
    return null;
  }
}

//验证手机号
Future<Basic> validatePhone({String phone, String phonePrefix}) async {
  try {
    Response<dynamic> res = await PlatformAwareHttp.post(
        '/api/account/validatePhone',
        data: {'phone': phone, 'phonePrefix': phonePrefix});
    Basic result = Basic.fromJson(res.data);
    return result;
  } catch (e) {
    return null;
  }
}

//海报数据
Future<Basic> posterData() async {
  try {
    Response<dynamic> res =
        await PlatformAwareHttp.post('/api/mv/list_promotional');
    CommonUtils.debugPrint(res.data);
    Basic result = Basic.fromJson(res.data);
    return result;
  } catch (e) {
    // CommonUtils.debugPrint(e);
    return null;
  }
}

//海报想看
Future<Basic> posterWantSee(String id) async {
  try {
    Response<dynamic> res = await PlatformAwareHttp.post(
        '/api/mv/wantbuy_promotional',
        data: {"id": id});
    CommonUtils.debugPrint(res.data);
    Basic result = Basic.fromJson(res.data);
    return result;
  } catch (e) {
    CommonUtils.debugPrint(e);
    return null;
  }
}

//验证用户名
Future<Basic> validateUsername({String username}) async {
  try {
    Response<dynamic> res = await PlatformAwareHttp.post(
        '/api/account/validateUsername',
        data: {'username': username});
    Basic result = Basic.fromJson(res.data);
    return result;
  } catch (e) {
    return null;
  }
}

//发送验证码
Future<Basic> sendPhone({String phone, String phonePrefix, int type}) async {
  try {
    Response<dynamic> res = await PlatformAwareHttp.post('/api/home/send',
        data: {'phone': phone, 'phonePrefix': phonePrefix, 'type': type});
    Basic result = Basic.fromJson(res.data);
    return result;
  } catch (e) {
    return null;
  }
}

//小视频菜单导航
Future<Basic> smallNavList() async {
  try {
    Response<dynamic> res = await PlatformAwareHttp.post('/api/vlog/vlog_tab');
    Basic result = Basic.fromJson(res.data);
    // CommonUtils.debugPrint("hjhjhjbjbjda==${result.data}");
    return result;
  } catch (e) {
    return null;
  }
}

//搜索菜单栏
Future<Basic> searchHotList() async {
  try {
    Response<dynamic> res = await PlatformAwareHttp.post('/api/search/index');
    Basic result = Basic.fromJson(res.data);
    CommonUtils.debugPrint("hjhjhjbjbjda==${result.data}");
    return result;
  } catch (e) {
    CommonUtils.debugPrint(e);
    return null;
  }
}

/// 动漫排行榜
// 'type' => 'enum(day = 日榜,week = 周榜 , like = 人气榜 , sale = 销售榜)
// 'page' => 'required|numeric',
// 'limit' => 'required|numeric|maxNum:50'
Future<Basic> cartoonTopList({String type = "day", int page, int limit}) async {
  try {
    Response<dynamic> res = await PlatformAwareHttp.post('/api/cartoon/toplist',
        data: {"type": type, 'page': page, 'limit': limit});
    Basic result = Basic.fromJson(res.data);
    CommonUtils.debugPrint(
        "rankList, type = ${type}, result ==== ${result.data}");
    return result;
  } catch (e) {
    CommonUtils.debugPrint(e);
    return null;
  }
}

/// 漫画排行榜
Future<Basic> bookTopList({String type = "day", int page, int limit}) async {
  try {
    Response<dynamic> res = await PlatformAwareHttp.post('/api/book/toplist',
        data: {"type": type, 'page': page, 'limit': limit});
    Basic result = Basic.fromJson(res.data);
    CommonUtils.debugPrint(
        "rankList, type = ${type}, result ==== ${result.data}");
    return result;
  } catch (e) {
    CommonUtils.debugPrint(e);
    return null;
  }
}

//下载次数验证
Future<Basic> downNum(int id) async {
  try {
    Response<dynamic> res = await PlatformAwareHttp.post(
        '/api/privilege/download',
        data: {"id": id});
    Basic result = Basic.fromJson(res.data);
    CommonUtils.debugPrint(res.data);
    return result;
  } catch (e) {
    CommonUtils.debugPrint(e);
    return null;
  }
}

//积分下载
Future<Basic> downNumByExp({int id, BuildContext context, int exp}) async {
  try {
    Response<dynamic> res = await PlatformAwareHttp.post(
        '/api/privilege/exp_down',
        data: {"id": id});
    Basic result = Basic.fromJson(res.data);
    if (result.status != 0) {
      HomeConfig.setUserExp(context, exp);
    }
    CommonUtils.debugPrint(res.data);
    return result;
  } catch (e) {
    CommonUtils.debugPrint(e);
    return null;
  }
}

//合集列表
Future<Basic> collectionList(
    {String id, int page, int limit, String sort = "hot"}) async {
  try {
    Response<dynamic> res = await PlatformAwareHttp.post(
        '/api/package/list_resource',
        data: {'id': id, 'page': page, 'limit': limit, "sort": sort});
    Basic result = Basic.fromJson(res.data);
    CommonUtils.debugPrint(result.data);
    return result;
  } catch (e) {
    return null;
  }
}

//塞选方式
Future<Basic> filtrateStyle() async {
  try {
    Response<dynamic> res =
        await PlatformAwareHttp.post('/api/book/filter_nav');
    Basic result = Basic.fromJson(res.data);
    CommonUtils.debugPrint(result.data);
    return result;
  } catch (e) {
    return null;
  }
}

//小说塞选方式
Future<Basic> nvelList(
    {String sort,
    String chapter,
    String category,
    int page,
    int limit = 15}) async {
  try {
    Response<dynamic> res =
        await PlatformAwareHttp.post('/api/story/getList', data: {
      "sort": sort,
      "chapter": chapter,
      "category": category,
      "page": page,
      "limit": limit
    });
    Basic result = Basic.fromJson(res.data);
    CommonUtils.debugPrint(result.data);
    return result;
  } catch (e) {
    return null;
  }
}

//动漫塞选方式
Future<Basic> comicList(
    {String sort, String element_id, int page, int limit = 15}) async {
  try {
    Response<dynamic> res =
        await PlatformAwareHttp.post('/api/book/filter_cartoon', data: {
      "sort": sort,
      "element_id": element_id,
      "page": page,
      "limit": limit
    });
    Basic result = Basic.fromJson(res.data);
    CommonUtils.debugPrint(result.data);
    return result;
  } catch (e) {
    return null;
  }
}

//漫画列表
Future<Basic> comcList({Map param, int limit = 15, int page}) async {
  try {
    Response<dynamic> res = await PlatformAwareHttp.post(
        '/api/book/list_filter',
        data: param..addAll({"limit": limit, "page": page}));
    Basic result = Basic.fromJson(res.data);
    return result;
  } catch (e) {
    return null;
  }
}

///动漫列表
Future<Basic> cartoonList({Map param, int limit = 15, int page}) async {
  try {
    Response<dynamic> res = await PlatformAwareHttp.post(
        '/api/cartoon/list_filter',
        data: param..addAll({"limit": limit, "page": page}));
    Basic result = Basic.fromJson(res.data);
    return result;
  } catch (e) {
    return null;
  }
}

///视频列表
Future<Basic> videoList({Map param, int limit = 15, int page}) async {
  try {
    Response<dynamic> res = await PlatformAwareHttp.post('/api/mv/list_filter',
        data: param..addAll({"limit": limit, "page": page}));
    Basic result = Basic.fromJson(res.data);
    return result;
  } catch (e) {
    return null;
  }
}

///色图分类
Future<Basic> pictureList({Map param, int limit = 15, int page}) async {
  try {
    Response<dynamic> res = await PlatformAwareHttp.post('/api/pic/list_filter',
        data: param..addAll({"limit": limit, "page": page}));
    Basic result = Basic.fromJson(res.data);
    return result;
  } catch (e) {
    return null;
  }
}

//获取系列数据
Future<SeriesModel> getSeries({int page, int limit}) async {
  try {
    Response<dynamic> res = await PlatformAwareHttp.post('/api/series/home',
        data: {'page': page, 'limit': limit});
    // CommonUtils.debugPrint(res.data);
    return SeriesModel.fromJson(res.data);
  } catch (e) {
    return null;
  }
}

//获取系列详情数据
Future<SeriesDetailDataModel> getSeriesDetail(
    {int id, int page, int limit}) async {
  try {
    Response<dynamic> res = await PlatformAwareHttp.post(
        '/api/series/getSmvBySeriesId',
        data: {'seriesId': id, 'page': page, 'limit': limit});
    // CommonUtils.debugPrint(res.data);
    return SeriesDetailDataModel.fromJson(res.data);
  } catch (e) {
    return null;
  }
}

//购买系列
Future<dynamic> buySeries({int id}) async {
  try {
    Response<dynamic> res =
        await PlatformAwareHttp.post('/api/series/buy', data: {'id': id});

    return res.data;
  } catch (e) {
    return null;
  }
}

//美图收藏
Future<Basic> collectPhoto({String relatedId}) async {
  try {
    Response<dynamic> res = await PlatformAwareHttp.post('/api/pic/favorites',
        data: {'relatedId': relatedId});
    return Basic.fromJson(res.data);
  } catch (e) {
    return null;
  }
}

//美图搜索
Future searchPhoto({int page, int limit, String word}) async {
  try {
    Response<dynamic> res = await PlatformAwareHttp.post('/api/pic/search',
        data: {'page': page, 'limit': limit, 'word': word});
    CommonUtils.debugPrint(res.data);
    return res.data;
  } catch (e) {
    CommonUtils.debugPrint(e);
    return null;
  }
}

//裸聊搜索
Future searchChats({int page, int limit, String word}) async {
  try {
    Response<dynamic> res = await PlatformAwareHttp.post('/api/chat/search',
        data: {'page': page, 'limit': limit, 'word': word});
    return res.data;
  } catch (e) {
    return null;
  }
}

/// 帖子搜索
Future searchCommunity({int page, int limit, String word}) async {
  try {
    Response<dynamic> res = await PlatformAwareHttp.post(
        '/api/community/search',
        data: {'page': page, 'limit': limit, 'word': word});
    return res.data;
  } catch (e) {
    return null;
  }
}

//美图搜索
Future searchSisters({int page, int limit, String word}) async {
  try {
    Response<dynamic> res = await PlatformAwareHttp.post('/api/girl/search',
        data: {'page': page, 'limit': limit, 'word': word});
    return res.data;
  } catch (e) {
    return null;
  }
}

//手机注册
Future<Basic> registerByPhone(
    {String phone, String phonePrefix, String code, String invitedAff}) async {
  try {
    Response<dynamic> res =
        await PlatformAwareHttp.post('/api/account/registerByPhone', data: {
      'phone': phone,
      'phonePrefix': phonePrefix,
      'code': code,
      'invitedAff': invitedAff
    });
    Basic result = Basic.fromJson(res.data);
    return result;
  } catch (e) {
    return null;
  }
}

//用户名注册
Future<Basic> registerByPassword(
    {String username,
    String password,
    String confirmPwd,
    String invitedAff}) async {
  try {
    Response<dynamic> res =
        await PlatformAwareHttp.post('/api/account/registerByPassword', data: {
      'username': username,
      'password': password,
      'confirm_pwd': confirmPwd,
      'invitedAff': invitedAff
    });

    Basic result = Basic.fromJson(res.data);
    return result;
  } catch (e) {
    return null;
  }
}

//用户名注册登录
Future<Basic> loginByReg({String username, String password}) async {
  try {
    Response<dynamic> res = await PlatformAwareHttp.post(
        '/api/account/registerByPassword',
        data: {'username': username, 'password': password});
    CommonUtils.debugPrint(res.data);
    Basic result = Basic.fromJson(res.data);
    return result;
  } catch (e) {
    return null;
  }
}

//用户名账号登录
Future<Basic> loginByAccount({String username, String password}) async {
  try {
    Response<dynamic> res = await PlatformAwareHttp.post(
        '/api/account/loginByPassword',
        data: {'username': username, 'password': password});
    Basic result = Basic.fromJson(res.data);
    return result;
  } catch (e) {
    return null;
  }
}

//手机登录
Future<Basic> loginByPhone(
    {String phone, String phonePrefix, String code}) async {
  try {
    Response<dynamic> res = await PlatformAwareHttp.post(
        '/api/account/loginByPhone',
        data: {'phone': phone, 'phonePrefix': phonePrefix, 'code': code});
    Basic result = Basic.fromJson(res.data);
    return result;
  } catch (e) {
    return null;
  }
}

//用户名登录
Future<Basic> loginByPassword({String username, String password}) async {
  try {
    Response<dynamic> res = await PlatformAwareHttp.post(
        '/api/account/loginByPassword',
        data: {'username': username, 'password': password});
    Basic result = Basic.fromJson(res.data);
    return result;
  } catch (e) {
    return null;
  }
}

//绑定手机
Future<Basic> bindPhone({String phone, String phonePrefix, String code}) async {
  try {
    Response<dynamic> res = await PlatformAwareHttp.post(
        '/api/account/bindPhone',
        data: {'phone': phone, 'phonePrefix': phonePrefix, 'code': code});
    Basic result = Basic.fromJson(res.data);
    return result;
  } catch (e) {
    return null;
  }
}

//切换手机
Future<Basic> changePhone(
    {String oldPhone,
    String oldPhonePrefix,
    String oldCode,
    String phone,
    String phonePrefix,
    String code}) async {
  try {
    Response<dynamic> res =
        await PlatformAwareHttp.post('/api/account/changePhone', data: {
      'oldPhone': oldPhone,
      'oldPhonePrefix': oldPhonePrefix,
      'oldCode': oldCode,
      'phone': phone,
      'phonePrefix': phonePrefix,
      'code': code
    });
    Basic result = Basic.fromJson(res.data);
    return result;
  } catch (e) {
    return null;
  }
}

//忘记密码
Future<Basic> forgetPassword(
    {String username,
    String phone,
    String phonePrefix,
    String code,
    String password,
    String passwordConfirm}) async {
  try {
    Response<dynamic> res =
        await PlatformAwareHttp.post('/api/account/forgetPassword', data: {
      'username': username,
      'phone': phone,
      'phonePrefix': phonePrefix,
      'code': code,
      'password': password,
      'passwordConfirm': passwordConfirm
    });
    Basic result = Basic.fromJson(res.data);
    return result;
  } catch (e) {
    return null;
  }
}

//更改密码
Future<Basic> updatePassword(
    {String password, String newPassword, String newPasswordConfirm}) async {
  try {
    Response<dynamic> res =
        await PlatformAwareHttp.post('/api/account/updatePassword', data: {
      'password': password,
      'newPassword': newPassword,
      'newPasswordConfirm': newPasswordConfirm
    });
    Basic result = Basic.fromJson(res.data);
    return result;
  } catch (e) {
    return null;
  }
}

//设置密码
Future<Basic> setPassword({String password, String passwordConfirm}) async {
  try {
    Response<dynamic> res = await PlatformAwareHttp.post(
        '/api/account/setPassword',
        data: {'password': password, 'passwordConfirm': passwordConfirm});
    Basic result = Basic.fromJson(res.data);
    return result;
  } catch (e) {
    return null;
  }
}

//获取精选��部导航
Future<ElementModel> getFisrtTopNavConfig({int nav_id = 7}) async {
  try {
    Response<dynamic> res = await PlatformAwareHttp.post(
        '/api/element/getElementById',
        data: {'id': nav_id});
    // Response<dynamic> res = await PlatformAwareHttp.post(
    //     '/api/element/getElementById',
    //     data: {'id': 7});

    ElementModel result = ElementModel.fromJson(res.data['data']);
    CommonUtils.debugPrint(res.data);
    return result;
  } catch (e) {
    // CommonUtils.debugPrint(e);
    return null;
  }
}

//获取特色顶部导航
Future<ElementModel> getSecondTopNavConfig() async {
  try {
    Response<dynamic> res = await PlatformAwareHttp.post(
        '/api/element/getElementById',
        data: {'id': 12});
    ElementModel result = ElementModel.fromJson(res.data['data']);
    return result;
  } catch (e) {
    return null;
  }
}

//获取精选某个栏目的�����������容元素
Future<ConstructModel> getConstructById({int id, int page, int limit}) async {
  try {
    Response<dynamic> res = await PlatformAwareHttp.post(
        '/api/element/getConstructById',
        data: {'id': id, 'page': page, 'limit': limit});
    CommonUtils.debugPrint(res);
    ConstructModel result = ConstructModel.fromJson(res.data['data']);
    return result;
  } catch (e) {
    return null;
  }
}

Future<dynamic> getConstructByApiLink({String apiLink, Map params}) async {
  try {
    Response<dynamic> res = await PlatformAwareHttp.post(apiLink, data: params);
    CommonUtils.debugPrint(res);
    if (res.data['data']['toplist'] != null) {
      RanklistConstructModel result =
          RanklistConstructModel.fromJson(res.data['data']);
      return result;
    } else if (res.data['data']['list'] != null) {
      if (res.data['data']['package'] != null) {
        HomePackageListConstructModel result =
            HomePackageListConstructModel.fromJson(res.data['data']);
        return result;
      }
      HomePureListConstructModel result =
          HomePureListConstructModel.fromJson(res.data['data']);
      result.api = apiLink;
      return result;
    }
    ConstructModel result = ConstructModel.fromJson(res.data['data']);
    return result;
  } catch (e) {
    if (kDebugMode) {
      if (e.runtimeType == DioError) {
        CommonUtils.showText((e as DioError).message);
      } else {
        CommonUtils.showText(e.toString());
      }
    }

    return null;
  }
}

//获取精选某个栏目的内容元素
Future<dynamic> getElementById({int id, int page, int limit}) async {
  try {
    Response<dynamic> res = await PlatformAwareHttp.post(
        '/api/element/getElementById',
        data: {'id': id, 'page': page, 'limit': limit});
    dynamic result = res.data;
    return result;
  } catch (e) {
    return null;
  }
}

//获取视频详情
Future<AnimationDetail> getVideoDetail({dynamic id}) async {
  try {
    Response<dynamic> res =
        await PlatformAwareHttp.post('/api/mv/getDetail', data: {'id': id});
    CommonUtils.debugPrint(res.data);
    AnimationDetail result = AnimationDetail.fromJson(res.data);
    return result;
  } catch (e) {
    CommonUtils.debugPrint(e);
    return null;
  }
}

/// 获取更新数量
Future<UpdateNumModel> apiGetUpdateNum({int cartoonId}) async {
  try {
    Response<dynamic> res =
        await PlatformAwareHttp.post('/api/home/getUpdateNum');
    UpdateNumModel result = UpdateNumModel.fromJson(res.data);
    return result;
  } catch (e) {
    return null;
  }
}

Future<SystemNotice> getSystemNotice() async {
  try {
    Response<dynamic> res =
        await PlatformAwareHttp.post('/api/message/getUnreadCount');
    return SystemNotice.fromJson(res.data);
  } catch (e) {
    return null;
  }
}

Future<SystemNoticeList> getSystemNoticeList({int page, int limit}) async {
  try {
    Response<dynamic> res = await PlatformAwareHttp.post(
        '/api/message/getSystemNoticeList',
        data: {'page': page, 'limit': limit});
    CommonUtils.debugPrint(res.data);
    return SystemNoticeList.fromJson(res.data);
  } catch (e) {
    CommonUtils.debugPrint(e);
    return null;
  }
}

//工单列表
Future<FeedBack> getFeedbackList({int page}) async {
  try {
    Response<dynamic> res = await PlatformAwareHttp.post(
        '/api/message/feedback',
        data: {'page': page});
    CommonUtils.debugPrint(res.data);
    return FeedBack.fromJson(res.data);
  } catch (e) {
    return null;
  }
}

//工单列表
Future<Basic> sendFeeding(String content, int type, int helpType) async {
  try {
    Response<dynamic> res = await PlatformAwareHttp.post('/api/message/feeding',
        data: {'content': content, 'type': type, 'helpType': helpType});
    CommonUtils.debugPrint(res.data);
    return Basic.fromJson(res.data);
  } catch (e) {
    return null;
  }
}

//修改用户头像、昵称、签名
Future<Basic> updateUserInfo(
    {String nickname, String thumb, String intro}) async {
  try {
    Response<dynamic> res = await PlatformAwareHttp.post(
        '/api/user/updateUserInfo',
        data: {'nickname': nickname, 'thumb': thumb, 'intro': intro});
    return Basic.fromJson(res.data);
  } catch (e) {
    return null;
  }
}

//填写邀请码
Future<Basic> toInvitation({String affCode}) async {
  try {
    Response<dynamic> res = await PlatformAwareHttp.post('/api/user/invitation',
        data: {'aff_code': affCode});
    // CommonUtils.debugPrint("====QQQQQQQ${res.data}");
    return Basic.fromJson(res.data);
  } catch (e) {
    // CommonUtils.debugPrint("====QQQQQQQ${e}");
    return null;
  }
}

//用户收藏   type: 1 mv  2 book 3 story 4 link 5 soundBook 6pic
Future<Basic> userFavorites({int type, int, id}) async {
  try {
    Response<dynamic> res = await PlatformAwareHttp.post('/api/user/favorites',
        data: {'type': type, 'relatedId': id});
    CommonUtils.debugPrint(res.data);
    return Basic.fromJson(res.data);
  } catch (e) {
    return null;
  }
}

/// 漫画 收藏
Future<Basic> bookFavorites({int, id}) async {
  try {
    Response<dynamic> res = await PlatformAwareHttp.post('/api/book/favorites',
        data: {'bookId': id});
    CommonUtils.debugPrint(res.data);
    return Basic.fromJson(res.data);
  } catch (e) {
    return null;
  }
}

//用户点赞 漫画
Future<Basic> userBookLike({int, id}) async {
  try {
    Response<dynamic> res =
        await PlatformAwareHttp.post('/api/book/like', data: {'bookId': id});
    CommonUtils.debugPrint(res.data);
    return Basic.fromJson(res.data);
  } catch (e) {
    return null;
  }
}

//小视频收藏
Future<Basic> userSmallFavorites({int, id}) async {
  try {
    Response<dynamic> res = await PlatformAwareHttp.post(
        '/api/cartoon/favorites',
        data: {'relatedId': id});
    CommonUtils.debugPrint(res.data);
    return Basic.fromJson(res.data);
  } catch (e) {
    return null;
  }
}

//获取小视频列表
Future<VideoList> getVideoList(
    {String elementId, int page, int limit = 15}) async {
  try {
    Response<dynamic> res = await PlatformAwareHttp.post('/api/vlog/list_vlog',
        data: {'element_id': elementId, 'page': page, 'limit': limit});
    CommonUtils.debugPrint(res.data);
    return VideoList.fromJson(res.data);
  } catch (e) {
    CommonUtils.debugPrint(e);
    return null;
  }
}

//获取视频列表
Future getChangVideoList(
    {int type = 1, int page, int limit, int isfree, int category}) async {
  try {
    Response<dynamic> res =
        await PlatformAwareHttp.post('/api/mv/getList', data: {
      'type': type,
      'page': page,
      'limit': limit,
      'isfree': isfree,
      'category': category
    });
    return res.data;
  } catch (e) {
    return null;
  }
}

//邀请记录
Future<InvitionList> getListInvition({int page, int limit}) async {
  try {
    Response<dynamic> res = await PlatformAwareHttp.post(
        '/api/user/listInvitation',
        data: {'page': page, 'limit': limit});
    return InvitionList.fromJson(res.data);
  } catch (e) {
    return null;
  }
}

//兑换
Future<Basic> onExchange({String cdk}) async {
  try {
    Response<dynamic> res =
        await PlatformAwareHttp.post('/api/home/exchange', data: {'cdk': cdk});
    return Basic.fromJson(res.data);
  } catch (e) {
    return null;
  }
}

//获取商品-VIP
Future<Basic> getProductOfVIP() async {
  try {
    Response<dynamic> res =
        await PlatformAwareHttp.post('/api/order/goodsList', data: {'type': 1});
    return Basic.fromJson(res.data);
  } catch (e) {
    return null;
  }
}

//获取积分列表
Future<Basic> getExpOfVIP() async {
  try {
    Response<dynamic> res = await PlatformAwareHttp.post(
        '/api/sign/list_exp_vip',
        data: {'type': 1});
    CommonUtils.debugPrint(res.data);
    return Basic.fromJson(res.data);
  } catch (e) {
    return null;
  }
}

//VIP积分兑换
Future<Basic> expConvertVIP({int id}) async {
  try {
    Response<dynamic> res =
        await PlatformAwareHttp.post('/api/sign/convert_vip', data: {'id': id});
    CommonUtils.debugPrint(res.data);
    return Basic.fromJson(res.data);
  } catch (e) {
    return null;
  }
}

//获取商品-扣币
Future<Basic> getProductOfGold(int type) async {
  try {
    Response<dynamic> res = await PlatformAwareHttp.post('/api/order/goodsList',
        data: {'type': type});
    CommonUtils.debugPrint(res);
    return Basic.fromJson(res.data);
  } catch (e) {
    CommonUtils.debugPrint(e);
    return null;
  }
}

//在线支付
Future<Basic> onCreatePaying({
  String pay_way,
  String pay_type,
  int product_id,
}) async {
  try {
    Response<dynamic> res =
        await PlatformAwareHttp.post('/api/order/createPaying', data: {
      'pay_way': pay_way,
      'pay_type': pay_type,
      'product_id': product_id
    });
    return Basic.fromJson(res.data);
  } catch (e) {
    return null;
  }
}

// 扣币兑换
Future<Basic> onOrderExchange({
  int product_id,
}) async {
  try {
    Response<dynamic> res = await PlatformAwareHttp.post('/api/order/exchange',
        data: {'product_id': product_id});
    return Basic.fromJson(res.data);
  } catch (e) {
    return null;
  }
}

//购买视频
Future<Basic> buyVideo({int id, int exp, BuildContext context}) async {
  try {
    Response<dynamic> res =
        await PlatformAwareHttp.post('/api/mv/exp_buy', data: {'id': id});
    CommonUtils.debugPrint(res);
    Basic data = Basic.fromJson(res.data);
    if (data.status != 0) {
      HomeConfig.setUserExp(context, exp);
    }
    return data;
  } catch (e) {
    CommonUtils.debugPrint(e);
    return null;
  }
}

//购买包视频
Future<Basic> buyPackageVideo({int id, int coins, BuildContext context}) async {
  try {
    Response<dynamic> res =
        await PlatformAwareHttp.post('/api/package/buy', data: {'id': id});
    // CommonUtils.debugPrint(res);
    Basic data = Basic.fromJson(res.data);
    if (data.status != 0) {
      // HomeConfig.setUserCoins(context, coins);
    }
    return data;
  } catch (e) {
    return null;
  }
}

//元素视频列表
Future<VideoList> getListFromElement({int id, int page, int limit}) async {
  try {
    Response<dynamic> res = await PlatformAwareHttp.post(
        "/api/mv/getListFromElement",
        data: {'elementId': id, 'page': page, 'limit': limit});
    return VideoList.fromJson(res.data);
  } catch (e) {
    return null;
  }
}

// 我收藏的
Future<dynamic> getUserFavor({
  int page,
  int limit = 15,
  int type,
  String last_ix,
}) async {
  try {
    Response<dynamic> res =
        await PlatformAwareHttp.post('/api/user/getUserFavor', data: {
      'page': page,
      'limit': limit,
      'type': type,
      "last_ix": last_ix,
    });
    CommonUtils.debugPrint(res.data);
    return res.data;
  } catch (e) {
    return null;
  }
}

//漫画详情
Future<ComicDetail> getComicDetail({int id}) async {
  try {
    Response<dynamic> res = await PlatformAwareHttp.post("/api/book/getDetail",
        data: {'bookId': id});
    CommonUtils.debugPrint(res.data);
    return ComicDetail.fromJson(res.data);
  } catch (e) {
    return null;
  }
}

//漫画章节购买
Future<Basic> comicChapterBy({int book_id, int episode}) async {
  try {
    Response<dynamic> res = await PlatformAwareHttp.post("/api/book/buy",
        data: {'book_id': book_id, "episode": episode});
    CommonUtils.debugPrint(res.data);
    return Basic.fromJson(res.data);
  } catch (e) {
    CommonUtils.debugPrint(e);
    return null;
  }
}

//漫画章节下载
Future<Basic> comicChapterDownload({Map param}) async {
  try {
    Response<dynamic> res =
        await PlatformAwareHttp.post("/api/book/down", data: param);
    CommonUtils.debugPrint(res.data);
    return Basic.fromJson(res.data);
  } catch (e) {
    CommonUtils.debugPrint(e);
    return null;
  }
}

//美图购买
Future<Basic> photoBy({String id}) async {
  try {
    Response<dynamic> res =
        await PlatformAwareHttp.post("/api/pic/buy", data: {'id': id});
    CommonUtils.debugPrint(res.data);
    return Basic.fromJson(res.data);
  } catch (e) {
    CommonUtils.debugPrint(e);
    return null;
  }
}

//小说章节购买
Future<Basic> nvelChapterBy({dynamic id}) async {
  try {
    Response<dynamic> res =
        await PlatformAwareHttp.post("/api/story/buy", data: {'id': id});
    CommonUtils.debugPrint(res.data);
    return Basic.fromJson(res.data);
  } catch (e) {
    CommonUtils.debugPrint(e);
    return null;
  }
}

//漫画评价
Future<Basic> getComicEvaluation({int id, String evaluation}) async {
  try {
    Response<dynamic> res = await PlatformAwareHttp.post("/api/book/evaluation",
        data: {'bookId': id, "evaluation": evaluation});
    return Basic.fromJson(res.data);
  } catch (e) {
    return null;
  }
}

//小说评价
Future<Basic> getNvelEvaluation({int id, String evaluation}) async {
  try {
    Response<dynamic> res = await PlatformAwareHttp.post(
        "/api/story/evaluation",
        data: {'storyId': id, "evaluation": evaluation});
    CommonUtils.debugPrint(res.data);
    return Basic.fromJson(res.data);
  } catch (e) {
    CommonUtils.debugPrint(e);
    return null;
  }
}

//小说评价
Future<Basic> getVideoEvaluation({int id, String evaluation}) async {
  try {
    Response<dynamic> res = await PlatformAwareHttp.post("/api/mv/evaluation",
        data: {'id': id, "evaluation": evaluation});
    CommonUtils.debugPrint(res.data);
    return Basic.fromJson(res.data);
  } catch (e) {
    CommonUtils.debugPrint(e);
    return null;
  }
}

// 小说章节
Future<Basic> nvelEpisode({String id}) async {
  try {
    Response<dynamic> res =
        await PlatformAwareHttp.post('/api/story/getSeries', data: {'id': id});
    CommonUtils.debugPrint(res.data);
    Basic result = Basic.fromJson(res.data);
    return result;
  } catch (e) {
    return null;
  }
}

//漫画阅读
Future<ComicReading> getComicReading({int id, int episode}) async {
  try {
    Response<dynamic> res = await PlatformAwareHttp.post("/api/book/read",
        data: {'bookId': id, 'episode': episode});
    CommonUtils.debugPrint(res.data);
    return ComicReading.fromJson(res.data);
  } catch (e) {
    return null;
  }
}

//详情页推荐漫画
Future<Basic> getRecommendComicsList(
    {int limit = 5, int page = 1, String category = '', int id}) async {
  try {
    Response<dynamic> res = await PlatformAwareHttp.post(
        "/api/book/getDetailRecommendList",
        data: {'limit': limit, 'page': page, 'category': category, 'id': id});
    return Basic.fromJson(res.data);
  } catch (e) {
    return null;
  }
}

// 我收藏的视频列表
Future getComicsList({int type, int limit, int page}) async {
  try {
    Response<dynamic> res = await PlatformAwareHttp.post('/api/book/getList',
        data: {'page': page, 'limit': limit, 'type': type == null ? 1 : type});
    return res.data;
  } catch (e) {
    return null;
  }
}

// 视频详情推荐视频
Future<Basic> getDetailRecommendList({int id}) async {
  try {
    Response<dynamic> res = await PlatformAwareHttp.post(
        '/api/mv/getDetailRecommendList',
        data: {'id': id});
    CommonUtils.debugPrint(res.data);
    // return VideoList.fromJson(res.data);
    return Basic.fromJson(res.data);
  } catch (e) {
    CommonUtils.debugPrint(e);
    return null;
  }
}

// 约炮列表
Future getListWithFilter(Map reqdata) async {
  try {
    Response<dynamic> res = await PlatformAwareHttp.post(
        '/api/girl/getListWithFilter',
        data: reqdata);
    return res.data;
  } catch (e) {
    return null;
  }
}

// 裸聊列表
Future getLuoliaoListFilter(Map reqdata) async {
  try {
    Response<dynamic> res = await PlatformAwareHttp.post(
        '/api/chat/getListWIthFilter',
        data: reqdata);
    return res.data;
  } catch (e) {
    return null;
  }
}

// 约炮筛选项
Future getFilterOption() async {
  try {
    Response<dynamic> res =
        await PlatformAwareHttp.post('/api/girl/getFilterOption', data: {});
    return res.data;
  } catch (e) {
    return null;
  }
}

// 裸聊筛选项
Future getLuoliaoFilterOption() async {
  try {
    Response<dynamic> res =
        await PlatformAwareHttp.post('/api/chat/getFilterOption', data: {});
    return res.data;
  } catch (e) {
    return null;
  }
}

// 裸聊详情
Future getLuoliaoDetail(int id) async {
  try {
    Response<dynamic> res =
        await PlatformAwareHttp.post('/api/chat/getDetail', data: {'id': id});
    return res.data;
  } catch (e) {
    return null;
  }
}

// 裸聊购买
Future buyLuoliao(
    int chatId, int priceId, BuildContext context, int coins) async {
  try {
    Response<dynamic> res = await PlatformAwareHttp.post('/api/chat/buy',
        data: {'chatId': chatId, 'priceId': priceId});
    Basic data = Basic.fromJson(res.data);
    if (data.status != 0) {
      // HomeConfig.setUserCoins(context, coins);
    }
    return res.data;
  } catch (e) {
    return null;
  }
}

// 上门解锁
Future buyGirl(int id, BuildContext context, int coins) async {
  try {
    Response<dynamic> res =
        await PlatformAwareHttp.post('/api/girl/buy', data: {'id': id});
    Basic data = Basic.fromJson(res.data);
    if (data.status != 0) {
      // HomeConfig.setUserCoins(context, coins);
    }
    return res.data;
  } catch (e) {
    return null;
  }
}

// 我购买的
Future getUserBuy({int page, int type, int limit = 24}) async {
  try {
    Response<dynamic> res = await PlatformAwareHttp.post("/api/user/getUserBuy",
        data: {'page': page, 'limit': limit, 'type': type});
    CommonUtils.debugPrint(res.data);
    return res.data;
  } catch (e) {
    CommonUtils.debugPrint(e);
    return null;
  }
}

//扣币明细
Future<CoinDetialModel> getListMoneyDetail(
    {int page = 1, dynamic type = '', limit}) async {
  try {
    Response<dynamic> res = await PlatformAwareHttp.post(
        "/api/user/listMoneyDetail",
        data: {'limit': limit, 'page': page, 'type': type});
    CommonUtils.debugPrint(res.data);
    return CoinDetialModel.fromJson(res.data);
  } catch (e) {
    CommonUtils.debugPrint(e);
    return null;
  }
}

// 充值记录
Future<CoinOrVipModel> getOrderList(
    {int page = 1, dynamic type = '', int limit = 24}) async {
  try {
    Response<dynamic> res = await PlatformAwareHttp.post("/api/order/orderList",
        data: {'limit': limit, 'page': page, 'type': type});
    return CoinOrVipModel.fromJson(res.data);
  } catch (e) {
    return null;
  }
}

// 应用商店
Future<AppCenterModel> getAppCenter({int page = 1, dynamic type = ''}) async {
  try {
    Response<dynamic> res = await PlatformAwareHttp.post("/api/home/appCenter");
    // CommonUtils.debugPrint(res);
    return AppCenterModel.fromJson(res.data);
  } catch (e) {
    return null;
  }
}

//应用福利
Future<AppCenterModel> getWelfare() async {
  try {
    Response<dynamic> res = await PlatformAwareHttp.post("/api/claim/index");
    return AppCenterModel.fromJson(res.data);
  } catch (e) {
    return null;
  }
}

//应用福利列表
Future<WelfareModel> getApps({int page = 1, int category_id = 0}) async {
  try {
    Response<dynamic> res = await PlatformAwareHttp.post("/api/claim/list",
        data: {"page": page, "category_id": category_id, "limit": 20});
    return WelfareModel.fromJson(res.data);
  } catch (e) {
    return null;
  }
}

// 我的邀请
Future<MyInvitationModel> myInvitation({int page, int limit}) async {
  try {
    Response<dynamic> res =
        await PlatformAwareHttp.post('/api/user/myInvitation');
    return MyInvitationModel.fromJson(res.data);
  } catch (e) {
    return null;
  }
}

// 裸聊购买
Future getGilrContact(dynamic id) async {
  try {
    Response<dynamic> res = await PlatformAwareHttp.post('/api/chat/contact',
        data: {'orderId': id});
    return res.data;
  } catch (e) {
    return null;
  }
}

// 上门评价
Future setGilrComment(
    int girlMeetId, String comment, int face, int service) async {
  try {
    Response<dynamic> res = await PlatformAwareHttp.post('/api/girl/comment',
        data: {
          'girlMeetId': girlMeetId,
          'comment': comment,
          'face': face,
          'service': service
        });
    return res.data;
  } catch (e) {
    return null;
  }
}

// 上门评价列表
Future getGirlComment({dynamic id, int page, int limit}) async {
  try {
    Response<dynamic> res = await PlatformAwareHttp.post('/api/girl/getComment',
        data: {'id': id, 'page': page, 'limit': limit});
    return res.data;
  } catch (e) {
    return null;
  }
}

// 图集列表
Future getPicList({int page, int limit}) async {
  try {
    Response<dynamic> res = await PlatformAwareHttp.post('/api/pic/getList',
        data: {'page': page, 'limit': limit});
    return res.data;
  } catch (e) {
    return null;
  }
}

// 图集详情
Future getPicDetail({int id}) async {
  try {
    Response<dynamic> res =
        await PlatformAwareHttp.post('/api/pic/getdetail', data: {'id': id});
    return res.data;
  } catch (e) {
    return null;
  }
}

//小说列表
Future getBookList({int page, int limit, int type}) async {
  try {
    Response<dynamic> res = await PlatformAwareHttp.post('/api/story/getList',
        data: {'page': page, 'limit': limit, 'type': type});
    return res.data;
  } catch (e) {
    return null;
  }
}

//小说阅读
Future<Basic> getBookReader({String id}) async {
  try {
    Response<dynamic> res = await PlatformAwareHttp.post('/api/story/read2',
        data: {'seriesId': id});
    CommonUtils.debugPrint(res.data);
    return Basic.fromJson(res.data);
  } catch (e) {
    return null;
  }
}

//小说详情
Future getBookDetail({int id, int type = 1}) async {
  try {
    Response<dynamic> res = await PlatformAwareHttp.post('/api/story/getDetail',
        data: {'id': id, 'type': type});
    return res.data;
  } catch (e) {
    return null;
  }
}

//小说详情推荐
Future getBookRecommendList({int limit, int page, int type = 1}) async {
  try {
    Response<dynamic> res = await PlatformAwareHttp.post(
        '/api/story/getRecommendList',
        data: {'limit': limit, 'page': page, 'type': type});
    return res.data;
  } catch (e) {
    return null;
  }
}

// 收益明细
Future<MyRewardModel> getMyReward() async {
  try {
    Response<dynamic> res =
        await PlatformAwareHttp.post('/api/user/getMyReward');
    return MyRewardModel.fromJson(res.data);
  } catch (e) {
    return null;
  }
}

// 联系官方
Future getContactList() async {
  try {
    Response<dynamic> res =
        await PlatformAwareHttp.post('/api/home/getContactList');
    CommonUtils.debugPrint(res.data);
    return res.data;
  } catch (e) {
    CommonUtils.debugPrint(e);
    return null;
  }
}

// 漫画章节
Future<Basic> comicsEpisode({String book_id}) async {
  try {
    Response<dynamic> res = await PlatformAwareHttp.post(
        '/api/book/list_episode',
        data: {'book_id': book_id});
    CommonUtils.debugPrint(res.data);
    Basic result = Basic.fromJson(res.data);
    return result;
  } catch (e) {
    return null;
  }
}

// 漫画搜索
Future comicsSearch({int page, int limit, String word}) async {
  try {
    Response<dynamic> res = await PlatformAwareHttp.post('/api/book/search',
        data: {'page': page, 'limit': limit, 'word': word});
    return res.data;
  } catch (e) {
    return null;
  }
}

// 视频搜索
Future videoSearch({int page, int limit, String word, int type = 1}) async {
  try {
    Response<dynamic> res = await PlatformAwareHttp.post('/api/mv/search',
        data: {'page': page, 'limit': limit, 'word': word, 'type': type});
    CommonUtils.debugPrint(res.data);
    return res.data;
  } catch (e) {
    return null;
  }
}

// 漫剧搜索
Future manjSearch({int page, int limit, String word, int type = 1}) async {
  try {
    Response<dynamic> res = await PlatformAwareHttp.post('/api/topic/search',
        data: {'page': page, 'limit': limit, 'word': word, 'type': type});
    CommonUtils.debugPrint(res.data);
    return res.data;
  } catch (e) {
    return null;
  }
}

// 小说搜索
Future novelSearch({int page, int limit, String word}) async {
  try {
    Response<dynamic> res = await PlatformAwareHttp.post('/api/story/search',
        data: {'page': page, 'limit': limit, 'word': word});
    return res.data;
  } catch (e) {
    return null;
  }
}

// 评论列表
Future getCommentList(
    {int page, int limit, int contentId, int contentType}) async {
  try {
    Response<dynamic> res =
        await PlatformAwareHttp.post('/api/comment/index', data: {
      'page': page,
      'limit': limit,
      'content_id': contentId,
      'content_type': contentType
    });
    // CommonUtils.debugPrint(
    //     '-------------评论：$res---参数page:${page}--limit:${limit}--content_id:${contentId}--content_type:${contentType}--url:/api/comment/index');
    return res.data;
  } catch (e) {
    return null;
  }
}

// 发表评论
Future publishComment(
    {int commentId, String reply, int contentId, int contentType}) async {
  try {
    Response<dynamic> res =
        await PlatformAwareHttp.post('/api/comment/comment', data: {
      'comment_id': commentId,
      'reply': reply,
      'content_id': contentId,
      'content_type': contentType
    });
    return res.data;
  } catch (e) {
    return null;
  }
}

// 领取扣币卡
Future getCoinFromCoinCard() async {
  try {
    Response<dynamic> res =
        await PlatformAwareHttp.post('/api/user/getCoinFromCoinCard');
    return res.data;
  } catch (e) {
    return null;
  }
}

//常规更多
Future<Basic> getElementByIdSecondPage(
    {String id, int page, int limit, String sort = "hot"}) async {
  try {
    Response<dynamic> res = await PlatformAwareHttp.post(
        '/api/element/getElementByIdSecondPage',
        data: {'id': id, 'page': page, 'limit': limit, "sort": sort});
    // CommonUtils.debugPrint("DDDDDDDDDD${res.data}");
    Basic result = Basic.fromJson(res.data);
    return result;
  } catch (e) {
    return null;
  }
}

//常规更多
Future<Basic> getElementByIdSecondPageWithParam({Map data}) async {
  try {
    Response<dynamic> res = await PlatformAwareHttp.post(
        '/api/element/getElementByIdSecondPage',
        data: data);
    // CommonUtils.debugPrint("DDDDDDDDDD${res.data}");
    Basic result = Basic.fromJson(res.data);
    return result;
  } catch (e) {
    return null;
  }
}

//常规更多
Future<Basic> getListConstructWithParam({Map data}) async {
  try {
    Response<dynamic> res =
        await PlatformAwareHttp.post('/api/mv/list_construct', data: data);
    Basic result = Basic.fromJson(res.data);
    return result;
  } catch (e) {
    return null;
  }
}

///裸聊列表
Future getNakedchatList(Map reqdata) async {
  try {
    Response<dynamic> res =
        await PlatformAwareHttp.post('/api/chat/getList', data: reqdata);
    CommonUtils.debugPrint(res.data);
    return Basic.fromJson(res.data);
  } catch (e) {
    return null;
  }
}

///裸聊详情
Future getNakedchatDetail(Map reqdata) async {
  try {
    Response<dynamic> res =
        await PlatformAwareHttp.post('/api/chat/getDetail', data: reqdata);
    return res.data;
  } catch (e) {
    return null;
  }
}

///裸聊购买
Future nakedchatPurchase(Map reqdata, {int coins, BuildContext context}) async {
  try {
    Response<dynamic> res =
        await PlatformAwareHttp.post('/api/chat/buy', data: reqdata);
    Basic data = Basic.fromJson(res.data);
    if (data.status != 0) {
      // HomeConfig.setUserCoins(context, coins);
    }
    return res.data;
  } catch (e) {
    return null;
  }
}

///裸聊 联系方式
Future<Basic> getNakedchatContact(Map reqdata) async {
  try {
    Response<dynamic> res =
        await PlatformAwareHttp.post('/api/chat/contact', data: reqdata);
    return Basic.fromJson(res.data);
  } catch (e) {
    return null;
  }
}

///裸聊 订单
Future<Basic> getChatOrder(Map reqdata) async {
  try {
    Response<dynamic> res =
        await PlatformAwareHttp.post('/api/chat/getMyOrders', data: reqdata);
    return Basic.fromJson(res.data);
  } catch (e) {
    return null;
  }
}

///裸聊 确认订单
Future<Basic> chatOrderConfirm(Map reqdata) async {
  try {
    Response<dynamic> res =
        await PlatformAwareHttp.post('/api/chat/confirm_chat', data: reqdata);
    return Basic.fromJson(res.data);
  } catch (e) {
    return null;
  }
}

///裸聊管理 订单列表
Future<Basic> getChatManageOrderList(Map reqdata) async {
  try {
    Response<dynamic> res = await PlatformAwareHttp.post(
        '/api/broker/chatOrderManage',
        data: reqdata);
    return Basic.fromJson(res.data);
  } catch (e) {
    return null;
  }
}

///裸聊  发布评价
Future<Basic> postNakedchatComment(Map reqdata) async {
  try {
    Response<dynamic> res =
        await PlatformAwareHttp.post('/api/chat/comment', data: reqdata);
    return Basic.fromJson(res.data);
  } catch (e) {
    return null;
  }
}

///裸聊  评价列表
Future<Basic> nakedchatCommentList(Map reqdata) async {
  try {
    Response<dynamic> res =
        await PlatformAwareHttp.post('/api/chat/getComment', data: reqdata);
    return Basic.fromJson(res.data);
  } catch (e) {
    return null;
  }
}

///把妹home
Future getBameiHome() async {
  try {
    Response<dynamic> res = await PlatformAwareHttp.post('/api/pua/home');
    return res.data;
  } catch (e) {
    return null;
  }
}

///把妹 Course
Future<Basic> getBameiCourseList(Map reqdata) async {
  try {
    Response<dynamic> res =
        await PlatformAwareHttp.post('/api/pua/list_course', data: reqdata);
    return Basic.fromJson(res.data);
  } catch (e) {
    return null;
  }
}

///把妹 Series
Future<Basic> getBameiSeriesList(Map reqdata) async {
  try {
    Response<dynamic> res =
        await PlatformAwareHttp.post('/api/pua/list_series', data: reqdata);
    return Basic.fromJson(res.data);
  } catch (e) {
    return null;
  }
}

///约妹 home
Future<Basic> getYuemeiHomeList() async {
  try {
    Response<dynamic> res = await PlatformAwareHttp.post('/api/girl/getList');
    return Basic.fromJson(res.data);
  } catch (e) {
    return null;
  }
}

///约妹 更多商家
Future<Basic> getYuemeiMoreSellerList(Map reqdata) async {
  try {
    Response<dynamic> res =
        await PlatformAwareHttp.post('/api/broker/moreBroker', data: reqdata);
    return Basic.fromJson(res.data);
  } catch (e) {
    return null;
  }
}

///约妹 筛选 选项列表
Future<Basic> getYuemeiFilterOption() async {
  try {
    Response<dynamic> res =
        await PlatformAwareHttp.post('/api/girl/getFilterOption');
    return Basic.fromJson(res.data);
  } catch (e) {
    return null;
  }
}

///约妹 list
Future<Basic> getYuemeiListWithFilter(Map reqdata) async {
  try {
    Response<dynamic> res = await PlatformAwareHttp.post(
        '/api/girl/getListWithFilter',
        data: reqdata);
    CommonUtils.debugPrint(res.data);
    return Basic.fromJson(res.data);
  } catch (e) {
    CommonUtils.debugPrint(e);
    return null;
  }
}

///约妹 体验报告 list
Future<Basic> getYuemeiHomeCommentList(Map reqdata) async {
  try {
    Response<dynamic> res =
        await PlatformAwareHttp.post('/api/girl/getCommentList', data: reqdata);
    return Basic.fromJson(res.data);
  } catch (e) {
    return null;
  }
}

///约妹 详情 detail
Future<Basic> getYuemeDetail(Map reqdata) async {
  try {
    Response<dynamic> res =
        await PlatformAwareHttp.post('/api/girl/getDetail', data: reqdata);
    CommonUtils.debugPrint(res.data);
    return Basic.fromJson(res.data);
  } catch (e) {
    return null;
  }
}

///约妹 解锁
Future<Basic> getYuemeiBuy(Map reqdata,
    {int coins, BuildContext context}) async {
  try {
    Response<dynamic> res =
        await PlatformAwareHttp.post('/api/girl/buy', data: reqdata);
    Basic data = Basic.fromJson(res.data);
    if (data.status != 0) {
      // HomeConfig.setUserCoins(context, coins);
    }
    return data;
  } catch (e) {
    return null;
  }
}

///约妹 评价
Future<Basic> getYuemeiComment(Map reqdata) async {
  try {
    Response<dynamic> res =
        await PlatformAwareHttp.post('/api/girl/getComment', data: reqdata);
    return Basic.fromJson(res.data);
  } catch (e) {
    return null;
  }
}

///约妹 商家 page
Future<Basic> getYuemeSeller(Map reqdata) async {
  try {
    Response<dynamic> res = await PlatformAwareHttp.post(
        '/api/girl/getBrokerDetail',
        data: reqdata);
    return Basic.fromJson(res.data);
  } catch (e) {
    return null;
  }
}

///约妹 订单
Future<Basic> getYuemeiOrder(Map reqdata) async {
  try {
    Response<dynamic> res =
        await PlatformAwareHttp.post('/api/girl/getMyOrders', data: reqdata);
    return Basic.fromJson(res.data);
  } catch (e) {
    return null;
  }
}

///约妹 商家信息编辑
Future<Basic> yuemeiSellerInfoEdit(Map reqdata) async {
  try {
    Response<dynamic> res =
        await PlatformAwareHttp.post('/api/broker/edit', data: reqdata);
    return Basic.fromJson(res.data);
  } catch (e) {
    return null;
  }
}

///约妹 商家管理 获取上传内容选项
Future<Basic> yuemeiSellerUploadOption(Map reqdata) async {
  try {
    Response<dynamic> res =
        await PlatformAwareHttp.post('/api/girl/uploadOption', data: reqdata);
    return Basic.fromJson(res.data);
  } catch (e) {
    return null;
  }
}

///约妹 商家管理 发布妹子信息
Future<Basic> yuemeiSellerPublishMeiziInfo(Map reqdata) async {
  try {
    Response<dynamic> res =
        await PlatformAwareHttp.post('/api/girl/upload', data: reqdata);
    return Basic.fromJson(res.data);
  } catch (e) {
    return null;
  }
}

///约妹 商家管理 商家信息
Future<Basic> yuemeiSellerInfo(Map reqdata) async {
  try {
    Response<dynamic> res =
        await PlatformAwareHttp.post('/api/broker/info', data: reqdata);
    return Basic.fromJson(res.data);
  } catch (e) {
    return null;
  }
}

///约妹 商家管理 妹子列表
Future<Basic> yuemeiSellerMeiziList(Map reqdata) async {
  try {
    Response<dynamic> res =
        await PlatformAwareHttp.post('/api/broker/myGirlmeet', data: reqdata);
    return Basic.fromJson(res.data);
  } catch (e) {
    return null;
  }
}

///约妹 商家管理 上架/下架
Future<Basic> yuemeiSellerMeiziUpDown(Map reqdata) async {
  try {
    Response<dynamic> res =
        await PlatformAwareHttp.post('/api/broker/updown', data: reqdata);
    return Basic.fromJson(res.data);
  } catch (e) {
    return null;
  }
}

///约妹 商家管理 置顶
Future<Basic> yuemeiSellerSetTop(Map reqdata) async {
  try {
    Response<dynamic> res =
        await PlatformAwareHttp.post('/api/broker/top', data: reqdata);
    return Basic.fromJson(res.data);
  } catch (e) {
    return null;
  }
}

///约妹 发布评价
Future<Basic> postYuemeiComment(Map reqdata) async {
  try {
    Response<dynamic> res =
        await PlatformAwareHttp.post('/api/girl/comment', data: reqdata);
    return Basic.fromJson(res.data);
  } catch (e) {
    return null;
  }
}

///代理 推广数据 | 等级信息
Future<Basic> getProxyDetail(Map reqdata) async {
  try {
    Response<dynamic> res =
        await PlatformAwareHttp.post('/api/proxy/detail', data: reqdata);
    CommonUtils.debugPrint(res.data);
    return Basic.fromJson(res.data);
  } catch (e) {
    return null;
  }
}

///代理 收益明细
Future<Basic> getProxyProfitList(Map reqdata) async {
  try {
    Response<dynamic> res =
        await PlatformAwareHttp.post('/api/proxy/list', data: reqdata);
    return Basic.fromJson(res.data);
  } catch (e) {
    return null;
  }
}

///代理 申请代理
Future<Basic> applyProxyWithContact(String contact) async {
  try {
    Response<dynamic> res = await PlatformAwareHttp.post('/api/proxy/apply',
        data: {'contact': contact});
    return Basic.fromJson(res.data);
  } catch (e) {
    return null;
  }
}

///代理 邀请记录
Future<Basic> getProxyInviteRecord(Map reqdata) async {
  try {
    Response<dynamic> res =
        await PlatformAwareHttp.post('/api/proxy/list_log', data: reqdata);
    return Basic.fromJson(res.data);
  } catch (e) {
    return null;
  }
}

///提现  添加银行卡
Future<Basic> cashAddBankCard(Map reqdata) async {
  try {
    Response<dynamic> res =
        await PlatformAwareHttp.post('/api/user/add_bankcard', data: reqdata);
    return Basic.fromJson(res.data);
  } catch (e) {
    return null;
  }
}

///提现  银行卡列表
Future<Basic> cashBankCardList(Map reqdata) async {
  try {
    Response<dynamic> res =
        await PlatformAwareHttp.post('/api/user/list_bankcard', data: reqdata);
    return Basic.fromJson(res.data);
  } catch (e) {
    return null;
  }
}

///提现  删除银行卡
Future<Basic> cashDeleteBankCard(Map reqdata) async {
  try {
    Response<dynamic> res =
        await PlatformAwareHttp.post('/api/user/del_bankcard', data: reqdata);
    return Basic.fromJson(res.data);
  } catch (e) {
    return null;
  }
}

///提现  申请提现
Future<Basic> cashApplyWithdraw(Map reqdata) async {
  try {
    Response<dynamic> res =
        await PlatformAwareHttp.post('/api/order/withdraw', data: reqdata);
    return Basic.fromJson(res.data);
  } catch (e) {
    return null;
  }
}

///提现  收益 申请提现
Future<Basic> incomeApplyWithdraw(Map reqdata) async {
  try {
    Response<dynamic> res =
        await PlatformAwareHttp.post('/api/order/withdraw', data: reqdata);
    CommonUtils.debugPrint(res.data);
    return Basic.fromJson(res.data);
  } catch (e) {
    return null;
  }
}

///提现 规则
Future<Basic> cashWithdrawRule(Map reqdata) async {
  try {
    Response<dynamic> res =
        await PlatformAwareHttp.post('/api/withdraw/index', data: reqdata);
    CommonUtils.debugPrint(res.data);
    return Basic.fromJson(res.data);
  } catch (e) {
    return null;
  }
}

///提现  提现列表
Future<Basic> cashWithdrawList(Map reqdata) async {
  try {
    Response<dynamic> res =
        await PlatformAwareHttp.post('/api/order/listWithdraw', data: reqdata);
    return Basic.fromJson(res.data);
  } catch (e) {
    return null;
  }
}

/// 获取签到数据
Future<Basic> getSignData() async {
  try {
    Response<dynamic> res =
        await PlatformAwareHttp.post('/api/sign/list', data: {});
    return Basic.fromJson(res.data);
  } catch (e) {
    return null;
  }
}

/// 签到
Future<Basic> userSign(Map reqdata) async {
  try {
    Response<dynamic> res =
        await PlatformAwareHttp.post('/api/sign/sign', data: reqdata);
    return Basic.fromJson(res.data);
  } catch (e) {
    return null;
  }
}

/// 新人福利
Future<Basic> signLiskTask() async {
  try {
    Response<dynamic> res = await PlatformAwareHttp.post('/api/sign/list_task');
    return Basic.fromJson(res.data);
  } catch (e) {
    return null;
  }
}

/// 新人福利 领取
Future<Basic> signLiskTaskAccept(Map reqdata) async {
  try {
    Response<dynamic> res =
        await PlatformAwareHttp.post('/api/sign/accept_task', data: reqdata);
    return Basic.fromJson(res.data);
  } catch (e) {
    return null;
  }
}

/// 福利任务
Future<Basic> welfareListTask() async {
  try {
    Response<dynamic> res = await PlatformAwareHttp.post('/api/sign/list_task');
    return Basic.fromJson(res.data);
  } catch (e) {
    return null;
  }
}

/// 漫画更新时间线
Future<Basic> comicTimeLine(Map reqdata) async {
  try {
    Response<dynamic> res =
        await PlatformAwareHttp.post('/api/book/timeline', data: reqdata);
    return Basic.fromJson(res.data);
  } catch (e) {
    return null;
  }
}
