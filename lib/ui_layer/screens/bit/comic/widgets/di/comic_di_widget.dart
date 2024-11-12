import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../domain/domain.dart';
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
      child: widget.child,
    );
  }
}
