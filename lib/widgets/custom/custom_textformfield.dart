import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomTextFormField extends StatefulWidget {
  const CustomTextFormField({
    required TextEditingController? controller,
    this.keyboardType,
    this.textInputAction,
    this.onChanged,
    this.focusNode,
    this.validator,
    this.onFieldSubmitted,
    this.initialValue,
    this.hint = '',
    this.color,
    this.contentPadding,
    this.minLines = 1,
    this.maxLines = 1,
    this.maxLength,
    this.prefixIcon,
    this.showSuffixIcon = true,
    this.displayCrossSufixIcon = true,
    this.readOnly = false,
    this.autoFocus = false,
    this.textAlign = TextAlign.start,
    this.style,
    this.border,
    Key? key,
  })  : _controller = controller,
        super(key: key);
  final TextEditingController? _controller;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final void Function(String)? onChanged;
  final FocusNode? focusNode;
  final Widget? prefixIcon;
  final bool showSuffixIcon;
  final bool displayCrossSufixIcon;
  final String? Function(String? value)? validator;
  final void Function(String)? onFieldSubmitted;
  final EdgeInsetsGeometry? contentPadding;
  final int? minLines;
  final int? maxLines;
  final int? maxLength;
  final Color? color;
  final String? initialValue;
  final String? hint;
  final bool readOnly;
  final bool autoFocus;
  final TextAlign textAlign;
  final InputBorder? border;
  final TextStyle? style;
  @override
  CustomTextFormFieldState createState() => CustomTextFormFieldState();
}

class CustomTextFormFieldState extends State<CustomTextFormField> {
  void _onListen() => setState(() {});
  @override
  void initState() {
    widget._controller!.addListener(_onListen);
    super.initState();
  }

  @override
  void dispose() {
    widget._controller!.removeListener(_onListen);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: TextFormField(
          initialValue: widget.initialValue,
          controller: widget._controller,
          readOnly: widget.readOnly,
          focusNode: widget.focusNode,
          enableInteractiveSelection: true,
          enableSuggestions: true,
          keyboardType: widget.keyboardType == TextInputType.number
              ? const TextInputType.numberWithOptions(
                  signed: true, decimal: true)
              : widget.maxLines! > 1
                  ? TextInputType.multiline
                  : widget.keyboardType ?? TextInputType.text,
          textInputAction: widget.maxLines! > 1
              ? TextInputAction.newline
              : widget.textInputAction ?? TextInputAction.next,
          autofocus: widget.autoFocus,
          textAlign: widget.textAlign,
          onChanged: widget.onChanged,
          minLines: widget.minLines,
          maxLines: (widget._controller!.text.isEmpty) ? 1 : widget.maxLines,
          maxLength: widget.maxLength,
          style: widget.style,
          validator: (String? value) => widget.validator!(value),
          cursorColor: Theme.of(context).colorScheme.secondary,
          onFieldSubmitted: widget.onFieldSubmitted,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 12),
            fillColor: widget.color ??
                Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.15),
            hintText: widget.hint,
            prefixIcon: widget.prefixIcon,
            suffixIcon: (widget._controller!.text.isEmpty ||
                    !widget.showSuffixIcon ||
                    widget.showSuffixIcon == false)
                ? null
                : widget.displayCrossSufixIcon
                    ? IconButton(
                        splashRadius: 16,
                        onPressed: () => setState(() {
                          widget._controller!.clear();
                        }),
                        icon: const Icon(CupertinoIcons.clear, size: 18),
                      )
                    : null,
            focusColor: Theme.of(context).primaryColor,
            border: widget.border ??
                OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(
                    color:
                        widget.color ?? Theme.of(context).dividerTheme.color!,
                  ),
                ),
          ),
        ),
      ),
    );
  }
}
