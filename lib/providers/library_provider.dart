import 'dart:io';
import 'package:file_picker/file_picker.dart' hide FileType;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:charavox/models/book.dart';
import 'package:charavox/services/epub_service.dart';
import 'package:charavox/services/txt_service.dart';
import 'package:charavox/services/cache_service.dart';
import 'package:charavox/core/utils/hash_utils.dart';

final libraryProvider =
    StateNotifierProvider<LibraryNotifier, List<Book>>((ref) {
  return LibraryNotifier();
});

class LibraryNotifier extends StateNotifier<List<Book>> {
  LibraryNotifier() : super([]);

  final _epubService = EpubService();
  final _txtService = TxtService();
  final _cacheService = CacheService();

  Future<({Book book, List<Chapter> chapters})?> importBook() async {
    final result = await FilePicker.platform.pickFiles(
      allowedExtensions: ['epub', 'txt'],
    );
    if (result == null || result.files.isEmpty) return null;

    final filePath = result.files.first.path!;
    final extension = filePath.split('.').last.toLowerCase();

    final (book, chapters) = switch (extension) {
      'epub' => await _epubService.parse(filePath),
      'txt' => _txtService.parse(filePath),
      _ => throw Exception('不支持的文件格式: $extension'),
    };

    final fileSize = File(filePath).lengthSync();
    final hash = computeBookHash(filePath, fileSize);
    final bookWithId = book.copyWith(id: hash);

    state = [...state, bookWithId];
    return (book: bookWithId, chapters: chapters);
  }

  void removeBook(String bookId) {
    state = state.where((b) => b.id != bookId).toList();
    _cacheService.clearBookCache(bookId);
  }
}
