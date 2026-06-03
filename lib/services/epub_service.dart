import 'dart:io';
import 'package:epub_pro/epub_pro.dart';
import 'package:charavox/models/book.dart';
import 'package:charavox/core/errors/app_exceptions.dart';

class EpubService {
  Future<(Book, List<Chapter>)> parse(String filePath) async {
    try {
      final bytes = await File(filePath).readAsBytes();
      final epubBook = await EpubReader.readBook(bytes);
      final title = epubBook.title ?? _extractFileName(filePath);
      final author = epubBook.author;

      final chapters = <Chapter>[];
      int index = 0;

      for (final ch in epubBook.chapters) {
        final text = _stripHtml(ch.htmlContent ?? '');
        if (text.trim().isEmpty) continue;

        chapters.add(Chapter(
          index: index,
          title: ch.title ?? '第${index + 1}章',
          text: text,
        ));
        index++;
      }

      final book = Book(
        id: '',
        title: title,
        author: author,
        coverPath: null,
        filePath: filePath,
        fileType: FileType.epub,
        chapterCount: chapters.length,
        addedAt: DateTime.now(),
      );

      return (book, chapters);
    } catch (e) {
      if (e is AppException) rethrow;
      throw EpubParseException(
        'EPUB 解析失败: ${e.toString()}',
        originalError: e,
      );
    }
  }

  String _extractFileName(String filePath) {
    final segments = filePath.split('/').last.split('\\').last;
    return segments.replaceAll(RegExp(r'\.[^.]+$'), '');
  }

  String _stripHtml(String html) {
    final noTags = html.replaceAll(RegExp(r'<[^>]*>'), '');
    return noTags
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&amp;', '&')
        .replaceAll('&quot;', '"')
        .trim();
  }
}
