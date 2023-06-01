import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';

class PhoneNumberField extends StatefulWidget {
  const PhoneNumberField({
    required this.initialCountryCode,
    required this.onChange,
    this.focusNode,
    this.bgColor,
    Key? key,
  }) : super(key: key);
  final Function(PhoneNumber)? onChange;
  final String? initialCountryCode;
  final Color? bgColor;
  final FocusNode? focusNode;
  @override
  State<PhoneNumberField> createState() => _PhoneNumberFieldState();
}

class _PhoneNumberFieldState extends State<PhoneNumberField> {
  @override
  Widget build(BuildContext context) {
    final OutlineInputBorder border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: IntlPhoneField(
        textInputAction: TextInputAction.done,
        showCountryFlag: true,
        focusNode: widget.focusNode,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 12),
          enabledBorder: border,
          labelText: 'Mobile number',
          border: border,
        ),
        initialCountryCode: 'GB',
        keyboardType: TextInputType.number,
        onChanged: widget.onChange!,
      ),
    );
  }
}
