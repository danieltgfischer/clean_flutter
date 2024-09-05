import '../../../validation/validators/protocols/protocols.dart';

class StreamLoginPresenter {
  final Validation validation;
  StreamLoginPresenter({required this.validation});

  void validateEmail(String email) {
    validation.validate('email', email);
  }
}
