import 'package:bot_toast/bot_toast.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:qypj/base/baseWidget.dart';
import 'package:qypj/components/page_status.dart';
import 'package:qypj/components/yy_dialog.dart';
import 'package:qypj/model/basic.dart';
import 'package:qypj/routers.dart';
import 'package:qypj/theme/default.dart';
import 'package:qypj/utils/api.dart';
import 'package:qypj/utils/common.dart';
import 'package:qypj/utils/extensionlibrary.dart';
import 'package:qypj/utils/index.dart';
import 'package:qypj/utils/networkImage.dart';

class MineAgentBankcardListPage extends BaseWidget {
  cState() => _MineAgentBankcardListPageState();
}

class _MineAgentBankcardListPageState
    extends BaseWidgetState<MineAgentBankcardListPage> {
  int page = 1;
  bool isAll = false;
  bool networkErr = false;
  bool isHud = true;
  List _dataList;

  int _selectedIndex = -1;
  List<String> accountTypeList = //["sryh",
      ["srkh", "srxm"];

  List<TextEditingController> _textControllerList = [];
  // List<> accountTypeList = ["sryh", "srkh", "srxm"];

  @override
  void onCreate() async {
    setAppTitle(title: CommonUtils.txt('tx'));

    _textControllerList.add(TextEditingController());
    _textControllerList.add(TextEditingController());

    _getBankList();
  }

  @override
  void onDestroy() {}

  _getBankList() async {
    Map param = {"page": page, "limit": 10};
    try {
      Basic res = await cashBankCardList(param);
      print(res.data);
      isHud = false;
      if (res.status != 1) {
        networkErr = true;
        CommonUtils.showText(res.msg);
      } else {
        if (page == 1) {
          _dataList = res.data['list'];
        } else {
          _dataList.addAll(res.data['list']);
        }

        if (res.data['list'].length < 10) {
          isAll = true;
        }
      }
    } catch (e) {
      networkErr = true;
    }

    setState(() {});
  }

  _addBankCard(BuildContext ctx) async {
    String bankNumber = _textControllerList[0].text;
    String userName = _textControllerList[1].text;

    if (bankNumber.length > 0 && userName.length > 0) {
      BotToast.showLoading();

      Map param = {'card': bankNumber, 'name': userName};

      try {
        Basic res = await cashAddBankCard(param);
        print(res.data);
        if (res.status != 1) {
          CommonUtils.showText(res.msg);
          ctx.pop();
        } else {
          _getBankList();
          ctx.pop();
        }

        _textControllerList[0].clear();
        _textControllerList[1].clear();
        BotToast.closeAllLoading();
      } catch (e) {
        BotToast.closeAllLoading();
      }
      // ctx.pop();
    } else {
      CommonUtils.showText(CommonUtils.txt('qsrxx'));
    }
  }

  _bankcardDeleteIndex(int index) async {
    dynamic card = _dataList[index];
    BotToast.showLoading();
    Map param = {'id': card['id']};

    try {
      Basic res = await cashDeleteBankCard(param);
      print(res.data);
      if (res.status != 1) {
        CommonUtils.showText(res.msg);
      } else {
        _selectedIndex = -1;
        _getBankList();
      }
      BotToast.closeAllLoading();
    } catch (e) {
      BotToast.closeAllLoading();
    }
  }

  _askDeleteIndex(int index) {
    YyShowDialog.showdialog_flj(context,
        backgroundColor: Color(0xff23262f),
        content: (setDialogState) {
          return Center(
            child: Column(
              children: [
                Text(
                  CommonUtils.txt("qrsctxzh"),
                  style: GQStyle.white_13,
                ),
                SizedBox(height: 20),
              ],
            ),
          );
        },
        title: CommonUtils.txt('sfsk'),
        cancelText: CommonUtils.txt('qx'),
        btnText: CommonUtils.txt('sch'),
        callBack: () {
          _bankcardDeleteIndex(index);
        });
  }

  @override
  Widget appbar() {
    return Stack(children: [
      super.appbar(),
      Positioned(
          right: 0,
          bottom: 0,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: GQStyle.pagePadding),
            alignment: Alignment.centerRight,
            height: GQStyle.navbarHegiht,
            child: GestureDetector(
              onTap: () {
                // context.push('/' + Routes.mineAgentProfitListPage);
                showAddBankCardView();
              },
              child: Text(
                CommonUtils.txt('tji'),
                style: GQStyle.gray15,
              ),
            ),
          ))
    ]);
    // TODO: implement appbar
    return super.appbar();
  }

  showAddBankCardView() {
    YyShowDialog.showdialog(
      context,
      backgroundColor: Color(0xff23262f),
      // title: CommonUtils.txt('tjzh'),
      // btnText: CommonUtils.txt('qr'),
      cancelBack: () {},
      content: (setDialogState) {
        return DefaultTextStyle(
          style: GQStyle.gray102_13,
          child: SingleChildScrollView(
              child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    CommonUtils.txt('tjzh'),
                    style: GQStyle.white244_20_M,
                  ),
                ),
                SizedBox(
                  height: ScreenUtil().setWidth(20),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(CommonUtils.txt('zhlx')),
                    Text(CommonUtils.txt('yhk'))
                  ],
                ),
                SizedBox(
                  height: ScreenUtil().setWidth(10),
                ),
                Column(
                  children: accountTypeList
                      .asMap()
                      .keys
                      .map(
                        (index) => SizedBox(
                          height: ScreenUtil().setWidth(50),
                          child: TextField(
                            textAlign: TextAlign.left,
                            controller: _textControllerList[index],
                            // textAlignVertical:
                            // TextAlignVertical.bottom,
                            style: GQStyle.white15bold,
                            cursorColor: Colors.white,
                            keyboardType: index == 0
                                ? TextInputType.number
                                : TextInputType.text,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: ScreenUtil()
                                      .setWidth(GQStyle.pagePadding)),
                              hintText: CommonUtils.txt(accountTypeList[index]),
                              hintStyle: GQStyle.hexb3b3b3_15_M,
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                    ScreenUtil().setWidth(5)),
                                borderSide: BorderSide(
                                    color: Color.fromRGBO(153, 153, 153, 1)),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                    ScreenUtil().setWidth(5)),
                                borderSide: BorderSide(
                                    color: Color.fromRGBO(153, 153, 153, 1)),
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList()
                      .map((e) => Column(
                            children: [
                              e,
                              SizedBox(
                                height: ScreenUtil().setWidth(20),
                              ),
                            ],
                          ))
                      .toList(),
                ),
                SizedBox(
                  height: ScreenUtil().setWidth(20),
                ),
                GestureDetector(
                  onTap: () {
                    _addBankCard(context);
                  },
                  child: Container(
                    width: double.infinity,
                    height: ScreenUtil().setWidth(40),
                    decoration: BoxDecoration(
                        gradient: GQStyle.btnGradient_ff00edfd_ffbbe954,
                        borderRadius: BorderRadius.all(
                            Radius.circular(ScreenUtil().setWidth(20)))),
                    child: Center(
                      child: Text(
                        CommonUtils.txt('qr'),
                        style: GQStyle.white9255_15,
                      ),
                    ),
                  ),
                )
              ],
            ),
          )),
        );
      },
    );
  }

  @override
  pageBody(BuildContext context) {
    return networkErr
        ? PageStatus.noNetWork
        : isHud
            ? PageStatus.loading(mounted)
            : _dataList.length == 0
                ? Container(
                    child: Stack(
                    children: [
                      Positioned.fill(child: PageStatus.noData()),
                      SafeArea(
                          child: Container(
                        alignment: Alignment.bottomCenter,
                        margin:
                            EdgeInsets.only(bottom: ScreenUtil().setWidth(20)),
                        child: GestureDetector(
                          onTap: () {
                            showAddBankCardView();
                          },
                          child: Container(
                            alignment: Alignment.center,
                            width: ScreenUtil().setWidth(324),
                            height: ScreenUtil().setWidth(40),
                            decoration: BoxDecoration(
                                gradient: GQStyle.btnGradient_ff00edfd_ffbbe954,
                                borderRadius: BorderRadius.circular(
                                    ScreenUtil().setWidth(5))),
                            child: Text(
                              CommonUtils.txt('tjxzh'),
                              style: GQStyle.white234_15_M,
                            ),
                          ),
                        ),
                      ))
                    ],
                  ))
                : Container(
                    // padding: EdgeInsets.symmetric(horizontal: GQStyle.pagePadding),
                    child: Stack(
                      children: [
                        Positioned.fill(
                            child: SingleChildScrollView(
                          physics: AlwaysScrollableScrollPhysics(),
                          child: Column(
                            children: _dataList.asMap().keys.map((index) {
                              dynamic data = _dataList[index];
                              return Container(
                                  padding: EdgeInsets.only(
                                      bottom: GQStyle.pagePadding),
                                  child: MineBankCardWidget(
                                    data,
                                    selected: _selectedIndex == index,
                                    onTap: () {
                                      if (_selectedIndex != index) {
                                        _selectedIndex = index;
                                        setState(() {});
                                      }
                                    },
                                    onAskDelete: () {
                                      _askDeleteIndex(index);
                                    },
                                    index: index,
                                  ));
                            }).toList(),
                          ),
                        )),
                        SafeArea(
                            child: Container(
                          alignment: Alignment.bottomCenter,
                          margin: EdgeInsets.only(
                              bottom: ScreenUtil().setWidth(20)),
                          child: Offstage(
                            child: GestureDetector(
                              onTap: () {
                                EventBus().emit('cash_choose_bankcard',
                                    _dataList[_selectedIndex]);
                                context.pop();
                              },
                              child: Container(
                                alignment: Alignment.center,
                                width: ScreenUtil().setWidth(328),
                                height: ScreenUtil().setWidth(44),
                                decoration: BoxDecoration(
                                    gradient:
                                        GQStyle.btnGradient_ff00edfd_ffbbe954,
                                    borderRadius: BorderRadius.circular(
                                        ScreenUtil().setWidth(44 / 2))),
                                child: Text(
                                  CommonUtils.txt('qrtz'),
                                  style: GQStyle.white234_15_M,
                                ),
                              ),
                            ),
                            offstage: _selectedIndex < 0,
                          ),
                        ))
                      ],
                    ),
                  );
  }
}

class MineBankCardWidget extends StatelessWidget {
  MineBankCardWidget(this.data,
      {this.selected = true, this.index = 0, this.onTap, this.onAskDelete});
  dynamic data;
  bool selected = false;
  int index;
  void Function() onTap;
  void Function() onAskDelete;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Row(
          children: [
            Container(
              width: ScreenUtil().setWidth(50),
              child: Center(
                child: Container(
                  width: ScreenUtil().setWidth(25),
                  height: ScreenUtil().setWidth(25),
                  decoration: selected
                      ? BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color.fromRGBO(109, 239, 220, 1),
                              Color.fromRGBO(96, 178, 220, 1)
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius:
                              BorderRadius.circular(ScreenUtil().setWidth(25)))
                      : BoxDecoration(
                          color: Colors.transparent,
                        ),
                  child: selected
                      ? Icon(
                          Icons.check,
                          color: Colors.white,
                        )
                      : SizedBox.square(
                          dimension: ScreenUtil().setWidth(25),
                          child: Icon(
                            Icons.circle_outlined,
                            color: Color(0xFF67e0b9),
                          ),
                        ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                  margin: EdgeInsets.symmetric(horizontal: GQStyle.pagePadding),
                  // padding: EdgeInsets.only(
                  //     left: GQStyle.pagePadding,
                  //     top: GQStyle.pagePadding,
                  //     bottom: GQStyle.pagePadding),
                  height: ScreenUtil().setWidth(110),
                  width: double.infinity,
                  child: Stack(children: [
                    Positioned.fill(
                        child: Container(
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(ScreenUtil().setWidth(10)),
                          gradient: LinearGradient(
                            colors: [
                              Color.fromRGBO(102, 58, 226, 1),
                              Color.fromRGBO(117, 126, 247, 1)
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          )),
                      width: double.infinity,
                      height: double.infinity,
                      // child: LImage(
                      //   ['bcr', 'bcb', 'bco'][index % 3],
                      //   fit: BoxFit.cover,
                      // ),
                    )),
                    Container(
                        width: double.infinity,
                        height: double.infinity,
                        margin: EdgeInsets.only(
                            left: GQStyle.pagePadding,
                            top: GQStyle.pagePadding,
                            bottom: GQStyle.pagePadding),
                        child: Stack(
                          children: [
                            // Positioned.fill(
                            //     child: Container(
                            //   width: double.infinity,
                            //   height: double.infinity,
                            //   child: LImage(
                            //     ['bcr', 'bcb', 'bco'][index % 3],
                            //     fit: BoxFit.cover,
                            //   ),
                            // )),
                            Positioned.fill(
                                child: Row(
                              children: [
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  // crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Container(
                                      width: ScreenUtil().setWidth(235),
                                      height: ScreenUtil().setWidth(10),
                                      // constraints: BoxConstraints(
                                      //   minWidth: ScreenUtil().setWidth(100),
                                      //   maxWidth: ScreenUtil().setWidth(100),
                                      // ),
                                      child: FittedBox(
                                        fit: BoxFit.cover,
                                        child: Text(
                                          subStringFour('${data['card']}'),
                                          style: GQStyle.white19_semi,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: ScreenUtil().setWidth(235),

                                      // constraints: BoxConstraints(
                                      //     minWidth: ScreenUtil().setWidth(100)),
                                      child: Row(
                                        // mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            '${data['bank']}',
                                            style: GQStyle.white9255_15,
                                          ),
                                          // Text(
                                          //   '${data['card_type']}' +
                                          //       '|' +
                                          //       '${data['name']}',
                                          //   style: GQStyle.white11,
                                          // ),
                                          // Expanded(
                                          //   child: Container(
                                          //     width: 50,
                                          //     color: Colors.red,
                                          //   ),
                                          // ),
                                          Text(
                                            '持卡人: ' + '${data['name']}',
                                            style: GQStyle.white255_12_M,
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                Expanded(
                                    child: Container(
                                  // color: Colors.red,
                                  child: Center(
                                    child: GestureDetector(
                                      onTap: onAskDelete,
                                      child: LImage(
                                        'shch',
                                        width: ScreenUtil().setWidth(16),
                                        height: ScreenUtil().setWidth(16),
                                      ),
                                    ),
                                  ),
                                ))
                              ],
                            )),
                            // Positioned.fill(
                            //     right: 0,
                            //     child: Align(
                            //       alignment: Alignment.centerRight,
                            //       child: ClipPath(
                            //         clipper: MyClipper(),
                            //         child: Container(
                            //           width: ScreenUtil().setWidth(41),
                            //           height: ScreenUtil().setWidth(57),
                            //           decoration: BoxDecoration(
                            //               borderRadius: BorderRadius.only(
                            //                   topLeft: Radius.circular(
                            //                       ScreenUtil().setWidth(5)),
                            //                   topRight: Radius.circular(
                            //                       ScreenUtil().setWidth(5))),
                            //               color: selected
                            //                   ? Colors.white
                            //                   : Colors.white.withAlpha(
                            //                       (255 * 0.6).toInt())),
                            //           child: Row(
                            //             children: [
                            //               SizedBox(
                            //                 width: ScreenUtil().setWidth(9),
                            //               ),
                            //               SizedBox.square(
                            //                   dimension:
                            //                       ScreenUtil().setWidth(20),
                            //                   child: Container(
                            //                     decoration: BoxDecoration(
                            //                       borderRadius:
                            //                           BorderRadius.circular(
                            //                               ScreenUtil()
                            //                                   .setWidth(10)),
                            //                       color: selected
                            //                           ? Color.fromRGBO(
                            //                               44, 45, 89, 1)
                            //                           : Colors.black.withAlpha(
                            //                               (255 * 0.2).toInt()),
                            //                     ),
                            //                     child: selected
                            //                         ? Icon(
                            //                             Icons.check,
                            //                             color: Colors.white,
                            //                             size: ScreenUtil()
                            //                                 .setWidth(10),
                            //                           )
                            //                         : Container(),
                            //                   ))
                            //             ],
                            //           ),
                            //         ),
                            //       ),
                            //     ))
                          ],
                        ))
                    // ))
                    // ]
                  ])),
            ),
          ],
        ));
  }
}

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    // double roundFactor = size.width;
    path.moveTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.quadraticBezierTo(-size.width, size.height / 2.0, size.width, 0);
    // path.lineTo(0, size.height / 3.3);

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}

///把String分隔成4个字符一段的
String subStringFour(String text) {
  String str = '';
  int index = 1;
  for (var character in text.characters) {
    str += character;
    if (index % 4 == 0) {
      str += ' ';
    }
    index += 1;
  }
  str = str.trim();
  return str;
}
