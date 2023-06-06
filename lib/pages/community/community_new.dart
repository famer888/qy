import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qypj/components/common/pullrefreshlist.dart';
import 'package:qypj/components/page_status.dart';
import 'package:qypj/pages/community/community_post.dart';
import 'package:qypj/pages/community/community_tags.dart';
import 'package:qypj/theme/default.dart';
import 'package:qypj/utils/api.dart';
import 'package:qypj/utils/common.dart';

class CommunityNew extends StatefulWidget {
  CommunityNew({Key key, this.id = 0, this.sort = "new", this.call})
      : super(key: key);
  final int id;
  final String sort;
  final Function(dynamic) call;

  @override
  State<CommunityNew> createState() => _CommunityNewState();
}

class _CommunityNewState extends State<CommunityNew> {
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
    communitySortList(id: widget.id, sort: widget.sort, page: page).then((res) {
      if (res.data == null) {
        networkErr = true;
        setState(() {});
        return;
      }
      List st = List.from(res.data["posts"] ?? []);
      if (page == 1) {
        noMore = false;
        topics = res.data["topics"];
        data = st;
        if (widget.call != null) widget.call(res.data);
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
            : data.isEmpty
                ? PageStatus.noData()
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
                        itemCount: 1, //标签+帖子
                        itemBuilder: (context, index) {
                          // if (topics.length > 0 && index == 0) {
                          //   return CommunityTags(data: topics);
                          // }
                          return CommunityPost(data: data, showHead: false);
                        }),
                  );
  }
}
