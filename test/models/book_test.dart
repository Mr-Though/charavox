import 'package:flutter_test/flutter_test.dart';
import 'package:charavox/models/book.dart';

void main() {
  group('Book', () {
    test('fromJson and toJson round-trip', () {
      final json = {
        'id': 'abc123',
        'title': '测试书籍',
        'author': '测试作者',
        'coverPath': null,
        'filePath': '/tmp/test.epub',
        'fileType': 'epub',
        'chapterCount': 10,
        'addedAt': '2026-06-02T00:00:00.000',
        'lastOpenedAt': null,
      };
      final book = Book.fromJson(json);
      final output = book.toJson();
      expect(output['id'], 'abc123');
      expect(output['title'], '测试书籍');
      expect(output['fileType'], 'epub');
      expect(output['chapterCount'], 10);
    });
  });
}
