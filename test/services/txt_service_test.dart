import 'package:flutter_test/flutter_test.dart';
import 'package:charavox/services/txt_service.dart';
import 'package:charavox/core/errors/app_exceptions.dart';

void main() {
  group('TxtService', () {
    test('throws TxtParseException for non-existent file', () {
      final service = TxtService();
      expect(
        () => service.parse('nonexistent.txt'),
        throwsA(isA<TxtParseException>()),
      );
    });
  });
}
