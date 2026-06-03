import 'package:dio/dio.dart';
import 'package:charavox/core/errors/app_exceptions.dart';

class TtsService {
  final Dio _dio;
  late final String _model;

  TtsService({
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
          responseType: ResponseType.bytes,
        )) {
    _model = model;
  }

  Future<List<int>> synthesize({
    required String text,
    required String voicePrompt,
    double speed = 1.0,
  }) async {
    try {
      final response = await _dio.post(
        '/audio/speech',
        data: {
          'model': _model,
          'input': text,
          'voice': voicePrompt,
          'speed': speed,
        },
      );
      return response.data as List<int>;
    } on DioException catch (e) {
      throw TtsApiException('TTS 合成失败: ${e.message}', originalError: e);
    }
  }
}
