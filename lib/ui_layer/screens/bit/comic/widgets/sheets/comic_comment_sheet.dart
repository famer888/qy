import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../../../domain/api_validator.dart';
import '../../../../../../domain/enum.dart';
import '../../../../../../domain/model/video_comment_model.dart';
import '../../../../../../domain/remote_domain/domains/comic.dart';
import '../../../../../../domain/remote_domain/domains/user.dart';
import '../../../../../utils/my_toast.dart';
import '../../../../common_widgets/comment_tile.dart';
import '../../../../common_widgets/localization_text.dart';
import '../../../../common_widgets/my_image.dart';
import '../../../../common_widgets/my_list_view.dart';
import '../../../../common_widgets/post/comment_input.dart';
import '../../../../image_paths.dart';
import '../../../../theme.dart';

class ComicCommentSheetView extends StatefulWidget {
  const ComicCommentSheetView(
      {super.key, required this.id, required this.totalCt});

  final int id;
  final int totalCt;

  @override
  State<ComicCommentSheetView> createState() => ComicCommentSheetViewState();
}

class ComicCommentSheetViewState extends State<ComicCommentSheetView> {
  late final height = 1.sh - 1.sw * 193 / 375;

  late final _domain = context.read<ComicDomain>();

  /// 文本框控制器
  final textEditingController = TextEditingController();

  /// 文本框焦点
  final inputFocusNode = FocusNode();
  final hintNotifier = ValueNotifier('wyddxf'.tr());

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<List<CommentModel>?> _getData({
    required int page,
    required int pageSize,
  }) async {
    final result = await _domain.comicCommentList(
        id: widget.id, page: page, limit: pageSize);
    if (result.isValid) {
      List<CommentModel> tp = List.from(result.data ?? []);
      return tp;
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xff272727),
      height: height,
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Center(
        child: Stack(
          fit: StackFit.expand,
          children: [
            Column(
              children: [
                SizedBox(height: 10.w),
                Text('${'qb'.tr()}${widget.totalCt}${'taoi'.tr()}',
                    style: MyTheme.white18bold),
                SizedBox(height: 10.w),
                Expanded(
                  child: MyListView.list(
                    padding:
                        EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
                    itemBuilder: (context, item, index) => CommentTile(
                      data: item,
                      changeLike: () async {
                        if (item.id case final id?) {
                          final domain = context.read<UserDomain>();

                          final res = await domain.toggleUserCommentLike(
                              id: id, type: MyModuleType.comic);
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
                        _getData(page: currentPage, pageSize: pageSize),
                  ),
                ),
                CommentInput(
                  controller: textEditingController,
                  focusNode: inputFocusNode,
                  hintNotifier: hintNotifier,
                  onSubmitted: () async {
                    await _sendComment(text: textEditingController.text);
                  },
                ),
              ],
            ),
            Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                onTap: () => context.pop(),
                child: Padding(
                  padding: EdgeInsets.all(10.w),
                  child: MyImage.asset(
                    MyImagePaths.appComicClose,
                    height: 25.w,
                    width: 25.w,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _sendComment({required String text}) async {
    late final domain = context.read<ComicDomain>();
    if (text.trim().isEmpty) {
      MyToast.showText(text: 'qsrnr'.tr(context: context));
      return;
    }
    MyToast.showLoading(text: 'fbioz'.tr(context: context));
    final result = await domain.comicComment(
      id: widget.id,
      text: text,
    );
    MyToast.closeAllLoading();
    MyToast.showText(text: result.msg ?? '');

    textEditingController.clear();
    inputFocusNode.unfocus();
  }
}
