import 'package:example/main.dart'; // Ensure this points to your main.dart
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Example app loads', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      const ExampleApp(),
    ); // Fixed: Changed MyApp to ExampleApp

    // Verify that the title is present on the screen.
    expect(find.text('UI Masked Text Demo'), findsWidgets);
  });
}
