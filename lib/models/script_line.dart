import 'package:freezed_annotation/freezed_annotation.dart';

part 'script_line.freezed.dart';
part 'script_line.g.dart';

enum LineType { narration, dialogue, monologue }

@freezed
class ScriptLine with _$ScriptLine {
  const factory ScriptLine({
    required int id,
    required String bookId,
    required int chapterIndex,
    required int lineIndex,
    required String speakerId,
    String? voiceVariantId,
    required String text,
    String? emotion,
    @Default(LineType.narration) LineType type,
    int? mergedGroupId,
  }) = _ScriptLine;

  factory ScriptLine.fromJson(Map<String, dynamic> json) =>
      _$ScriptLineFromJson(json);
}
