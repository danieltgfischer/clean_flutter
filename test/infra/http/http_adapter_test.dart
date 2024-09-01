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
    anyAnswer = '{"any_key": "any_value"}';
  });
  When mockRequest() => when(() => client.post(
        any(),
        headers: any(named: 'headers'),
        body: any(named: 'body'),
      ));

  void mockAnswer(String? data, int statusCode) =>
      mockRequest().thenAnswer((_) async => Response(data ?? '{}', statusCode));
  group('post', () {
    setUp(() {
      mockAnswer(null, 200);
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
      mockAnswer(anyAnswer, 200);
      final response = await sut.request(url: url, method: 'post');
      expect(response, {"any_key": "any_value"});
    });
  });
}
