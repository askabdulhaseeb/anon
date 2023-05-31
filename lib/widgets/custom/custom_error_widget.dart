import 'package:flutter/material.dart';

class CustomErrorWidget extends StatelessWidget {
  const CustomErrorWidget({this.error, Key? key}) : super(key: key);
  final String? error;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        error ?? 'Some thing goes wrong',
        style: const TextStyle(color: Colors.grey),
      ),
    );
  }
}