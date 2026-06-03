import 'package:flutter_test/flutter_test.dart';
import 'package:charavox/providers/playback_provider.dart';

void main() {
  group('PlaybackNotifier', () {
    late PlaybackNotifier notifier;

    setUp(() => notifier = PlaybackNotifier());

    test('initial state is idle', () {
      expect(notifier.state.status, PlaybackStatus.idle);
      expect(notifier.state.currentLineIndex, 0);
      expect(notifier.state.speed, 1.0);
    });

    test('setSpeed updates speed', () {
      notifier.setSpeed(2.0);
      expect(notifier.state.speed, 2.0);
    });

    test('previous does not go below 0', () async {
      await notifier.previous();
      expect(notifier.state.currentLineIndex, 0);
    });
  });
}
