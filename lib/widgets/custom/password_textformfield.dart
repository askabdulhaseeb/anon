import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../utilities/custom_validators.dart';

class PasswordTextFormField extends StatefulWidget {
  const PasswordTextFormField({
    required TextEditingController controller,
    this.title = 'Password',
    this.focusNode,
    this.validator,
    this.textInputAction = TextInputAction.done,
    this.onFieldSubmitted,
    Key? key,
  })  : _controller = controller,
        super(key: key);
  final TextEditingController _controller;
  final String title;
  final FocusNode? focusNode;
  final String? Function(String? value)? validator;
  final TextInputAction? textInputAction;
  final void Function(String)? onFieldSubmitted;
  @override
  PasswordTextFormFieldState createState() => PasswordTextFormFieldState();
}

class PasswordTextFormFieldState extends State<PasswordTextFormField> {
  bool _notVisible = true;
  void _onListener() => setState(() {});
  @override
  void initState() {
    widget._controller.addListener(_onListener);
    super.initState();
  }

  @override
  void dispose() {
    widget._controller.removeListener(_onListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: TextFormField(
          controller: widget._controller,
          obscureText: _notVisible,
          focusNode: widget.focusNode,
          keyboardType: TextInputType.visiblePassword,
          textInputAction: widget.textInputAction,
          cursorColor: Theme.of(context).colorScheme.secondary,
          validator: (String? value) => widget.validator == null
              ? CustomValidator.password(value)
              : widget.validator!(value),
          onFieldSubmitted: widget.onFieldSubmitted,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 12),
            hintText: widget.title,
            suffixIcon: IconButton(
              onPressed: () => setState(() {
                _notVisible = !_notVisible;
              }),
              splashRadius: 16,
              icon: (_notVisible == true)
                  ? const Icon(CupertinoIcons.eye)
                  : const Icon(CupertinoIcons.eye_slash),
            ),
            focusColor: Theme.of(context).primaryColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                color: Theme.of(context).dividerTheme.color!,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
