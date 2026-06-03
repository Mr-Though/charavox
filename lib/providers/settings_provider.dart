import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:charavox/models/api_config_model.dart';
import 'package:charavox/services/config_service.dart';

final settingsProvider =
    StateNotifierProvider<SettingsNotifier, ApiConfig?>((ref) {
  return SettingsNotifier();
});

class SettingsNotifier extends StateNotifier<ApiConfig?> {
  final _configService = ConfigService();

  SettingsNotifier() : super(null);

  Future<void> load() async {
    state = await _configService.loadApiConfig();
  }

  Future<void> save(ApiConfig config) async {
    await _configService.saveApiConfig(config);
    state = config;
  }

  void applyPreset({
    required String llmPreset,
    required String ttsPreset,
  }) {
    final llm = ApiPresets.llmPresets[llmPreset];
    final tts = ApiPresets.ttsPresets[ttsPreset];
    if (llm == null || tts == null) return;

    state = ApiConfig(
      llmBaseUrl: llm.baseUrl,
      llmApiKey: '',
      llmModel: llm.model,
      ttsBaseUrl: tts.baseUrl,
      ttsApiKey: '',
      ttsModel: tts.model,
    );
  }

  Future<String?> testConnection() async {
    if (state == null) return '请先配置 API';
    return _configService.testLlmConnection(state!);
  }
}
