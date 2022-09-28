import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qypj/theme/default.dart';
import 'package:qypj/utils/common.dart';
import 'package:qypj/utils/images_anim.dart';
import 'package:qypj/utils/loading_widget.dart';

class PageStatus {
  //全屏式loding
  static Function showLoading({String text}) {
    return BotToast.showLoading(
        backgroundColor: Colors.black45,
        wrapToastAnimation: (AnimationController animation, fc, Widget child) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Container(
              //   child: LImage(
              //     "load_data_n",
              //     width: ScreenUtil().setWidth(100),
              //     height: ScreenUtil().setWidth(100),
              //     ext: ".gif",
              //   ),
              // ),
              CircularProgressIndicator(
                color: GQStyle.jellyCyanColor103224185,
              ),
              SizedBox(
                height: ScreenUtil().setWidth(15),
              ),
              Text(
                text == null ? '' : text,
                style: GQStyle.gray666_13,
              )
            ],
          );
        });
  }

//列表loding
  static Widget loading(bool mouted, {String text, int width = 100}) {
    if (mouted) {
      return Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // LImage(
            //   "ref_data_loading",
            //   width: ScreenUtil().setWidth(width),
            //   height: ScreenUtil().setWidth(width),
            //   ext: ".gif",
            // ),
// LImage(
            //   "load_data_n",
            //   width: ScreenUtil().setWidth(width),
            //   height: ScreenUtil().setWidth(width),
            //   ext: ".gif",
            // ),
            SizedBox(
              height: ScreenUtil().setWidth(30),
              width: ScreenUtil().setWidth(30),
              child: CircularProgressIndicator(
                color: GQStyle.jellyCyanColor103224185,
                strokeWidth: 2,
              ),
            ),
            SizedBox(
              height: ScreenUtil().setWidth(15),
            ),
            Text(
              text == null ? CommonUtils.txt('zzjzsh') : text,
              style: TextStyle(
                  color: Color(0xff666666),
                  fontSize: ScreenUtil().setSp(12),
                  fontWeight: FontWeight.normal,
                  overflow: TextOverflow.visible,
                  decoration: TextDecoration.none),
            )
          ],
        ),
      );
    } else {
      return Container();
    }
  }

//关闭全屏式loading
  static void closeLoading() {
    return BotToast.closeAllLoading();
  }

//无数据
  static Widget noData({String text, double w = 218}) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: ScreenUtil().setWidth(20)),
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          LImage(
            "nodata_n",
            width: ScreenUtil().setWidth(w),
            fit: BoxFit.fitWidth,
          ),
          SizedBox(
            height: ScreenUtil().setWidth(5),
          ),
          Text(
            text == null ? CommonUtils.txt('zwsj') : text,
            style: GQStyle.gray666_13,
          )
        ],
      ),
    );
  }

//网络错误
  static Widget noNetWork({String text, Function onTap}) {
    return InkWell(
      onTap: () {
        if (onTap != null) {
          onTap();
        }
      },
      child: Container(
        alignment: Alignment.center,
        child: Padding(
          padding: EdgeInsets.only(top: ScreenUtil().setWidth(0)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              LImage(
                'no_network_n',
                width: ScreenUtil().setWidth(206),
                fit: BoxFit.fitWidth,
              ),
              SizedBox(
                height: ScreenUtil().setWidth(5),
              ),
              Text(
                text == null ? CommonUtils.txt('zzsb') : text,
                style: GQStyle.gray666_13,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
