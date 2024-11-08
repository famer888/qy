import 'package:bot_toast/bot_toast.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../domain/api_validator.dart';
import '../../../../../../domain/model/video_comment_model.dart';
import '../../../../../../domain/remote_domain/domains/monitor.dart';
import '../../../../../utils/my_toast.dart';
import '../../../../common_widgets/comment_tile.dart';
import '../../../../common_widgets/my_list_view.dart';
import '../../../../common_widgets/post/comment_input.dart';
import '../../../../theme.dart';

class MonitorVideoCommentView extends StatefulWidget {
  const MonitorVideoCommentView({super.key, required this.id});
  final String id;
  @override
  State<MonitorVideoCommentView> createState() =>
      _MonitorVideoCommentViewState();
}

class _MonitorVideoCommentViewState extends State<MonitorVideoCommentView> {
  /// 文本框控制器
  final textEditingController = TextEditingController();

  /// 文本框焦点
  final inputFocusNode = FocusNode();

  final hintNotifier = ValueNotifier('wyddxf'.tr());

  late final monitorDomain = context.read<MonitorDomain>();

  Future<List<CommentModel>?> _getData({
    required int currentPage,
    required int limit,
  }) async {
    final result = await monitorDomain.getMonitorListComment(
      id: int.parse(widget.id),
      page: currentPage,
      limit: limit,
    );

    if (result.msg case final msg? when !result.isValid) {
      MyToast.showText(text: msg);
    }

    return result.data;
  }

  Future<void> _sendComment({required String text}) async {
    if (text.trim().isEmpty) {
      MyToast.showText(text: 'qsrnr'.tr(context: context));
      return;
    }
    MyToast.showLoading(text: 'fbioz'.tr(context: context));
    final result = await monitorDomain.getMonitorComment(
      text: text,
      id: int.parse(widget.id),
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
                changeLike: () async {
                  if (item.id case final id?) {
                    final res =
                        await monitorDomain.toggleMonitorCommentLike(id: id);
                    if (res.isValid) {
                      return true;
                    } else if (res.msg case final msg?) {
                      MyToast.showText(text: msg);
                    }
                  }
                  return false;
                },
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
