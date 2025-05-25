import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:quien_para/app.dart';
import 'package:flutter/material.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end-to-end test', () {
    testWidgets('login flow test', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Verify we're on the login screen
      expect(find.text('Login'), findsOneWidget);

      // Find email and password fields
      final Finder emailField = find.byKey(const Key('email_field'));
      final Finder passwordField = find.byKey(const Key('password_field'));
      final Finder loginButton = find.byKey(const Key('login_button'));

      // Enter credentials
      await tester.enterText(emailField, 'test@example.com');
      await tester.enterText(passwordField, 'password123');

      // Tap login button and wait for navigation
      await tester.tap(loginButton);
      await tester.pumpAndSettle();

      // Verify we're on the home screen
      expect(find.text('Welcome'), findsOneWidget);
    });
  });
}
