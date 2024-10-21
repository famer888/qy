import 'package:bot_toast/bot_toast.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../domain/api_validator.dart';
import '../../../../domain/async_value.dart';
import '../../../../domain/domain.dart';
import '../../../../domain/enum.dart';
import '../../../../domain/type_def.dart';
import '../../../../domain/model/bit_detail_model.dart';
import '../../../../domain/model/review_data_model.dart';
import '../../../utils/my_toast.dart';
import '../../common_widgets/my_app_bar.dart';
import '../../common_widgets/my_list_view.dart';
import '../../common_widgets/post/comment.dart';
import '../../common_widgets/post/comment_input.dart';
import '../../common_widgets/post/replies_sheet_view.dart';
import '../../common_widgets/screen_background.dart';
import '../../common_widgets/status/loading.dart';
import '../../common_widgets/status/network_error.dart';
import '../../theme.dart';
import 'content.dart';

class BitPostDetailScreen extends StatelessWidget {
  const BitPostDetailScreen({super.key, required this.id});
  final String id;
  @override
  Widget build(BuildContext context) {
    return ScreenBackground(
      child: Scaffold(
        appBar: MyAppBar(
          title: 'zhxq'.tr(context: context),
        ),
        body: _Body(
          id: id,
        ),
      ),
    );
  }
}

class _Body extends StatefulWidget {
  const _Body({required this.id});
  final String id;

  @override
  State<_Body> createState() => _BodyState();
}

class _BodyState extends State<_Body> with WidgetsBindingObserver {
  late final _domain = context.read<SeedDomain>();

  AsyncValue<BitDetail> _asyncValue = const AsyncInit();

  /// 文本框控制器
  final textEditingController = TextEditingController();

  /// 文本框焦点
  final inputFocusNode = FocusNode();

  final hintNotifier = ValueNotifier('');

  ReviewData? currentReply;

  double _viewBottom = 0;

  @override
  void initState() {
    resetInput();
    _init();
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void didChangeMetrics() {
    final newBottom = View.of(context).viewInsets.bottom;
    if (newBottom == 0 && newBottom < _viewBottom) {
      unfocus();
    }
    _viewBottom = newBottom;

    super.didChangeMetrics();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  void resetInput() {
    currentReply = null;
    hintNotifier.value = 'wyddxf'.tr();
    textEditingController.clear();
  }

  void unfocus() {
    inputFocusNode.unfocus();
    resetInput();
  }

  /// 取得种子详情
  Future<void> _init() async {
    if (_asyncValue.isLoading) return;
    setState(() {
      _asyncValue = const AsyncLoading();
    });

    final result = await _domain.bitTopicDetail(id: widget.id);

    if (result.data case final data?) {
      _asyncValue = AsyncData(data);
    } else {
      _asyncValue = AsyncError(error: result.msg);
    }

    if (mounted) {
      setState(() {});
    }
  }

  /// 取得评论
  Future<List<ReviewData>?> getReviewData(
      {required int currentPage, required int pageSize}) async {
    final result = await _domain.bitPostComments(
        id: widget.id, page: currentPage, limit: pageSize);

    if (result.data case final data?) {
      return data;
    }
    MyToast.showText(text: result.msg ?? '');

    return null;
  }

  Future<void> _sendComment({ReviewData? target, required String text}) async {
    if (_asyncValue case AsyncData<BitDetail> data) {
      if (text.trim().isEmpty) {
        MyToast.showText(text: 'qsrnr'.tr(context: context));
        return;
      }
      MyToast.showLoading(text: 'fbioz'.tr(context: context));
      late final String postId;
      late final String commentId;

      if (target?.id case final id?) {
        postId = '0';
        commentId = id.toString();
      } else {
        postId = '${data.value.id}';
        commentId = '0';
      }
      final result = await _domain.bitPostComment(
        postId: postId,
        commentId: commentId,
        content: text,
      );

      BotToast.closeAllLoading();
      MyToast.showText(text: result.msg ?? '');
    }
  }

  Future<bool> _changeCommentLike(String id) async {
    final res = await _domain.bitTopicLike(type: MyLikeType.comment, id: id);
    return res.isValid;
  }

  _showMoreReview(ReviewData comment) async {
    if (inputFocusNode.hasFocus) {
      unfocus();
    }
    if (!mounted) {
      return;
    }

    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      context: context,
      builder: (_) => RepliesSheetView(
        comment: comment,
        onLikeChange: (id) => _changeCommentLike(id),
        commentsAsyncGetter: (int currentPage, int limit) =>
            _domain.bitPostCommentsSecond(
          commentId: '${comment.id}',
          page: currentPage,
          limit: limit,
        ),
        onCommentInputSubmitted: (String value) {
          _sendComment(target: comment, text: value);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _asyncValue.maybeWhen(
      data: (data) {
        return GestureDetector(
          onTap: () {
            unfocus();
          },
          child: Column(
            children: [
              Expanded(
                child: MyListView.list(
                  header: BitDetailContentView(
                    data: data,
                  ),
                  padding: EdgeInsets.symmetric(
                    vertical: 5.w,
                    horizontal: MyTheme.pagePadding,
                  ),
                  itemBuilder: (context, item, index) {
                    return PostCommentView(
                      commentData: item,
                      onReply: () {
                        currentReply = item;
                        hintNotifier.value =
                            '${'hf'.tr()}@${item.user?.nickname ?? ""}';
                        inputFocusNode.requestFocus();
                      },
                      onMoreCommentTap: () => _showMoreReview(item),
                      changeLike: () => _changeCommentLike('${item.id}'),
                    );
                  },
                  onFetchingMore: (currentPage, pageSize) => getReviewData(
                    currentPage: currentPage,
                    pageSize: pageSize,
                  ),
                ),
              ),
              CommentInput(
                controller: textEditingController,
                focusNode: inputFocusNode,
                hintNotifier: hintNotifier,
                onSubmitted: () async {
                  await _sendComment(
                      target: currentReply, text: textEditingController.text);
                  resetInput();
                },
              ),
            ],
          ),
        );
      },
      error: (error, __) => NetworkErrorView(
        text: error is String? ? error : null,
        onTap: _init,
      ),
      orElse: () => const LoadingView(),
    );
  }
}
