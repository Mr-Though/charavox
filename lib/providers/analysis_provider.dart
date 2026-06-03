import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:charavox/models/book.dart';
import 'package:charavox/models/character.dart';
import 'package:charavox/models/script_line.dart';
import 'package:charavox/services/llm_service.dart';
import 'package:charavox/services/cache_service.dart';
import 'package:charavox/core/config/app_config.dart';
import 'package:charavox/core/constants/app_constants.dart';

enum AnalysisStatus { idle, discovering, analyzing, complete, error }

class AnalysisState {
  final AnalysisStatus status;
  final List<CharacterInfo> characters;
  final int chaptersAnalyzed;
  final int totalChapters;
  final String? errorMessage;

  const AnalysisState({
    this.status = AnalysisStatus.idle,
    this.characters = const [],
    this.chaptersAnalyzed = 0,
    this.totalChapters = 0,
    this.errorMessage,
  });

  double get progress =>
      totalChapters > 0 ? chaptersAnalyzed / totalChapters : 0.0;

  AnalysisState copyWith({
    AnalysisStatus? status,
    List<CharacterInfo>? characters,
    int? chaptersAnalyzed,
    int? totalChapters,
    String? errorMessage,
  }) {
    return AnalysisState(
      status: status ?? this.status,
      characters: characters ?? this.characters,
      chaptersAnalyzed: chaptersAnalyzed ?? this.chaptersAnalyzed,
      totalChapters: totalChapters ?? this.totalChapters,
      errorMessage: errorMessage,
    );
  }
}

final analysisProvider = StateNotifierProvider.family<AnalysisNotifier,
    AnalysisState, String>((ref, bookId) => AnalysisNotifier(bookId));

class AnalysisNotifier extends StateNotifier<AnalysisState> {
  final String bookId;
  final _cacheService = CacheService();

  AnalysisNotifier(this.bookId) : super(const AnalysisState());

  Future<void> analyze({
    required Book book,
    required List<Chapter> chapters,
    required LlmService llmService,
    bool isJapaneseLN = false,
  }) async {
    state = state.copyWith(
      status: AnalysisStatus.discovering,
      totalChapters: chapters.length,
    );

    try {
      // Phase 1: Character discovery
      final discovered =
          await llmService.discoverCharacters(bookId, chapters);
      var allCharacters = [...discovered];

      // Add narrator
      allCharacters.add(CharacterInfo(
        id: 'narrator',
        bookId: bookId,
        canonicalName: '旁白',
        voicePrompt: '35岁男性，磁性沉稳的叙述声音',
        isNarrator: true,
      ));

      await _cacheService.saveBookMeta(bookId, book, allCharacters);

      state = state.copyWith(
        status: AnalysisStatus.analyzing,
        characters: allCharacters,
      );

      // Phase 2 & 3: Per-chapter dialogue attribution
      for (int i = 0; i < chapters.length; i++) {
        final result = await llmService.analyzeChapter(
          bookId: bookId,
          chapter: chapters[i],
          knownCharacters: allCharacters,
          isJapaneseLN: isJapaneseLN,
        );

        final merged = _mergeShortDialogues(result.scriptLines);
        await _cacheService.saveChapterScript(bookId, i, merged);

        if (result.newCharacters.isNotEmpty) {
          if (result.newCharacters.length >=
              AppConstants.maxUnknownCharacters) {
            state = state.copyWith(
              errorMessage:
                  '检测到大量未识别角色 (${result.newCharacters.length} 个)',
            );
            break;
          }
          allCharacters = [...allCharacters, ...result.newCharacters];
          await _cacheService.saveBookMeta(bookId, book, allCharacters);
        }

        state = state.copyWith(
          chaptersAnalyzed: i + 1,
          characters: allCharacters,
        );
      }

      state = state.copyWith(status: AnalysisStatus.complete);
    } catch (e) {
      state = state.copyWith(
        status: AnalysisStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  List<ScriptLine> _mergeShortDialogues(List<ScriptLine> lines) {
    final merged = <ScriptLine>[];
    int groupId = 0;

    for (int i = 0; i < lines.length; i++) {
      final current = lines[i];
      if (current.type != LineType.dialogue ||
          current.speakerId == 'narrator') {
        merged.add(current.copyWith(mergedGroupId: null));
        continue;
      }

      final group = <ScriptLine>[current];
      int totalChars = current.text.length;
      int j = i + 1;

      while (j < lines.length &&
          lines[j].speakerId == current.speakerId &&
          lines[j].type == LineType.dialogue &&
          totalChars + lines[j].text.length <=
              AppConfig.shortSentenceMergeMaxChars &&
          group.length < AppConfig.shortSentenceMergeMaxCount) {
        group.add(lines[j]);
        totalChars += lines[j].text.length;
        j++;
      }

      if (group.length > 1) {
        for (final line in group) {
          merged.add(line.copyWith(mergedGroupId: groupId));
        }
        groupId++;
      } else {
        merged.add(current.copyWith(mergedGroupId: null));
      }
      i = j - 1;
    }
    return merged;
  }
}
