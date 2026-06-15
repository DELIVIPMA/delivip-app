import 'package:flutter_test/flutter_test.dart';
import 'package:delivip_app/main.dart';

void main() {
  testWidgets('App launches smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const DeliVipApp());
    expect(find.text('DeliVip'), findsWidgets);
  });
}
