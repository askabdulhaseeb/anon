import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../../enums/my_hive_type.dart';
import '../../enums/user/user_type.dart';
import '../../models/user/app_user.dart';
import '../../models/user/number_detail.dart';
import '../firebase/auth_methods.dart';
import '../firebase/user_api.dart';

class LocalUser {
  static Future<Box<AppUser>> get openBox async =>
      await Hive.openBox<AppUser>(MyHiveType.user.database);

  static Future<void> get closeBox async =>
      Hive.box<AppUser>(MyHiveType.user.database).close();

  Future<Box<AppUser>> refresh() async {
    final bool isOpen = Hive.box<AppUser>(MyHiveType.user.database).isOpen;
    if (isOpen) {
      return Hive.box<AppUser>(MyHiveType.user.database);
    } else {
      return await openBox;
    }
  }

  Future<void> signIn(AppUser value) async {
    final Box<AppUser> box = await refresh();
    await box.put(value.uid, value);
  }

  Future<void> add(AppUser value) async {
    final Box<AppUser> box = await refresh();
    await box.put(value.uid, value);
  }

  Future<void> addAll(List<AppUser> value) async {
    final Box<AppUser> box = await refresh();
    try {
      for (int i = 0; i < value.length; i++) {
        await box.put(value[i].uid, value[i]);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<AppUser> user(String value) async {
    final Box<AppUser> box = await refresh();
    final AppUser? result = box.get(value);
    if (result == null) {
      final AppUser? cloudUser = await UserAPI().user(value);
      if (cloudUser == null) {
        return _null;
      } else {
        add(cloudUser);
        return cloudUser;
      }
    } else {
      return result;
    }
  }

  AppUser userWithoutFuture(String value) {
    final AppUser? result =
        Hive.box<AppUser>(MyHiveType.user.database).get(value);
    return result ?? _null;
  }

  Future<AppUser?> updateProfileURL(String value) async {
    final Box<AppUser> box = await refresh();
    final String me = AuthMethods.uid;
    box.get(me)!.imageURL = value;
    return box.get(me);
  }

  Future<List<AppUser>> stringListToObjectList(List<String> value) async {
    final Box<AppUser> box = await refresh();
    List<AppUser> objectList = <AppUser>[];
    try {
      for (String element in value) {
        final AppUser? result = box.get(element);
        if (result == null) {
          final AppUser? cloudUser = await UserAPI().user(element);
          if (cloudUser == null) {
          } else {
            add(cloudUser);
            objectList.add(cloudUser);
          }
        } else {
          objectList.add(result);
        }
      }
    } catch (e) {
      debugPrint('Local User: String to Object - ERROR: ${e.toString()}');
    }
    return objectList;
  }

  Future<void> switchAgency() async {
    try {
      final Box<AppUser> box = await refresh();
      final AppUser? me = box.get(AuthMethods.uid);
      assert(me != null);
      await box.clear();
      signIn(me!);
    } catch (e) {
      debugPrint('Error: Local User - ${e.toString()}');
    }
  }

  Future<void> refreshUsers() async {
    final Box<AppUser> box = await refresh();
    final List<String> uids =
        box.keys.map((dynamic e) => e.toString()).toSet().toList();
    await UserAPI().refresh(uids);
  }

  Future<void> signOut() async {
    final Box<AppUser> box = await refresh();
    await box.clear();
  }

  AppUser get _null => AppUser(
        uid: 'null',
        agencyIDs: <String>[],
        name: 'null',
        phoneNumber: NumberDetails(
            countryCode: 'PK',
            number: '1234567',
            completeNumber: '+923451234567',
            isoCode: '-'),
        email: 'null@user.com',
        password: '-',
        type: UserType.user,
      );
}
