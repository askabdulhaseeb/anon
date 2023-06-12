import 'dart:convert';
import 'dart:developer';
import 'package:encrypt/encrypt.dart';

class MyEncryption {
  String encrypt(String data, String uid) {
    log('Data: $data, ID: $uid');
    if (data.isEmpty || uid.isEmpty) return '';
    String bs64 = base64.encode(uid.codeUnits);
    String x = bs64.substring(bs64.length - 24, bs64.length);
    final Key key = Key.fromBase64(x);
    final IV iv = IV.fromBase64(x);
    final Encrypter encrypter = Encrypter(AES(key));
    final Encrypted encrypted = encrypter.encrypt(data, iv: iv);
    final String encrypted64 = encrypted.base64;

    return encrypted64;
  }

  String decrypt(String data, String uid) {
    log('Data: $data, ID: $uid');
    if (data.isEmpty || uid.isEmpty) return '';
    String bs64 = base64.encode(uid.codeUnits);
    String x = bs64.substring(bs64.length - 24, bs64.length);
    final Key key = Key.fromBase64(x);
    final IV iv = IV.fromBase64(x);
    final Encrypter encrypter = Encrypter(AES(key));
    final String decrypted64 =
        encrypter.decrypt(Encrypted.fromBase64(data), iv: iv);
    return decrypted64;
  }
}
