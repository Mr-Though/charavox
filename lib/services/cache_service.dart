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
    final dir = Directory('${appDir.path}/${AppConfig.cacheDirName}');
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return dir;
  }

  Future<Directory> _bookAnalysisDir(String bookId) async {
    final cacheDir = await _cacheDir;
    final dir = Directory(
      '${cacheDir.path}/${AppConfig.analysisSubDir}/$bookId',
    );
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return dir;
  }

  Future<void> saveBookMeta(
    String bookId,
    Book book,
    List<CharacterInfo> characters,
  ) async {
    final dir = await _bookAnalysisDir(bookId);
    final metaFile = File('${dir.path}/meta.json');
    final json = {
      'version': AppConfig.currentSchemaVersion,
      'book': book.toJson(),
      'characters': characters.map((c) => c.toJson()).toList(),
    };
    await metaFile.writeAsString(jsonEncode(json));
  }

  Future<({Book book, List<CharacterInfo> characters})?> loadBookMeta(
    String bookId,
  ) async {
    try {
      final dir = await _bookAnalysisDir(bookId);
      final metaFile = File('${dir.path}/meta.json');
      if (!await metaFile.exists()) return null;

      final json =
          jsonDecode(await metaFile.readAsString()) as Map<String, dynamic>;
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

  Future<List<ScriptLine>?> loadChapterScript(
    String bookId,
    int chapterIndex,
  ) async {
    try {
      final dir = await _bookAnalysisDir(bookId);
      final chFile = File(
        '${dir.path}/ch_${chapterIndex.toString().padLeft(4, '0')}.json',
      );
      if (!await chFile.exists()) return null;

      final json =
          jsonDecode(await chFile.readAsString()) as Map<String, dynamic>;
      _checkVersion(json['version'] as int? ?? 0);

      return (json['script_lines'] as List<dynamic>)
          .map((s) => ScriptLine.fromJson(s as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw CacheException('章节缓存读取失败: ${e.toString()}',
          originalError: e);
    }
  }

  Future<bool> hasAnalysis(String bookId) async {
    try {
      final dir = await _bookAnalysisDir(bookId);
      final metaFile = File('${dir.path}/meta.json');
      return await metaFile.exists();
    } catch (_) {
      return false;
    }
  }

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
        '数据由更新版本 (v$version) 创建，请升级应用',
      );
    }
  }
}
