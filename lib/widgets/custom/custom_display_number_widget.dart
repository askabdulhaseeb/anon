import 'package:flutter/material.dart';

class CustomNumberDisplayWidget extends StatelessWidget {
  const CustomNumberDisplayWidget({
    required this.number,
    this.margin,
    this.style,
    super.key,
  });
  final int number;
  final EdgeInsetsGeometry? margin;
  final TextStyle? style;
  @override
  Widget build(BuildContext context) {
    return number == 0
        ? const SizedBox()
        : Container(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            margin: margin ?? const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              number.toString(),
              style: style ??
                  const TextStyle(
                    fontSize: 10,
                    color: Colors.white,
                  ),
            ),
          );
  }
}
