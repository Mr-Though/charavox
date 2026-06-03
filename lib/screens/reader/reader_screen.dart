import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'widgets/text_view.dart';

class ReaderScreen extends ConsumerStatefulWidget {
  final String bookId;
  final String chapterTitle;
  final String chapterText;

  const ReaderScreen({
    super.key,
    required this.bookId,
    required this.chapterTitle,
    required this.chapterText,
  });

  @override
  ConsumerState<ReaderScreen> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends ConsumerState<ReaderScreen> {
  final _scrollController = ScrollController();
  int? _highlightedLine;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.chapterTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.people),
            tooltip: '角色管理',
            onPressed: () {
              // TODO: Task 16 — navigate to character list
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: TextView(
              text: widget.chapterText,
              highlightedLineIndex: _highlightedLine,
              scrollController: _scrollController,
            ),
          ),
          Container(
            height: 64,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              border: Border(
                top: BorderSide(color: Theme.of(context).dividerColor),
              ),
            ),
            child: const Center(child: Text('播放控制 (待实现)')),
          ),
        ],
      ),
    );
  }
}
