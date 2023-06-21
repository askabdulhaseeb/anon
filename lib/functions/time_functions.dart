import 'dart:io';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TimeFun {
  DateTime now() => DateTime.now();
  static DateTime parseTime(dynamic date) {
    return date == null
        ? DateTime.now()
        : Platform.isIOS
            ? (date as Timestamp).toDate()
            : (date as Timestamp).toDate();
  }

  static Duration timeDuration(DateTime value) {
    DateTime now = DateTime.now();
    Duration diff = value.difference(now);
    return diff;
  }

  static DateTime timeAfterDays(int numOfDays) {
    DateTime now = DateTime.now();
    now.add(Duration(days: numOfDays));
    return now;
  }

  static String timeInDigits(DateTime value) {
    return DateFormat.jm().format(value);
  }

  static String timeleft(DateTime? value) {
    DateTime now = DateTime.now();
    Duration diff = value?.difference(now) ?? const Duration();
    int inSec = diff.inSeconds.abs();
    int inMints = diff.inMinutes.abs();
    int inHour = diff.inHours.abs();
    int inDays = diff.inDays.abs();
    String time = '';
    if (inDays > 365) {
      time = (diff.inDays.abs() / 365).toStringAsFixed(0);
      inDays = inDays ~/ 365;
      time += '$inDays:';
    } else {
      time += '$inDays:';
    }
    if (inHour > 23) {
      time += '${(inHour.abs() % 24).toStringAsFixed(0)}:';
    } else {
      time += '00:';
    }
    if (inMints > 59) {
      time += '${(inMints.abs() % 59).toStringAsFixed(0)}:';
    } else {
      time += '00:';
    }
    if (inSec > 59) {
      time += (inSec.abs() % 59).toStringAsFixed(0);
    } else {
      time += '00';
    }
    return time;
  }

  static String deadlineDate(DateTime? value) {
    DateTime now = DateTime.now();
    return DateFormat.yMEd().format(value ?? now);
  }

  static String timeInWords(DateTime? value) {
    DateTime now = DateTime.now();
    if (value == null) return 'null';
    Duration diff = value.difference(now);
    String time = '';

    int inSec = diff.inSeconds.abs();
    int inMints = diff.inMinutes.abs();
    int inHour = diff.inHours.abs();
    int inDays = diff.inDays.abs();

    if (inSec <= 0 || inSec > 0 && inMints == 0) {
      time = timeInDigits(value);
      //
    } else if (inMints > 0 && inHour == 0) {
      //
      time = timeInDigits(value);
      //
    } else if (inHour > 0 && inDays == 0) {
      //
      time = timeInDigits(value);
      //
    } else if (inDays > 0 && inDays < 7) {
      //
      if (inDays < 1.5) {
        time = '${inDays.toStringAsFixed(0)} day ago';
      } else {
        time = '${inDays.toStringAsFixed(0)} days ago';
      }
      //
    } else if (inDays >= 7 && inDays < 30) {
      double temp = (diff.inDays.abs() / 7);
      //
      if (inDays < 14) {
        time = '${temp.toStringAsFixed(0)} week ago';
      } else {
        time = '${temp.toStringAsFixed(0)} weeks ago';
      }
      //
    } else if (diff.inDays.abs() >= 30 && diff.inDays.abs() < 365) {
      double temp = (diff.inDays.abs() / 30);
      if (temp < 1.5) {
        time = '${temp.toStringAsFixed(0)} month ago';
      } else {
        time = '${temp.toStringAsFixed(0)} months ago';
      }
    } else {
      double temp = (diff.inDays.abs() / 365);
      if (temp < 1.5) {
        time = '${temp.toStringAsFixed(0)} year ago';
      } else {
        time = '${temp.toStringAsFixed(0)} years ago';
      }
    }
    return time;
  }
}
