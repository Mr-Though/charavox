import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:charavox/models/book.dart';
import 'package:charavox/models/character.dart';
import 'package:charavox/models/script_line.dart';
import 'package:charavox/core/constants/prompt_templates.dart';
import 'package:charavox/core/constants/app_constants.dart';
import 'package:charavox/core/errors/app_exceptions.dart';

class ChapterAnalysisResult {
  final List<ScriptLine> scriptLines;
  final List<CharacterInfo> newCharacters;

  ChapterAnalysisResult({
    required this.scriptLines,
    required this.newCharacters,
  });
}

class LlmService {
  final Dio _dio;
  late final String _model;

  LlmService({
    required String baseUrl,
    required String apiKey,
    required String model,
  }) : _dio = Dio(BaseOptions(
          baseUrl: baseUrl,
          headers: {
            'Authorization': 'Bearer $apiKey',
            'Content-Type': 'application/json',
          },
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 120),
        )) {
    _model = model;
  }

  Future<List<CharacterInfo>> discoverCharacters(
    String bookId,
    List<Chapter> chapters,
  ) async {
    final previewChapters = chapters.take(3).toList();
    final textBuffer = StringBuffer();
    for (final ch in previewChapters) {
      final preview = ch.text.length > AppConstants.chapterTextPreviewChars
          ? ch.text.substring(0, AppConstants.chapterTextPreviewChars)
          : ch.text;
      textBuffer.writeln(preview);
    }

    final prompt =
        PromptTemplates.buildCharacterDiscoveryPrompt(textBuffer.toString());
    final response = await _callLlm(prompt);
    return _parseCharacterDiscovery(response, bookId);
  }

  Future<ChapterAnalysisResult> analyzeChapter({
    required String bookId,
    required Chapter chapter,
    required List<CharacterInfo> knownCharacters,
    bool isJapaneseLN = false,
  }) async {
    final charactersJson = jsonEncode(knownCharacters
        .map((c) => {
              'id': c.id,
              'canonical_name': c.canonicalName,
              'aliases': c.aliases,
              'gender': c.gender.name,
              'age': c.age.name,
              'personalities': c.personalities,
            })
        .toList());

    final prompt = PromptTemplates.buildDialogueAttributionPrompt(
      chapter.text,
      charactersJson,
      isJapaneseLN: isJapaneseLN,
    );

    final response = await _callLlm(prompt);
    return _parseDialogueAttribution(
      response,
      bookId,
      chapter.index,
      knownCharacters,
    );
  }

  Future<Map<String, dynamic>> _callLlm(String prompt) async {
    try {
      final response = await _dio.post(
        '/chat/completions',
        data: {
          'model': _model,
          'messages': [
            {'role': 'user', 'content': prompt},
          ],
          'temperature': 0.3,
          'response_format': {'type': 'json_object'},
          'max_tokens': 4096,
        },
      );

      final content =
          response.data['choices'][0]['message']['content'] as String;
      return jsonDecode(content) as Map<String, dynamic>;
    } on DioException catch (e) {
      throw LlmApiException('LLM API 调用失败: ${e.message}',
          originalError: e);
    } catch (e) {
      if (e is AppException) rethrow;
      throw LlmApiException('LLM 响应解析失败: ${e.toString()}',
          originalError: e);
    }
  }

  List<CharacterInfo> _parseCharacterDiscovery(
    Map<String, dynamic> json,
    String bookId,
  ) {
    final charactersList = json['characters'] as List<dynamic>? ?? [];
    return charactersList.map((c) {
      return CharacterInfo(
        id: 'char-${c['canonical_name']}',
        bookId: bookId,
        canonicalName: c['canonical_name'] as String? ?? '未知角色',
        aliases: List<String>.from(c['aliases'] as List? ?? []),
        gender: _parseGender(c['gender'] as String?),
        age: _parseAge(c['age'] as String?),
        personalities: List<String>.from(c['personalities'] as List? ?? []),
        firstPerson: c['first_person'] as String?,
        sentenceEndings: c['sentence_endings'] != null
            ? List<String>.from(c['sentence_endings'] as List)
            : null,
        voicePrompt: c['voice_prompt'] as String? ?? '通用音色',
        voiceVariants: _parseVoiceVariants(c['voice_variants'] as List?),
      );
    }).toList();
  }

  ChapterAnalysisResult _parseDialogueAttribution(
    Map<String, dynamic> json,
    String bookId,
    int chapterIndex,
    List<CharacterInfo> knownCharacters,
  ) {
    final scriptList = json['script'] as List<dynamic>? ?? [];
    final newCharactersList = json['new_characters'] as List<dynamic>? ?? [];

    final scriptLines = <ScriptLine>[];
    for (int i = 0; i < scriptList.length; i++) {
      final s = scriptList[i] as Map<String, dynamic>;
      scriptLines.add(ScriptLine(
        id: 0,
        bookId: bookId,
        chapterIndex: chapterIndex,
        lineIndex: i,
        speakerId: s['speaker_id'] as String? ?? 'narrator',
        voiceVariantId: s['voice_variant_id'] as String?,
        text: s['text'] as String? ?? '',
        emotion: s['emotion'] as String?,
        type: _parseLineType(s['type'] as String?),
      ));
    }

    final newCharacters = newCharactersList.map((c) {
      return CharacterInfo(
        id: 'char-${c['canonical_name']}',
        bookId: bookId,
        canonicalName: c['canonical_name'] as String? ?? '未知角色',
        voicePrompt: '通用音色',
      );
    }).toList();

    return ChapterAnalysisResult(
      scriptLines: scriptLines,
      newCharacters: newCharacters,
    );
  }

  Gender _parseGender(String? value) {
    switch (value) {
      case 'male': return Gender.male;
      case 'female': return Gender.female;
      default: return Gender.unknown;
    }
  }

  AgeGroup _parseAge(String? value) {
    switch (value) {
      case 'child': return AgeGroup.child;
      case 'teen': return AgeGroup.teen;
      case 'young_adult': return AgeGroup.youngAdult;
      case 'middle_aged': return AgeGroup.middleAged;
      case 'elderly': return AgeGroup.elderly;
      default: return AgeGroup.unknown;
    }
  }

  LineType _parseLineType(String? value) {
    switch (value) {
      case 'dialogue': return LineType.dialogue;
      case 'monologue': return LineType.monologue;
      default: return LineType.narration;
    }
  }

  List<VoiceVariant> _parseVoiceVariants(List<dynamic>? list) {
    if (list == null) return [];
    return list.map((v) => VoiceVariant(
      variantId: v['variant_id'] as String? ?? '',
      label: v['label'] as String? ?? '',
      voicePrompt: v['voice_prompt'] as String? ?? '',
      triggerCondition: v['trigger_condition'] as String?,
      chapters: v['chapters'] != null
          ? List<int>.from(v['chapters'] as List)
          : null,
    )).toList();
  }
}
