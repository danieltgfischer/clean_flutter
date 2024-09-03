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
  late StreamController<String?> passwordStreamController;
  late StreamController<bool?> isFormValidController;
  late StreamController<bool?> isLoadingStreamController;
  late StreamController<String?> mainErrorController;

  void initStreams() {
    emailStreamController = StreamController<String?>();
    passwordStreamController = StreamController<String?>();
    isFormValidController = StreamController<bool?>();
    isLoadingStreamController = StreamController<bool?>();
    mainErrorController = StreamController<String?>();
  }

  void mockStreams() {
    when(() => presenter.emailErrorStream)
        .thenAnswer((_) => emailStreamController.stream);
    when(() => presenter.passwordErrorStream)
        .thenAnswer((_) => passwordStreamController.stream);
    when(() => presenter.isFormValidStream)
        .thenAnswer((_) => isFormValidController.stream);
    when(() => presenter.isLoadingStream)
        .thenAnswer((_) => isLoadingStreamController.stream);
    when(() => presenter.mainErrorStream)
        .thenAnswer((_) => mainErrorController.stream);
  }

  void closeStreams() {
    emailStreamController.close();
    passwordStreamController.close();
    isFormValidController.close();
    isLoadingStreamController.close();
    mainErrorController.close();
  }

  setUp(() {
    initStreams();
    email = faker.internet.email();
    password = faker.internet.email();
    presenter = LoginPresenterSpy();
  });

  tearDown(() {
    closeStreams();
  });

  Future<void> loadPage(WidgetTester tester) async {
    mockStreams();
    final loginPage = MaterialApp(home: LoginPage(presenter));
    await tester.pumpWidget(loginPage);
  }

  testWidgets('Should load with correct initial state', (tester) async {
    await loadPage(tester);

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
    await loadPage(tester);
    final emailInput = find.bySemanticsLabel('Email');
    await tester.enterText(emailInput, email);

    verify(() => presenter.validateEmail(email));

    final passwordInput = find.bySemanticsLabel('Senha');
    await tester.enterText(passwordInput, password);

    verify(() => presenter.validatePassword(password));
  });

  testWidgets('Should emits message error if email is invalid', (tester) async {
    await loadPage(tester);
    const error = 'any_error';
    emailStreamController.add(error);
    await tester.pump();
    final textError = find.text(error);
    expect(textError, findsOne);
  });

  testWidgets('Should emits no error if email is valid', (tester) async {
    await loadPage(tester);
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

  testWidgets('Should emits message error if password is invalid',
      (tester) async {
    await loadPage(tester);
    const error = 'any_error';
    passwordStreamController.add(error);
    await tester.pump();
    final errorText = find.text(error);

    expect(errorText, findsOneWidget);
  });

  testWidgets('Should emits no error if password is valid', (tester) async {
    await loadPage(tester);
    passwordStreamController.add('');
    await tester.pump();
    final passwordTextChildren = find.descendant(
      of: find.bySemanticsLabel('Senha'),
      matching: find.byType(Text),
    );
    expect(passwordTextChildren, findsOneWidget);

    passwordStreamController.add(null);
    await tester.pump();

    expect(passwordTextChildren, findsOneWidget);
  });

  testWidgets('Should enable login button if form is valid', (tester) async {
    await loadPage(tester);
    isFormValidController.add(true);
    await tester.pump();

    final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));

    expect(button.enabled, true);
  });

  testWidgets('Should desable login button if form is invalid', (tester) async {
    await loadPage(tester);
    isFormValidController.add(null);
    await tester.pump();

    ElevatedButton button =
        tester.widget<ElevatedButton>(find.byType(ElevatedButton));

    expect(button.enabled, false);

    isFormValidController.add(false);
    await tester.pumpAndSettle();

    button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));

    expect(button.enabled, false);
  });

  testWidgets('Should call auth method', (tester) async {
    when(() => presenter.auth()).thenAnswer((_) async => Future.value());
    await loadPage(tester);
    isFormValidController.add(true);
    await tester.pump();
    final button = find.byType(ElevatedButton);
    await tester.tap(button);
    await tester.pump();
    verify(() => presenter.auth()).called(1);
  });

  testWidgets('Should show progress indicator', (tester) async {
    await loadPage(tester);
    isLoadingStreamController.add(true);
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOne);
  });

  testWidgets('Should hide progress indicator', (tester) async {
    await loadPage(tester);
    isLoadingStreamController.add(true);
    await tester.pump();
    isLoadingStreamController.add(false);
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('Should present error message if authentication fails',
      (WidgetTester tester) async {
    await loadPage(tester);

    mainErrorController.add('main error');
    await tester.pump();

    expect(find.text('main error'), findsOneWidget);
  });

  testWidgets('Should close streams on dispose', (WidgetTester tester) async {
    await loadPage(tester);

    addTearDown(() {
      verify(() => presenter.dispose()).called(1);
    });
  });
}
