import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:clean_flutter/domain/use_cases/authentication.dart';
import 'package:clean_flutter/domain/helpers/domain_error.dart';

import 'package:clean_flutter/data/use_cases/use_cases.dart';
import 'package:clean_flutter/data/http/http.dart';

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  late RemoteAuthentication sut;
  late String url;
  late HttpClient httpClient;
  late AuthenticationParams params;

  Map mockValidData() => {
        'accessToken': faker.guid.guid(),
        'name': faker.person.name(),
      };

  When mockRequest() => when(
        () => httpClient.request(
          url: url,
          method: 'post',
          body: any(named: 'body'),
        ),
      );

  void mockHttpData(Map data) => mockRequest().thenAnswer(
        (_) async => data,
      );

  void mockHttpError(HttpError error) => mockRequest().thenThrow(error);

  setUp(() {
    url = faker.internet.httpUrl();
    httpClient = HttpClientSpy();
    sut = RemoteAuthentication(httpClient: httpClient, url: url);
    params = AuthenticationParams(
      email: faker.internet.email(),
      password: faker.internet.password(),
    );

    mockHttpData(mockValidData());
  });

  test("Should call HttpClient with correct values", () async {
    await sut.auth(params);

    verify(
      () => httpClient.request(
        url: url,
        method: 'post',
        body: {'email': params.email, 'password': params.password},
      ),
    );
  });

  test("Should throws UnexpectedError if HttpClient returns 400", () async {
    mockHttpError(HttpError.badRequest);

    final future = sut.auth(params);

    expect(future, throwsA(DomainError.unexpected));
  });

  test("Should throws UnexpectedError if HttpClient returns 404", () async {
    mockHttpError(HttpError.notFound);

    final future = sut.auth(params);

    expect(future, throwsA(DomainError.unexpected));
  });

  test("Should throws UnexpectedError if HttpClient returns 500", () async {
    mockHttpError(HttpError.serverError);

    final future = sut.auth(params);

    expect(future, throwsA(DomainError.unexpected));
  });

  test("Should throws InvalidCredentialsError if HttpClient returns 401",
      () async {
    mockHttpError(HttpError.unauthorized);

    final future = sut.auth(params);

    expect(future, throwsA(DomainError.invalidCredentials));
  });

  test("Should returns AccountEntity if HttpClient returns 200", () async {
    final accessToken = faker.guid.guid();
    mockHttpData(
      {
        'accessToken': accessToken,
        'name': faker.person.name(),
      },
    );

    final account = await sut.auth(params);

    expect(account.token, accessToken);
  });
}
