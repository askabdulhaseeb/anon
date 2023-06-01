import 'package:flutter/material.dart';

import '../../enums/user/user_type.dart';

class UserTypeSelectionWidget extends StatefulWidget {
  const UserTypeSelectionWidget({
    required this.initType,
    required this.onSwitch,
    super.key,
  });
  final UserType initType;
  final void Function(UserType?) onSwitch;

  @override
  State<UserTypeSelectionWidget> createState() =>
      _UserTypeSelectionWidgetState();
}

class _UserTypeSelectionWidgetState extends State<UserTypeSelectionWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: RadioListTile<UserType>(
            value: UserType.user,
            title: Text(UserType.user.title),
            groupValue: widget.initType,
            onChanged: widget.onSwitch,
          ),
        ),
        Expanded(
          child: RadioListTile<UserType>(
            value: UserType.client,
            title: Text(UserType.client.title),
            groupValue: widget.initType,
            onChanged: widget.onSwitch,
          ),
        ),
      ],
    );
  }
}
