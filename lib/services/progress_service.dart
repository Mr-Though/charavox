import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:charavox/models/reading_progress.dart';
import 'package:charavox/core/config/app_config.dart';
import 'package:charavox/core/errors/app_exceptions.dart';

class ProgressService {
  Future<File> get _progressFile async {
    final appDir = await getApplicationSupportDirectory();
    final dir = Directory(
      '${appDir.path}/${AppConfig.cacheDirName}/${AppConfig.configSubDir}',
    );
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return File('${dir.path}/reading_progress.json');
  }

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

  Future<ReadingProgress?> loadProgress(String bookId) async {
    try {
      final all = await _loadAllProgress();
      return all[bookId];
    } catch (_) {
      return null;
    }
  }

  Future<Map<String, ReadingProgress>> _loadAllProgress() async {
    final file = await _progressFile;
    if (!await file.exists()) return {};

    try {
      final json =
          jsonDecode(await file.readAsString()) as Map<String, dynamic>;
      return json.map(
        (k, v) =>
            MapEntry(k, ReadingProgress.fromJson(v as Map<String, dynamic>)),
      );
    } catch (_) {
      return {};
    }
  }
}
