import 'package:flutter/material.dart';

class CustomToast {
  // static void successToast({required String message, int duration = 3}) {
  //   Fluttertoast.showToast(
  //     msg: message,
  //     timeInSecForIosWeb: duration,
  //     backgroundColor: Colors.green,
  //   );
  // }

  // static void errorToast({required String message, int duration = 4}) {
  //   Fluttertoast.showToast(
  //     msg: message,
  //     timeInSecForIosWeb: duration,
  //     backgroundColor: Colors.red,
  //   );
  // }

  static void errorSnackBar(BuildContext context, {required String text}) {
    final SnackBar snackBar =
        SnackBar(content: Text(text), backgroundColor: Colors.red);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static void successSnackBar(BuildContext context, {required String text}) {
    final SnackBar snackBar =
        SnackBar(content: Text(text), backgroundColor: Colors.green);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
