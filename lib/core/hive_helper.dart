import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

class HiveHelper {
  static Future<void> init() async {
    if (kIsWeb) {
      await Hive.initFlutter();
      return;
    }
    final dir = await getApplicationDocumentsDirectory();
    await Hive.initFlutter(dir.path);
  }
}
