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

  setUp(() {
    url = faker.internet.httpUrl();
    client = ClientSpy();
    sut = HttpAdapter(client);
    uri = Uri.parse(url);
    registerFallbackValue(uri);
  });
  group('post', () {
    setUp(() {
      when(
        () => client.post(
          any(),
          headers: any(named: 'headers'),
        ),
      ).thenAnswer((_) async => Response('', 200));
    });
    test('Should call post with correct values', () async {
      await sut.request(
        url: url,
        method: 'post',
      );

      verify(
        () => client.post(uri, headers: {
          'content-type': 'application/json',
          'accept': 'application/json'
        }),
      );
    });
  });
}
