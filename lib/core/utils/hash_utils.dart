import 'dart:convert';
import 'package:crypto/crypto.dart';

String computeBookHash(String filePath, int fileSize) {
  final input = '$filePath:$fileSize';
  final bytes = utf8.encode(input);
  final digest = sha256.convert(bytes);
  return digest.toString().substring(0, 16);
}
