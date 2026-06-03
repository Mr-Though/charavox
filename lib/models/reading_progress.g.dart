// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reading_progress.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ReadingProgressImpl _$$ReadingProgressImplFromJson(
  Map<String, dynamic> json,
) => _$ReadingProgressImpl(
  bookId: json['bookId'] as String,
  chapterIndex: (json['chapterIndex'] as num).toInt(),
  lineIndex: (json['lineIndex'] as num).toInt(),
  positionFraction: (json['positionFraction'] as num).toDouble(),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$$ReadingProgressImplToJson(
  _$ReadingProgressImpl instance,
) => <String, dynamic>{
  'bookId': instance.bookId,
  'chapterIndex': instance.chapterIndex,
  'lineIndex': instance.lineIndex,
  'positionFraction': instance.positionFraction,
  'updatedAt': instance.updatedAt.toIso8601String(),
};
