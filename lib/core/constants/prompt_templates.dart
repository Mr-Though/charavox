import 'package:flutter/services.dart' show rootBundle;

class PromptTemplates {
  static String? _systemBase;
  static String? _characterDiscovery;
  static String? _dialogueAttribution;
  static String? _japaneseLnEnhance;

  static Future<void> load() async {
    _systemBase =
        await rootBundle.loadString('assets/prompts/system_base.txt');
    _characterDiscovery =
        await rootBundle.loadString('assets/prompts/character_discovery.txt');
    _dialogueAttribution = await rootBundle
        .loadString('assets/prompts/dialogue_attribution.txt');
    _japaneseLnEnhance = await rootBundle
        .loadString('assets/prompts/japanese_ln_enhance.txt');
  }

  static String get systemBase => _systemBase ?? '';
  static String get characterDiscovery => _characterDiscovery ?? '';
  static String get dialogueAttribution => _dialogueAttribution ?? '';
  static String get japaneseLnEnhance => _japaneseLnEnhance ?? '';

  static String buildCharacterDiscoveryPrompt(String text) {
    return '$systemBase\n\n${characterDiscovery.replaceAll('{text}', text)}';
  }

  static String buildDialogueAttributionPrompt(
    String text,
    String charactersJson, {
    bool isJapaneseLN = false,
  }) {
    var prompt = '$systemBase\n\n${dialogueAttribution
        .replaceAll('{text}', text)
        .replaceAll('{characters_json}', charactersJson)}';

    if (isJapaneseLN && _japaneseLnEnhance != null) {
      prompt += '\n\n$_japaneseLnEnhance';
    }

    return prompt;
  }
}
