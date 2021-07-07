import 'dart:async';
import 'package:crypto/crypto.dart';
import 'dart:convert'; // for the utf8.encode method

import 'package:meta/meta.dart';
import 'package:http/http.dart' show Client;

enum AuthenticationStatus { unknown, authenticated, unauthenticated }

class AuthenticationRepository {
  Client client = Client();
  final _authUrl =
      'https://dariocast.altervista.org/fantazama/api/admin/auth.php';
  final _controller = StreamController<AuthenticationStatus>();

  Stream<AuthenticationStatus> get status async* {
    yield AuthenticationStatus.unauthenticated;
    yield* _controller.stream;
  }

  Future<void> logIn({
    required String username,
    required String password,
  }) async {
    var digest = sha1.convert(utf8.encode(password));
    final response = await client.post(
      Uri.parse(_authUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': username,
        'password': digest.toString()
      }),
    );
    if (response.statusCode == 200) {
      _controller.add(AuthenticationStatus.authenticated);
    } else {
      _controller.add(AuthenticationStatus.unauthenticated);
      throw Exception();
    }
  }

  void logOut() {
    _controller.add(AuthenticationStatus.unauthenticated);
  }

  void dispose() => _controller.close();
}
