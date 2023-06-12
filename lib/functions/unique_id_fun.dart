import 'dart:math';

import '../database/firebase/auth_methods.dart';

class UniqueIdFun {
  static String generateRandomString({int length = 6}) {
    const String letterLowerCase = 'abcdefghijklmnopqrstuvwxyz';
    const String letterUpperCase = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    // don't user 0, it confuse users sometimes with 'o' and 'O'
    const String number = '123456789';
    final String possibleChar =
        letterLowerCase + AuthMethods.uid + letterUpperCase + number;
    return List<String>.generate(length, (int index) {
      final int indexRandom = Random.secure().nextInt(possibleChar.length);
      return possibleChar[indexRandom];
    }).join('').trim();
  }

  static String unique() {
    return '${AuthMethods.uid}-${DateTime.now().microsecondsSinceEpoch}';
  }

  static String projectID(String agencyID) {
    return '$agencyID-pro-${generateRandomString()}';
  }

  static String chatID(String proID) {
    return '$proID-chat-${generateRandomString()}';
  }

  static String messageID(String chatID) {
    return '$chatID-${generateRandomString()}-${DateTime.now().microsecondsSinceEpoch}';
  }
}
