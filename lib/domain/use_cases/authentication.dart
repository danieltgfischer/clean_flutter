import '../entities/entities.dart';

abstract class Authentication {
  Future<AccountEntity> auth();
}
