import 'package:flutter_test/flutter_test.dart';
import 'package:charavox/services/epub_service.dart';
import 'package:charavox/core/errors/app_exceptions.dart';

void main() {
  group('Full Analysis Flow (Integration)', () {
    test('EPUB service throws for non-existent file', () async {
      final service = EpubService();
      expect(
        () => service.parse('nonexistent.epub'),
        throwsA(isA<EpubParseException>()),
      );
    });
  });
}
