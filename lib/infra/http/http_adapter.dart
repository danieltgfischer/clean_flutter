import 'package:http/http.dart';

class HttpAdapter {
  final Client client;
  HttpAdapter(this.client);

  Future<void> request(
      {required String url, required String method, Map? body}) async {
    final headers = {
      'content-type': 'application/json',
      'accept': 'application/json'
    };
    await client.post(Uri.parse(url), headers: headers, body: body);
  }
}
