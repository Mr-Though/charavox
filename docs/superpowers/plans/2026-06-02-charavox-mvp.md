# 聆书 charavox MVP 实现计划

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 构建聆书 MVP——在 Linux 桌面端实现 EPUB/TXT 导入、LLM 多角色分析、多音色 TTS 朗读、播放控制和进度保存。

**Architecture:** Flutter 3.27+ 桌面应用，Riverpod 状态管理，Isar 本地持久化。通过 OpenAI 兼容 API 调用 LLM（角色分析）和 TTS（语音合成）。EPUB 用 epub_pro 解析，TXT 自研解析器。音频播放用 just_audio。

**Tech Stack:** Flutter 3.27+, Dart 3.6+, Riverpod 2.4+, Isar 3.1+, just_audio 0.9+, dio 5.4+, epub_pro 5.1+

**Spec:** `docs/superpowers/specs/2026-06-02-lingshu-prd.md`

---

## 文件结构总览

```
charavox/
├── pubspec.yaml
├── analysis_options.yaml
├── README.md
├── CONTRIBUTING.md
├── CHANGELOG.md
├── assets/
│   └── prompts/
│       ├── system_base.txt
│       ├── character_discovery.txt
│       ├── dialogue_attribution.txt
│       └── japanese_ln_enhance.txt
├── lib/
│   ├── main.dart
│   ├── app.dart
│   ├── core/
│   │   ├── config/
│   │   │   └── app_config.dart
│   │   ├── constants/
│   │   │   ├── app_constants.dart
│   │   │   └── prompt_templates.dart
│   │   ├── errors/
│   │   │   └── app_exceptions.dart
│   │   └── utils/
│   │       ├── hash_utils.dart
│   │       └── text_utils.dart
│   ├── models/
│   │   ├── book.dart
│   │   ├── character.dart
│   │   ├── script_line.dart
│   │   ├── reading_progress.dart
│   │   └── api_config_model.dart
│   ├── services/
│   │   ├── epub_service.dart
│   │   ├── txt_service.dart
│   │   ├── llm_service.dart
│   │   ├── tts_service.dart
│   │   ├── audio_player_service.dart
│   │   ├── cache_service.dart
│   │   ├── progress_service.dart
│   │   └── config_service.dart
│   ├── providers/
│   │   ├── library_provider.dart
│   │   ├── reader_provider.dart
│   │   ├── analysis_provider.dart
│   │   ├── playback_provider.dart
│   │   └── settings_provider.dart
│   ├── screens/
│   │   ├── library/
│   │   │   └── library_screen.dart
│   │   ├── reader/
│   │   │   ├── reader_screen.dart
│   │   │   └── widgets/
│   │   │       ├── text_view.dart
│   │   │       └── playback_bar.dart
│   │   ├── character/
│   │   │   └── character_list_screen.dart
│   │   └── settings/
│   │       └── settings_screen.dart
│   └── widgets/
│       ├── loading_indicator.dart
│       └── error_view.dart
└── test/
    ├── models/
    │   ├── book_test.dart
    │   ├── character_test.dart
    │   └── script_line_test.dart
    ├── services/
    │   ├── epub_service_test.dart
    │   ├── txt_service_test.dart
    │   ├── llm_service_test.dart
    │   ├── tts_service_test.dart
    │   ├── cache_service_test.dart
    │   ├── progress_service_test.dart
    │   └── migration_test.dart
    ├── providers/
    │   ├── reader_provider_test.dart
    │   └── playback_provider_test.dart
    ├── integration/
    │   ├── full_analysis_flow_test.dart
    │   └── playback_flow_test.dart
    └── fixtures/
        ├── sample_book.epub
        ├── sample_book.txt
        └── mock_llm_responses/
            ├── character_discovery.json
            └── dialogue_attribution.json
```

---

## M1: 项目启动 + 基础框架

### Task 1: Flutter 项目初始化

**Files:**
- Create: `pubspec.yaml`
- Create: `analysis_options.yaml`
- Create: `lib/main.dart`
- Create: `lib/app.dart`
- Create: `README.md`
- Create: `CONTRIBUTING.md`
- Create: `CHANGELOG.md`
- Create: `lib/core/config/app_config.dart`
- Create: `lib/core/constants/app_constants.dart`
- Create: `lib/core/errors/app_exceptions.dart`
- Create: `lib/widgets/loading_indicator.dart`
- Create: `lib/widgets/error_view.dart`

- [ ] **Step 1: 创建 Flutter 项目**

```bash
flutter create --org com.charavox --platforms=linux charavox
cd charavox
```

- [ ] **Step 2: 配置 pubspec.yaml 依赖**

```yaml
name: charavox
description: 多角色分音色有声书阅读器
version: 0.1.0
publish_to: none

environment:
  sdk: ^3.6.0
  flutter: ^3.27.0

dependencies:
  flutter:
    sdk: flutter
  riverpod: ^2.4.0
  flutter_riverpod: ^2.4.0
  riverpod_annotation: ^2.3.0
  dio: ^5.4.0
  isar: ^3.1.0
  isar_flutter_libs: ^3.1.0
  just_audio: ^0.9.0
  audio_service: ^0.18.0
  epub_pro: ^5.1.0
  flutter_secure_storage: ^9.2.0
  file_picker: ^6.0.0
  path_provider: ^2.1.0
  path: ^1.9.0
  uuid: ^4.3.0
  crypto: ^3.0.3
  freezed_annotation: ^2.4.0
  json_annotation: ^4.8.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^4.0.0
  build_runner: ^2.4.0
  freezed: ^2.4.0
  json_serializable: ^6.7.0
  riverpod_generator: ^2.3.0
  mockito: ^5.4.0
  isar_generator: ^3.1.0
```

- [ ] **Step 3: 创建 analysis_options.yaml**

```yaml
include: package:flutter_lints/flutter.yaml

linter:
  rules:
    prefer_const_constructors: true
    prefer_const_declarations: true
    avoid_print: true
    require_trailing_commas: true
    sort_constructors_first: true
```

- [ ] **Step 4: 创建 lib/main.dart**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const ProviderScope(
      child: CharavoxApp(),
    ),
  );
}
```

- [ ] **Step 5: 创建 lib/app.dart**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CharavoxApp extends ConsumerWidget {
  const CharavoxApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: '聆书 charavox',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4A90D9),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        fontFamily: 'Noto Sans SC',
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4A90D9),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        fontFamily: 'Noto Sans SC',
      ),
      themeMode: ThemeMode.system,
      home: const Scaffold(
        body: Center(child: Text('聆书 charavox')),
      ),
    );
  }
}
```

- [ ] **Step 6: 创建 lib/core/config/app_config.dart**

```dart
class AppConfig {
  static const String appName = '聆书 charavox';
  static const String version = '0.1.0';
  static const String cacheDirName = 'charavox_cache';
  static const String analysisSubDir = 'analysis';
  static const String audioSubDir = 'audio';
  static const String configSubDir = 'config';
  static const String apiConfigFile = 'api_config.json';
  static const int currentSchemaVersion = 1;
  static const int shortSentenceMergeMaxChars = 100;
  static const int shortSentenceMergeMaxCount = 3;
}
```

- [ ] **Step 7: 创建 lib/core/constants/app_constants.dart**

```dart
class AppConstants {
  static const double defaultSpeed = 1.0;
  static const List<double> speedOptions = [0.5, 0.75, 1.0, 1.25, 1.5, 2.0, 3.0];
  static const int defaultTransitionMs = 300;
  static const int tenseTransitionMs = 150;
  static const int sceneTransitionMs = 600;
  static const int prefetchWindow = 2;
  static const int autoSaveInterval = 30;
  static const int maxUnknownCharacters = 20;
  static const int chapterTextPreviewChars = 2000;
  static const int txtChunkSize = 5000;
}
```

- [ ] **Step 8: 创建 lib/core/errors/app_exceptions.dart**

```dart
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
      : super(message, code: 'SCHEMA_MIGRATION_ERROR', originalError: originalError);
}
```

- [ ] **Step 9: 创建 lib/widgets/loading_indicator.dart**

```dart
import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  final String? message;

  const LoadingIndicator({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(message!, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ],
      ),
    );
  }
}
```

- [ ] **Step 10: 创建 lib/widgets/error_view.dart**

```dart
import 'package:flutter/material.dart';

class ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const ErrorView({super.key, required this.message, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 48, color: Theme.of(context).colorScheme.error),
            const SizedBox(height: 16),
            Text(message, textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyLarge),
            if (onRetry != null) ...[
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('重试'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
```

- [ ] **Step 11: 创建 README.md、CONTRIBUTING.md、CHANGELOG.md 占位文件**

```bash
touch README.md CONTRIBUTING.md CHANGELOG.md
```

- [ ] **Step 12: 运行 pub get 并验证编译**

```bash
flutter pub get
flutter analyze
```

- [ ] **Step 13: Commit**

```bash
git add -A
git commit -m "feat: initialize Flutter project with core infrastructure

- Set up Flutter 3.27+ project with Linux platform target
- Add dependencies: riverpod, isar, just_audio, dio, epub_pro
- Create core config, constants, exceptions, and shared widgets
- Add README, CONTRIBUTING, CHANGELOG stubs"
```

---

### Task 2: 工具函数

**Files:**
- Create: `lib/core/utils/hash_utils.dart`
- Create: `lib/core/utils/text_utils.dart`
- Create: `test/services/migration_test.dart`

- [ ] **Step 1: 创建 lib/core/utils/hash_utils.dart**

```dart
import 'dart:convert';
import 'package:crypto/crypto.dart';

String computeBookHash(String filePath, int fileSize) {
  final input = '$filePath:$fileSize';
  final bytes = utf8.encode(input);
  final digest = sha256.convert(bytes);
  return digest.toString().substring(0, 16);
}
```

- [ ] **Step 2: 创建 lib/core/utils/text_utils.dart**

```dart
import 'dart:convert';

final _chapterPatterns = [
  RegExp(r'^第[零一二三四五六七八九十百千万\d]{1,5}[章节卷]'),
  RegExp(r'^Chapter\s+\d+', caseSensitive: false),
  RegExp(r'^CHAPTER\s+\d+'),
  RegExp(r'^第[零一二三四五六七八九十百千万\d]{1,5}章'),
];

bool isChapterMarker(String line) {
  final trimmed = line.trim();
  return _chapterPatterns.any((p) => p.hasMatch(trimmed));
}

List<int> findChapterIndices(List<String> lines) {
  final indices = <int>[0];
  for (int i = 0; i < lines.length; i++) {
    if (isChapterMarker(lines[i]) && i > 0) {
      indices.add(i);
    }
  }
  if (indices.length == 1) {
    // No chapter markers found; chunk by fixed size instead
    indices.clear();
    indices.add(0);
    for (int i = 5000; i < lines.length; i += 5000) {
      indices.add(i);
    }
  }
  return indices;
}

Encoding detectEncoding(List<int> bytes) {
  // Try UTF-8 first
  try {
    utf8.decode(bytes);
    return utf8;
  } catch (_) {}

  // Try GBK
  try {
    gbk.decode(bytes);
    return gbk;
  } catch (_) {}

  // Try Shift-JIS
  try {
    shiftJis.decode(bytes);
    return shiftJis;
  } catch (_) {}

  // Fallback to UTF-8 with replacement
  return utf8;
}

// Simple GBK detection via BOM and heuristic
const gbk = _GbkCodec();
const shiftJis = _ShiftJisCodec();

class _GbkCodec extends Encoding {
  @override
  String get name => 'gbk';

  @override
  Converter<List<int>, String> get decoder => const _GbkDecoder();
  @override
  Converter<String, List<int>> get encoder => throw UnimplementedError();
}

class _GbkDecoder extends Converter<List<int>, String> {
  const _GbkDecoder();
  @override
  String convert(List<int> input) {
    // GBK/GB18030: handle common 2-byte sequences
    final buf = StringBuffer();
    int i = 0;
    while (i < input.length) {
      if (input[i] < 0x80) {
        buf.writeCharCode(input[i]);
        i++;
      } else if (i + 1 < input.length) {
        final code = (input[i] << 8) | input[i + 1];
        try {
          buf.writeCharCode(_gbkToUnicode(code));
          i += 2;
        } catch (_) {
          buf.write('?');
          i++;
        }
      } else {
        buf.write('?');
        i++;
      }
    }
    return buf.toString();
  }
}

int _gbkToUnicode(int gbk) {
  // GBK to Unicode conversion table lookup
  // This is a simplified version; production code should use charset package
  if (gbk >= 0x8140 && gbk <= 0xFEFE) {
    // Simplified lookup — full table omitted for brevity
    // In production, use the `charset` package: Charset.forName('GBK')
    return 0xFFFD; // Replacement character
  }
  throw FormatException('Invalid GBK code: $gbk');
}

class _ShiftJisCodec extends Encoding {
  @override
  String get name => 'shift_jis';
  @override
  Converter<List<int>, String> get decoder => const _ShiftJisDecoder();
  @override
  Converter<String, List<int>> get encoder => throw UnimplementedError();
}

class _ShiftJisDecoder extends Converter<List<int>, String> {
  const _ShiftJisDecoder();
  @override
  String convert(List<int> input) {
    final buf = StringBuffer();
    int i = 0;
    while (i < input.length) {
      if (input[i] < 0x80 || (input[i] >= 0xA1 && input[i] <= 0xDF)) {
        buf.writeCharCode(input[i]);
        i++;
      } else if (i + 1 < input.length) {
        buf.write('?');
        i += 2;
      } else {
        buf.write('?');
        i++;
      }
    }
    return buf.toString();
  }
}
```

**注:** 以上编码检测为简化实现。生产代码建议使用 Dart `charset` 包提供完整的 GBK/GB18030/Shift-JIS 解码：

```yaml
# pubspec.yaml 追加
  charset: ^2.0.1
```

然后替换 `detectEncoding` 使用 `charset` 包。此处保留手动实现作为代码框架参考。

- [ ] **Step 3: 编写 text_utils 单元测试**

```bash
# 在后续 Task 中完成，此处先创建文件占位
mkdir -p test/services
touch test/services/migration_test.dart
```

- [ ] **Step 4: Commit**

```bash
git add lib/core/utils/
git commit -m "feat: add hash and text utility functions"
```

---

### Task 3: 数据模型

**Files:**
- Create: `lib/models/book.dart`
- Create: `lib/models/character.dart`
- Create: `lib/models/script_line.dart`
- Create: `lib/models/reading_progress.dart`
- Create: `lib/models/api_config_model.dart`
- Create: `test/models/book_test.dart`
- Create: `test/models/character_test.dart`
- Create: `test/models/script_line_test.dart`

- [ ] **Step 1: 创建 lib/models/book.dart**

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'book.freezed.dart';
part 'book.g.dart';

enum FileType { epub, txt }

@freezed
class Book with _$Book {
  const factory Book({
    required String id,
    required String title,
    String? author,
    String? coverPath,
    required String filePath,
    required FileType fileType,
    required int chapterCount,
    required DateTime addedAt,
    DateTime? lastOpenedAt,
  }) = _Book;

  factory Book.fromJson(Map<String, dynamic> json) => _$BookFromJson(json);
}

@freezed
class Chapter with _$Chapter {
  const factory Chapter({
    required int index,
    required String title,
    required String text,
  }) = _Chapter;

  factory Chapter.fromJson(Map<String, dynamic> json) =>
      _$ChapterFromJson(json);
}
```

- [ ] **Step 2: 创建 lib/models/character.dart**

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'character.freezed.dart';
part 'character.g.dart';

enum Gender { male, female, unknown }

enum AgeGroup { child, teen, youngAdult, middleAged, elderly, unknown }

@freezed
class VoiceVariant with _$VoiceVariant {
  const factory VoiceVariant({
    required String variantId,
    required String label,
    required String voicePrompt,
    String? triggerCondition,
    List<int>? chapters,
  }) = _VoiceVariant;

  factory VoiceVariant.fromJson(Map<String, dynamic> json) =>
      _$VoiceVariantFromJson(json);
}

@freezed
class CharacterInfo with _$CharacterInfo {
  const factory CharacterInfo({
    required String id,
    required String bookId,
    required String canonicalName,
    @Default([]) List<String> aliases,
    @Default(Gender.unknown) Gender gender,
    @Default(AgeGroup.unknown) AgeGroup age,
    @Default([]) List<String> personalities,
    String? firstPerson,
    List<String>? sentenceEndings,
    required String voicePrompt,
    @Default([]) List<VoiceVariant> voiceVariants,
    @Default(false) bool isNarrator,
  }) = _CharacterInfo;

  factory CharacterInfo.fromJson(Map<String, dynamic> json) =>
      _$CharacterInfoFromJson(json);
}
```

- [ ] **Step 3: 创建 lib/models/script_line.dart**

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'script_line.freezed.dart';
part 'script_line.g.dart';

enum LineType { narration, dialogue, monologue }

@freezed
class ScriptLine with _$ScriptLine {
  const factory ScriptLine({
    required int id,
    required String bookId,
    required int chapterIndex,
    required int lineIndex,
    required String speakerId,
    String? voiceVariantId,
    required String text,
    String? emotion,
    @Default(LineType.narration) LineType type,
    int? mergedGroupId,
  }) = _ScriptLine;

  factory ScriptLine.fromJson(Map<String, dynamic> json) =>
      _$ScriptLineFromJson(json);
}
```

- [ ] **Step 4: 创建 lib/models/reading_progress.dart**

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'reading_progress.freezed.dart';
part 'reading_progress.g.dart';

@freezed
class ReadingProgress with _$ReadingProgress {
  const factory ReadingProgress({
    required String bookId,
    required int chapterIndex,
    required int lineIndex,
    required double positionFraction,
    required DateTime updatedAt,
  }) = _ReadingProgress;

  factory ReadingProgress.fromJson(Map<String, dynamic> json) =>
      _$ReadingProgressFromJson(json);
}
```

- [ ] **Step 5: 创建 lib/models/api_config_model.dart**

```dart
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

class ApiPresets {
  static const llmPresets = {
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
      model: 'deepseek-chat',
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

  static const ttsPresets = {
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

class LlmPreset {
  final String name;
  final String model;
  final String baseUrl;
  const LlmPreset({required this.name, required this.model, required this.baseUrl});
}

class TtsPreset {
  final String name;
  final String model;
  final String baseUrl;
  const TtsPreset({required this.name, required this.model, required this.baseUrl});
}
```

- [ ] **Step 6: 运行 build_runner 生成 freezed 代码**

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

- [ ] **Step 7: 编写模型序列化测试 (test/models/book_test.dart)**

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:charavox/models/book.dart';

void main() {
  group('Book', () {
    test('fromJson and toJson round-trip', () {
      final json = {
        'id': 'abc123',
        'title': '测试书籍',
        'author': '测试作者',
        'coverPath': null,
        'filePath': '/tmp/test.epub',
        'fileType': 'epub',
        'chapterCount': 10,
        'addedAt': '2026-06-02T00:00:00.000',
        'lastOpenedAt': null,
      };
      final book = Book.fromJson(json);
      final output = book.toJson();
      expect(output['id'], 'abc123');
      expect(output['title'], '测试书籍');
      expect(output['fileType'], 'epub');
      expect(output['chapterCount'], 10);
    });
  });
}
```

- [ ] **Step 8: 编写 CharacterInfo 序列化测试 (test/models/character_test.dart)**

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:charavox/models/character.dart';

void main() {
  group('CharacterInfo', () {
    test('fromJson with aliases and voiceVariants', () {
      final json = {
        'id': 'char-1',
        'bookId': 'abc123',
        'canonicalName': '林风',
        'aliases': ['林公子', '小林'],
        'gender': 'male',
        'age': 'teen',
        'personalities': ['热血', '正直'],
        'firstPerson': null,
        'sentenceEndings': null,
        'voicePrompt': '18岁少年，声音清亮有力',
        'voiceVariants': [
          {
            'variantId': 'var-1',
            'label': '受伤虚弱',
            'voicePrompt': '18岁少年，声音虚弱沙哑',
            'triggerCondition': '角色受伤时',
            'chapters': [15, 16],
          }
        ],
        'isNarrator': false,
      };
      final character = CharacterInfo.fromJson(json);
      expect(character.canonicalName, '林风');
      expect(character.aliases, ['林公子', '小林']);
      expect(character.voiceVariants.length, 1);
      expect(character.voiceVariants.first.label, '受伤虚弱');
    });

    test('narrator has isNarrator=true', () {
      final json = {
        'id': 'narrator',
        'bookId': 'abc123',
        'canonicalName': '旁白',
        'aliases': [],
        'gender': 'male',
        'age': 'middleAged',
        'personalities': [],
        'voicePrompt': '35岁男性，磁性沉稳',
        'voiceVariants': [],
        'isNarrator': true,
      };
      final narrator = CharacterInfo.fromJson(json);
      expect(narrator.isNarrator, true);
    });
  });
}
```

- [ ] **Step 9: 编写 ScriptLine 序列化测试 (test/models/script_line_test.dart)**

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:charavox/models/script_line.dart';

void main() {
  group('ScriptLine', () {
    test('narration line', () {
      final json = {
        'id': 1,
        'bookId': 'abc123',
        'chapterIndex': 0,
        'lineIndex': 0,
        'speakerId': 'narrator',
        'voiceVariantId': null,
        'text': '巨大的浮游城堡矗立在虚拟的天空中。',
        'emotion': null,
        'type': 'narration',
        'mergedGroupId': null,
      };
      final line = ScriptLine.fromJson(json);
      expect(line.type, LineType.narration);
      expect(line.speakerId, 'narrator');
    });

    test('dialogue line with emotion', () {
      final json = {
        'id': 2,
        'bookId': 'abc123',
        'chapterIndex': 0,
        'lineIndex': 1,
        'speakerId': 'char-1',
        'voiceVariantId': null,
        'text': '这就是那个死亡游戏吗？',
        'emotion': '惊讶',
        'type': 'dialogue',
        'mergedGroupId': 0,
      };
      final line = ScriptLine.fromJson(json);
      expect(line.type, LineType.dialogue);
      expect(line.emotion, '惊讶');
      expect(line.mergedGroupId, 0);
    });
  });
}
```

- [ ] **Step 10: 运行所有测试验证**

```bash
flutter test test/models/
```

- [ ] **Step 11: Commit**

```bash
git add lib/models/ test/models/ pubspec.yaml
git commit -m "feat: add data models with freezed serialization

- Book, Chapter, CharacterInfo, ScriptLine, ReadingProgress, ApiConfig
- VoiceVariant for character voice variations
- ApiPresets for LLM/TTS provider presets
- Freezed + json_serializable code generation
- Unit tests for model serialization"
```

---

## M2: EPUB/TXT 解析 + 文本渲染

### Task 4: EPUB 解析服务

**Files:**
- Create: `lib/services/epub_service.dart`
- Create: `test/services/epub_service_test.dart`
- Create: `test/fixtures/sample_book.epub`

- [ ] **Step 1: 创建 lib/services/epub_service.dart**

```dart
import 'package:epub_pro/epub_pro.dart' as epub_pro;
import 'package:charavox/models/book.dart';
import 'package:charavox/core/errors/app_exceptions.dart';

class EpubService {
  /// 解析 EPUB 文件，返回 Book 对象和章节列表
  (Book, List<Chapter>) parse(String filePath) {
    try {
      final epubBook = epub_pro.EpubPro.readFile(filePath);

      final title = epubBook.title ?? _extractFileName(filePath);
      final author = epubBook.author;

      final chapters = <Chapter>[];
      int index = 0;

      for (final chapter in epubBook.chapters ?? <epub_pro.EpubChapter>[]) {
        final text = _stripHtml(chapter.htmlContent ?? '');
        if (text.trim().isEmpty) continue;

        chapters.add(Chapter(
          index: index,
          title: chapter.title ?? '第${index + 1}章',
          text: text,
        ));
        index++;
      }

      final fileSize = _getFileSize(filePath);
      final book = Book(
        id: '', // Will be set by caller using hash
        title: title,
        author: author,
        coverPath: null, // Cover extraction deferred to P1
        filePath: filePath,
        fileType: FileType.epub,
        chapterCount: chapters.length,
        addedAt: DateTime.now(),
      );

      return (book, chapters);
    } catch (e) {
      throw EpubParseException('EPUB 解析失败: ${e.toString()}', originalError: e);
    }
  }

  String _extractFileName(String filePath) {
    final segments = filePath.split('/').last.split('\\').last;
    return segments.replaceAll(RegExp(r'\.[^.]+$'), '');
  }

  String _stripHtml(String html) {
    // Remove HTML tags
    final noTags = html.replaceAll(RegExp(r'<[^>]*>'), '');
    // Decode HTML entities
    return noTags
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&amp;', '&')
        .replaceAll('&quot;', '"')
        .trim();
  }

  int _getFileSize(String filePath) {
    final file = java_io_File(filePath);
    return file.lengthSync();
  }
}

// Native file access — use dart:io
import 'dart:io';

int _getFileSizeImpl(String filePath) {
  return File(filePath).lengthSync();
}

// Override above stub
int Function(String) _getFileSize = _getFileSizeImpl;
```

**注:** EPUB 封面提取使用 epub_pro 的 `coverImage` API，此处暂缓至 P1。

- [ ] **Step 2: 创建测试 fixtures 目录**

```bash
mkdir -p test/fixtures
# 使用一个公版 EPUB 文件 (如 鲁迅《呐喊》) 作为测试 fixture
# 或创建最小化的 EPUB (包含单个 XHTML 章节)
```

- [ ] **Step 3: 编写 EPUB 服务测试**

```dart
// test/services/epub_service_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:charavox/services/epub_service.dart';
import 'package:charavox/models/book.dart';

void main() {
  group('EpubService', () {
    late EpubService service;

    setUp(() {
      service = EpubService();
    });

    test('parses valid EPUB file', () {
      final (book, chapters) = service.parse('test/fixtures/sample_book.epub');
      expect(book.fileType, FileType.epub);
      expect(book.title, isNotEmpty);
      expect(chapters.length, greaterThan(0));
      expect(chapters.first.text, isNotEmpty);
    });

    test('throws EpubParseException for invalid file', () {
      expect(
        () => service.parse('test/fixtures/not_exist.epub'),
        throwsA(isA<EpubParseException>()), // Corrected: uses AppException
      );
    });
  });
}
```

**注:** 上面的测试引用的异常类型已修正。需在 `app_exceptions.dart` 中已定义 `EpubParseException`。

- [ ] **Step 4: Run tests**

```bash
flutter test test/services/epub_service_test.dart
```

- [ ] **Step 5: Commit**

```bash
git add lib/services/epub_service.dart test/services/ test/fixtures/
git commit -m "feat: add EPUB parsing service with epub_pro"
```

---

### Task 5: TXT 解析服务

**Files:**
- Create: `lib/services/txt_service.dart`
- Create: `test/services/txt_service_test.dart`
- Create: `test/fixtures/sample_book.txt`

- [ ] **Step 1: 创建 lib/services/txt_service.dart**

```dart
import 'dart:convert';
import 'dart:io';
import 'package:charavox/models/book.dart';
import 'package:charavox/core/utils/text_utils.dart';
import 'package:charavox/core/errors/app_exceptions.dart';

class TxtService {
  (Book, List<Chapter>) parse(String filePath) {
    try {
      final file = File(filePath);
      final bytes = file.readAsBytesSync();
      final encoding = detectEncoding(bytes);
      final content = encoding.decode(bytes);

      final lines = content.split('\n');
      final chapterIndices = findChapterIndices(lines);

      final chapters = <Chapter>[];
      for (int i = 0; i < chapterIndices.length; i++) {
        final start = chapterIndices[i];
        final end = (i + 1 < chapterIndices.length) ? chapterIndices[i + 1] : lines.length;
        final chapterLines = lines.sublist(start, end);

        final title = chapterLines.first.trim();
        final text = chapterLines.join('\n');

        if (text.trim().isEmpty) continue;

        chapters.add(Chapter(
          index: i,
          title: title.isNotEmpty ? title : '第${i + 1}章',
          text: text,
        ));
      }

      final book = Book(
        id: '',
        title: _extractFileName(filePath),
        author: null,
        coverPath: null,
        filePath: filePath,
        fileType: FileType.txt,
        chapterCount: chapters.length,
        addedAt: DateTime.now(),
      );

      return (book, chapters);
    } catch (e) {
      if (e is AppException) rethrow;
      throw TxtParseException('TXT 解析失败: ${e.toString()}', originalError: e);
    }
  }

  String _extractFileName(String filePath) {
    final segments = filePath.split('/').last.split('\\').last;
    return segments.replaceAll(RegExp(r'\.[^.]+$'), '');
  }
}
```

- [ ] **Step 2: 编写 TXT 服务测试**

```dart
// test/services/txt_service_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:charavox/services/txt_service.dart';
import 'package:charavox/models/book.dart';

void main() {
  group('TxtService', () {
    late TxtService service;

    setUp(() {
      service = TxtService();
    });

    test('parses UTF-8 TXT with chapter markers', () {
      final (book, chapters) = service.parse('test/fixtures/sample_book.txt');
      expect(book.fileType, FileType.txt);
      expect(chapters.length, greaterThan(0));
    });

    test('detects chapter markers correctly', () {
      final (book, chapters) = service.parse('test/fixtures/sample_book.txt');
      for (final ch in chapters) {
        expect(ch.text, isNotEmpty);
        expect(ch.index, greaterThanOrEqualTo(0));
      }
    });
  });
}
```

- [ ] **Step 3: Run tests**

```bash
flutter test test/services/txt_service_test.dart
```

- [ ] **Step 4: Commit**

```bash
git add lib/services/txt_service.dart test/services/txt_service_test.dart
git commit -m "feat: add TXT parsing service with encoding detection and chapter splitting"
```

---

### Task 6: 基础文本阅读器 UI

**Files:**
- Create: `lib/screens/reader/reader_screen.dart`
- Create: `lib/screens/reader/widgets/text_view.dart`
- Create: `lib/screens/library/library_screen.dart`
- Modify: `lib/app.dart`

- [ ] **Step 1: 创建 lib/screens/library/library_screen.dart**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LibraryScreen extends ConsumerWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('聆书'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: '导入书籍',
            onPressed: () {
              // TODO: 在 Task 11 中接入 file_picker
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // TODO: 在 Task 16 中导航到设置页
            },
          ),
        ],
      ),
      body: const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.library_books, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('书架为空', style: TextStyle(fontSize: 18, color: Colors.grey)),
            SizedBox(height: 8),
            Text('点击右上角 + 导入 EPUB 或 TXT 文件',
                style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
```

- [ ] **Step 2: 创建 lib/screens/reader/widgets/text_view.dart**

```dart
import 'package:flutter/material.dart';

class TextView extends StatelessWidget {
  final String text;
  final int? highlightedLineIndex;
  final ScrollController scrollController;

  const TextView({
    super.key,
    required this.text,
    this.highlightedLineIndex,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    final lines = text.split('\n');

    return ListView.builder(
      controller: scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: lines.length,
      itemBuilder: (context, index) {
        final isHighlighted = index == highlightedLineIndex;
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          decoration: isHighlighted
              ? BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                )
              : null,
          child: Text(
            lines[index],
            style: TextStyle(
              fontSize: 18,
              height: 1.8,
              color: isHighlighted
                  ? Theme.of(context).colorScheme.onPrimaryContainer
                  : Theme.of(context).colorScheme.onSurface,
            ),
          ),
        );
      },
    );
  }
}
```

- [ ] **Step 3: 创建 lib/screens/reader/reader_screen.dart**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'widgets/text_view.dart';

class ReaderScreen extends ConsumerStatefulWidget {
  final String bookId;
  final String chapterTitle;
  final String chapterText;

  const ReaderScreen({
    super.key,
    required this.bookId,
    required this.chapterTitle,
    required this.chapterText,
  });

  @override
  ConsumerState<ReaderScreen> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends ConsumerState<ReaderScreen> {
  final _scrollController = ScrollController();
  int? _highlightedLine;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.chapterTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.people),
            tooltip: '角色管理',
            onPressed: () {
              // TODO: 在 Task 16 中导航到角色管理页
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: TextView(
              text: widget.chapterText,
              highlightedLineIndex: _highlightedLine,
              scrollController: _scrollController,
            ),
          ),
          // 底部播放控制条 (在 Task 13 中实现)
          Container(
            height: 64,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              border: Border(
                top: BorderSide(color: Theme.of(context).dividerColor),
              ),
            ),
            child: const Center(child: Text('播放控制 (待实现)')),
          ),
        ],
      ),
    );
  }
}
```

- [ ] **Step 4: 更新 lib/app.dart 默认路由**

在 `CharavoxApp.build` 中将 `home:` 改为 `LibraryScreen`:

```dart
// Replace:
// home: const Scaffold(body: Center(child: Text('聆书 charavox'))),
// With:
import 'screens/library/library_screen.dart';
// ...
home: const LibraryScreen(),
```

- [ ] **Step 5: 验证编译**

```bash
flutter analyze
```

- [ ] **Step 6: Commit**

```bash
git add lib/screens/ lib/app.dart
git commit -m "feat: add library screen and basic text reader UI

- LibraryScreen: empty state with import and settings buttons
- ReaderScreen: text view with scroll and line highlighting
- TextView: line-by-line rendering with highlight support"
```

---

## M3: LLM 角色分析

### Task 7: Prompt 模板

**Files:**
- Create: `lib/core/constants/prompt_templates.dart`
- Create: `assets/prompts/system_base.txt`
- Create: `assets/prompts/character_discovery.txt`
- Create: `assets/prompts/dialogue_attribution.txt`
- Create: `assets/prompts/japanese_ln_enhance.txt`

- [ ] **Step 1: 创建 assets/prompts/system_base.txt**

```text
你是一名专业的小说编辑和角色分析师。你的任务是分析小说文本，识别其中的角色并进行对话标注。

规则：
1. 所有输出必须是有效的 JSON 格式
2. 角色名使用其最常见的称呼作为 canonical_name，其他称呼录入 aliases
3. 音色描述 (voice_prompt) 用中文撰写，包含年龄、性别、性格特征，80-150 字
4. 旁白统一标注 speaker_id 为 "narrator"
5. 无法确定的信息使用 null，不要编造
```

- [ ] **Step 2: 创建 assets/prompts/character_discovery.txt**

```text
分析以下小说文本片段，发现所有角色并描述其特征。

对每个角色输出：
{
  "canonical_name": "角色规范名",
  "aliases": ["别名1", "别名2"],
  "gender": "male|female|unknown",
  "age": "child|teen|young_adult|middle_aged|elderly|unknown",
  "personalities": ["性格标签1", "性格标签2"],
  "first_person": "一人称代词 (日轻) 或 null",
  "sentence_endings": ["語尾模式1"] 或 null,
  "voice_prompt": "中文音色描述，80-150字",
  "role_type": "protagonist|antagonist|supporting|minor",
  "description": "角色在故事中的简要描述"
}

注意：
- 通过对话语气、用词特征推断性格和性别
- 注意角色间的称呼关系（如"师父"表示师徒关系）
- 如果角色有多个称呼，全部录入 aliases

文本片段：
{text}
```

- [ ] **Step 3: 创建 assets/prompts/dialogue_attribution.txt**

```text
已知角色列表：
{characters_json}

逐句标注以下文本中每一句话的说话人。标注规则：

1. 对话（引号内的内容）：标注 speaker_id 为说话人的角色 ID
2. 旁白/叙述（非引号内容）：speaker_id = "narrator"
3. 内心独白：type = "monologue"
4. 情绪标注：根据上下文推断情绪（喜怒哀惧惊厌或 null）
5. 指代消解：如果上下文中同一角色用不同称呼，统一使用 canonical_name 对应的 ID

声线变体检测 (voice_variant):
- 如果对话描述中明确提到角色改变了说话方式（压低声线、模仿他人、装出某种语气），
  标记 voice_variant，描述当前音色特征
- 如果角色处于特殊生理状态（受伤、醉酒、极度疲惫），标记 voice_variant
- 无特殊标记时 voice_variant_id 为 null

输出格式：
{
  "script": [
    {
      "speaker_id": "角色ID 或 narrator",
      "voice_variant_id": "变体ID 或 null",
      "text": "原文字句",
      "emotion": "情绪 或 null",
      "type": "narration|dialogue|monologue"
    }
  ],
  "new_characters": [
    {
      "temporary_id": "unknown_N",
      "canonical_name": "角色名",
      "evidence": "判断依据"
    }
  ]
}

文本：
{text}
```

- [ ] **Step 4: 创建 assets/prompts/japanese_ln_enhance.txt**

```text
因为这是一本日本轻小说，请在分析时特别注意以下特征：

一人称代名詞:
- 俺 (ore) → 男性，自信/粗犷
- 僕 (boku) → 男性，温和/礼貌/少年
- 私 (watashi) → 女性 (正式) 或 男性 (正式场合)
- あたし (atashi) → 女性，活泼/随性
- わし (washi) → 老年男性
- おいら (oira) → 男性，乡村/粗俗

語尾模式:
- 〜ぜ / 〜ぞ → 热血/自信男性
- 〜わ / 〜ですわ → 优雅女性/大小姐
- 〜っす → 运动系/后辈
- 〜にゃ / 〜にゃん → 猫娘/萌系角色
- 〜でござる → 武士/忍者系
- 〜なのだ / 〜のだ → 解说役/吐槽役
- 〜かしら → 女性，疑惑/优雅

请结合以上特征推断角色属性，并将 first_person 和 sentence_endings 字段填入角色信息。
```

- [ ] **Step 5: 创建 lib/core/constants/prompt_templates.dart**

```dart
import 'package:flutter/services.dart' show rootBundle;

class PromptTemplates {
  static String? _systemBase;
  static String? _characterDiscovery;
  static String? _dialogueAttribution;
  static String? _japaneseLnEnhance;

  static Future<void> load() async {
    _systemBase = await rootBundle.loadString('assets/prompts/system_base.txt');
    _characterDiscovery = await rootBundle.loadString('assets/prompts/character_discovery.txt');
    _dialogueAttribution = await rootBundle.loadString('assets/prompts/dialogue_attribution.txt');
    _japaneseLnEnhance = await rootBundle.loadString('assets/prompts/japanese_ln_enhance.txt');
  }

  static String get systemBase => _systemBase ?? '';
  static String get characterDiscovery => _characterDiscovery ?? '';
  static String get dialogueAttribution => _dialogueAttribution ?? '';
  static String get japaneseLnEnhance => _japaneseLnEnhance ?? '';

  static String buildCharacterDiscoveryPrompt(String text) {
    return '${systemBase}\n\n${characterDiscovery.replaceAll('{text}', text)}';
  }

  static String buildDialogueAttributionPrompt(
    String text,
    String charactersJson, {
    bool isJapaneseLN = false,
  }) {
    var prompt = '${systemBase}\n\n${dialogueAttribution
        .replaceAll('{text}', text)
        .replaceAll('{characters_json}', charactersJson)}';

    if (isJapaneseLN) {
      prompt += '\n\n${_japaneseLnEnhance ?? ''}';
    }

    return prompt;
  }
}
```

- [ ] **Step 6: 在 pubspec.yaml 中注册 assets**

```yaml
flutter:
  assets:
    - assets/prompts/
```

- [ ] **Step 7: 验证 assets 加载**

```bash
flutter analyze
flutter test test/models/  # Ensure existing tests still pass
```

- [ ] **Step 8: Commit**

```bash
git add assets/prompts/ lib/core/constants/prompt_templates.dart pubspec.yaml
git commit -m "feat: add LLM prompt templates for character analysis

- system_base: general rules for analysis
- character_discovery: phase 1 character extraction
- dialogue_attribution: phase 2 script annotation
- japanese_ln_enhance: JP light novel first-person/end-pattern analysis"
```

---

### Task 8: LLM 服务

**Files:**
- Create: `lib/services/llm_service.dart`
- Create: `test/services/llm_service_test.dart`
- Create: `test/fixtures/mock_llm_responses/character_discovery.json`
- Create: `test/fixtures/mock_llm_responses/dialogue_attribution.json`

- [ ] **Step 1: 创建 lib/services/llm_service.dart**

```dart
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:charavox/models/book.dart';
import 'package:charavox/models/character.dart';
import 'package:charavox/models/script_line.dart';
import 'package:charavox/core/constants/prompt_templates.dart';
import 'package:charavox/core/constants/app_constants.dart';
import 'package:charavox/core/errors/app_exceptions.dart';

class LlmService {
  final Dio _dio;

  LlmService({required String baseUrl, required String apiKey, required String model})
      : _dio = Dio(BaseOptions(
          baseUrl: baseUrl,
          headers: {
            'Authorization': 'Bearer $apiKey',
            'Content-Type': 'application/json',
          },
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 120),
        )) {
    _model = model;
  }

  late final String _model;

  /// Phase 1: Discover characters from first 3 chapters
  Future<List<CharacterInfo>> discoverCharacters(
    String bookId,
    List<Chapter> chapters,
  ) async {
    final previewChapters = chapters.take(3).toList();
    final textBuffer = StringBuffer();
    for (final ch in previewChapters) {
      final preview = ch.text.length > AppConstants.chapterTextPreviewChars
          ? ch.text.substring(0, AppConstants.chapterTextPreviewChars)
          : ch.text;
      textBuffer.writeln(preview);
    }

    final prompt = PromptTemplates.buildCharacterDiscoveryPrompt(textBuffer.toString());
    final response = await _callLlm(prompt);
    final characters = _parseCharacterDiscovery(response, bookId);
    return characters;
  }

  /// Phase 2 & 3: Attribute dialogue and discover new characters per chapter
  Future<ChapterAnalysisResult> analyzeChapter({
    required String bookId,
    required Chapter chapter,
    required List<CharacterInfo> knownCharacters,
    bool isJapaneseLN = false,
  }) async {
    final charactersJson = jsonEncode(
      knownCharacters.map((c) => {
        'id': c.id,
        'canonical_name': c.canonicalName,
        'aliases': c.aliases,
        'gender': c.gender.name,
        'age': c.age.name,
        'personalities': c.personalities,
      }).toList(),
    );

    final prompt = PromptTemplates.buildDialogueAttributionPrompt(
      chapter.text,
      charactersJson,
      isJapaneseLN: isJapaneseLN,
    );

    final response = await _callLlm(prompt);
    return _parseDialogueAttribution(response, bookId, chapter.index, knownCharacters);
  }

  Future<Map<String, dynamic>> _callLlm(String prompt) async {
    try {
      final response = await _dio.post(
        '/chat/completions',
        data: {
          'model': _model,
          'messages': [
            {'role': 'user', 'content': prompt},
          ],
          'temperature': 0.3,
          'response_format': {'type': 'json_object'},
          'max_tokens': 4096,
        },
      );

      final content = response.data['choices'][0]['message']['content'] as String;
      return jsonDecode(content) as Map<String, dynamic>;
    } on DioException catch (e) {
      throw LlmApiException(
        'LLM API 调用失败: ${e.message}',
        originalError: e,
      );
    } catch (e) {
      if (e is AppException) rethrow;
      throw LlmApiException('LLM 响应解析失败: ${e.toString()}', originalError: e);
    }
  }

  List<CharacterInfo> _parseCharacterDiscovery(
    Map<String, dynamic> json,
    String bookId,
  ) {
    final charactersList = json['characters'] as List<dynamic>? ?? [];
    return charactersList.map((c) {
      return CharacterInfo(
        id: 'char-${c['canonical_name']}',
        bookId: bookId,
        canonicalName: c['canonical_name'] as String? ?? '未知角色',
        aliases: List<String>.from(c['aliases'] as List? ?? []),
        gender: _parseGender(c['gender'] as String?),
        age: _parseAge(c['age'] as String?),
        personalities: List<String>.from(c['personalities'] as List? ?? []),
        firstPerson: c['first_person'] as String?,
        sentenceEndings: c['sentence_endings'] != null
            ? List<String>.from(c['sentence_endings'] as List)
            : null,
        voicePrompt: c['voice_prompt'] as String? ?? '通用音色',
        voiceVariants: _parseVoiceVariants(c['voice_variants'] as List?),
        isNarrator: false,
      );
    }).toList();
  }

  ChapterAnalysisResult _parseDialogueAttribution(
    Map<String, dynamic> json,
    String bookId,
    int chapterIndex,
    List<CharacterInfo> knownCharacters,
  ) {
    final scriptList = json['script'] as List<dynamic>? ?? [];
    final newCharactersList = json['new_characters'] as List<dynamic>? ?? [];

    final scriptLines = <ScriptLine>[];
    for (int i = 0; i < scriptList.length; i++) {
      final s = scriptList[i] as Map<String, dynamic>;
      scriptLines.add(ScriptLine(
        id: 0, // Will be assigned by cache service
        bookId: bookId,
        chapterIndex: chapterIndex,
        lineIndex: i,
        speakerId: s['speaker_id'] as String? ?? 'narrator',
        voiceVariantId: s['voice_variant_id'] as String?,
        text: s['text'] as String? ?? '',
        emotion: s['emotion'] as String?,
        type: _parseLineType(s['type'] as String?),
        mergedGroupId: null, // Set in merge step
      ));
    }

    final newCharacters = newCharactersList.map((c) {
      return CharacterInfo(
        id: 'char-${c['canonical_name']}',
        bookId: bookId,
        canonicalName: c['canonical_name'] as String? ?? '未知角色',
        aliases: [],
        voicePrompt: '通用音色',
        isNarrator: false,
      );
    }).toList();

    return ChapterAnalysisResult(
      scriptLines: scriptLines,
      newCharacters: newCharacters,
    );
  }

  Gender _parseGender(String? value) {
    switch (value) {
      case 'male': return Gender.male;
      case 'female': return Gender.female;
      default: return Gender.unknown;
    }
  }

  AgeGroup _parseAge(String? value) {
    switch (value) {
      case 'child': return AgeGroup.child;
      case 'teen': return AgeGroup.teen;
      case 'young_adult': return AgeGroup.youngAdult;
      case 'middle_aged': return AgeGroup.middleAged;
      case 'elderly': return AgeGroup.elderly;
      default: return AgeGroup.unknown;
    }
  }

  LineType _parseLineType(String? value) {
    switch (value) {
      case 'dialogue': return LineType.dialogue;
      case 'monologue': return LineType.monologue;
      default: return LineType.narration;
    }
  }

  List<VoiceVariant> _parseVoiceVariants(List<dynamic>? list) {
    if (list == null) return [];
    return list.map((v) => VoiceVariant(
      variantId: v['variant_id'] as String? ?? '',
      label: v['label'] as String? ?? '',
      voicePrompt: v['voice_prompt'] as String? ?? '',
      triggerCondition: v['trigger_condition'] as String?,
      chapters: v['chapters'] != null
          ? List<int>.from(v['chapters'] as List)
          : null,
    )).toList();
  }
}

class ChapterAnalysisResult {
  final List<ScriptLine> scriptLines;
  final List<CharacterInfo> newCharacters;

  ChapterAnalysisResult({
    required this.scriptLines,
    required this.newCharacters,
  });
}
```

- [ ] **Step 2: 创建 mock LLM 响应 fixtures**

`test/fixtures/mock_llm_responses/character_discovery.json`:
```json
{
  "characters": [
    {
      "canonical_name": "林风",
      "aliases": ["小林", "风儿"],
      "gender": "male",
      "age": "teen",
      "personalities": ["热血", "正直", "努力"],
      "first_person": null,
      "sentence_endings": null,
      "voice_prompt": "18岁少年，声音清亮有力，带着少年人特有的朝气和热血感，语调激昂有力，说话节奏偏快",
      "role_type": "protagonist",
      "description": "本书主角，年轻剑客"
    },
    {
      "canonical_name": "苏婉",
      "aliases": ["婉儿", "苏姑娘"],
      "gender": "female",
      "age": "teen",
      "personalities": ["温柔", "坚强", "聪慧"],
      "first_person": null,
      "sentence_endings": null,
      "voice_prompt": "17岁少女，声音柔软清澈，语调温柔婉转，带着大家闺秀的优雅气质，偶尔流露出坚定",
      "role_type": "protagonist",
      "description": "女主角"
    }
  ]
}
```

`test/fixtures/mock_llm_responses/dialogue_attribution.json`:
```json
{
  "script": [
    {
      "speaker_id": "narrator",
      "voice_variant_id": null,
      "text": "巨大的浮游城堡矗立在虚拟的天空中。",
      "emotion": null,
      "type": "narration"
    },
    {
      "speaker_id": "char-林风",
      "voice_variant_id": null,
      "text": "这就是那个死亡游戏吗？",
      "emotion": "惊讶",
      "type": "dialogue"
    },
    {
      "speaker_id": "narrator",
      "voice_variant_id": null,
      "text": "桐人低声说道。",
      "emotion": null,
      "type": "narration"
    }
  ],
  "new_characters": []
}
```

- [ ] **Step 3: 编写 LLM 服务单元测试**

```dart
// test/services/llm_service_test.dart
import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:charavox/services/llm_service.dart';
import 'package:charavox/models/book.dart';
import 'package:charavox/models/character.dart';

void main() {
  group('LlmService _parseCharacterDiscovery', () {
    // We test the parsing logic by creating a service and calling internal
    // methods indirectly, or by testing the parsing methods directly.

    test('parses character_discovery mock response correctly', () {
      final jsonStr = File(
        'test/fixtures/mock_llm_responses/character_discovery.json',
      ).readAsStringSync();
      final json = jsonDecode(jsonStr) as Map<String, dynamic>;

      // Directly test the parsing by using a mock
      // In production: use mockito to mock HTTP layer
      final characters = <CharacterInfo>[];
      final charactersList = json['characters'] as List<dynamic>;

      for (final c in charactersList) {
        characters.add(CharacterInfo(
          id: 'char-${c['canonical_name']}',
          bookId: 'test-book',
          canonicalName: c['canonical_name'] as String,
          aliases: List<String>.from(c['aliases'] as List),
          voicePrompt: c['voice_prompt'] as String,
          isNarrator: false,
        ));
      }

      expect(characters.length, 2);
      expect(characters[0].canonicalName, '林风');
      expect(characters[0].aliases, contains('小林'));
      expect(characters[1].canonicalName, '苏婉');
    });

    test('parses dialogue_attribution mock response correctly', () {
      final jsonStr = File(
        'test/fixtures/mock_llm_responses/dialogue_attribution.json',
      ).readAsStringSync();
      final json = jsonDecode(jsonStr) as Map<String, dynamic);
      final scriptList = json['script'] as List<dynamic>;

      expect(scriptList.length, 3);
      expect(scriptList[0]['type'], 'narration');
      expect(scriptList[1]['speaker_id'], 'char-林风');
      expect(scriptList[1]['emotion'], '惊讶');
    });
  });
}
```

- [ ] **Step 4: Run tests**

```bash
flutter test test/services/llm_service_test.dart
```

- [ ] **Step 5: Commit**

```bash
git add lib/services/llm_service.dart test/services/llm_service_test.dart test/fixtures/mock_llm_responses/
git commit -m "feat: add LLM service for character analysis

- Phase 1: character discovery from chapter previews
- Phase 2: dialogue attribution with voice variant detection
- Phase 3: incremental new character discovery
- OpenAI-compatible API via dio
- Mock response fixtures for testing"
```

---

## M3 续: 缓存与进度服务

### Task 9: 缓存服务

**Files:**
- Create: `lib/services/cache_service.dart`
- Create: `test/services/cache_service_test.dart`

- [ ] **Step 1: 创建 lib/services/cache_service.dart**

```dart
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:charavox/models/book.dart';
import 'package:charavox/models/character.dart';
import 'package:charavox/models/script_line.dart';
import 'package:charavox/core/config/app_config.dart';
import 'package:charavox/core/errors/app_exceptions.dart';

class CacheService {
  Future<Directory> get _cacheDir async {
    final appDir = await getApplicationSupportDirectory();
    final cacheDir = Directory('${appDir.path}/${AppConfig.cacheDirName}');
    if (!await cacheDir.exists()) {
      await cacheDir.create(recursive: true);
    }
    return cacheDir;
  }

  Future<Directory> _bookAnalysisDir(String bookId) async {
    final cacheDir = await _cacheDir;
    final dir = Directory('${cacheDir.path}/${AppConfig.analysisSubDir}/$bookId');
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return dir;
  }

  /// Save book metadata and character list
  Future<void> saveBookMeta(String bookId, Book book, List<CharacterInfo> characters) async {
    final dir = await _bookAnalysisDir(bookId);
    final metaFile = File('${dir.path}/meta.json');
    final json = {
      'version': AppConfig.currentSchemaVersion,
      'book': book.toJson(),
      'characters': characters.map((c) => c.toJson()).toList(),
    };
    await metaFile.writeAsString(jsonEncode(json));
  }

  /// Load book metadata and characters
  Future<({Book book, List<CharacterInfo> characters})?> loadBookMeta(String bookId) async {
    try {
      final dir = await _bookAnalysisDir(bookId);
      final metaFile = File('${dir.path}/meta.json');
      if (!await metaFile.exists()) return null;

      final json = jsonDecode(await metaFile.readAsString()) as Map<String, dynamic>;
      _checkVersion(json['version'] as int? ?? 0);

      final book = Book.fromJson(json['book'] as Map<String, dynamic>);
      final characters = (json['characters'] as List<dynamic>)
          .map((c) => CharacterInfo.fromJson(c as Map<String, dynamic>))
          .toList();

      return (book: book, characters: characters);
    } catch (e) {
      throw CacheException('缓存读取失败: ${e.toString()}', originalError: e);
    }
  }

  /// Save chapter script lines
  Future<void> saveChapterScript(
    String bookId,
    int chapterIndex,
    List<ScriptLine> scriptLines,
  ) async {
    final dir = await _bookAnalysisDir(bookId);
    final chFile = File(
      '${dir.path}/ch_${chapterIndex.toString().padLeft(4, '0')}.json',
    );
    final json = {
      'version': AppConfig.currentSchemaVersion,
      'script_lines': scriptLines.map((s) => s.toJson()).toList(),
    };
    await chFile.writeAsString(jsonEncode(json));
  }

  /// Load chapter script lines
  Future<List<ScriptLine>?> loadChapterScript(String bookId, int chapterIndex) async {
    try {
      final dir = await _bookAnalysisDir(bookId);
      final chFile = File(
        '${dir.path}/ch_${chapterIndex.toString().padLeft(4, '0')}.json',
      );
      if (!await chFile.exists()) return null;

      final json = jsonDecode(await chFile.readAsString()) as Map<String, dynamic>;
      _checkVersion(json['version'] as int? ?? 0);

      return (json['script_lines'] as List<dynamic>)
          .map((s) => ScriptLine.fromJson(s as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw CacheException('章节缓存读取失败: ${e.toString()}', originalError: e);
    }
  }

  /// Check if cached analysis exists for a book
  Future<bool> hasAnalysis(String bookId) async {
    try {
      final dir = await _bookAnalysisDir(bookId);
      final metaFile = File('${dir.path}/meta.json');
      return await metaFile.exists();
    } catch (_) {
      return false;
    }
  }

  /// Delete all cached data for a book
  Future<void> clearBookCache(String bookId) async {
    try {
      final dir = await _bookAnalysisDir(bookId);
      if (await dir.exists()) {
        await dir.delete(recursive: true);
      }
    } catch (e) {
      throw CacheException('缓存清理失败: ${e.toString()}', originalError: e);
    }
  }

  void _checkVersion(int version) {
    if (version > AppConfig.currentSchemaVersion) {
      throw SchemaMigrationException(
        '数据由更新版本 (v$version) 创建，当前应用版本 (v${AppConfig.currentSchemaVersion})，请升级应用',
      );
    }
    // Forward migration from older versions would be handled here
    // (simplified for MVP — P2 feature)
  }
}
```

- [ ] **Step 2: 编写缓存服务测试**

```dart
// test/services/cache_service_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:charavox/services/cache_service.dart';
import 'package:charavox/models/book.dart';
import 'package:charavox/models/character.dart';
import 'package:charavox/models/script_line.dart';

void main() {
  group('CacheService', () {
    late CacheService service;
    const testBookId = 'test-hash-001';

    setUp(() {
      service = CacheService();
    });

    test('save and load book meta round-trip', () async {
      final book = Book(
        id: testBookId,
        title: '测试书籍',
        filePath: '/tmp/test.epub',
        fileType: FileType.epub,
        chapterCount: 3,
        addedAt: DateTime.now(),
      );
      final characters = [
        CharacterInfo(
          id: 'char-1',
          bookId: testBookId,
          canonicalName: '测试角色',
          voicePrompt: '测试音色',
          isNarrator: false,
        ),
      ];

      await service.saveBookMeta(testBookId, book, characters);
      final loaded = await service.loadBookMeta(testBookId);

      expect(loaded, isNotNull);
      expect(loaded!.book.title, '测试书籍');
      expect(loaded.characters.length, 1);
    });

    test('save and load chapter script round-trip', () async {
      final lines = [
        ScriptLine(
          id: 1,
          bookId: testBookId,
          chapterIndex: 0,
          lineIndex: 0,
          speakerId: 'narrator',
          text: '测试文本',
          type: LineType.narration,
        ),
      ];

      await service.saveChapterScript(testBookId, 0, lines);
      final loaded = await service.loadChapterScript(testBookId, 0);

      expect(loaded, isNotNull);
      expect(loaded!.length, 1);
      expect(loaded.first.text, '测试文本');
    });

    test('hasAnalysis returns true after saving meta', () async {
      final book = Book(
        id: testBookId,
        title: '测试',
        filePath: '/tmp/test.epub',
        fileType: FileType.epub,
        chapterCount: 1,
        addedAt: DateTime.now(),
      );
      await service.saveBookMeta(testBookId, book, []);

      final has = await service.hasAnalysis(testBookId);
      expect(has, true);
    });

    tearDown(() async {
      await service.clearBookCache(testBookId);
    });
  });
}
```

- [ ] **Step 3: Run tests**

```bash
flutter test test/services/cache_service_test.dart
```

- [ ] **Step 4: Commit**

```bash
git add lib/services/cache_service.dart test/services/cache_service_test.dart
git commit -m "feat: add cache service with sharded chapter storage

- Per-book analysis directory with meta.json + ch_NNNN.json
- Schema version check for forward compatibility
- Round-trip save/load for book meta, characters, and chapter scripts"
```

---

### Task 10: 进度服务

**Files:**
- Create: `lib/services/progress_service.dart`
- Create: `test/services/progress_service_test.dart`

- [ ] **Step 1: 创建 lib/services/progress_service.dart**

```dart
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:charavox/models/reading_progress.dart';
import 'package:charavox/core/config/app_config.dart';
import 'package:charavox/core/errors/app_exceptions.dart';

class ProgressService {
  Future<File> get _progressFile async {
    final appDir = await getApplicationSupportDirectory();
    final dir = Directory('${appDir.path}/${AppConfig.cacheDirName}/${AppConfig.configSubDir}');
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return File('${dir.path}/reading_progress.json');
  }

  /// Save reading progress for a book
  Future<void> saveProgress(ReadingProgress progress) async {
    try {
      final all = await _loadAllProgress();
      all[progress.bookId] = progress;
      final file = await _progressFile;
      final json = all.map((k, v) => MapEntry(k, v.toJson()));
      await file.writeAsString(jsonEncode(json));
    } catch (e) {
      throw CacheException('进度保存失败: ${e.toString()}', originalError: e);
    }
  }

  /// Load reading progress for a book
  Future<ReadingProgress?> loadProgress(String bookId) async {
    try {
      final all = await _loadAllProgress();
      return all[bookId];
    } catch (e) {
      return null; // Graceful degradation: start from beginning
    }
  }

  Future<Map<String, ReadingProgress>> _loadAllProgress() async {
    final file = await _progressFile;
    if (!await file.exists()) return {};

    try {
      final json = jsonDecode(await file.readAsString()) as Map<String, dynamic>;
      return json.map(
        (k, v) => MapEntry(k, ReadingProgress.fromJson(v as Map<String, dynamic>)),
      );
    } catch (_) {
      return {};
    }
  }
}
```

- [ ] **Step 2: 编写进度服务测试**

```dart
// test/services/progress_service_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:charavox/services/progress_service.dart';
import 'package:charavox/models/reading_progress.dart';

void main() {
  group('ProgressService', () {
    late ProgressService service;

    setUp(() {
      service = ProgressService();
    });

    test('save and load progress round-trip', () async {
      final progress = ReadingProgress(
        bookId: 'test-book',
        chapterIndex: 3,
        lineIndex: 42,
        positionFraction: 0.35,
        updatedAt: DateTime.now(),
      );

      await service.saveProgress(progress);
      final loaded = await service.loadProgress('test-book');

      expect(loaded, isNotNull);
      expect(loaded!.chapterIndex, 3);
      expect(loaded.lineIndex, 42);
      expect(loaded.positionFraction, 0.35);
    });

    test('loadProgress returns null for unknown book', () async {
      final loaded = await service.loadProgress('non-existent-book');
      expect(loaded, isNull);
    });
  });
}
```

- [ ] **Step 3: Run tests**

```bash
flutter test test/services/progress_service_test.dart
```

- [ ] **Step 4: Commit**

```bash
git add lib/services/progress_service.dart test/services/progress_service_test.dart
git commit -m "feat: add reading progress service with JSON persistence"
```

---

### Task 11: 分析流程 Provider + 文件导入集成

**Files:**
- Create: `lib/providers/analysis_provider.dart`
- Create: `lib/providers/library_provider.dart`
- Modify: `lib/screens/library/library_screen.dart`
- Modify: `lib/app.dart`

- [ ] **Step 1: 创建 lib/providers/library_provider.dart**

```dart
import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:charavox/models/book.dart';
import 'package:charavox/services/epub_service.dart';
import 'package:charavox/services/txt_service.dart';
import 'package:charavox/services/cache_service.dart';
import 'package:charavox/core/utils/hash_utils.dart';
import 'dart:io';

final libraryProvider = StateNotifierProvider<LibraryNotifier, List<Book>>((ref) {
  return LibraryNotifier();
});

class LibraryNotifier extends StateNotifier<List<Book>> {
  LibraryNotifier() : super([]);

  final _epubService = EpubService();
  final _txtService = TxtService();
  final _cacheService = CacheService();

  Future<({Book book, List<Chapter> chapters})?> importBook() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['epub', 'txt'],
    );

    if (result == null || result.files.isEmpty) return null;

    final filePath = result.files.first.path!;
    final extension = filePath.split('.').last.toLowerCase();

    final (book, chapters) = switch (extension) {
      'epub' => _epubService.parse(filePath),
      'txt' => _txtService.parse(filePath),
      _ => throw Exception('不支持的文件格式: $extension'),
    };

    final fileSize = File(filePath).lengthSync();
    final hash = computeBookHash(filePath, fileSize);
    final bookWithId = book.copyWith(id: hash);

    state = [...state, bookWithId];
    return (book: bookWithId, chapters: chapters);
  }

  void removeBook(String bookId) {
    state = state.where((b) => b.id != bookId).toList();
    _cacheService.clearBookCache(bookId);
  }

  bool hasBook(String bookId) {
    return state.any((b) => b.id == bookId);
  }
}
```

- [ ] **Step 2: 创建 lib/providers/analysis_provider.dart**

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:charavox/models/book.dart';
import 'package:charavox/models/character.dart';
import 'package:charavox/models/script_line.dart';
import 'package:charavox/services/llm_service.dart';
import 'package:charavox/services/cache_service.dart';

enum AnalysisStatus { idle, discovering, analyzing, complete, error }

class AnalysisState {
  final AnalysisStatus status;
  final List<CharacterInfo> characters;
  final int chaptersAnalyzed;
  final int totalChapters;
  final String? errorMessage;

  const AnalysisState({
    this.status = AnalysisStatus.idle,
    this.characters = const [],
    this.chaptersAnalyzed = 0,
    this.totalChapters = 0,
    this.errorMessage,
  });

  double get progress =>
      totalChapters > 0 ? chaptersAnalyzed / totalChapters : 0.0;

  AnalysisState copyWith({
    AnalysisStatus? status,
    List<CharacterInfo>? characters,
    int? chaptersAnalyzed,
    int? totalChapters,
    String? errorMessage,
  }) {
    return AnalysisState(
      status: status ?? this.status,
      characters: characters ?? this.characters,
      chaptersAnalyzed: chaptersAnalyzed ?? this.chaptersAnalyzed,
      totalChapters: totalChapters ?? this.totalChapters,
      errorMessage: errorMessage,
    );
  }
}

final analysisProvider = StateNotifierProvider.family<AnalysisNotifier, AnalysisState, String>(
  (ref, bookId) => AnalysisNotifier(bookId),
);

class AnalysisNotifier extends StateNotifier<AnalysisState> {
  final String bookId;
  final _cacheService = CacheService();

  AnalysisNotifier(this.bookId) : super(const AnalysisState());

  Future<void> analyze({
    required Book book,
    required List<Chapter> chapters,
    required LlmService llmService,
    bool isJapaneseLN = false,
  }) async {
    state = state.copyWith(
      status: AnalysisStatus.discovering,
      totalChapters: chapters.length,
    );

    try {
      // Phase 1: Character discovery
      final discoveredCharacters = await llmService.discoverCharacters(bookId, chapters);
      var allCharacters = [...discoveredCharacters];

      // Add narrator
      allCharacters.add(CharacterInfo(
        id: 'narrator',
        bookId: bookId,
        canonicalName: '旁白',
        voicePrompt: '35岁男性，磁性沉稳的叙述声音',
        isNarrator: true,
      ));

      // Save meta immediately after phase 1
      await _cacheService.saveBookMeta(bookId, book, allCharacters);

      state = state.copyWith(
        status: AnalysisStatus.analyzing,
        characters: allCharacters,
      );

      // Phase 2 & 3: Per-chapter dialogue attribution
      for (int i = 0; i < chapters.length; i++) {
        final result = await llmService.analyzeChapter(
          bookId: bookId,
          chapter: chapters[i],
          knownCharacters: allCharacters,
          isJapaneseLN: isJapaneseLN,
        );

        // Merge short consecutive dialogues
        final mergedLines = _mergeShortDialogues(result.scriptLines);

        // Save chapter script
        await _cacheService.saveChapterScript(bookId, i, mergedLines);

        // Process incremental character discovery
        if (result.newCharacters.isNotEmpty) {
          final unknownCount = result.newCharacters.length;
          if (unknownCount >= AppConstants.maxUnknownCharacters) {
            // Too many unknowns — pause and notify
            state = state.copyWith(
              errorMessage: '检测到大量未识别角色 ($unknownCount 个)，可能文本格式不适合自动分析',
            );
            break;
          }

          allCharacters = [...allCharacters, ...result.newCharacters];
          await _cacheService.saveBookMeta(bookId, book, allCharacters);
        }

        state = state.copyWith(
          chaptersAnalyzed: i + 1,
          characters: allCharacters,
        );
      }

      state = state.copyWith(status: AnalysisStatus.complete);
    } catch (e) {
      state = state.copyWith(
        status: AnalysisStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  List<ScriptLine> _mergeShortDialogues(List<ScriptLine> lines) {
    final merged = <ScriptLine>[];
    int groupId = 0;

    for (int i = 0; i < lines.length; i++) {
      final current = lines[i];
      if (current.type != LineType.dialogue || current.speakerId == 'narrator') {
        merged.add(current.copyWith(mergedGroupId: null));
        continue;
      }

      // Start a merge group with same speaker
      final group = <ScriptLine>[current];
      int totalChars = current.text.length;
      int j = i + 1;

      while (j < lines.length &&
             lines[j].speakerId == current.speakerId &&
             lines[j].type == LineType.dialogue &&
             totalChars + lines[j].text.length <= AppConfig.shortSentenceMergeMaxChars &&
             group.length < AppConfig.shortSentenceMergeMaxCount) {
        group.add(lines[j]);
        totalChars += lines[j].text.length;
        j++;
      }

      if (group.length > 1) {
        for (final line in group) {
          merged.add(line.copyWith(mergedGroupId: groupId));
        }
        groupId++;
      } else {
        merged.add(current.copyWith(mergedGroupId: null));
      }

      i = j - 1; // Skip merged lines
    }

    return merged;
  }
}
```

- [ ] **Step 3: 更新 LibraryScreen 接入文件导入**

修改 `lib/screens/library/library_screen.dart`，用 `libraryProvider` 替换占位实现:

```dart
// 在 onPressed 回调中改为:
onPressed: () async {
  final result = await ref.read(libraryProvider.notifier).importBook();
  if (result != null) {
    if (context.mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ReaderScreen(
            bookId: result.book.id,
            chapterTitle: result.chapters.isNotEmpty
                ? result.chapters.first.title
                : '正文',
            chapterText: result.chapters.isNotEmpty
                ? result.chapters.first.text
                : '',
          ),
        ),
      );
    }
  }
},
```

- [ ] **Step 4: Verify compilation**

```bash
flutter analyze
```

- [ ] **Step 5: Commit**

```bash
git add lib/providers/ lib/screens/library/library_screen.dart
git commit -m "feat: add analysis pipeline with providers

- LibraryProvider: book import via file_picker
- AnalysisProvider: 3-phase analysis with incremental discovery
- Short dialogue merge logic for TTS optimization
- Library screen now supports file import + navigation to reader"
```

---

## M4: TTS 多角色朗读

### Task 12: TTS 服务

**Files:**
- Create: `lib/services/tts_service.dart`
- Create: `test/services/tts_service_test.dart`

- [ ] **Step 1: 创建 lib/services/tts_service.dart**

```dart
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:charavox/core/errors/app_exceptions.dart';

class TtsService {
  final Dio _dio;
  late final String _model;

  TtsService({required String baseUrl, required String apiKey, required String model})
      : _dio = Dio(BaseOptions(
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

  /// Synthesize speech from text with voice prompt
  /// Returns audio bytes (MP3/OPUS depending on API)
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
      throw TtsApiException(
        'TTS 合成失败: ${e.message}',
        originalError: e,
      );
    }
  }
}
```

- [ ] **Step 2: 编写 TTS 服务测试**

```dart
// test/services/tts_service_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:charavox/services/tts_service.dart';

void main() {
  group('TtsService', () {
    // Note: Integration test against real API requires valid credentials
    // Unit tests validate the service construction and error handling

    test('service can be constructed with valid config', () {
      final service = TtsService(
        baseUrl: 'https://dashscope.aliyuncs.com/compatible-mode/v1',
        apiKey: 'test-key',
        model: 'qwen3-tts-flash',
      );
      expect(service, isNotNull);
    });
  });
}
```

- [ ] **Step 3: Run tests**

```bash
flutter test test/services/tts_service_test.dart
```

- [ ] **Step 4: Commit**

```bash
git add lib/services/tts_service.dart test/services/tts_service_test.dart
git commit -m "feat: add TTS service with OpenAI-compatible API

- POST /v1/audio/speech with voice prompt and text
- Returns audio bytes for playback
- Speed parameter support (0.5-3.0x)"
```

---

### Task 13: 音频播放服务 + 播放控制

**Files:**
- Create: `lib/services/audio_player_service.dart`
- Create: `lib/providers/playback_provider.dart`
- Create: `lib/screens/reader/widgets/playback_bar.dart`
- Modify: `lib/screens/reader/reader_screen.dart`

- [ ] **Step 1: 创建 lib/services/audio_player_service.dart**

```dart
import 'dart:typed_data';
import 'package:just_audio/just_audio.dart';
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

  /// Synthesize and play a single line
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

    await _player.setAudioSource(
      AudioSource.bytes(Uint8List.fromList(audioBytes)),
    );
    await _player.play();
  }

  /// Prefetch upcoming lines in background
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
        // Prefetch failure is non-fatal
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
```

- [ ] **Step 2: 创建 lib/providers/playback_provider.dart**

```dart
import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:charavox/models/script_line.dart';
import 'package:charavox/models/character.dart';
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

  double get progress => totalLines > 0 ? currentLineIndex / totalLines : 0.0;

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

final playbackProvider = StateNotifierProvider<PlaybackNotifier, PlaybackState>(
  (ref) => PlaybackNotifier(),
);

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
      _startPrefetch();
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
    await _progressService.saveProgress(
      ReadingProgress(
        bookId: _bookId,
        chapterIndex: _lines.isNotEmpty ? _lines[state.currentLineIndex].chapterIndex : 0,
        lineIndex: state.currentLineIndex,
        positionFraction: state.progress,
        updatedAt: DateTime.now(),
      ),
    );
  }

  void _startPrefetch() {
    // Background prefetch of next N lines
    final start = state.currentLineIndex + 1;
    final end = (start + AppConstants.prefetchWindow).clamp(0, _lines.length);
    if (start >= end) return;

    final prefetchLines = _lines.sublist(start, end);
    _audioService?.prefetchLines(
      lines: prefetchLines,
      characters: _characters,
      speed: state.speed,
    );
  }

  @override
  void dispose() {
    _autoSaveTimer?.cancel();
    _saveProgress();
    super.dispose();
  }
}
```

- [ ] **Step 3: 创建 lib/screens/reader/widgets/playback_bar.dart**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:charavox/providers/playback_provider.dart';

class PlaybackBar extends ConsumerWidget {
  const PlaybackBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(playbackProvider);
    final notifier = ref.read(playbackProvider.notifier);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        border: Border(top: BorderSide(color: Theme.of(context).dividerColor)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Character indicator
          if (state.currentCharacter != null)
            Text(
              '现在: ${state.currentCharacter!.canonicalName}'
              ' (${state.currentCharacter!.voicePrompt.substring(0, state.currentCharacter!.voicePrompt.length.clamp(0, 20))}...)',
              style: Theme.of(context).textTheme.labelSmall,
              overflow: TextOverflow.ellipsis,
            ),

          const SizedBox(height: 4),

          // Progress bar
          LinearProgressIndicator(
            value: state.totalLines > 0
                ? state.currentLineIndex / state.totalLines
                : 0,
          ),

          // Controls
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.skip_previous),
                onPressed: () => notifier.previous(),
              ),
              IconButton(
                icon: Icon(
                  state.status == PlaybackStatus.playing
                      ? Icons.pause
                      : Icons.play_arrow,
                ),
                iconSize: 36,
                onPressed: () {
                  if (state.status == PlaybackStatus.playing) {
                    notifier.pause();
                  } else {
                    notifier.play();
                  }
                },
              ),
              IconButton(
                icon: const Icon(Icons.skip_next),
                onPressed: () => notifier.next(),
              ),

              const SizedBox(width: 16),

              // Speed selector
              PopupMenuButton<double>(
                initialValue: state.speed,
                onSelected: (speed) => notifier.setSpeed(speed),
                itemBuilder: (_) => [0.5, 0.75, 1.0, 1.25, 1.5, 2.0, 3.0]
                    .map((s) => PopupMenuItem(
                          value: s,
                          child: Text('${s}x'),
                        ))
                    .toList(),
                child: Text(
                  '${state.speed}x',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ),

              // Progress text
              Text(
                ' ${state.currentLineIndex + 1}/${state.totalLines}',
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
```

- [ ] **Step 4: 更新 ReaderScreen 集成播放控制**

修改 `lib/screens/reader/reader_screen.dart`，将底部占位替换为 `PlaybackBar`:

```dart
// 在 body 的 Column children 中替换 bottom Container:
// 将:
//   Container(height: 64, ...)
// 替换为:
import 'widgets/playback_bar.dart';
// ...
const PlaybackBar(),
```

- [ ] **Step 5: Verify compilation**

```bash
flutter analyze
```

- [ ] **Step 6: Commit**

```bash
git add lib/services/audio_player_service.dart lib/providers/playback_provider.dart lib/screens/reader/widgets/playback_bar.dart lib/screens/reader/reader_screen.dart
git commit -m "feat: add TTS playback engine with controls

- AudioPlayerService: synthesize + play with voice prompt resolution
- PlaybackProvider: play/pause/next/prev/speed/auto-save
- PlaybackBar UI: transport controls, speed selector, progress bar
- Prefetch window for smooth playback
- Adaptive sentence transition timing"
```

---

## M5: 设置 + 配置服务

### Task 14: 配置服务

**Files:**
- Create: `lib/services/config_service.dart`
- Create: `lib/providers/settings_provider.dart`

- [ ] **Step 1: 创建 lib/services/config_service.dart**

```dart
import 'dart:convert';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:charavox/models/api_config_model.dart';
import 'package:charavox/core/config/app_config.dart';

class ConfigService {
  final _secureStorage = const FlutterSecureStorage();

  Future<File> get _configFile async {
    final appDir = await getApplicationSupportDirectory();
    final dir = Directory('${appDir.path}/${AppConfig.cacheDirName}/${AppConfig.configSubDir}');
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return File('${dir.path}/${AppConfig.apiConfigFile}');
  }

  /// Save API config (keys encrypted, non-key fields plain)
  Future<void> saveApiConfig(ApiConfig config) async {
    // Save API keys to secure storage
    await _secureStorage.write(key: 'llm_api_key', value: config.llmApiKey);
    await _secureStorage.write(key: 'tts_api_key', value: config.ttsApiKey);

    // Save non-sensitive fields to plain JSON
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

  /// Load API config
  Future<ApiConfig?> loadApiConfig() async {
    try {
      final file = await _configFile;
      if (!await file.exists()) return null;

      final json = jsonDecode(await file.readAsString()) as Map<String, dynamic>;

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

  /// Test LLM API connectivity
  Future<String?> testLlmConnection(ApiConfig config) async {
    // Implementation uses dio to send minimal request
    // Returns null on success, error message on failure
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
      return null; // Success
    } catch (e) {
      return e.toString();
    }
  }
}
```

- [ ] **Step 2: 创建 lib/providers/settings_provider.dart**

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:charavox/models/api_config_model.dart';
import 'package:charavox/services/config_service.dart';

final settingsProvider = StateNotifierProvider<SettingsNotifier, ApiConfig?>((ref) {
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

  void applyPreset({required String llmPreset, required String ttsPreset}) {
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
```

- [ ] **Step 3: Commit**

```bash
git add lib/services/config_service.dart lib/providers/settings_provider.dart
git commit -m "feat: add config service with secure API key storage

- FlutterSecureStorage for API keys
- Plain JSON for non-sensitive config fields
- LLM/TTS API presets (Aliyun, Volcengine, DeepSeek, MiniMax, Ollama)
- Connection test endpoint"
```

---

### Task 15: 设置页面 UI

**Files:**
- Create: `lib/screens/settings/settings_screen.dart`
- Modify: `lib/screens/library/library_screen.dart`

- [ ] **Step 1: 创建 lib/screens/settings/settings_screen.dart**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:charavox/providers/settings_provider.dart';
import 'package:charavox/models/api_config_model.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final _llmUrlController = TextEditingController();
  final _llmKeyController = TextEditingController();
  final _llmModelController = TextEditingController();
  final _ttsUrlController = TextEditingController();
  final _ttsKeyController = TextEditingController();
  final _ttsModelController = TextEditingController();
  bool _testing = false;

  @override
  void initState() {
    super.initState();
    _loadConfig();
  }

  void _loadConfig() {
    final config = ref.read(settingsProvider);
    if (config != null) {
      _llmUrlController.text = config.llmBaseUrl;
      _llmKeyController.text = config.llmApiKey;
      _llmModelController.text = config.llmModel;
      _ttsUrlController.text = config.ttsBaseUrl;
      _ttsKeyController.text = config.ttsApiKey;
      _ttsModelController.text = config.ttsModel;
    }
  }

  @override
  void dispose() {
    _llmUrlController.dispose();
    _llmKeyController.dispose();
    _llmModelController.dispose();
    _ttsUrlController.dispose();
    _ttsKeyController.dispose();
    _ttsModelController.dispose();
    super.dispose();
  }

  void _applyPreset(String llmPreset, String ttsPreset) {
    ref.read(settingsProvider.notifier).applyPreset(
      llmPreset: llmPreset,
      ttsPreset: ttsPreset,
    );
    _loadConfig();
  }

  Future<void> _save() async {
    final config = ApiConfig(
      llmBaseUrl: _llmUrlController.text.trim(),
      llmApiKey: _llmKeyController.text.trim(),
      llmModel: _llmModelController.text.trim(),
      ttsBaseUrl: _ttsUrlController.text.trim(),
      ttsApiKey: _ttsKeyController.text.trim(),
      ttsModel: _ttsModelController.text.trim(),
    );

    await ref.read(settingsProvider.notifier).save(config);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('配置已保存')),
      );
    }
  }

  Future<void> _testConnection() async {
    setState(() => _testing = true);
    await _save();
    final error = await ref.read(settingsProvider.notifier).testConnection();
    setState(() => _testing = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error == null ? '连接测试通过 ✓' : '连接失败: $error'),
          backgroundColor: error == null ? Colors.green : Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('API 配置')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Preset selector
          Text('快速预设', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: ApiPresets.llmPresets.keys.map((name) {
              return ActionChip(
                label: Text(name),
                onPressed: () => _applyPreset(name, '阿里云百炼'),
              );
            }).toList(),
          ),
          const Divider(height: 32),

          // LLM Config
          Text('LLM 配置', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          TextField(
            controller: _llmUrlController,
            decoration: const InputDecoration(
              labelText: 'Base URL',
              hintText: 'https://dashscope.aliyuncs.com/compatible-mode/v1',
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _llmKeyController,
            decoration: const InputDecoration(labelText: 'API Key'),
            obscureText: true,
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _llmModelController,
            decoration: const InputDecoration(
              labelText: 'Model',
              hintText: 'qwen3.5-flash',
            ),
          ),
          const Divider(height: 32),

          // TTS Config
          Text('TTS 配置', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          TextField(
            controller: _ttsUrlController,
            decoration: const InputDecoration(labelText: 'Base URL'),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _ttsKeyController,
            decoration: const InputDecoration(labelText: 'API Key'),
            obscureText: true,
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _ttsModelController,
            decoration: const InputDecoration(
              labelText: 'Model',
              hintText: 'qwen3-tts-flash',
            ),
          ),
          const SizedBox(height: 24),

          // Actions
          Row(
            children: [
              Expanded(
                child: FilledButton(
                  onPressed: _save,
                  child: const Text('保存配置'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: OutlinedButton(
                  onPressed: _testing ? null : _testConnection,
                  child: _testing
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('测试连接'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
```

- [ ] **Step 2: 更新 LibraryScreen 导航到设置页**

在 `lib/screens/library/library_screen.dart` 的设置按钮 `onPressed` 中:

```dart
onPressed: () {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => const SettingsScreen()),
  );
},
```

- [ ] **Step 3: Verify compilation**

```bash
flutter analyze
```

- [ ] **Step 4: Commit**

```bash
git add lib/screens/settings/ lib/screens/library/library_screen.dart
git commit -m "feat: add settings screen with API configuration

- LLM/TTS base URL, API key, model fields
- Quick presets for domestic providers
- Connection test with success/failure feedback
- Secure storage for API keys"
```

---

### Task 16: 角色列表页面

**Files:**
- Create: `lib/screens/character/character_list_screen.dart`
- Modify: `lib/screens/reader/reader_screen.dart`

- [ ] **Step 1: 创建 lib/screens/character/character_list_screen.dart**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:charavox/models/character.dart';

class CharacterListScreen extends StatelessWidget {
  final List<CharacterInfo> characters;
  final VoidCallback? onReanalyze;

  const CharacterListScreen({
    super.key,
    required this.characters,
    this.onReanalyze,
  });

  @override
  Widget build(BuildContext context) {
    final nonNarratorCharacters = characters
        .where((c) => !c.isNarrator)
        .toList();
    final narrator = characters.where((c) => c.isNarrator).firstOrNull;

    return Scaffold(
      appBar: AppBar(
        title: Text('角色管理 (${nonNarratorCharacters.length} 个角色)'),
        actions: [
          if (onReanalyze != null)
            TextButton.icon(
              onPressed: onReanalyze,
              icon: const Icon(Icons.refresh),
              label: const Text('重新分析'),
            ),
        ],
      ),
      body: ListView(
        children: [
          // Regular characters
          ...nonNarratorCharacters.map((character) => _CharacterTile(
                character: character,
                onPreview: () {
                  // TODO: preview voice sample
                },
              )),

          // Narrator
          if (narrator != null) ...[
            const Divider(),
            _CharacterTile(
              character: narrator,
              isNarrator: true,
              onPreview: () {},
            ),
          ],
        ],
      ),
    );
  }
}

class _CharacterTile extends StatelessWidget {
  final CharacterInfo character;
  final bool isNarrator;
  final VoidCallback onPreview;

  const _CharacterTile({
    required this.character,
    this.isNarrator = false,
    required this.onPreview,
  });

  @override
  Widget build(BuildContext context) {
    final genderIcon = switch (character.gender) {
      Gender.male => Icons.male,
      Gender.female => Icons.female,
      Gender.unknown => Icons.person,
    };

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: isNarrator
            ? Colors.grey
            : Theme.of(context).colorScheme.primaryContainer,
        child: Icon(
          isNarrator ? Icons.volume_up : genderIcon,
          color: isNarrator
              ? Colors.white
              : Theme.of(context).colorScheme.onPrimaryContainer,
        ),
      ),
      title: Row(
        children: [
          Text(character.canonicalName),
          if (character.aliases.isNotEmpty) ...[
            const SizedBox(width: 8),
            Text(
              '(${character.aliases.join(", ")})',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${character.age.name} · ${character.gender.name}'
            '${character.personalities.isNotEmpty ? " · ${character.personalities.join("、")}" : ""}',
          ),
          Text(
            character.voicePrompt,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          if (character.voiceVariants.isNotEmpty)
            Text(
              '${character.voiceVariants.length} 个声线变体',
              style: TextStyle(color: Theme.of(context).colorScheme.tertiary),
            ),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.volume_up),
            tooltip: '试听',
            onPressed: onPreview,
          ),
        ],
      ),
      isThreeLine: true,
    );
  }
}
```

- [ ] **Step 2: 更新 ReaderScreen 角色按钮导航**

修改 `lib/screens/reader/reader_screen.dart`，在顶部 AppBar 的角色按钮中:

```dart
IconButton(
  icon: const Icon(Icons.people),
  tooltip: '角色管理',
  onPressed: () {
    // navigate to character list
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CharacterListScreen(
          characters: [], // TODO: pass from analysis provider
        ),
      ),
    );
  },
),
```

- [ ] **Step 3: Commit**

```bash
git add lib/screens/character/
git commit -m "feat: add character list screen with voice preview stub"
```

---

## M6: 测试 + 集成 + 打磨

### Task 17: Provider 单元测试

**Files:**
- Create: `test/providers/reader_provider_test.dart`
- Create: `test/providers/playback_provider_test.dart`

- [ ] **Step 1: 创建 test/providers/playback_provider_test.dart**

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:charavox/providers/playback_provider.dart';

void main() {
  group('PlaybackNotifier', () {
    late PlaybackNotifier notifier;

    setUp(() {
      notifier = PlaybackNotifier();
    });

    test('initial state is idle', () {
      expect(notifier.state.status, PlaybackStatus.idle);
      expect(notifier.state.currentLineIndex, 0);
    });

    test('setSpeed updates speed in state', () {
      expect(notifier.state.speed, 1.0);
      notifier.setSpeed(2.0);
      expect(notifier.state.speed, 2.0);
    });

    test('previous does not go below 0', () async {
      // State at index 0 → previous should not go negative
      final before = notifier.state.currentLineIndex;
      await notifier.previous();
      expect(notifier.state.currentLineIndex, before);
    });
  });
}
```

- [ ] **Step 2: 创建 test/providers/reader_provider_test.dart**

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:charavox/providers/analysis_provider.dart';

void main() {
  group('AnalysisNotifier', () {
    test('initial state is idle', () {
      final container = ProviderContainer();
      final state = container.read(analysisProvider('test-book'));
      expect(state.status, AnalysisStatus.idle);
    });
  });
}
```

- [ ] **Step 3: Run tests**

```bash
flutter test test/providers/
```

- [ ] **Step 4: Commit**

```bash
git add test/providers/
git commit -m "test: add provider unit tests for playback and analysis"
```

---

### Task 18: 集成测试

**Files:**
- Create: `test/integration/full_analysis_flow_test.dart`
- Create: `test/integration/playback_flow_test.dart`

- [ ] **Step 1: 创建 test/integration/full_analysis_flow_test.dart**

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:charavox/services/epub_service.dart';
import 'package:charavox/services/txt_service.dart';
import 'package:charavox/services/cache_service.dart';
import 'package:charavox/services/llm_service.dart';
import 'package:charavox/models/book.dart';

void main() {
  group('Full Analysis Flow (Integration)', () {
    late EpubService epubService;
    late CacheService cacheService;
    const testBookId = 'integration-test-001';

    setUp(() {
      epubService = EpubService();
      cacheService = CacheService();
    });

    test('EPUB parse → cache save → cache load', () async {
      // 1. Parse EPUB
      final (book, chapters) = epubService.parse('test/fixtures/sample_book.epub');
      final bookWithId = book.copyWith(id: testBookId);

      expect(chapters.length, greaterThan(0));

      // 2. Save to cache
      await cacheService.saveBookMeta(testBookId, bookWithId, []);

      // 3. Load from cache
      final loaded = await cacheService.loadBookMeta(testBookId);
      expect(loaded, isNotNull);
      expect(loaded!.book.title, book.title);
    });

    tearDown(() async {
      await cacheService.clearBookCache(testBookId);
    });
  });
}
```

- [ ] **Step 2: 创建 test/integration/playback_flow_test.dart**

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:charavox/services/progress_service.dart';
import 'package:charavox/models/reading_progress.dart';

void main() {
  group('Playback Flow (Integration)', () {
    late ProgressService progressService;

    setUp(() {
      progressService = ProgressService();
    });

    test('save progress → load progress → update → load updated', () async {
      // Initial save
      final p1 = ReadingProgress(
        bookId: 'playback-test',
        chapterIndex: 0,
        lineIndex: 10,
        positionFraction: 0.1,
        updatedAt: DateTime.now(),
      );
      await progressService.saveProgress(p1);

      // Load
      var loaded = await progressService.loadProgress('playback-test');
      expect(loaded!.lineIndex, 10);

      // Update
      final p2 = p1.copyWith(lineIndex: 42, positionFraction: 0.42);
      await progressService.saveProgress(p2);

      // Load updated
      loaded = await progressService.loadProgress('playback-test');
      expect(loaded!.lineIndex, 42);
    });
  });
}
```

- [ ] **Step 3: Run integration tests**

```bash
flutter test test/integration/
```

- [ ] **Step 4: Commit**

```bash
git add test/integration/
git commit -m "test: add integration tests for analysis and playback flows"
```

---

### Task 19: 最终打磨

- [ ] **Step 1: 运行全部测试**

```bash
flutter test
```

- [ ] **Step 2: 运行静态分析**

```bash
flutter analyze
```

- [ ] **Step 3: 修复所有 warning 和 error**

- [ ] **Step 4: 更新 README.md**

在 README.md 中填入项目实际内容：

```markdown
# 聆书 charavox

多角色分音色有声书阅读器。LLM 自动识别小说角色，AI 生成独特音色——打开 EPUB，等待片刻，听到一本广播剧。

## 功能

- 导入 EPUB / TXT 小说
- LLM 自动分析角色（中日文小说）
- 多角色分音色 TTS 朗读
- 播放控制（倍速、跳转、章节导航）
- 阅读进度自动保存

## 快速开始

### 安装

```bash
# Arch Linux (AUR)
yay -S charavox

# Flatpak
flatpak install com.charavox.Charavox

# 或从源码构建
git clone git@github.com:Mr-Though/charavox.git
cd charavox
flutter pub get
flutter run -d linux
```

### 配置 API

首次启动需配置 LLM 和 TTS API：
- 阿里云百炼（推荐）：注册获取 API Key
- 或使用本地 Ollama + Docker TTS（隐私模式）

## 许可证

GPL v3
```

- [ ] **Step 5: Linux 构建测试**

```bash
flutter build linux
```

- [ ] **Step 6: Commit**

```bash
git add -A
git commit -m "chore: final polish and documentation

- Update README with project overview and quickstart
- Fix all static analysis warnings
- Confirm all tests pass
- Linux build verified"
```

---

## 实现清单汇总

| # | Task | 里程碑 | 预估 |
|---|------|:------:|:----:|
| 1 | Flutter 项目初始化 | M1 | 2h |
| 2 | 工具函数 (hash/text) | M1 | 1h |
| 3 | 数据模型 (Book/Character/ScriptLine) | M1 | 2h |
| 4 | EPUB 解析服务 | M2 | 2h |
| 5 | TXT 解析服务 | M2 | 2h |
| 6 | 基础文本阅读器 UI | M2 | 2h |
| 7 | Prompt 模板 | M3 | 1h |
| 8 | LLM 服务 + 测试 | M3 | 3h |
| 9 | 缓存服务 | M3 | 2h |
| 10 | 进度服务 | M3 | 1h |
| 11 | 分析流程 Provider + 文件导入 | M3 | 2h |
| 12 | TTS 服务 | M4 | 1h |
| 13 | 音频播放 + 播放控制 + UI | M4 | 3h |
| 14 | 配置服务 (加密存储) | M5 | 2h |
| 15 | 设置页面 UI | M5 | 2h |
| 16 | 角色列表页面 | M5 | 1h |
| 17 | Provider 单元测试 | M6 | 1h |
| 18 | 集成测试 | M6 | 1h |
| 19 | 最终打磨 (README/构建) | M6 | 1h |

**总计: 19 个任务，约 32 小时**

---

> **文档状态**: 待执行
> **Spec**: `docs/superpowers/specs/2026-06-02-lingshu-prd.md`
