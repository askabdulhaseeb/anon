import 'package:flutter/material.dart';

import 'custom_textformfield.dart';

class CustomTextEditableWidget extends StatefulWidget {
  const CustomTextEditableWidget({
    required this.displayTitle,
    required this.initText,
    this.hint,
    this.keyboardType,
    this.textCapitalization,
    super.key,
  });
  final String displayTitle;
  final String initText;
  final String? hint;
  final TextInputType? keyboardType;
  final TextCapitalization? textCapitalization;

  @override
  State<CustomTextEditableWidget> createState() =>
      _CustomTextEditableWidgetState();
}

class _CustomTextEditableWidgetState extends State<CustomTextEditableWidget> {
  late TextEditingController _controller;
  @override
  void initState() {
    _controller = TextEditingController(text: widget.initText);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      maxChildSize: 0.9,
      initialChildSize: 0.9,
      minChildSize: 0.8,
      expand: false,
      builder: (BuildContext context, ScrollController scrollController) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          widget.displayTitle,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () =>
                          Navigator.of(context).pop(_controller.text),
                      child: const Text(
                        'Apply',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                CustomTextFormField(
                  controller: _controller,
                  showSuffixIcon: false,
                  autoFocus: true,
                  maxLines: 5,
                  keyboardType: widget.keyboardType,
                  hint: widget.hint ?? widget.displayTitle,
                  textCapitalization: widget.textCapitalization,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
