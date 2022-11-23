import 'dart:async';

import 'package:supabase_flutter/supabase_flutter.dart' as sb;
import 'package:user_repository/src/models/models.dart';

class UserRepository {
  sb.SupabaseClient supabase = sb.Supabase.instance.client;
  User? _user;

  Future<User?> getUser() async {
    if (_user != null) return _user;
    final userId = supabase.auth.currentUser!.id;
    final data = await supabase
        .from('profiles')
        .select()
        .eq('id', userId)
        .single() as Map<String, dynamic>;

    _user = User.fromMap(data);
    return _user;
  }
}
