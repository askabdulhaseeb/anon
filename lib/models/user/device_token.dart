import 'package:hive/hive.dart';
part 'device_token.g.dart';

@HiveType(typeId: 15)
class MyDeviceToken {
  MyDeviceToken({
    required this.token,
    List<String>? failNotificationByUID,
    DateTime? registerTimestamp,
  })  : failNotificationByUID = failNotificationByUID ?? <String>[],
        registerTimestamp = registerTimestamp ?? DateTime.now();

  @HiveField(0)
  final String token;
  @HiveField(1)
  final List<String> failNotificationByUID;
  @HiveField(2)
  final DateTime registerTimestamp;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'token': token,
      'fail_notification_by_uid': failNotificationByUID,
      'register_timestamp': registerTimestamp.millisecondsSinceEpoch,
    };
  }

  // ignore: sort_constructors_first
  factory MyDeviceToken.fromMap(Map<String, dynamic> map) {
    return MyDeviceToken(
      token: map['token'] ?? '',
      failNotificationByUID: map['fail_notification_by_uid'] != null
          ? List<String>.from((map['fail_notification_by_uid']) ?? <String>[])
          : <String>[],
      registerTimestamp:
          DateTime.fromMillisecondsSinceEpoch(map['register_timestamp'] ?? 0),
    );
  }
}
