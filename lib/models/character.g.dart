// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'character.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$VoiceVariantImpl _$$VoiceVariantImplFromJson(Map<String, dynamic> json) =>
    _$VoiceVariantImpl(
      variantId: json['variantId'] as String,
      label: json['label'] as String,
      voicePrompt: json['voicePrompt'] as String,
      triggerCondition: json['triggerCondition'] as String?,
      chapters: (json['chapters'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
    );

Map<String, dynamic> _$$VoiceVariantImplToJson(_$VoiceVariantImpl instance) =>
    <String, dynamic>{
      'variantId': instance.variantId,
      'label': instance.label,
      'voicePrompt': instance.voicePrompt,
      'triggerCondition': instance.triggerCondition,
      'chapters': instance.chapters,
    };

_$CharacterInfoImpl _$$CharacterInfoImplFromJson(
  Map<String, dynamic> json,
) => _$CharacterInfoImpl(
  id: json['id'] as String,
  bookId: json['bookId'] as String,
  canonicalName: json['canonicalName'] as String,
  aliases:
      (json['aliases'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  gender:
      $enumDecodeNullable(_$GenderEnumMap, json['gender']) ?? Gender.unknown,
  age: $enumDecodeNullable(_$AgeGroupEnumMap, json['age']) ?? AgeGroup.unknown,
  personalities:
      (json['personalities'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  firstPerson: json['firstPerson'] as String?,
  sentenceEndings: (json['sentenceEndings'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  voicePrompt: json['voicePrompt'] as String,
  voiceVariants:
      (json['voiceVariants'] as List<dynamic>?)
          ?.map((e) => VoiceVariant.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  isNarrator: json['isNarrator'] as bool? ?? false,
);

Map<String, dynamic> _$$CharacterInfoImplToJson(_$CharacterInfoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'bookId': instance.bookId,
      'canonicalName': instance.canonicalName,
      'aliases': instance.aliases,
      'gender': _$GenderEnumMap[instance.gender]!,
      'age': _$AgeGroupEnumMap[instance.age]!,
      'personalities': instance.personalities,
      'firstPerson': instance.firstPerson,
      'sentenceEndings': instance.sentenceEndings,
      'voicePrompt': instance.voicePrompt,
      'voiceVariants': instance.voiceVariants,
      'isNarrator': instance.isNarrator,
    };

const _$GenderEnumMap = {
  Gender.male: 'male',
  Gender.female: 'female',
  Gender.unknown: 'unknown',
};

const _$AgeGroupEnumMap = {
  AgeGroup.child: 'child',
  AgeGroup.teen: 'teen',
  AgeGroup.youngAdult: 'youngAdult',
  AgeGroup.middleAged: 'middleAged',
  AgeGroup.elderly: 'elderly',
  AgeGroup.unknown: 'unknown',
};
