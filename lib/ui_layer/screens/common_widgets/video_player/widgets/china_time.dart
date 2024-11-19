import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChinaTimeWidget extends StatefulWidget {
  const ChinaTimeWidget({super.key, this.textStyle});

  final TextStyle? textStyle;

  @override
  _ChinaTimeWidgetState createState() => _ChinaTimeWidgetState();
}

class _ChinaTimeWidgetState extends State<ChinaTimeWidget> {
  late DateTime _currentTime;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _currentTime = _getChinaTime();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _currentTime = _getChinaTime();
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  DateTime _getChinaTime() {
    return DateTime.now().toUtc().add(const Duration(hours: 8));
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        DateFormat('yyyy/MM/dd HH:mm:ss').format(_currentTime),
        style: widget.textStyle,
      ),
    );
  }
}
