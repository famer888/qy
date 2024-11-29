import 'package:bot_toast/bot_toast.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../domain/api_validator.dart';
import '../../../../domain/enum.dart';
import '../../../../domain/model/video_comment_model.dart';
import '../../../../domain/remote_domain/domains/mv.dart';
import '../../../utils/my_toast.dart';
import '../../common_widgets/comment_tile.dart';
import '../../common_widgets/my_list_view.dart';
import '../../common_widgets/post/comment_input.dart';
import '../../theme.dart';

class CommentView extends StatefulWidget {
  const CommentView({super.key, required this.id});
  final String id;
  @override
  State<CommentView> createState() => _CommentViewState();
}

class _CommentViewState extends State<CommentView> {
  /// 文本框控制器
  final textEditingController = TextEditingController();

  /// 文本框焦点
  final inputFocusNode = FocusNode();

  final hintNotifier = ValueNotifier('wyddxf'.tr());

  String _lastIx = '';

  late final mvDomain = context.read<MvDomain>();

  Future<List<CommentModel>> _getData({
    required int currentPage,
    required int limit,
  }) async {
    final result = await mvDomain.getVideoCommentList(
      id: widget.id,
      lastIx: _lastIx,
      page: currentPage,
      limit: limit,
    );

    _lastIx = result.data?.lastIx ?? '';

    if (result.msg case final msg? when !result.isValid) {
      MyToast.showText(text: msg);
    }

    return result.data!.list;
  }

  Future<void> _sendComment({required String text}) async {
    if (text.trim().isEmpty) {
      MyToast.showText(text: 'qsrnr'.tr(context: context));
      return;
    }
    MyToast.showLoading(text: 'fbioz'.tr(context: context));
    final result = await mvDomain.sendVideoComment(
      content: text,
      id: widget.id,
    );

    BotToast.closeAllLoading();
    MyToast.showText(text: result.msg ?? '');
    inputFocusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        inputFocusNode.unfocus();
      },
      child: Column(
        children: [
          Expanded(
            child: MyListView.list(
              padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
              itemBuilder: (context, item, index) => CommentTile(
                data: item,
                moduleType: ModuleType.video,
              ),
              onFetchingMore: (currentPage, pageSize) =>
                  _getData(currentPage: currentPage, limit: pageSize),
            ),
          ),
          CommentInput(
            controller: textEditingController,
            focusNode: inputFocusNode,
            hintNotifier: hintNotifier,
            onSubmitted: () async {
              await _sendComment(text: textEditingController.text);
              textEditingController.clear();
            },
          ),
        ],
      ),
    );
  }
}
