import 'package:hive/hive.dart';

import '../../functions/time_functions.dart';
part 'number_detail.g.dart';

@HiveType(typeId: 14)
class NumberDetails {
  NumberDetails({
    required this.countryCode,
    required this.number,
    required this.completeNumber,
    required this.isoCode,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  @HiveField(0)
  final String countryCode;
  @HiveField(1)
  final String number;
  @HiveField(2)
  final String completeNumber;
  @HiveField(3)
  final String isoCode;
  @HiveField(4)
  final DateTime timestamp;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'country_code': countryCode,
      'number': number,
      'complete_number': completeNumber,
      'iso_code': isoCode,
      'timestamp': timestamp,
    };
  }

  // ignore: sort_constructors_first
  factory NumberDetails.fromMap(Map<String, dynamic> map) {
    return NumberDetails(
      countryCode: map['country_code'] ?? '',
      number: map['number'] ?? '',
      completeNumber: map['complete_number'] ?? '',
      isoCode: map['iso_code'] ?? '',
      timestamp: TimeFun.parseTime(map['timestamp']),
    );
  }

  
}
