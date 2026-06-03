import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:charavox/models/script_line.dart';
import 'package:charavox/models/character.dart';
import 'package:charavox/models/reading_progress.dart';
import 'package:charavox/services/audio_player_service.dart';
import 'package:charavox/services/progress_service.dart';
import 'package:charavox/core/constants/app_constants.dart';

enum PlaybackStatus { idle, loading, playing, paused }

class PlaybackState {
  final PlaybackStatus status;
  final int currentLineIndex;
  final int totalLines;
  final double speed;
  final ScriptLine? currentLine;
  final CharacterInfo? currentCharacter;

  const PlaybackState({
    this.status = PlaybackStatus.idle,
    this.currentLineIndex = 0,
    this.totalLines = 0,
    this.speed = 1.0,
    this.currentLine,
    this.currentCharacter,
  });

  double get progress =>
      totalLines > 0 ? currentLineIndex / totalLines : 0.0;

  PlaybackState copyWith({
    PlaybackStatus? status,
    int? currentLineIndex,
    int? totalLines,
    double? speed,
    ScriptLine? currentLine,
    CharacterInfo? currentCharacter,
  }) {
    return PlaybackState(
      status: status ?? this.status,
      currentLineIndex: currentLineIndex ?? this.currentLineIndex,
      totalLines: totalLines ?? this.totalLines,
      speed: speed ?? this.speed,
      currentLine: currentLine ?? this.currentLine,
      currentCharacter: currentCharacter ?? this.currentCharacter,
    );
  }
}

final playbackProvider =
    StateNotifierProvider<PlaybackNotifier, PlaybackState>((ref) {
  return PlaybackNotifier();
});

class PlaybackNotifier extends StateNotifier<PlaybackState> {
  final _progressService = ProgressService();
  AudioPlayerService? _audioService;
  List<ScriptLine> _lines = [];
  List<CharacterInfo> _characters = [];
  String _bookId = '';
  Timer? _autoSaveTimer;
  int _linesSinceLastSave = 0;

  PlaybackNotifier() : super(const PlaybackState());

  void initialize({
    required AudioPlayerService audioService,
    required List<ScriptLine> lines,
    required List<CharacterInfo> characters,
    required String bookId,
    int startLineIndex = 0,
  }) {
    _audioService = audioService;
    _lines = lines;
    _characters = characters;
    _bookId = bookId;

    final characterMap = {for (final c in characters) c.id: c};

    state = PlaybackState(
      status: PlaybackStatus.idle,
      currentLineIndex: startLineIndex,
      totalLines: lines.length,
      currentLine: lines.isNotEmpty ? lines[startLineIndex] : null,
      currentCharacter: lines.isNotEmpty
          ? characterMap[lines[startLineIndex].speakerId]
          : null,
    );
  }

  Future<void> play() async {
    if (_audioService == null || _lines.isEmpty) return;

    state = state.copyWith(status: PlaybackStatus.loading);

    try {
      final line = _lines[state.currentLineIndex];
      final character = _characters.firstWhere(
        (c) => c.id == line.speakerId,
        orElse: () => _characters.first,
      );

      await _audioService!.playLine(
        line: line,
        character: character,
        speed: state.speed,
      );

      state = state.copyWith(
        status: PlaybackStatus.playing,
        currentLine: line,
        currentCharacter: character,
      );

      _autoSave();
      _startAutoSaveTimer();
    } catch (e) {
      state = state.copyWith(status: PlaybackStatus.idle);
    }
  }

  Future<void> pause() async {
    await _audioService?.player.pause();
    state = state.copyWith(status: PlaybackStatus.paused);
    await _saveProgress();
  }

  Future<void> next() async {
    if (state.currentLineIndex + 1 >= _lines.length) return;
    state = state.copyWith(
      currentLineIndex: state.currentLineIndex + 1,
      status: PlaybackStatus.idle,
    );
    await play();
  }

  Future<void> previous() async {
    if (state.currentLineIndex <= 0) return;
    state = state.copyWith(
      currentLineIndex: state.currentLineIndex - 1,
      status: PlaybackStatus.idle,
    );
    await play();
  }

  void setSpeed(double speed) {
    state = state.copyWith(speed: speed);
  }

  void _startAutoSaveTimer() {
    _autoSaveTimer?.cancel();
    _autoSaveTimer = Timer.periodic(
      const Duration(seconds: 30),
      (_) => _saveProgress(),
    );
  }

  void _autoSave() {
    _linesSinceLastSave++;
    if (_linesSinceLastSave >= AppConstants.autoSaveInterval) {
      _saveProgress();
      _linesSinceLastSave = 0;
    }
  }

  Future<void> _saveProgress() async {
    if (_bookId.isEmpty) return;
    await _progressService.saveProgress(ReadingProgress(
      bookId: _bookId,
      chapterIndex: _lines.isNotEmpty
          ? _lines[state.currentLineIndex].chapterIndex
          : 0,
      lineIndex: state.currentLineIndex,
      positionFraction: state.progress,
      updatedAt: DateTime.now(),
    ));
  }

  @override
  void dispose() {
    _autoSaveTimer?.cancel();
    _saveProgress();
    super.dispose();
  }
}
