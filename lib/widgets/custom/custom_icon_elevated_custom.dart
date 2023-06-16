import 'package:flutter/material.dart';

import 'show_loading.dart';

class CustomIconElevatedButton extends StatelessWidget {
  const CustomIconElevatedButton({
    required this.title,
    required this.icon,
    required this.isLoading,
    required this.onTap,
    this.isExpanded = true,
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
  final IconData icon;
  final bool isLoading;
  final bool isExpanded;
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
            constraints: const BoxConstraints(maxWidth: 400, minWidth: 80),
            margin: margin ?? const EdgeInsets.symmetric(vertical: 6),
            decoration: BoxDecoration(
              color: bgColor ?? Theme.of(context).primaryColor,
              borderRadius: borderRadius ?? BorderRadius.circular(8),
              border: border,
            ),
            child: Material(
              borderRadius: borderRadius ?? BorderRadius.circular(8),
              color: bgColor ?? Theme.of(context).primaryColor,
              child: InkWell(
                borderRadius: borderRadius ?? BorderRadius.circular(8),
                onTap: onTap,
                child: Container(
                  padding: padding ?? const EdgeInsets.all(10),
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisSize:
                        isExpanded ? MainAxisSize.max : MainAxisSize.min,
                    children: <Widget>[
                      Icon(icon, color: textColor ?? Colors.white),
                      Text(
                        title,
                        style: textStyle ??
                            TextStyle(
                              color: textColor ?? Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
