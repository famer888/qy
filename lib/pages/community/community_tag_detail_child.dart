import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qypj/components/common/pullrefreshlist.dart';
import 'package:qypj/components/page_status.dart';
import 'package:qypj/pages/community/community_post.dart';
import 'package:qypj/theme/default.dart';
import 'package:qypj/utils/api.dart';

class CommunityTagDetailChild extends StatefulWidget {
  CommunityTagDetailChild({Key key, this.topic_id, this.cate})
      : super(key: key);
  final String topic_id;
  final String cate;

  @override
  State<CommunityTagDetailChild> createState() =>
      _CommunityTagDetailChildState();
}

class _CommunityTagDetailChildState extends State<CommunityTagDetailChild> {
  int page = 1;
  bool noMore = false;
  bool networkErr = false;
  bool isHud = true;
  List<dynamic> data = [];

  @override
  void initState() {
    super.initState();
    _getData();
  }

  _getData() {
    communityListTopicPost(
            topic_id: widget.topic_id, cate: widget.cate, page: page)
        .then((res) {
      if (res.data == null) {
        networkErr = true;
        setState(() {});
        return;
      }
      List st = res.data;
      if (page == 1) {
        noMore = false;
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
    return Container(
      color: Colors.transparent,
      child: networkErr
          ? PageStatus.noNetWork(onTap: () {
              networkErr = false;
              _getData();
            })
          : isHud
              ? PageStatus.loading(mounted)
              : data.length == 0
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
                          padding: EdgeInsets.symmetric(
                              vertical: ScreenUtil().setWidth(10)),
                          itemCount: 1, //帖子
                          itemBuilder: (context, index) {
                            return CommunityPost(
                              data: data,
                              noHead: true,
                              replace: true,
                            );
                          }),
                    ),
    );
  }
}
