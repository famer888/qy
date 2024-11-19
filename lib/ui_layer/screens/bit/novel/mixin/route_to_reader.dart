import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../router/routes.dart';
import '../di/notifier.dart';

mixin RouteToReaderMixin {
  void routeToReader(BuildContext context, index) {
    context.read<NovelChangeNotifier>().setCurrentChapterIndex(index);
    const NovelReaderRoute().push(context);
  }
}
