import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HelpingFuncation {
  void dismissKeyboard(BuildContext context) {
    FocusScope.of(context).unfocus();
  }

  void copyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text)).then((_) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('$text copied')));
    });
  }

  String numberInWords(String number) {
    String words = '';
    for (int i = 0; i < number.length; i++) {
      words += digitToWord(int.tryParse(number[i]) ?? 0);
      words += ' ';
    }
    return words;
  }

  digitToWord(int digit) {
    switch (digit) {
      case 0:
        return 'zero';
      case 1:
        return 'one';
      case 2:
        return 'two';
      case 3:
        return 'three';
      case 4:
        return 'four';
      case 5:
        return 'five';
      case 6:
        return 'six';
      case 7:
        return 'seven';
      case 8:
        return 'eight';
      case 9:
        return 'nine';
      default:
    }
  }
}
