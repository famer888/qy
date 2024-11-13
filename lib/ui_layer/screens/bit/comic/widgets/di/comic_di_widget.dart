import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../../../domain/domain.dart';
import '../../../../../../domain/remote_domain/domains/comic.dart';
import 'notifier.dart';

class ComicDIWidget extends StatefulWidget {
  const ComicDIWidget({super.key, required this.child});
  final Widget child;

  @override
  State<ComicDIWidget> createState() => _ComicDIWidgetState();
}

class _ComicDIWidgetState extends State<ComicDIWidget> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ComicChangeNotifier(
        context.read<CacheDomain>(),
        context.read<UserDomain>(),
      ),
      child: FixSwipeBackWrapper(child: widget.child),
    );
  }
}

class FixSwipeBackWrapper extends StatelessWidget {
  const FixSwipeBackWrapper({
    super.key,
    required this.child,
  });
  final Widget child;

  bool canPop(BuildContext context) {
    final lastMatch = GoRouter.of(context)
        .routerDelegate
        .currentConfiguration
        .matches
        .lastOrNull;

    if (lastMatch is ShellRouteMatch) {
      return lastMatch.matches.length == 1;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: canPop(context),
      child: child,
    );
  }
}
