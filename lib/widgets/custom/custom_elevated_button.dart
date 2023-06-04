import 'package:flutter/material.dart';

import 'show_loading.dart';

class CustomElevatedButton extends StatelessWidget {
  const CustomElevatedButton({
    required this.title,
    required this.isLoading,
    required this.onTap,
    this.margin,
    this.padding,
    this.bgColor,
    this.borderRadius,
    this.border,
    this.textStyle,
    this.textColor,
    Key? key,
  }) : super(key: key);
  final String title;
  final VoidCallback onTap;
  final bool isLoading;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final Color? bgColor;
  final BorderRadius? borderRadius;
  final BoxBorder? border;
  final TextStyle? textStyle;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const ShowLoading()
        : Container(
            constraints: const BoxConstraints(maxWidth: 400),
            margin: margin ?? const EdgeInsets.symmetric(vertical: 6),
            decoration: BoxDecoration(
              color: bgColor ?? Theme.of(context).primaryColor,
              borderRadius: borderRadius ?? BorderRadius.circular(12),
              border: border,
            ),
            child: Material(
              borderRadius: borderRadius ?? BorderRadius.circular(12),
              color: bgColor ?? Theme.of(context).primaryColor,
              child: InkWell(
                borderRadius: borderRadius ?? BorderRadius.circular(12),
                onTap: onTap,
                child: Container(
                  padding: padding ?? const EdgeInsets.symmetric(vertical: 10),
                  alignment: Alignment.center,
                  child: Text(
                    title,
                    style: textStyle ??
                        TextStyle(
                          color: textColor ?? Colors.white,
                          fontSize: 18,
                        ),
                  ),
                ),
              ),
            ),
          );
  }
}
