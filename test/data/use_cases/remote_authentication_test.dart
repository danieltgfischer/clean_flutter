import 'package:clean_flutter/domain/use_cases/authentication.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:clean_flutter/data/http/http.dart';
import 'package:clean_flutter/data/use_cases/use_cases.dart';

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  late RemoteAuthentication sut;
  late String url;
  late HttpClient httpClient;

  setUp(() {
    url = faker.internet.httpUrl();
    httpClient = HttpClientSpy();
    sut = RemoteAuthentication(httpClient: httpClient, url: url);
    When callHttpClienRequest() => when(() =>
        httpClient.request(url: url, method: 'post', body: any(named: 'body')));
    callHttpClienRequest().thenAnswer((_) async {});
  });

  test("Should call HttpClient with correct values", () async {
    final params = AuthenticationParams(
        email: faker.internet.email(), password: faker.internet.password());
    await sut.auth(params);

    verify(() => httpClient.request(
        url: url,
        method: 'post',
        body: {'email': params.email, 'password': params.password}));
  });
}
