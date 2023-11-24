import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qypj/model/homedata.dart';
import 'package:qypj/store/homeConfig.dart';
import 'package:qypj/theme/default.dart';
import 'package:qypj/utils/common.dart';
import 'package:qypj/utils/networkImage.dart';
import 'package:provider/provider.dart';

class InputContainer extends StatelessWidget {
  InputContainer({
    Key key,
    this.child,
    this.onEditingCompleteText,
    this.onSelectPicComplete,
    this.labelText,
    this.bg = const Color.fromRGBO(21, 21, 42, 1),
  }) : super(key: key);
  final Color bg;
  final Widget child;
  final String labelText;
  final TextEditingController controller = TextEditingController();
  final ValueChanged onEditingCompleteText;
  final Function onSelectPicComplete;

  @override
  Widget build(BuildContext context) {
    Member user = Provider.of<HomeConfig>(context, listen: false).member;
    return Container(
      color: Colors.transparent,
      child: Column(
        children: [
          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                CommonUtils.unFocusNode(context);
              },
              child: child ?? Container(),
            ),
          ),
          const Divider(height: 1),
          Container(
            color: bg,
            child: Column(
              children: [
                ListTile(
                  leading: onSelectPicComplete == null
                      ? SizedBox(
                          height: 30.w,
                          width: 30.w,
                          child: PlatformAwareNetworkImage(
                            url: user?.thumb ?? "",
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.w)),
                          ),
                        )
                      : GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () {
                            CommonUtils.unFocusNode(context);
                            onSelectPicComplete?.call();
                          },
                          child: Icon(Icons.photo,
                              size: 30.w, color: GQStyle.grayColor150),
                        ),
                  title: TextField(
                    controller: controller,
                    style: GQStyle.white14,
                    cursorColor: Colors.white,
                    decoration: InputDecoration(
                      hintText: labelText,
                      hintStyle: GQStyle.gray153_14,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                      border: const OutlineInputBorder(
                        gapPadding: 0,
                        borderSide: BorderSide(
                          width: 0,
                          style: BorderStyle.none,
                        ),
                      ),
                    ),
                    minLines: 1,
                    maxLines: 5,
                    onTap: () {},
                    onSubmitted: (_) {},
                  ),
                  trailing: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      CommonUtils.unFocusNode(context);
                      onEditingCompleteText?.call(controller.text);
                      controller.text = "";
                    },
                    child: Icon(
                      Icons.send,
                      size: 30.w,
                      color: GQStyle.cyanColor00edfd,
                    ),
                  ),
                ),
                SizedBox(height: GQStyle.ipx ? 5.w : 0.w)
              ],
            ),
          )
        ],
      ),
    );
  }
}
