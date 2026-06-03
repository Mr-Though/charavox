// ignore_for_file: use_super_parameters

class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;

  const AppException(this.message, {this.code, this.originalError});

  @override
  String toString() => 'AppException($code): $message';
}

class EpubParseException extends AppException {
  EpubParseException(String message, {dynamic originalError})
      : super(message, code: 'EPUB_PARSE_ERROR', originalError: originalError);
}

class TxtParseException extends AppException {
  TxtParseException(String message, {dynamic originalError})
      : super(message, code: 'TXT_PARSE_ERROR', originalError: originalError);
}

class LlmApiException extends AppException {
  LlmApiException(String message, {dynamic originalError})
      : super(message, code: 'LLM_API_ERROR', originalError: originalError);
}

class TtsApiException extends AppException {
  TtsApiException(String message, {dynamic originalError})
      : super(message, code: 'TTS_API_ERROR', originalError: originalError);
}

class CacheException extends AppException {
  CacheException(String message, {dynamic originalError})
      : super(message, code: 'CACHE_ERROR', originalError: originalError);
}

class ConfigException extends AppException {
  ConfigException(String message, {dynamic originalError})
      : super(message, code: 'CONFIG_ERROR', originalError: originalError);
}

class SchemaMigrationException extends AppException {
  SchemaMigrationException(String message, {dynamic originalError})
      : super(message, code: 'SCHEMA_MIGRATION_ERROR',
            originalError: originalError);
}
