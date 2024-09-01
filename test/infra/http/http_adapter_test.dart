import 'package:clean_flutter/data/http/http_error.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:faker/faker.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';

import 'package:clean_flutter/infra/http/http.dart';

class ClientSpy extends Mock implements Client {}

void main() {
  late String url;
  late ClientSpy client;
  late HttpAdapter sut;
  late Uri uri;
  late String anyAnswer;

  setUp(() {
    url = faker.internet.httpUrl();
    client = ClientSpy();
    sut = HttpAdapter(client);
    uri = Uri.parse(url);
    registerFallbackValue(uri);
  });
  group('post', () {
    When mockRequest() => when(() => client.post(
          any(),
          headers: any(named: 'headers'),
          body: any(named: 'body'),
        ));

    void mockAnswer(int statusCode, {String? data}) =>
        mockRequest().thenAnswer((_) async => Response(data ?? '', statusCode));

    void mockError() {
      mockRequest().thenThrow(Exception());
    }

    setUp(() {
      anyAnswer = '{"any_key": "any_value"}';
      mockAnswer(200);
    });
    test('Should call post with correct values', () async {
      final headers = {
        'content-type': 'application/json',
        'accept': 'application/json'
      };
      final body = {'any_key': 'any_value'};
      await sut.request(url: url, method: 'post', body: body);

      verify(
        () => client.post(uri, headers: headers, body: body),
      );
    });

    test('Should call post without body', () async {
      final headers = {
        'content-type': 'application/json',
        'accept': 'application/json'
      };
      await sut.request(url: url, method: 'post');

      verify(
        () => client.post(uri, headers: headers),
      );
    });

    test('Should return data if post returns 200 ', () async {
      mockAnswer(200, data: anyAnswer);
      final response = await sut.request(url: url, method: 'post');
      expect(response, {"any_key": "any_value"});
    });

    test('Should return null if post returns 200 with no data', () async {
      mockAnswer(200);
      final response = await sut.request(url: url, method: 'post');
      expect(response, null);
    });

    test('Should return null if post returns 204', () async {
      mockAnswer(204);
      final response = await sut.request(url: url, method: 'post');
      expect(response, null);
    });

    test('Should return null if post returns 204 with data', () async {
      mockAnswer(
        204,
        data: anyAnswer,
      );
      final response = await sut.request(url: url, method: 'post');
      expect(response, null);
    });

    test('Should return BadRequestError if post returns 400', () async {
      mockAnswer(400);

      final future = sut.request(url: url, method: 'post');

      expect(future, throwsA(HttpError.badRequest));
    });

    test('Should return BadRequestError if post returns 400', () async {
      mockAnswer(400);

      final future = sut.request(url: url, method: 'post');

      expect(future, throwsA(HttpError.badRequest));
    });

    test('Should return UnauthorizedError if post returns 401', () async {
      mockAnswer(401);

      final future = sut.request(url: url, method: 'post');

      expect(future, throwsA(HttpError.unauthorized));
    });

    test('Should return ForbiddenError if post returns 403', () async {
      mockAnswer(403);

      final future = sut.request(url: url, method: 'post');

      expect(future, throwsA(HttpError.forbidden));
    });

    test('Should return NotFoundError if post returns 404', () async {
      mockAnswer(404);

      final future = sut.request(url: url, method: 'post');

      expect(future, throwsA(HttpError.notFound));
    });

    test('Should return ServerError if post returns 500', () async {
      mockAnswer(500);

      final future = sut.request(url: url, method: 'post');

      expect(future, throwsA(HttpError.serverError));
    });

    test('Should return ServerError if post throws', () async {
      mockError();

      final future = sut.request(url: url, method: 'post');

      expect(future, throwsA(HttpError.serverError));
    });
  });
}
