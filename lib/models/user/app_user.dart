import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';

import '../../database/firebase/auth_methods.dart';
import '../../enums/user/auth_type.dart';
import '../../enums/user/user_type.dart';
import '../../functions/helping_funcation.dart';
import 'device_token.dart';
import 'number_detail.dart';
part 'app_user.g.dart';

@HiveType(typeId: 1)
class AppUser extends HiveObject {
  AppUser({
    required this.uid,
    required this.agencyIDs,
    required this.name,
    required this.phoneNumber,
    required this.email,
    required this.password,
    required this.type,
    int? defaultColor,
    String? nickName,
    AuthType? authType,
    String? imageURL,
    List<MyDeviceToken>? deviceToken,
    List<String>? notAllowedWords,
    DateTime? lastUpdate,
    this.status = true,
  })  : nickName = nickName ?? 'no-name',
        authType = authType ?? AuthType.email,
        imageURL = imageURL ?? '',
        deviceToken = deviceToken ?? <MyDeviceToken>[],
        defaultColor = defaultColor ?? HelpingFuncation().randomColor(),
        lastUpdate = lastUpdate ?? DateTime.now(),
        notAllowedWords = notAllowedWords ??
            <String>[
              'on Whatsapp',
              'paying',
              'paid',
              '\$',
              'usd',
              phoneNumber.number,
              phoneNumber.completeNumber,
              HelpingFuncation().numberInWords(phoneNumber.number),
            ];

  @HiveField(0)
  final String uid;
  // file 1, not available
  @HiveField(2)
  final String name;
  @HiveField(3)
  final String nickName;
  // file 4, not for use
  @HiveField(5) // Class Code: 12
  final UserType type;
  @HiveField(6) // Class Code: 13
  final AuthType authType;
  @HiveField(7) // Class Code: 14
  final NumberDetails phoneNumber;
  @HiveField(8)
  final String email;
  @HiveField(9)
  final String password;
  @HiveField(10)
  final String imageURL;
  @HiveField(11) // Class Code: 15
  final List<MyDeviceToken> deviceToken;
  @HiveField(12)
  final List<String> notAllowedWords;
  @HiveField(13)
  final bool status;
  @HiveField(14)
  final List<String> agencyIDs;
  // 15 not in use
  @HiveField(16, defaultValue: 808080)
  final int defaultColor;
  @HiveField(17)
  final DateTime lastUpdate;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'agency_ids': agencyIDs,
      'name': name,
      'nick_name': nickName,
      'type': type.json,
      'auth_type': authType.json,
      'phone_number': phoneNumber.toMap(),
      'email': email,
      'password': password,
      'image_url': imageURL,
      'devices_token': deviceToken.map((MyDeviceToken x) => x.toMap()).toList(),
      'not_allowed_words': notAllowedWords,
      'default_color': defaultColor,
      'status': status,
      'last_update': lastUpdate,
    };
  }

  Map<String, dynamic> deviceTokenMap() {
    return <String, dynamic>{
      'devices_token': deviceToken.map((MyDeviceToken x) => x.toMap()).toList(),
      'last_update': lastUpdate,
    };
  }

  // ignore: sort_constructors_first
  factory AppUser.fromMap(DocumentSnapshot<Map<String, dynamic>> doc) {
    List<MyDeviceToken> dtData = <MyDeviceToken>[];
    if (doc.data()?['devices_token'] != null) {
      doc.data()?['devices_token'].forEach((dynamic e) {
        dtData.add(MyDeviceToken.fromMap(e));
      });
    }
    final bool isMe = AuthMethods.uid == (doc.data()?['uid'] ?? '');
    return AppUser(
      uid: doc.data()?['uid'] ?? '',
      agencyIDs: List<String>.from((doc.data()?['agency_ids'] ?? <String>[])),
      name: doc.data()?['name'] ?? '',
      nickName: doc.data()?['nick_name'] ?? '',
      type:
          UserTypeConvertor().toEnum(doc.data()?['type'] ?? UserType.user.json),
      authType: AuthTypeConvertor()
          .toEnum(doc.data()?['auth_type'] ?? AuthType.email.json),
      phoneNumber: NumberDetails.fromMap(
          doc.data()?['phone_number'] ?? <String, dynamic>{}),
      email: doc.data()?['email'] ?? '',
      password: !isMe ? '' : doc.data()?['password'] ?? '',
      imageURL: doc.data()?['image_url'] ?? '',
      defaultColor:
          doc.data()?['default_color'] ?? HelpingFuncation().randomColor(),
      deviceToken: dtData,
      notAllowedWords:
          List<String>.from((doc.data()?['not_allowed_words'] ?? <String>[])),
      status: doc.data()?['status'] ?? false,
      lastUpdate: doc.data()?['last_update'] ?? DateTime.now(),
    );
  }

  Map<String, dynamic> updateAgencyMap() {
    return <String, dynamic>{
      'agency_ids': agencyIDs,
      'last_update': lastUpdate,
    };
  }
}
