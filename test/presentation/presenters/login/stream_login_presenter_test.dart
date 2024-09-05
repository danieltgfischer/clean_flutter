import 'package:flutter_test/flutter_test.dart';
import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';

import 'package:ForDev/presentation/presenters/presenters.dart';
import 'package:ForDev/validation/validators/protocols/protocols.dart';

class ValidationSpy extends Mock implements Validation {}

void main() {
  late StreamLoginPresenter sut;
  late Validation validation;
  late String email = faker.internet.email();

  setUp(() {
    email = faker.internet.email();
    validation = ValidationSpy();
    sut = StreamLoginPresenter(validation: validation);
  });

  test('Should Validation with correct email', () {
    sut.validateEmail(email);

    verify(() => validation.validate('email', email)).called(1);
  });
}
