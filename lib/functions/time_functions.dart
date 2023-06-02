import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

class TimeFun {
  DateTime now() => DateTime.now();
  static DateTime parseTime(dynamic date) {
    return Platform.isIOS ? (date as Timestamp).toDate() : (date as DateTime);
  }
}
