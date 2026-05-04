import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trying_flutter/main.dart';

void main() {
  testWidgets('Sign up then login flow works', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.widgetWithText(ElevatedButton, 'Login'), findsOneWidget);

    await tester.tap(find.byKey(const Key('toggleAuthModeButton')));
    await tester.pumpAndSettle();
    expect(find.widgetWithText(ElevatedButton, 'Sign Up'), findsOneWidget);

    await tester.enterText(
      find.byKey(const Key('emailField')),
      'test@example.com',
    );
    await tester.enterText(find.byKey(const Key('passwordField')), 'password1');
    await tester.enterText(
      find.byKey(const Key('confirmPasswordField')),
      'password1',
    );
    await tester.tap(find.byKey(const Key('submitButton')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('welcomeText')), findsOneWidget);
    expect(find.textContaining('test@example.com'), findsOneWidget);

    await tester.tap(find.byTooltip('Logout'));
    await tester.pumpAndSettle();
    expect(find.widgetWithText(ElevatedButton, 'Login'), findsOneWidget);

    await tester.enterText(
      find.byKey(const Key('emailField')),
      'test@example.com',
    );
    await tester.enterText(find.byKey(const Key('passwordField')), 'password1');
    await tester.tap(find.byKey(const Key('submitButton')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('welcomeText')), findsOneWidget);
  });

  testWidgets('Shows error for unknown user login', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const Key('emailField')),
      'unknown@example.com',
    );
    await tester.enterText(find.byKey(const Key('passwordField')), 'password1');
    await tester.tap(find.byKey(const Key('submitButton')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('authError')), findsOneWidget);
    expect(find.text('User not found. Please sign up first.'), findsOneWidget);
  });
}
