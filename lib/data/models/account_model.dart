import '../../domain/entities/entities.dart';

class AccountModel {
  final String token;
  AccountModel(this.token);

  factory AccountModel.fromJson(Map json) => AccountModel(json['accessToken']);

  AccountEntity toEntity() => AccountEntity(token);
}
