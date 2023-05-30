import '../../enums/auth_type.dart';
import '../../enums/user_type.dart';
import 'device_token.dart';
import 'number_detail.dart';

class AppUser {
  AppUser({
    required this.uid,
    required this.name,
    required this.designation,
    required this.phoneNumber,
    required this.email,
    required this.password,
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

  final String uid;
  final String name;
  final String nickName;
  final UserDesignation designation;
  final AuthType authType;
  final NumberDetails phoneNumber;
  final String email;
  final String password;
  final String imageURL;
  final List<MyDeviceToken> deviceToken;
  final List<String> notAllowedWords;
  final bool status;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'name': name,
      'nickName': nickName,
      'designation': designation.json,
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
      name: map['name'] ?? '',
      nickName: map['nickName'] ?? '',
      designation: UserDesignationConvertor()
          .toEnum(map['designation'] ?? UserDesignation.employee.json),
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
