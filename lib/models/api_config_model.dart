import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_config_model.freezed.dart';
part 'api_config_model.g.dart';

@freezed
class ApiConfig with _$ApiConfig {
  const factory ApiConfig({
    required String llmBaseUrl,
    required String llmApiKey,
    required String llmModel,
    required String ttsBaseUrl,
    required String ttsApiKey,
    required String ttsModel,
  }) = _ApiConfig;

  factory ApiConfig.fromJson(Map<String, dynamic> json) =>
      _$ApiConfigFromJson(json);
}

class LlmPreset {
  final String name;
  final String model;
  final String baseUrl;
  const LlmPreset({
    required this.name,
    required this.model,
    required this.baseUrl,
  });
}

class TtsPreset {
  final String name;
  final String model;
  final String baseUrl;
  const TtsPreset({
    required this.name,
    required this.model,
    required this.baseUrl,
  });
}

class ApiPresets {
  static const llmPresets = <String, LlmPreset>{
    '阿里云百炼': LlmPreset(
      name: '阿里云百炼',
      model: 'qwen3.5-flash',
      baseUrl: 'https://dashscope.aliyuncs.com/compatible-mode/v1',
    ),
    '火山引擎': LlmPreset(
      name: '火山引擎',
      model: 'doubao-seed-2.0-lite',
      baseUrl: 'https://ark.cn-beijing.volces.com/api/v3',
    ),
    'DeepSeek': LlmPreset(
      name: 'DeepSeek',
      model: 'deepseek-v4-flash',
      baseUrl: 'https://api.deepseek.com/v1',
    ),
    'MiniMax': LlmPreset(
      name: 'MiniMax',
      model: 'minimax-m2.5',
      baseUrl: 'https://api.minimaxi.com/v1',
    ),
    '本地 Ollama': LlmPreset(
      name: '本地 Ollama',
      model: '',
      baseUrl: 'http://localhost:11434/v1',
    ),
  };

  static const ttsPresets = <String, TtsPreset>{
    '阿里云百炼': TtsPreset(
      name: '阿里云百炼',
      model: 'qwen3-tts-flash',
      baseUrl: 'https://dashscope.aliyuncs.com/compatible-mode/v1',
    ),
    '本地 Docker': TtsPreset(
      name: '本地 Docker',
      model: 'qwen3-tts',
      baseUrl: 'http://localhost:8000/v1',
    ),
  };
}
