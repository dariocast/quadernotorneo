import 'dart:developer' as developer;

class QTLog {
  static String appTag = 'quadernotorneo';

  static log(String message, {String? name, int level = 0}) {
    developer.log(message, name: '$appTag.$name', level: level);
  }
}
