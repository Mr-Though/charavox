import 'package:flutter_test/flutter_test.dart';
import 'package:charavox/models/script_line.dart';

void main() {
  group('ScriptLine', () {
    test('narration line', () {
      final json = {
        'id': 1, 'bookId': 'abc', 'chapterIndex': 0, 'lineIndex': 0,
        'speakerId': 'narrator', 'voiceVariantId': null,
        'text': '巨大的浮游城堡。', 'emotion': null,
        'type': 'narration', 'mergedGroupId': null,
      };
      final line = ScriptLine.fromJson(json);
      expect(line.type, LineType.narration);
      expect(line.speakerId, 'narrator');
    });

    test('dialogue with emotion and merge group', () {
      final json = {
        'id': 2, 'bookId': 'abc', 'chapterIndex': 0, 'lineIndex': 1,
        'speakerId': 'char-1', 'voiceVariantId': 'var-1',
        'text': '这就是那个死亡游戏吗？', 'emotion': '惊讶',
        'type': 'dialogue', 'mergedGroupId': 0,
      };
      final line = ScriptLine.fromJson(json);
      expect(line.type, LineType.dialogue);
      expect(line.emotion, '惊讶');
      expect(line.mergedGroupId, 0);
      expect(line.voiceVariantId, 'var-1');
    });
  });
}
