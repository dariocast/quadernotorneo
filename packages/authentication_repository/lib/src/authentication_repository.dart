import 'dart:async';

import 'package:http/http.dart' show Client;
import 'package:supabase_flutter/supabase_flutter.dart';

enum AuthenticationStatus { unknown, authenticated, unauthenticated }

class AuthenticationRepository {
  SupabaseClient supabase = Supabase.instance.client;

  Client client = Client();
  final _controller = StreamController<AuthenticationStatus>();

  Stream<AuthenticationStatus> get status async* {
    yield AuthenticationStatus.unauthenticated;
    yield* _controller.stream;
  }

  Future<void> logIn({
    required String username,
    required String password,
  }) async {
    final res = await supabase.auth.signIn(email: username, password: password);

    final error = res.error;
    if (error != null) {
      _controller.add(AuthenticationStatus.unauthenticated);
      throw Exception(error.message);
    } else {
      _controller.add(AuthenticationStatus.authenticated);
    }
  }

  void logOut() {
    supabase.auth.signOut();
    _controller.add(AuthenticationStatus.unauthenticated);
  }

  void dispose() => _controller.close();
}
