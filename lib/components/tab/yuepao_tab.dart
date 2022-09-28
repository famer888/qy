import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

typedef void YuepaoTabFunction(String vlue);

class YuepaoTab extends StatefulWidget {
  YuepaoTab({Key key, this.tabList, this.tabKey, this.onTap}) : super(key: key);
  final List tabList;
  final String tabKey;
  final YuepaoTabFunction onTap;
  @override
  _YuepaoTabState createState() => _YuepaoTabState();
}

class _YuepaoTabState extends State<YuepaoTab> {
  String currentTab = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentTab = widget.tabList[0]['value'];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil().setWidth(30),
      padding: EdgeInsets.only(left: ScreenUtil().setWidth(13.5)),
      margin: EdgeInsets.only(top: ScreenUtil().setWidth(20)),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: widget.tabList
            .asMap()
            .keys
            .map((e) => GestureDetector(
                  onTap: () {
                    currentTab = widget.tabList[e]['value'];
                    widget.onTap(widget.tabList[e]['value']);
                    setState(() {});
                  },
                  child: Container(
                    height: ScreenUtil().setWidth(30),
                    padding: EdgeInsets.symmetric(
                        horizontal: ScreenUtil().setWidth(16)),
                    decoration: BoxDecoration(
                        gradient: currentTab == widget.tabList[e]['value']
                            ? LinearGradient(
                                colors: [
                                  Color(0xfff36f65),
                                  Color(0xffff6c49),
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              )
                            : null,
                        borderRadius:
                            BorderRadius.circular(ScreenUtil().setWidth(15))),
                    child: Center(
                      child: Text(
                        widget.tabList[e]['name'],
                        style: TextStyle(
                            color: currentTab == widget.tabList[e]['value']
                                ? Colors.white
                                : Color(0xff323232),
                            fontSize: ScreenUtil().setSp(14)),
                      ),
                    ),
                  ),
                ))
            .toList(),
      ),
    );
  }
}
