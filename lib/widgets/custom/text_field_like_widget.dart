import 'package:flutter/material.dart';

class TextFieldLikeWidget extends StatelessWidget {
  const TextFieldLikeWidget({required this.child, super.key});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).dividerColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: child,
    );
  }
}