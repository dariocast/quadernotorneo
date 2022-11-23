import 'dart:developer' as developer;

class QTLog {
  static String APP_TAG = 'quadernotorneo';

  static log(String message, {String? name, int level = 0}) {
    developer.log(message, name: '$APP_TAG.$name', level: level);
  }
}
