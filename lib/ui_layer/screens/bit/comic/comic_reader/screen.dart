import 'package:flutter/material.dart';

import '../../../../../domain/model/comic/comic_model.dart';

///漫画阅读界面
class ComicReaderScreen extends StatefulWidget {
  const ComicReaderScreen(
      {super.key, required this.chapterIndex, required this.data});

  final ComicDetailModel data;
  final int chapterIndex;

  @override
  State<ComicReaderScreen> createState() => _ComicReaderScreenState();
}

class _ComicReaderScreenState extends State<ComicReaderScreen> with RouteAware {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
    );
  }
}
