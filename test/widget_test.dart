import 'package:flutter_test/flutter_test.dart';
import 'package:taiaodex/main.dart';

void main() {
  testWidgets('TaiaoDex app boots', (WidgetTester tester) async {
    await tester.pumpWidget(const TaiaoDexApp());
    expect(find.textContaining('TaiaoDex'), findsOneWidget);
  });
  testWidgets('Shows Kakapo card', (tester) async {
  await tester.pumpWidget(const TaiaoDexApp());
  expect(find.text('Kākāpō'), findsOneWidget);
});

}
