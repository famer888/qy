import 'package:flutter/material.dart';
import 'package:qypj/components/common/pullrefreshlist.dart';
import 'package:qypj/components/page_status.dart';
import 'package:qypj/pages/community/community_post.dart';
import 'package:qypj/pages/community/community_tags.dart';
import 'package:qypj/theme/default.dart';
import 'package:qypj/utils/api.dart';
import 'package:qypj/utils/common.dart';

class CommunityFocus extends StatefulWidget {
  CommunityFocus({Key key}) : super(key: key);

  @override
  State<CommunityFocus> createState() => _CommunityFocusState();
}

class _CommunityFocusState extends State<CommunityFocus> {
  int page = 1;
  bool noMore = false;
  bool networkErr = false;
  bool isHud = true;
  List<dynamic> data = [];
  List<dynamic> topics = [];

  @override
  void initState() {
    super.initState();
    _getData();
  }

  _getData() {
    communityList(cate: "follow", page: page).then((res) {
      if (res.data == null) {
        networkErr = true;
        setState(() {});
        return;
      }
      List st = res.data["posts"];
      CommonUtils.debugPrint("===st==${st.length}");
      if (page == 1) {
        noMore = false;
        topics = res.data["topics"];
        data = st;
      } else if (st.length > 0) {
        data.addAll(st);
      } else {
        noMore = true;
      }
      isHud = false;
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return networkErr
        ? PageStatus.noNetWork(onTap: () {
            networkErr = false;
            _getData();
          })
        : isHud
            ? PageStatus.loading(mounted)
            : PullRefreshList(
                onRefresh: () {
                  page = 1;
                  _getData();
                },
                onLoading: () {
                  page++;
                  _getData();
                },
                isAll: noMore,
                child: ListView.builder(
                    itemCount: 2, //标签+帖子
                    itemBuilder: (context, index) {
                      if (topics.length > 0 && index == 0) {
                        return CommunityTags(data: topics, isMore: false);
                      }
                      return CommunityPost(data: data, showHead: false);
                    }),
              );
  }
}
