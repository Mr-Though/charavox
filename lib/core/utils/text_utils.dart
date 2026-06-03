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
  // No chapter markers found: chunk by fixed line count
  if (indices.length == 1) {
    indices.clear();
    indices.add(0);
    for (int i = 5000; i < lines.length; i += 5000) {
      indices.add(i);
    }
  }
  return indices;
}

Encoding detectEncoding(List<int> bytes) {
  try {
    utf8.decode(bytes);
    return utf8;
  } catch (_) {}
  // Fallback: try Latin-1 (never throws, decodes any byte sequence)
  return latin1;
}
