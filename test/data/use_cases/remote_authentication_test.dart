import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class RemoteAuthentication {
  final HttpClient httpClient;
  final String url;

  RemoteAuthentication({required this.httpClient, required this.url});

  Future<void> auth() async {
    await httpClient.request(url: url, method: 'post');
  }
}

abstract class HttpClient {
  Future<void> request({required String url, required String method});
}

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  late RemoteAuthentication sut;
  late String url;
  late HttpClient httpClient;

  setUp(() {
    url = faker.internet.httpUrl();
    httpClient = HttpClientSpy();
    sut = RemoteAuthentication(httpClient: httpClient, url: url);
    When callHttpClienRequest() =>
        when(() => httpClient.request(url: url, method: 'post'));
    callHttpClienRequest().thenAnswer((_) async {});
  });

  test("Should call HttpClient with correct values", () async {
    await sut.auth();

    verify(() => httpClient.request(url: url, method: 'post'));
  });
}
