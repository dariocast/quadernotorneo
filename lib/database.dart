import 'dart:io';

import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

class Database {
  final name = 'database';
  static Box? box;
  static Future init() async {
    final Directory appDocDir = await getApplicationDocumentsDirectory();
    final String appDocPath = appDocDir.path;
    Hive.init(appDocPath);
    box = await Hive.openBox('quaderno');
    if (box != null) {
      return 'ok';
    }
  }

  static Future autoInit() async {
    if (box == null) {
      await Database.init();
    }
  }

  static Future remove() async {
    await autoInit();
    final response = await box!.clear();
    return response;
  }

  static Future put(key, value) async {
    await autoInit();
    final r = await box!.put(key, value);
    return r;
  }

  static Future get(key) async {
    await autoInit();
    final r = await box!.get(key);
    return r;
  }

  static Future delete(key) async {
    await autoInit();
    final r = await box!.delete(key);
    return r;
  }
}
