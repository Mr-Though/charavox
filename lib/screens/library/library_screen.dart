import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:charavox/screens/settings/settings_screen.dart';
import 'package:charavox/screens/reader/reader_screen.dart';
import 'package:charavox/providers/library_provider.dart';

class LibraryScreen extends ConsumerWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('聆书'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: '导入书籍',
            onPressed: () async {
              final result =
                  await ref.read(libraryProvider.notifier).importBook();
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
            },
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
      body: const Center(
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
      ),
    );
  }
}
