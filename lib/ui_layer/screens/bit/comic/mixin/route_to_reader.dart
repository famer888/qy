import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../router/routes.dart';
import '../widgets/di/notifier.dart';

mixin RouteToReaderMixin {
  void routeToReader(BuildContext context, index) {
    context.read<ComicChangeNotifier>().setCurrentChapterIndex(index);
    const ComicReaderRoute().push(context);
  }
}
