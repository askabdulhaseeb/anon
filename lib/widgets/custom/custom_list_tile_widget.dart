import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomListTileWidget extends StatelessWidget {
  const CustomListTileWidget({
    this.leadingIcon,
    this.leading,
    this.leadingIconColor,
    this.leadingIconSize = 18,
    this.header,
    this.headerTextStyle,
    this.canEdit = false,
    this.trailing,
    this.title,
    this.titleTextStyle,
    this.onEdit,
    this.margin,
    this.padding,
    this.bgColor,
    this.borderRadius,
    this.border,
    this.textStyle,
    this.textColor,
    Key? key,
  }) : super(key: key);
  final IconData? leadingIcon;
  final Widget? leading;
  final Color? leadingIconColor;
  final double leadingIconSize;
  final String? header;
  final TextStyle? headerTextStyle;
  final bool canEdit;
  final VoidCallback? onEdit;
  final Widget? trailing;

  final String? title;
  final TextStyle? titleTextStyle;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final Color? bgColor;
  final BorderRadius? borderRadius;
  final BoxBorder? border;
  final TextStyle? textStyle;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 400),
      margin: margin,
      // decoration: BoxDecoration(
      //   color: bgColor ?? Theme.of(context).primaryColor,
      //   borderRadius: borderRadius ?? BorderRadius.circular(8),
      //   border: border,
      // ),
      child: Material(
        borderRadius: borderRadius ?? BorderRadius.circular(8),
        color: bgColor,
        child: InkWell(
          borderRadius: borderRadius ?? BorderRadius.circular(8),
          onTap: onEdit,
          child: Padding(
            padding: padding ?? const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                leading ??
                    (leadingIcon != null
                        ? Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: Icon(
                              leadingIcon,
                              color: leadingIconColor ??
                                  Theme.of(context).disabledColor,
                              size: leadingIconSize,
                            ),
                          )
                        : const SizedBox()),
                //
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        if (header != null)
                          Text(
                            header ?? '',
                            style: headerTextStyle ??
                                TextStyle(
                                    color: Theme.of(context).disabledColor),
                          ),
                        if (title != null)
                          Text(
                            title ?? '',
                            style: titleTextStyle,
                          ),
                      ],
                    ),
                  ),
                ),
                //
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    trailing ?? const SizedBox(),
                    if (canEdit)
                      IconButton(
                        splashRadius: 16,
                        tooltip: 'Edit',
                        onPressed: onEdit,
                        icon: Icon(
                          CupertinoIcons.pencil_ellipsis_rectangle,
                          color: Theme.of(context).primaryColor,
                        ),
                      )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
