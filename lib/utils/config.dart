import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Configuration class for environment variables
class Config {
  /// Loads environment variables from .env file
  static Future<void> load() async {
    await dotenv.load();
  }

  /// Gets the Supabase URL from environment variables
  static String get supabaseUrl {
    final url = dotenv.env['SUPABASE_URL'];
    if (url == null) {
      throw Exception('SUPABASE_URL not found in environment variables');
    }
    return url;
  }

  /// Gets the Supabase anonymous key from environment variables
  static String get supabaseAnonKey {
    final key = dotenv.env['SUPABASE_ANON_KEY'];
    if (key == null) {
      throw Exception('SUPABASE_ANON_KEY not found in environment variables');
    }
    return key;
  }
}
