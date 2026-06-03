import 'package:flutter_test/flutter_test.dart';
import 'package:charavox/models/character.dart';

void main() {
  group('CharacterInfo', () {
    test('fromJson with aliases and voiceVariants', () {
      final json = {
        'id': 'char-1', 'bookId': 'abc123',
        'canonicalName': '林风',
        'aliases': ['林公子', '小林'],
        'gender': 'male', 'age': 'teen',
        'personalities': ['热血', '正直'],
        'voicePrompt': '18岁少年，声音清亮有力',
        'voiceVariants': [
          {
            'variantId': 'var-1', 'label': '受伤虚弱',
            'voicePrompt': '声音虚弱沙哑',
            'triggerCondition': '角色受伤时',
            'chapters': [15, 16],
          }
        ],
        'isNarrator': false,
      };
      final c = CharacterInfo.fromJson(json);
      expect(c.canonicalName, '林风');
      expect(c.aliases, ['林公子', '小林']);
      expect(c.voiceVariants.length, 1);
      expect(c.voiceVariants.first.label, '受伤虚弱');
    });

    test('narrator has isNarrator=true', () {
      final json = {
        'id': 'narrator', 'bookId': 'abc123',
        'canonicalName': '旁白',
        'aliases': [], 'gender': 'male', 'age': 'middleAged',
        'personalities': [],
        'voicePrompt': '35岁男性，磁性沉稳',
        'voiceVariants': [],
        'isNarrator': true,
      };
      expect(CharacterInfo.fromJson(json).isNarrator, true);
    });
  });
}
