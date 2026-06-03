import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:charavox/screens/character/character_list_screen.dart';
import 'widgets/text_view.dart';
import 'widgets/playback_bar.dart';

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
              Navigator.push(context, MaterialPageRoute(
                builder: (_) => const CharacterListScreen(characters: []),
              ));
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
          const PlaybackBar(),
        ],
      ),
    );
  }
}
