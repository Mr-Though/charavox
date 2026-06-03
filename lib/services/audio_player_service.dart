import 'dart:io';
import 'dart:typed_data';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:charavox/models/character.dart';
import 'package:charavox/models/script_line.dart';
import 'package:charavox/services/tts_service.dart';
import 'package:charavox/core/constants/app_constants.dart';

class AudioPlayerService {
  final AudioPlayer _player = AudioPlayer();
  final TtsService _ttsService;

  AudioPlayer get player => _player;

  AudioPlayerService({required TtsService ttsService})
      : _ttsService = ttsService;

  Future<void> playLine({
    required ScriptLine line,
    required CharacterInfo character,
    double speed = 1.0,
  }) async {
    final voicePrompt = _resolveVoicePrompt(line, character);
    final audioBytes = await _ttsService.synthesize(
      text: line.text,
      voicePrompt: voicePrompt,
      speed: speed,
    );

    final tmpDir = await getTemporaryDirectory();
    final tmpFile = File('${tmpDir.path}/tts_play.mp3');
    await tmpFile.writeAsBytes(audioBytes);

    await _player.setAudioSource(AudioSource.file(tmpFile.path));
    await _player.play();
  }

  Future<List<Uint8List>> prefetchLines({
    required List<ScriptLine> lines,
    required List<CharacterInfo> characters,
    double speed = 1.0,
  }) async {
    final characterMap = {for (final c in characters) c.id: c};
    final results = <Uint8List>[];

    for (final line in lines) {
      final character = characterMap[line.speakerId];
      if (character == null) continue;

      try {
        final voicePrompt = _resolveVoicePrompt(line, character);
        final bytes = await _ttsService.synthesize(
          text: line.text,
          voicePrompt: voicePrompt,
          speed: speed,
        );
        results.add(Uint8List.fromList(bytes));
      } catch (_) {
        results.add(Uint8List(0));
      }
    }
    return results;
  }

  String _resolveVoicePrompt(ScriptLine line, CharacterInfo character) {
    if (line.voiceVariantId != null) {
      final variant = character.voiceVariants
          .where((v) => v.variantId == line.voiceVariantId)
          .firstOrNull;
      if (variant != null) return variant.voicePrompt;
    }
    return character.voicePrompt;
  }

  int getTransitionDuration(String? currentEmotion, String? nextEmotion,
      {bool isSceneChange = false}) {
    if (isSceneChange) return AppConstants.sceneTransitionMs;
    if (currentEmotion != null && currentEmotion != '平淡') {
      return AppConstants.tenseTransitionMs;
    }
    return AppConstants.defaultTransitionMs;
  }

  Future<void> dispose() async {
    await _player.dispose();
  }
}
