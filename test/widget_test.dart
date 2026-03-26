import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:desitracker_mobile/main.dart';

void main() {
  testWidgets('App renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: DesiTrackerApp(),
      ),
    );
    expect(find.byType(DesiTrackerApp), findsOneWidget);
  });
}
