import '../../domain/entities/entities.dart';

import '../http/http.dart';

class RemoteAccountModel {
  final String token;
  RemoteAccountModel(this.token);

  factory RemoteAccountModel.fromJson(Map<dynamic, dynamic> json) {
    if (!json.containsKey('accessToken') || json['accessToken'] == null) {
      throw HttpError.invalidData;
    }
    return RemoteAccountModel(json['accessToken']);
  }

  AccountEntity toEntity() => AccountEntity(token);
}
