import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../enums/my_hive_type.dart';
import '../../models/agency/agency.dart';
import '../firebase/auth_methods.dart';

class LocalAgency {
  static const String nullID = '-%-null-%-';
  static Future<Box<Agency>> get openBox async =>
      await Hive.openBox<Agency>(MyHiveType.agency.database);

  static Future<void> get closeBox async =>
      Hive.box<Agency>(MyHiveType.agency.database).close();

  Future<Box<Agency>> refresh() async {
    final bool isOpen = Hive.box<Agency>(MyHiveType.agency.database).isOpen;
    if (isOpen) {
      return Hive.box<Agency>(MyHiveType.agency.database);
    } else {
      return await openBox;
    }
  }

  Future<void> add(Agency value) async {
    final Box<Agency> box = await refresh();
    await box.put(value.agencyID, value);
  }

  Future<void> addAll(List<Agency> value) async {
    final Box<Agency> box = await refresh();
    try {
      for (int i = 0; i < value.length; i++) {
        await box.put(value[i].agencyID, value[i]);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> leaveAgency(String value) async {
    final Box<Agency> box = await refresh();
    await box.delete(value);
  }

  Future<bool> displayMainScreen() async {
    final Box<Agency> box = await refresh();
    try {
      final List<Agency> results = box.values.toList();
      final Agency found = results.firstWhere(
        (Agency element) {
          return element.isCurrenlySelected &&
              element.members.contains(AuthMethods.uid);
        },
        orElse: () =>
            Agency(agencyID: nullID, agencyCode: nullID, name: nullID),
      );
      log('Current Agency ID: ${found.agencyID} - ${found.name}');
      return found.agencyID == nullID ? false : true;
    } catch (e) {
      debugPrint(e.toString());
    }
    return false;
  }

  Future<Agency?> currentlySelected() async {
    final Box<Agency> box = await refresh();
    try {
      final List<Agency> results = box.values.toList();
      final Agency found = results.firstWhere(
        (Agency element) =>
            element.isCurrenlySelected == true &&
            element.members.contains(AuthMethods.uid),
        orElse: () =>
            Agency(agencyID: nullID, agencyCode: nullID, name: nullID),
      );
      log('Current Agency ID: ${found.agencyID} - ${found.name}');
      return found.agencyID == nullID ? null : found;
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  Future<Agency?> agency(String value) async {
    final Box<Agency> box = await refresh();
    final Agency? result = box.get(value);
    if (result != null && result.members.contains(AuthMethods.uid)) {
      return result;
    }
    return null;
  }

  Future<void> switchAgency(String value) async {
    final Box<Agency> box = await refresh();
    try {
      final List<Agency> results = box.values.toList();
      for (Agency element in results) {
        if (element.agencyID == value) {
          element.isCurrenlySelected = true;
          debugPrint('${element.agencyID} is Joined');
        } else {
          element.isCurrenlySelected = false;
        }
      }
      for (Agency element in results) {
        await element.save();
      }
    } catch (e) {
      debugPrint('Error: Local User - ${e.toString()}');
    }
  }


  ValueListenable<Box<Agency>> listenable() {
    final bool isOpen = Hive.box<Agency>(MyHiveType.agency.database).isOpen;
    if (isOpen) {
      return Hive.box<Agency>(MyHiveType.agency.database).listenable();
    } else {
      openBox;
      return Hive.box<Agency>(MyHiveType.agency.database).listenable();
    }
  }

  Future<void> signOut() async {
    final Box<Agency> box = await refresh();
    await box.clear();
  }
}
