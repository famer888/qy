import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:qypj/model/homedata.dart';
import 'package:qypj/store/homeConfig.dart';
import 'package:qypj/theme/default.dart';
import 'package:qypj/utils/common.dart';
import 'package:qypj/utils/networkImage.dart';

class InputCommentBox extends StatelessWidget {
  InputCommentBox({
    this.child,
    this.onEditingCompleteText,
    this.labelText,
    this.focusNode,
    this.bg = const Color(0xFF232337),
  });
  final Color bg;
  final Widget child;
  final String labelText;
  final FocusNode focusNode;
  final TextEditingController controller = TextEditingController();
  final ValueChanged onEditingCompleteText;

  @override
  Widget build(BuildContext context) {
    Member member = Provider.of<HomeConfig>(context, listen: false).member;
    return Container(
      child: Column(
        children: [
          Expanded(child: child),
          Divider(height: 1),
          Container(
            color: bg,
            child: ListTile(
              leading: Container(
                height: 40.0,
                width: 40.0,
                child: PlatformAwareNetworkImage(
                  url: member.thumb ?? "",
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                  background: GQStyle.bgColor,
                ),
              ),
              title: TextField(
                focusNode: focusNode,
                controller: controller,
                style: GQStyle.white255_15,
                cursorColor: Color.fromRGBO(255, 255, 255, 1),
                decoration: InputDecoration(
                  hintText: labelText,
                  hintStyle: GQStyle.gray109_15,
                  isDense: true,
                  contentPadding: EdgeInsets.all(5),
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
                onSubmitted: (ss) {
                  // CommonUtils.showText("test 1111");
                },
              ),
              trailing: GestureDetector(
                onTap: () {
                  focusNode.unfocus();
                  onEditingCompleteText(controller.text);
                },
                child:
                    Icon(Icons.send_sharp, size: 30, color: Color(0xFF7fecfe)),
              ),
            ),
          )
        ],
      ),
    );
  }
}
