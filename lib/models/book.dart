import 'package:freezed_annotation/freezed_annotation.dart';

part 'book.freezed.dart';
part 'book.g.dart';

enum FileType { epub, txt }

@freezed
class Book with _$Book {
  const factory Book({
    required String id,
    required String title,
    String? author,
    String? coverPath,
    required String filePath,
    required FileType fileType,
    required int chapterCount,
    required DateTime addedAt,
    DateTime? lastOpenedAt,
  }) = _Book;

  factory Book.fromJson(Map<String, dynamic> json) => _$BookFromJson(json);
}

@freezed
class Chapter with _$Chapter {
  const factory Chapter({
    required int index,
    required String title,
    required String text,
  }) = _Chapter;

  factory Chapter.fromJson(Map<String, dynamic> json) =>
      _$ChapterFromJson(json);
}
