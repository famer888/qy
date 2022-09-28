// import 'package:bot_toast/bot_toast.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:qypj/base/baseWidget.dart';
// import 'package:qypj/components/common/pullrefreshlist.dart';
// import 'package:qypj/components/page_status.dart';
// import 'package:qypj/global.dart';
// import 'package:qypj/model/basic.dart';
// import 'package:qypj/theme/default.dart';
// import 'package:qypj/utils/api.dart';
// import 'package:qypj/utils/common.dart';
// import 'package:qypj/utils/extensionlibrary.dart';
// import 'package:qypj/utils/networkImage.dart';

// class MoreAndMoreComc extends BaseWidget {
//   MoreAndMoreComc({Key key, this.id}) : super(key: key);
//   String id = "0";

//   @override
//   State<StatefulWidget> cState() {
//     // TODO: implement cState
//     return _MoreAndMoreComcState();
//   }
// }

// class _MoreAndMoreComcState extends BaseWidgetState<MoreAndMoreComc> {
//   int page = 1;
//   bool isHud = true;
//   List<dynamic> values = [];
//   bool noMore = false;
//   bool netWorkErr = false;
//   List<dynamic> selecteds = [];
//   String sort = "new";
//   String type = "";
//   String categories = "";

//   @override
//   void onCreate() {
//     // TODO: implement onCreate
//     setAppTitle(title: CommonUtils.txt("manh"));
//     _getClasses();
//   }

//   @override
//   void onDestroy() {
//     // TODO: implement onDestroy
//   }

//   _getClasses() async {
//     Basic t = await filtrateStyle();
//     selecteds = t.data;
//     _getData();
//   }

//   _getData({bool showHud = false}) async {
//     if (showHud) CommonUtils.startLoadGIF(tip: CommonUtils.txt("jzz"));
//     Basic t = await comcList(
//         category: categories, type: type, page: page, sort: sort);
//     if (showHud) BotToast.closeAllLoading();
//     if (t.data == null) {
//       netWorkErr = true;
//       setState(() {});
//       return;
//     }
//     if (page == 1) {
//       noMore = false;
//       values = t.data["list"];
//     } else if ((t.data["list"] as List<dynamic>).length > 0) {
//       values.addAll((t.data["list"] as List<dynamic>));
//     } else {
//       noMore = true;
//     }
//     isHud = false;
//     setState(() {});
//   }

//   @override
//   Widget pageBody(BuildContext context) {
//     // TODO: implement pageBody
//     double _w = (ScreenUtil().screenWidth -
//             GQStyle.pagePadding * 2 -
//             ScreenUtil().setWidth(20)) /
//         3;

//     return netWorkErr
//         ? PageStatus.noNetWork(onTap: () {
//             netWorkErr = false;
//             setState(() {});
//             _getData();
//           })
//         : (isHud
//             ? PageStatus.loading(mounted)
//             : Column(
//                 children: [
//                   Column(
//                     children: selecteds.map((e) {
//                       List<dynamic> items = e["items"];
//                       return Column(
//                         children: [
//                           Container(
//                             padding: EdgeInsets.symmetric(
//                                 horizontal: ScreenUtil().setWidth(18)),
//                             height: ScreenUtil().setWidth(30),
//                             child: ListView.builder(
//                                 physics: BouncingScrollPhysics(),
//                                 itemCount: items.length,
//                                 scrollDirection: Axis.horizontal,
//                                 itemBuilder: (context, index) {
//                                   var flag = false;
//                                   if (e["value"] == "sort") {
//                                     flag = sort == items[index]["value"];
//                                   } else if (e["value"] == "type") {
//                                     flag = type == items[index]["value"];
//                                   } else {
//                                     flag = categories == items[index]["value"];
//                                   }
//                                   return Row(children: [
//                                     GestureDetector(
//                                       onTap: () {
//                                         var result = items[index]["value"];
//                                         if (sort == result &&
//                                             type == result &&
//                                             categories == result) return;
//                                         if (e["value"] == "sort") {
//                                           sort = result;
//                                         } else if (e["value"] == "type") {
//                                           type = result;
//                                         } else {
//                                           categories = result;
//                                         }
//                                         page = 1;
//                                         _getData(showHud: true);
//                                       },
//                                       child: Container(
//                                         padding: EdgeInsets.symmetric(
//                                             horizontal: GQStyle.pagePadding),
//                                         decoration: BoxDecoration(
//                                             color: flag
//                                                 ? Color(0xFFff4d0b)
//                                                 : Colors.transparent,
//                                             borderRadius: BorderRadius.all(
//                                                 Radius.circular(15))),
//                                         child: Center(
//                                           child: Text(
//                                             "${items[index]["label"] ?? "loading"}",
//                                             style: flag
//                                                 ? GQStyle.white255_14_M
//                                                 : GQStyle.gray137_14_M,
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                     SizedBox(width: ScreenUtil().setWidth(10))
//                                   ]);
//                                 }),
//                           ),
//                           SizedBox(height: ScreenUtil().setWidth(15))
//                         ],
//                       );
//                     }).toList(),
//                   ),
//                   Expanded(
//                     child: values.length == 0
//                         ? PageStatus.noData()
//                         : PullRefreshList(
//                             isAll: noMore,
//                             onRefresh: () {
//                               page = 1;
//                               _getData();
//                             },
//                             onLoading: () {
//                               page += 1;
//                               _getData();
//                             },
//                             child: GridView.count(
//                               padding: EdgeInsets.symmetric(
//                                   horizontal: GQStyle.pagePadding),
//                               shrinkWrap: true,
//                               crossAxisCount: 3,
//                               mainAxisSpacing: 25,
//                               crossAxisSpacing: 10,
//                               childAspectRatio: 219 / 398,
//                               scrollDirection: Axis.vertical,
//                               children: values
//                                   .map((e) => GestureDetector(
//                                         onTap: () {
//                                           context.push(CommonUtils.getRealHash(
//                                               'comicsdetail/${e["id"] ?? "0"}'));
//                                         },
//                                         child: Stack(
//                                           children: [
//                                             Column(
//                                               crossAxisAlignment:
//                                                   CrossAxisAlignment.start,
//                                               children: [
//                                                 SizedBox(
//                                                   height: _w / 110 * 147,
//                                                   child:
//                                                       PlatformAwareNetworkImage(
//                                                           url: clipImageUrl(
//                                                               CommonUtils
//                                                                   .getThumb(e),
//                                                               inputWidth:
//                                                                   ScreenUtil()
//                                                                       .setWidth(
//                                                                           110)),
//                                                           borderRadius:
//                                                               BorderRadius.all(
//                                                                   Radius
//                                                                       .circular(
//                                                                           5))),
//                                                 ),
//                                                 SizedBox(
//                                                     height: ScreenUtil()
//                                                         .setWidth(10)),
//                                                 Text(e["title"] ?? "loading",
//                                                     style:
//                                                         GQStyle.white255_14_M),
//                                                 SizedBox(
//                                                     height: ScreenUtil()
//                                                         .setWidth(6)),
//                                                 Text(
//                                                   e["finished"] == 1
//                                                       ? "${CommonUtils.txt("wj")} ${CommonUtils.txt("gng")}${e["series"]}${CommonUtils.txt("hua")}"
//                                                       : "${CommonUtils.txt("gxz")}${e["series"]}${CommonUtils.txt("hua")}",
//                                                   style: GQStyle.gray128_11,
//                                                 )
//                                               ],
//                                             ),
//                                             Positioned(
//                                                 right: 0,
//                                                 top: 0,
//                                                 child: CommonUtils.identiWget(e,
//                                                     isHideCoin: true))
//                                           ],
//                                         ),
//                                       ))
//                                   .toList(),
//                             )),
//                   )
//                 ],
//               ));
//   }
// }
