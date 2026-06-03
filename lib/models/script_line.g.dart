// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'script_line.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ScriptLineImpl _$$ScriptLineImplFromJson(Map<String, dynamic> json) =>
    _$ScriptLineImpl(
      id: (json['id'] as num).toInt(),
      bookId: json['bookId'] as String,
      chapterIndex: (json['chapterIndex'] as num).toInt(),
      lineIndex: (json['lineIndex'] as num).toInt(),
      speakerId: json['speakerId'] as String,
      voiceVariantId: json['voiceVariantId'] as String?,
      text: json['text'] as String,
      emotion: json['emotion'] as String?,
      type:
          $enumDecodeNullable(_$LineTypeEnumMap, json['type']) ??
          LineType.narration,
      mergedGroupId: (json['mergedGroupId'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$ScriptLineImplToJson(_$ScriptLineImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'bookId': instance.bookId,
      'chapterIndex': instance.chapterIndex,
      'lineIndex': instance.lineIndex,
      'speakerId': instance.speakerId,
      'voiceVariantId': instance.voiceVariantId,
      'text': instance.text,
      'emotion': instance.emotion,
      'type': _$LineTypeEnumMap[instance.type]!,
      'mergedGroupId': instance.mergedGroupId,
    };

const _$LineTypeEnumMap = {
  LineType.narration: 'narration',
  LineType.dialogue: 'dialogue',
  LineType.monologue: 'monologue',
};
