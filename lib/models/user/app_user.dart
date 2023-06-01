import 'package:hive/hive.dart';

import '../../enums/user/auth_type.dart';
import '../../enums/user/user_type.dart';
import 'device_token.dart';
import 'number_detail.dart';
part 'app_user.g.dart';

@HiveType(typeId: 1)
class AppUser extends HiveObject {
  AppUser({
    required this.uid,
    required this.agencyID,
    required this.name,
    required this.phoneNumber,
    required this.email,
    required this.password,
    required this.type,
    String? nickName,
    AuthType? authType,
    String? imageURL,
    List<MyDeviceToken>? deviceToken,
    List<String>? notAllowedWords,
    this.status = true,
  })  : nickName = nickName ?? 'no-name',
        authType = authType ?? AuthType.email,
        imageURL = imageURL ?? '',
        deviceToken = deviceToken ?? <MyDeviceToken>[],
        notAllowedWords = notAllowedWords ?? <String>[];

  @HiveField(0)
  final String uid;
  @HiveField(1)
  final String agencyID;
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

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'agency_id': agencyID,
      'name': name,
      'nickName': nickName,
      'type': type.json,
      'auth_type': authType.json,
      'phone_number': phoneNumber.toMap(),
      'email': email,
      'password': password,
      'image_url': imageURL,
      'devices_token': deviceToken.map((MyDeviceToken x) => x.toMap()).toList(),
      'not_allowed_words': notAllowedWords,
      'status': status,
    };
  }

  // ignore: sort_constructors_first
  factory AppUser.fromMap(Map<String, dynamic> map) {
    List<MyDeviceToken> dtData = <MyDeviceToken>[];
    if (map['devices_token'] != null) {
      map['devices_token'].forEach((dynamic e) {
        dtData.add(MyDeviceToken.fromMap(e));
      });
    }
    return AppUser(
      uid: map['uid'] ?? '',
      agencyID: map['agency_id'] ?? '',
      name: map['name'] ?? '',
      nickName: map['nickName'] ?? '',
      type: UserTypeConvertor().toEnum(map['type'] ?? UserType.user.json),
      authType:
          AuthTypeConvertor().toEnum(map['auth_type'] ?? AuthType.email.json),
      phoneNumber:
          NumberDetails.fromMap(map['phone_number'] as Map<String, dynamic>),
      email: map['email'] ?? '',
      password: map['password'] ?? '',
      imageURL: map['image_url'] ?? '',
      deviceToken: List<MyDeviceToken>.from(
        (map['devices_token'] as List<int>).map<MyDeviceToken>(
          (int x) => MyDeviceToken.fromMap(x as Map<String, dynamic>),
        ),
      ),
      notAllowedWords:
          List<String>.from((map['not_allowed_words'] as List<String>)),
      status: map['status'] ?? false,
    );
  }
}
