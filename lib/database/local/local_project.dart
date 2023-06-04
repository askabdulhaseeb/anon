import 'package:hive_flutter/hive_flutter.dart';

import '../../enums/my_hive_type.dart';
import '../../models/project/project.dart';

class LocalProject {
  static Future<Box<Project>> get openBox async =>
      await Hive.openBox<Project>(MyHiveType.project.database);

  static Future<void> get closeBox async =>
      Hive.box<Project>(MyHiveType.project.database).close();

  Future<Box<Project>> refresh() async {
    final bool isOpen = Hive.box<Project>(MyHiveType.project.database).isOpen;
    if (isOpen) {
      return Hive.box<Project>(MyHiveType.project.database);
    } else {
      return await openBox;
    }
  }

  Future<void> add(Project value) async {
    final Box<Project> box = await refresh();
    await box.put(value.pid, value);
  }

  Future<void> signOut() async {
    final Box<Project> box = await refresh();
    await box.clear();
  }
}
