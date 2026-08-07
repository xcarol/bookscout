import 'package:flutter_test/flutter_test.dart';
import 'package:bookscout/main.dart';

void main() {
  testWidgets('BookScout smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.text('BookScout'), findsOneWidget);
  });
}
