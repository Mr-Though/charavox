import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:charavox/app.dart';

void main() {
  testWidgets('App renders library screen', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: CharavoxApp()),
    );
    expect(find.text('聆书'), findsOneWidget);
    expect(find.text('书架为空'), findsOneWidget);
  });
}
