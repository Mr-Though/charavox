import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:charavox/models/book.dart';
import 'package:charavox/screens/settings/settings_screen.dart';
import 'package:charavox/screens/reader/reader_screen.dart';
import 'package:charavox/providers/library_provider.dart';
import 'package:charavox/providers/analysis_provider.dart';
import 'package:charavox/providers/settings_provider.dart';
import 'package:charavox/services/epub_service.dart';
import 'package:charavox/services/txt_service.dart';
import 'package:charavox/services/llm_service.dart';
import 'package:charavox/services/cache_service.dart';

class LibraryScreen extends ConsumerWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final books = ref.watch(libraryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('聆书'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: '导入书籍',
            onPressed: () => _importBook(context, ref),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: '设置',
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (_) => const SettingsScreen(),
              ));
            },
          ),
        ],
      ),
      body: books.isEmpty ? _emptyState() : _bookList(context, books, ref),
    );
  }

  Widget _emptyState() {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.library_books, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text('书架为空', style: TextStyle(fontSize: 18, color: Colors.grey)),
          SizedBox(height: 8),
          Text('点击右上角 + 导入 EPUB 或 TXT 文件',
              style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _bookList(BuildContext context, List<Book> books, WidgetRef ref) {
    return ListView.builder(
      itemCount: books.length,
      itemBuilder: (context, index) {
        final book = books[index];
        return ListTile(
          leading: const Icon(Icons.book, size: 40),
          title: Text(book.title, maxLines: 1, overflow: TextOverflow.ellipsis),
          subtitle: Text('${book.chapterCount} 章 · ${book.fileType.name}'),
          trailing: IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () =>
                ref.read(libraryProvider.notifier).removeBook(book.id),
          ),
          onTap: () => _openBook(context, book, ref),
        );
      },
    );
  }

  Future<void> _importBook(BuildContext context, WidgetRef ref) async {
    final result = await ref.read(libraryProvider.notifier).importBook();
    if (result == null || !context.mounted) return;

    final book = result.book;
    final chapters = result.chapters;
    await _analyzeAndOpen(context, ref, book, chapters);
  }

  Future<void> _openBook(
    BuildContext context,
    Book book,
    WidgetRef ref,
  ) async {
    // Re-parse the file
    List<Chapter> chapters;
    if (book.fileType == FileType.epub) {
      final (_, chs) = await EpubService().parse(book.filePath);
      chapters = chs;
    } else {
      final (_, chs) = TxtService().parse(book.filePath);
      chapters = chs;
    }
    if (!context.mounted) return;

    await _analyzeAndOpen(context, ref, book, chapters);
  }

  Future<void> _analyzeAndOpen(
    BuildContext context,
    WidgetRef ref,
    Book book,
    List<Chapter> chapters,
  ) async {
    final cacheService = CacheService();
    final hasCache = await cacheService.hasAnalysis(book.id);

    if (!hasCache) {
      final apiConfig = ref.read(settingsProvider);
      if (apiConfig == null || apiConfig.llmApiKey.isEmpty) {
        if (!context.mounted) return;
        final goSettings = await showDialog<bool>(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('未配置 LLM API'),
            content: const Text('需要先配置 LLM API 才能分析角色。\n是否前往设置？'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('取消'),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('去设置'),
              ),
            ],
          ),
        );
        if (goSettings == true && context.mounted) {
          Navigator.push(context, MaterialPageRoute(
            builder: (_) => const SettingsScreen(),
          ));
        }
        return;
      }

      // Start analysis
      final llmService = LlmService(
        baseUrl: apiConfig.llmBaseUrl,
        apiKey: apiConfig.llmApiKey,
        model: apiConfig.llmModel,
      );

      // Show dialog and wait for analysis to complete
      if (context.mounted) {
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => _AnalysisDialog(
            bookId: book.id,
            book: book,
            chapters: chapters,
            llmService: llmService,
          ),
        );
        // Actual analysis starts inside the dialog
      }
    }

    // Navigate to reader after analysis completes
    if (context.mounted) {
      Navigator.push(context, MaterialPageRoute(
        builder: (_) => ReaderScreen(
          bookId: book.id,
          chapterTitle: chapters.isNotEmpty ? chapters.first.title : '正文',
          chapterText: chapters.isNotEmpty ? chapters.first.text : '',
        ),
      ));
    }
  }
}

class _AnalysisDialog extends ConsumerStatefulWidget {
  final String bookId;
  final Book book;
  final List<Chapter> chapters;
  final LlmService llmService;

  const _AnalysisDialog({
    required this.bookId,
    required this.book,
    required this.chapters,
    required this.llmService,
  });

  @override
  ConsumerState<_AnalysisDialog> createState() => _AnalysisDialogState();
}

class _AnalysisDialogState extends ConsumerState<_AnalysisDialog> {
  @override
  void initState() {
    super.initState();
    _startAnalysis();
  }

  void _startAnalysis() {
    ref.read(analysisProvider(widget.bookId).notifier).analyze(
      book: widget.book,
      chapters: widget.chapters,
      llmService: widget.llmService,
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(analysisProvider(widget.bookId));
    final isDone = state.status == AnalysisStatus.complete ||
        state.status == AnalysisStatus.error;

    return PopScope(
      canPop: isDone,
      child: AlertDialog(
        title: Row(
          children: [
            Expanded(
              child: Text(state.status == AnalysisStatus.discovering
                  ? '正在发现角色...'
                  : isDone
                      ? '分析完成'
                      : '正在分析角色...'),
            ),
            if (isDone)
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!isDone) ...[
              LinearProgressIndicator(value: state.progress),
              const SizedBox(height: 16),
            ],
            Text('第 ${state.chaptersAnalyzed} / ${state.totalChapters} 章'),
            const SizedBox(height: 8),
            if (state.status == AnalysisStatus.complete)
              Text('已识别 ${state.characters.length} 个角色，可开始朗读'),
            if (state.status == AnalysisStatus.error)
              Text(state.errorMessage ?? '分析失败',
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.error)),
          ],
        ),
        actions: isDone
            ? [
                FilledButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('开始阅读'),
                ),
              ]
            : null,
      ),
    );
  }
}
