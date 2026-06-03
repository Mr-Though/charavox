import 'package:flutter_test/flutter_test.dart';
import 'package:charavox/services/cache_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('CacheService', () {
    late CacheService service;

    setUp(() => service = CacheService());

    test('hasAnalysis returns false for unknown book', () async {
      expect(await service.hasAnalysis('nonexistent-book'), false);
    });
  });
}
