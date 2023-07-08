import 'package:hive/hive.dart';

import '../../functions/time_functions.dart';
part 'message_read_info.g.dart';

@HiveType(typeId: 45)
class MessageReadInfo {
  MessageReadInfo({
    required this.uid,
    this.delivered = true,
    this.seen = false,
    DateTime? deliveryAt,
    DateTime? seenAt,
  })  : deliveryAt = deliveryAt ?? DateTime.now(),
        seenAt = seenAt ?? DateTime.now();

  @HiveField(0)
  final String uid;
  @HiveField(1)
  final bool delivered;
  @HiveField(2)
  bool seen;
  @HiveField(3)
  final DateTime? deliveryAt;
  @HiveField(4)
  DateTime? seenAt;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'delivered': delivered,
      'seen': seen,
      'seen_at': seenAt,
      'delivery_at': deliveryAt,
    };
  }

  // ignore: sort_constructors_first
  factory MessageReadInfo.fromMap(Map<String, dynamic> map) {
    return MessageReadInfo(
      uid: map['uid'] ?? '',
      delivered: map['delivered'] ?? false,
      seen: map['seen'] ?? false,
      deliveryAt: TimeFun.parseTime(map['delivery_at']),
      seenAt: TimeFun.parseTime(map['seen_at']),
    );
  }
}
