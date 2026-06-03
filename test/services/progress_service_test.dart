import 'package:flutter_test/flutter_test.dart';
import 'package:charavox/services/progress_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ProgressService', () {
    late ProgressService service;

    setUp(() => service = ProgressService());

    test('loadProgress returns null for unknown book', () async {
      expect(await service.loadProgress('nonexistent-book'), isNull);
    });
  });
}
