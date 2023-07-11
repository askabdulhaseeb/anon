import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../enums/my_hive_type.dart';
import '../../enums/project/milestone_status.dart';
import '../../models/project/milestone.dart';
import '../../models/project/project.dart';
import '../firebase/project_api.dart';

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

  Future<Project> project(String value) async {
    final Box<Project> box = await refresh();
    return box.get(value) ?? _null;
  }

  Future<List<Project>> projectByAgencyAndUID(
      String agencyID, String uid) async {
    final Box<Project> box = await refresh();
    return box.values
        .where((Project element) =>
            element.members.contains(uid) &&
            element.agencies.contains(agencyID))
        .toList();
  }

  Future<void> add(Project value) async {
    final Box<Project> box = await refresh();
    await box.put(value.pid, value);
  }

  Future<void> remove(Project value) async {
    final Box<Project> box = await refresh();
    await box.delete(value.pid);
  }

  Future<void> update(Project value) async {
    final Box<Project> box = await refresh();
    await box.put(value.pid, value);
    await ProjectAPI().update(value);
  }

  Future<void> addAll(List<Project> value) async {
    final Box<Project> box = await refresh();
    await box.clear();
    for (Project element in value) {
      await box.put(element.pid, element);
    }
  }

  Future<void> updateMembers(Project value) async {
    final Box<Project> box = await refresh();
    debugPrint('Local Project: Start updating Project Member');
    await box.put(value.pid, value);
    await ProjectAPI().updateMembers(value);
  }

  List<Project> boxToProjects(
    Box<Project> box,
    String agencyID,
    String search,
  ) {
    final List<Project> results = box.values
        .toList()
        .cast<Project>()
        .where((Project element) =>
            element.agencies.contains(agencyID) &&
            element.title.toLowerCase().contains(search.toLowerCase()))
        .toList();
    results.sort((Project a, Project b) => (a.milestone
                .firstWhere(
                  (Milestone aEle) =>
                      aEle.status == MilestoneStatus.inActive ||
                      aEle.status == MilestoneStatus.active,
                  orElse: () => a.milestone.last,
                )
                .deadline ??
            DateTime.now())
        .compareTo(b.milestone
                .firstWhere(
                  (Milestone bEle) =>
                      bEle.status == MilestoneStatus.inActive ||
                      bEle.status == MilestoneStatus.active,
                  orElse: () => b.milestone.last,
                )
                .deadline ??
            DateTime.now()));
    return results;
  }

  ValueListenable<Box<Project>> listenable() {
    final bool isOpen = Hive.box<Project>(MyHiveType.project.database).isOpen;
    if (isOpen) {
      return Hive.box<Project>(MyHiveType.project.database).listenable();
    } else {
      openBox;
      return Hive.box<Project>(MyHiveType.project.database).listenable();
    }
  }

  Future<void> signOut() async {
    final Box<Project> box = await refresh();
    await box.clear();
  }

  Project get _null => Project(
        pid: 'null',
        title: 'Null',
        agencies: <String>[],
        logo: '',
      );
}
