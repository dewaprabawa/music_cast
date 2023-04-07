
import 'package:hive_flutter/adapters.dart';
import 'package:music_cast/commons/box_name/hive_box_name.dart';
import 'package:path_provider/path_provider.dart';

Future<void> registerHives() async {
  var dir = await getApplicationDocumentsDirectory();
  Hive.init(dir.path);
  await Hive.initFlutter();
  await Hive.openBox(HiveBoxName.songs);
  await Hive.openBox(HiveBoxName.playlist);
}

