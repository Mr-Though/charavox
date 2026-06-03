import 'dart:io';
import 'package:charavox/models/book.dart';
import 'package:charavox/core/utils/text_utils.dart';
import 'package:charavox/core/errors/app_exceptions.dart';

class TxtService {
  (Book, List<Chapter>) parse(String filePath) {
    try {
      final file = File(filePath);
      final bytes = file.readAsBytesSync();
      final encoding = detectEncoding(bytes);
      final content = encoding.decode(bytes);

      final lines = content.split('\n');
      final chapterIndices = findChapterIndices(lines);

      final chapters = <Chapter>[];
      for (int i = 0; i < chapterIndices.length; i++) {
        final start = chapterIndices[i];
        final end = (i + 1 < chapterIndices.length)
            ? chapterIndices[i + 1]
            : lines.length;
        final chapterLines = lines.sublist(start, end);
        final title = chapterLines.first.trim();
        final text = chapterLines.join('\n');

        if (text.trim().isEmpty) continue;

        chapters.add(Chapter(
          index: i,
          title: title.isNotEmpty ? title : '第${i + 1}章',
          text: text,
        ));
      }

      final book = Book(
        id: '',
        title: _extractFileName(filePath),
        author: null,
        coverPath: null,
        filePath: filePath,
        fileType: FileType.txt,
        chapterCount: chapters.length,
        addedAt: DateTime.now(),
      );

      return (book, chapters);
    } catch (e) {
      if (e is AppException) rethrow;
      throw TxtParseException(
        'TXT 解析失败: ${e.toString()}',
        originalError: e,
      );
    }
  }

  String _extractFileName(String filePath) {
    final segments = filePath.split('/').last.split('\\').last;
    return segments.replaceAll(RegExp(r'\.[^.]+$'), '');
  }
}
