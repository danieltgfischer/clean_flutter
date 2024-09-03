import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';

import 'package:ForDev/ui/pages/pages.dart';

class LoginPresenterSpy extends Mock implements LoginPresenter {}

void main() {
  late String email;
  late String password;
  late LoginPresenter presenter;
  late StreamController<String?> emailStreamController;

  setUp(() {
    email = faker.internet.email();
    password = faker.internet.email();
    presenter = LoginPresenterSpy();
    emailStreamController = StreamController<String?>();
  });

  tearDown(() async {
    await emailStreamController.close();
  });

  Future<void> loadLoing(WidgetTester tester) async {
    final loginPage = MaterialApp(home: LoginPage(presenter));
    when(() => presenter.emailErrorStream)
        .thenAnswer((_) => emailStreamController.stream);

    await tester.pumpWidget(loginPage);
  }

  testWidgets('Should load with correct initial state', (tester) async {
    await loadLoing(tester);

    final emailTextChildren = find.descendant(
      of: find.bySemanticsLabel('Email'),
      matching: find.byType(Text),
    );
    expect(
      emailTextChildren,
      findsOneWidget,
      reason:
          'when a TextFormField has only one text child, means it has no errors, since one of the childs is always the label text',
    );

    final passwordTextChildren = find.descendant(
      of: find.bySemanticsLabel('Senha'),
      matching: find.byType(Text),
    );
    expect(
      passwordTextChildren,
      findsOneWidget,
      reason:
          'when a TextFormField has only one text child, means it has no errors, since one of the childs is always the label text',
    );

    final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
    expect(button.onPressed, null);
  });

  testWidgets('Should call validate with input values', (tester) async {
    await loadLoing(tester);
    final emailInput = find.bySemanticsLabel('Email');
    await tester.enterText(emailInput, email);

    verify(() => presenter.validateEmail(email));

    final passwordInput = find.bySemanticsLabel('Senha');
    await tester.enterText(passwordInput, password);

    verify(() => presenter.validatePassword(password));
  });

  testWidgets('Should emits message error if email is invalid', (tester) async {
    await loadLoing(tester);
    const error = 'any_error';
    emailStreamController.add(error);
    await tester.pump();
    final textError = find.text(error);
    expect(textError, findsOne);
  });

  testWidgets('Should emits no error if email is valid', (tester) async {
    await loadLoing(tester);
    emailStreamController.add('');
    await tester.pump();
    final emailTextChildren = find.descendant(
      of: find.bySemanticsLabel('Email'),
      matching: find.byType(Text),
    );
    expect(emailTextChildren, findsOneWidget);

    emailStreamController.add(null);
    await tester.pump();

    expect(emailTextChildren, findsOneWidget);
  });
}
