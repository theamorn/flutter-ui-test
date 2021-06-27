import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:uitest/main.dart' as app;

void main() {
  // Command for run test
  // flutter drive --driver=test_driver/integration_test.dart --target=integration_test/login_test.dart
  // flutter drive --no-build --driver=test_driver/integration_test.dart --target=integration_test/login_test.dart
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  final loginButton = find.byKey(const Key("LoginButton"));
  final incrementButton = find.byKey(const Key('IncrementButton'));
  final emailField = find.byKey(const Key("EmailField"));
  final passwordField = find.byKey(const Key("PasswordField"));
  final submitLogin = find.byKey(const Key("SubmitLogin"));
  final counterText = find.byKey(const Key('CounterText'));

  final shortDuration = Duration(seconds: 1);
  final longDuration = Duration(seconds: 5);

  Future<void> pumpUntilFound(
    WidgetTester tester,
    Finder finder, {
    Duration timeout = const Duration(seconds: 30),
  }) async {
    bool timerDone = false;
    final timer = Timer(
        timeout, () => throw TimeoutException("Pump until has timed out"));
    while (timerDone != true) {
      await tester.pump();

      final found = tester.any(finder);
      if (found) {
        timerDone = true;
      }
    }
    timer.cancel();
  }

  testWidgets("Testing Login", (WidgetTester tester) async {
    print("== Start Testing Login ==");
    app.main();
    await tester.pump();
    await tester.tap(incrementButton);
    await tester.pump();
    await tester.tap(incrementButton);
    await tester.pump();
    await tester.tap(incrementButton);
    await tester.pump();
    await tester.tap(incrementButton);
    await tester.pump();
    await tester.tap(incrementButton);
    await tester.pump();
    Text text = tester.firstWidget(counterText);
    expect(text.data, equals("5"));
    print("== Checked incrementButton ==");

    await tester.tap(loginButton);
    await pumpUntilFound(tester, emailField);
    expect(emailField, findsOneWidget);
    expect(passwordField, findsOneWidget);
    print("== Checked email and password Field are existed ==");

    await tester.tap(emailField);
    await tester.pumpAndSettle();

    await tester.enterText(emailField, "theamorn@gmai");
    await tester.pumpAndSettle();

    await tester.tap(passwordField);
    await tester.pumpAndSettle();

    await tester.enterText(passwordField, "password1234");
    await tester.pumpAndSettle();
    await tester.tap(submitLogin);
    await tester.pumpAndSettle();
    expect(find.text('Enter a valid email address'), findsOneWidget);
    print("== Checked Email validator ==");

    await tester.tap(emailField);
    await tester.pumpAndSettle();
    await tester.enterText(emailField, "theamorn@gmail.com");
    await tester.tap(submitLogin);
    await tester.pumpAndSettle();
    expect(find.text('Processing Data'), findsOneWidget);
    print("== Checked Logged in ==");

    // Waiting for API called
    await tester.pump(Duration(seconds: 5));
    await pumpUntilFound(tester, find.text('welcome to UI Testing App'));
    expect(find.text('welcome to UI Testing App'), findsOneWidget);
    print("== Checked Logged in succeed ==");
  });
}
