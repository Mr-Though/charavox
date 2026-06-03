import 'package:flutter_test/flutter_test.dart';
import 'package:charavox/app.dart';

void main() {
  testWidgets('App renders title', (WidgetTester tester) async {
    await tester.pumpWidget(const CharavoxApp());
    expect(find.text('聆书 charavox'), findsOneWidget);
  });
}
