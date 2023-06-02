import 'dart:math';

class UniqueIdFun {
  static String generateRandomString({int length = 6}) {
    const String letterLowerCase = 'abcdefghijklmnopqrstuvwxyz';
    const String letterUpperCase = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const String number = '0123456789';
    const String possibleChar = letterLowerCase + letterUpperCase + number;
    return List<String>.generate(length, (int index) {
      final int indexRandom = Random.secure().nextInt(possibleChar.length);
      return possibleChar[indexRandom];
    }).join('').trim();
  }
}
