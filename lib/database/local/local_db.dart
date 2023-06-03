import 'dart:io';

import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

import '../../enums/user/auth_type.dart';
import '../../enums/user/user_designation.dart';
import '../../enums/user/user_type.dart';
import '../../models/agency/agency.dart';
import '../../models/agency/member_detail.dart';
import '../../models/user/app_user.dart';
import '../../models/user/device_token.dart';
import '../../models/user/number_detail.dart';
import 'local_agency.dart';
import 'local_user.dart';

class LocalDB {
  Future<void> init() async {
    Directory directory = await getApplicationDocumentsDirectory();
    Hive.init(directory.path);
    await Hive.initFlutter(directory.path);
    //
    // Type: User 1
    Hive.registerAdapter(AppUserAdapter()); // 1
    Hive.registerAdapter(UserTypeAdapter()); // 12
    Hive.registerAdapter(AuthTypeAdapter()); // 13
    Hive.registerAdapter(NumberDetailsAdapter()); // 14
    Hive.registerAdapter(MyDeviceTokenAdapter()); // 15
    //
    // Type: Agency 2
    Hive.registerAdapter(AgencyAdapter()); // 2
    Hive.registerAdapter(MemberDetailAdapter()); // 20
    Hive.registerAdapter(UserDesignationAdapter()); // 200

    //
    // Open Boxes
    await LocalUser.openBox;
    await LocalAgency.openBox;
  }

  Future<void> signOut() async {
    await LocalUser().signOut();
    await LocalAgency().signOut();
  }
}
