import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:charavox/models/book.dart';
import 'package:charavox/screens/settings/settings_screen.dart';
import 'package:charavox/screens/reader/reader_screen.dart';
import 'package:charavox/providers/library_provider.dart';
import 'package:charavox/services/epub_service.dart';
import 'package:charavox/services/txt_service.dart';

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
            onPressed: () => ref.read(libraryProvider.notifier).removeBook(book.id),
          ),
          onTap: () => _openBook(context, book),
        );
      },
    );
  }

  Future<void> _importBook(BuildContext context, WidgetRef ref) async {
    final result = await ref.read(libraryProvider.notifier).importBook();
    if (result != null && context.mounted) {
      Navigator.push(context, MaterialPageRoute(
        builder: (_) => ReaderScreen(
          bookId: result.book.id,
          chapterTitle: result.chapters.isNotEmpty
              ? result.chapters.first.title
              : '正文',
          chapterText: result.chapters.isNotEmpty
              ? result.chapters.first.text
              : '',
        ),
      ));
    }
  }

  Future<void> _openBook(BuildContext context, Book book) async {
    // Re-parse the file to get chapters
    try {
      late List<Chapter> chapters;
      if (book.fileType == FileType.epub) {
        final (_, chs) = await EpubService().parse(book.filePath);
        chapters = chs;
      } else {
        final (_, chs) = TxtService().parse(book.filePath);
        chapters = chs;
      }

      if (context.mounted) {
        Navigator.push(context, MaterialPageRoute(
          builder: (_) => ReaderScreen(
            bookId: book.id,
            chapterTitle: chapters.isNotEmpty ? chapters.first.title : '正文',
            chapterText: chapters.isNotEmpty ? chapters.first.text : '',
          ),
        ));
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('打开失败: $e')),
        );
      }
    }
  }
}
