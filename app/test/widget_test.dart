// This is a basic Flutter widget test.

import 'package:flutter_test/flutter_test.dart';
import 'package:quit_smoking_app/app.dart';

void main() {
  testWidgets('App starts on Welcome Screen', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const QuitSmokingApp());
    await tester.pumpAndSettle();

    // Verify that we are on the Welcome screen (which has the "这个APP" text)
    expect(find.text('这个APP'), findsOneWidget);
    expect(find.text('能让你戒烟'), findsOneWidget);
  });
}
