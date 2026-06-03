// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BookImpl _$$BookImplFromJson(Map<String, dynamic> json) => _$BookImpl(
  id: json['id'] as String,
  title: json['title'] as String,
  author: json['author'] as String?,
  coverPath: json['coverPath'] as String?,
  filePath: json['filePath'] as String,
  fileType: $enumDecode(_$FileTypeEnumMap, json['fileType']),
  chapterCount: (json['chapterCount'] as num).toInt(),
  addedAt: DateTime.parse(json['addedAt'] as String),
  lastOpenedAt: json['lastOpenedAt'] == null
      ? null
      : DateTime.parse(json['lastOpenedAt'] as String),
);

Map<String, dynamic> _$$BookImplToJson(_$BookImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'author': instance.author,
      'coverPath': instance.coverPath,
      'filePath': instance.filePath,
      'fileType': _$FileTypeEnumMap[instance.fileType]!,
      'chapterCount': instance.chapterCount,
      'addedAt': instance.addedAt.toIso8601String(),
      'lastOpenedAt': instance.lastOpenedAt?.toIso8601String(),
    };

const _$FileTypeEnumMap = {FileType.epub: 'epub', FileType.txt: 'txt'};

_$ChapterImpl _$$ChapterImplFromJson(Map<String, dynamic> json) =>
    _$ChapterImpl(
      index: (json['index'] as num).toInt(),
      title: json['title'] as String,
      text: json['text'] as String,
    );

Map<String, dynamic> _$$ChapterImplToJson(_$ChapterImpl instance) =>
    <String, dynamic>{
      'index': instance.index,
      'title': instance.title,
      'text': instance.text,
    };
