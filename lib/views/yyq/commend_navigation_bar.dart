import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qypj/global.dart';
import 'package:qypj/theme/default.dart';
import 'package:qypj/utils/common.dart';
import 'package:qypj/utils/extensionlibrary.dart';
import 'package:qypj/utils/index.dart';
import 'package:qypj/utils/networkImage.dart';

/// TYPE_18 => '其他-导航',
class CommendNavigationBar extends StatelessWidget {
  CommendNavigationBar({Key key, this.data}) : super(key: key);
  dynamic data;

  List textColors = [
    Color.fromRGBO(214, 160, 96, 1),
    Color.fromRGBO(235, 70, 62, 1),
    Color.fromRGBO(153, 107, 193, 1),
    Color.fromRGBO(103, 92, 216, 1),
  ];

  List bgColors = [
    Color.fromRGBO(78, 48, 19, 1),
    Color.fromRGBO(0, 152, 230, 1),
    Color.fromRGBO(132, 87, 225, 1),
    Color.fromRGBO(103, 71, 173, 1),
  ];

  double mainHeight() {
    List values = data['value'];

    int count = values.length;

    int row = count ~/ 4;

    row += count % 4 > 0 ? 1 : 0;
    double rowHeight = ScreenUtil().setWidth(35);
    double rowMargin = ScreenUtil().setWidth(10);

    double height =
        rowHeight * row + rowMargin * (row - 1) + ScreenUtil().setWidth(10) * 2;
    return height;
  }

  @override
  Widget build(BuildContext context) {
    List values = data['value'];

    // GQStyle.cyanColor00edfd;
    // if (values.length < 6) {
    //   values.add({'name': '22222'});
    // }

    return Container(
        // color: Colors.red,
        // margin: EdgeInsets.only(bottom: ScreenUtil().setWidth(10)),
        padding: EdgeInsets.only(
          top: ScreenUtil().setWidth(10),
          left: GQStyle.pagePadding,
          right: GQStyle.pagePadding,
          bottom: ScreenUtil().setWidth(10),
        ),
        child: Column(
          children: [
            GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: values.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    childAspectRatio: 80 / 35,
                    mainAxisSpacing: ScreenUtil().setWidth(10),
                    crossAxisSpacing: ScreenUtil().setWidth(10)),
                itemBuilder: (context, index) {
                  dynamic e = values[index];

                  return GestureDetector(
                    onTap: () {
                      if (e['link_url'] == null || e['link_url'].length == 0)
                        return;
                      if (e['redirect_type'] == 1) {
                        String linkUrl = e['link_url'];
                        List urlList = linkUrl.split('??');
                        Map<String, dynamic> pramas = {};
                        if (urlList.first == "ktloadwebview") {
                          pramas["url"] = urlList.last.toString().substring(4);
                          AppGlobal.webExtra = {"url": pramas.values.first};
                          if (kIsWeb) {
                            CommonUtils.launchURL(Uri.decodeComponent(
                                pramas.values.first.trim()));
                          } else {
                            context.push("/${urlList[0]}");
                          }
                        } else {
                          if (urlList.length > 1 && urlList.last != "") {
                            urlList[1].split("&").forEach((item) {
                              List stringText = item.split('=');
                              pramas[stringText[0]] =
                                  stringText.length > 1 ? stringText[1] : null;
                            });
                          }
                          String pramasStrs = "";
                          if (pramas.values.length > 0) {
                            pramas.forEach((key, value) {
                              pramasStrs += "/${value}";
                            });
                          }
                          context.push("/${urlList[0]}${pramasStrs}");
                        }
                      } else if (e['redirect_type'] == 2) {
                        CommonUtils.launchURL(e['link_url'].trim());
                      } else if (e['redirect_type'] == 3) {
                        if (e['open_type'] == 0) {
                          EventBus().emit('IndexNavTapItem', e);
                        } else if (e['open_type'] == 1) {
                          print('');
                          context.push('/more_and_more_page', extra: e);
                        }
                      }

                      // EventBus().emit('IndexNavTapItem', e);
                      // context.push(CommonUtils.getRealHash(e['router']));
                    },
                    child: ClipRRect(
                      borderRadius:
                          BorderRadius.circular(ScreenUtil().setWidth(2)),
                      child: Container(
                          height: ScreenUtil().setWidth(35),
                          // padding:EdgeInsets.symmetric(
                          //     hori zontal: ScreenUtil().setWidth(19)),
                          // decoration: BoxDecoration(color: bgColors[index % 4]),
                          child: Stack(
                            children: [
                              // Positioned.fill(
                              //     child: PlatformAwareNetworkImage(
                              //   url: e['resource_url'],
                              // )),
                              // e['resource_url'] != null &&
                              //         e['resource_url'].length > 0
                              //     ? Container()
                              //     :
                              Positioned.fill(
                                  child: Container(
                                      width: double.infinity,
                                      height: double.infinity,
                                      color: Color(0xff262631))),
                              Center(
                                child: Text(e["name"],
                                    style: TextStyle(
                                        color: Colors
                                            .white, // textColors[index % 4],
                                        fontSize: ScreenUtil().setSp(13),
                                        overflow: TextOverflow.ellipsis,
                                        decoration: TextDecoration.none)),
                              ),
                            ],
                          )),
                    ),
                  );
                }),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceAround,
            //   children: List.from(values)
            //       .asMap()
            //       .keys
            //       .map(
            //         (index) => Builder(builder: (context) {
            //           dynamic e = data['value'][index];

            //           return GestureDetector(
            //             onTap: () {
            //               // context.push('/recentlyupdate');
            //               context.push(CommonUtils.getRealHash(e['router']));

            //               // if (e["title"] == CommonUtils.txt("wj")) {
            //               // } else if (e["title"] == CommonUtils.txt("lz")) {
            //               //   context.push("/more_and_more_nvel/0/serial/0");
            //               // } else if (e["title"] == CommonUtils.txt("rm")) {
            //               //   context.push("/more_and_more_nvel/hot/0/0");
            //               // } else if (e["title"] == CommonUtils.txt("fl")) {
            //               //   context.push("/more_and_more_nvel/0/0/0");
            //               // } else if (e["title"] == CommonUtils.txt("ph")) {
            //               //   if (kDebugMode) {
            //               //     print("******* commend_navigaiton_bar debug here");
            //               //   }
            //               //   context.push("/rank/1/1");
            //               // }
            //             },
            //             child: ClipRRect(
            //               borderRadius:
            //                   BorderRadius.circular(ScreenUtil().setWidth(2)),
            //               child: Container(
            //                   height: ScreenUtil().setWidth(35),
            //                   padding: EdgeInsets.symmetric(
            //                       horizontal: ScreenUtil().setWidth(19)),
            //                   decoration:
            //                       BoxDecoration(color: bgColors[index % 4]),
            //                   child: Center(
            //                     child: Text(e["name"],
            //                         style: TextStyle(
            //                             color: textColors[index % 4],
            //                             fontSize: ScreenUtil().setSp(12),
            //                             overflow: TextOverflow.ellipsis,
            //                             decoration: TextDecoration.none)),
            //                   )),
            //             ),
            //           );
            //         }),
            //       )
            //       .toList(),
            // ),
          ],
        ));
  }
}
