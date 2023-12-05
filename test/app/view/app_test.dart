import 'package:flutter_test/flutter_test.dart';
import 'package:on_space/app/app.dart';
import 'package:on_space/counter/counter.dart';

void main() {
  group('App', () {
    testWidgets('renders CounterPage', (tester) async {
      await tester.pumpWidget(const App());
      expect(find.byType(CounterPage), findsOneWidget);
    });
  });
}
