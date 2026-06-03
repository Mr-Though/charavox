import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
            onPressed: () {
              // TODO: Task 11 — file_picker integration
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: '设置',
            onPressed: () {
              // TODO: Task 15 — navigate to settings
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
