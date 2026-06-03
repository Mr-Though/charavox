import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:charavox/models/api_config_model.dart';
import 'package:charavox/core/config/app_config.dart';

class ConfigService {
  final _secureStorage = const FlutterSecureStorage();

  Future<File> get _configFile async {
    final appDir = await getApplicationSupportDirectory();
    final dir = Directory(
      '${appDir.path}/${AppConfig.cacheDirName}/${AppConfig.configSubDir}',
    );
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return File('${dir.path}/${AppConfig.apiConfigFile}');
  }

  Future<void> saveApiConfig(ApiConfig config) async {
    await _secureStorage.write(key: 'llm_api_key', value: config.llmApiKey);
    await _secureStorage.write(key: 'tts_api_key', value: config.ttsApiKey);

    final plainConfig = {
      'version': AppConfig.currentSchemaVersion,
      'llm_base_url': config.llmBaseUrl,
      'llm_model': config.llmModel,
      'tts_base_url': config.ttsBaseUrl,
      'tts_model': config.ttsModel,
    };
    final file = await _configFile;
    await file.writeAsString(jsonEncode(plainConfig));
  }

  Future<ApiConfig?> loadApiConfig() async {
    try {
      final file = await _configFile;
      if (!await file.exists()) return null;

      final json =
          jsonDecode(await file.readAsString()) as Map<String, dynamic>;

      final llmKey = await _secureStorage.read(key: 'llm_api_key') ?? '';
      final ttsKey = await _secureStorage.read(key: 'tts_api_key') ?? '';

      return ApiConfig(
        llmBaseUrl: json['llm_base_url'] as String? ?? '',
        llmApiKey: llmKey,
        llmModel: json['llm_model'] as String? ?? '',
        ttsBaseUrl: json['tts_base_url'] as String? ?? '',
        ttsApiKey: ttsKey,
        ttsModel: json['tts_model'] as String? ?? '',
      );
    } catch (_) {
      return null;
    }
  }

  Future<String?> testLlmConnection(ApiConfig config) async {
    try {
      final dio = Dio(BaseOptions(
        baseUrl: config.llmBaseUrl,
        headers: {'Authorization': 'Bearer ${config.llmApiKey}'},
        connectTimeout: const Duration(seconds: 10),
      ));
      await dio.post('/chat/completions', data: {
        'model': config.llmModel,
        'messages': [{'role': 'user', 'content': '回复 OK'}],
        'max_tokens': 5,
      });
      return null;
    } catch (e) {
      return e.toString();
    }
  }
}
