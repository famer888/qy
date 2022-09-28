import 'package:flutter/material.dart';
import 'package:qypj/acg_page/home/home_get_element_by_id_second_page.dart';

class HomeMoreAndMorePage extends StatefulWidget {
  HomeMoreAndMorePage({Key key, this.data}) : super(key: key);
  dynamic data;

  @override
  State<StatefulWidget> createState() {
    return _HomeMoreAndMorePageState();
  }
}

class _HomeMoreAndMorePageState extends State<HomeMoreAndMorePage> {
  Widget _page;

  @override
  void initState() {
    super.initState();

    // if (widget.data['more_api'] == '/api/element/getElementByIdSecondPage' ||
    //     true) {
    // Map param = Map.from(widget.data['more_api_params']);
    Map param = {};
    param['id'] = int.parse(widget.data['link_url']);

    _page = HomeGetElementByIdSecondPage(
      param: param,
      contentType: 1,
      title: widget.data['name'],
    );
    // } else {
    //   _page = Container(color: Colors.red);
    // }
  }

  @override
  void onDestroy() {}

  // @override
  // Widget appbar() {
  //   return Container(
  //     height: 20,
  //     color: Colors.white,
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return _page;
  }
}
