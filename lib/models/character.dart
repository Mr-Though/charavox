import 'package:freezed_annotation/freezed_annotation.dart';

part 'character.freezed.dart';
part 'character.g.dart';

enum Gender { male, female, unknown }

enum AgeGroup { child, teen, youngAdult, middleAged, elderly, unknown }

@freezed
class VoiceVariant with _$VoiceVariant {
  const factory VoiceVariant({
    required String variantId,
    required String label,
    required String voicePrompt,
    String? triggerCondition,
    List<int>? chapters,
  }) = _VoiceVariant;

  factory VoiceVariant.fromJson(Map<String, dynamic> json) =>
      _$VoiceVariantFromJson(json);
}

@freezed
class CharacterInfo with _$CharacterInfo {
  const factory CharacterInfo({
    required String id,
    required String bookId,
    required String canonicalName,
    @Default([]) List<String> aliases,
    @Default(Gender.unknown) Gender gender,
    @Default(AgeGroup.unknown) AgeGroup age,
    @Default([]) List<String> personalities,
    String? firstPerson,
    List<String>? sentenceEndings,
    required String voicePrompt,
    @Default([]) List<VoiceVariant> voiceVariants,
    @Default(false) bool isNarrator,
  }) = _CharacterInfo;

  factory CharacterInfo.fromJson(Map<String, dynamic> json) =>
      _$CharacterInfoFromJson(json);
}
