import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/card_display_provider.dart';

class TaskCardQuickActionButtonsWidget extends StatelessWidget {
  const TaskCardQuickActionButtonsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            'Quick Action',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Row(
            children: <Widget>[
              Expanded(
                child: _Button(
                  icon: Icons.playlist_add_check_outlined,
                  title: 'Add Checklist',
                  onTap: () async => await Provider.of<CardDisplayProvider>(
                          context,
                          listen: false)
                      .onCreateChecklist(context),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _Button(
                  icon: Icons.attachment,
                  title: 'Add Attachment',
                  onTap: () {},
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: <Widget>[
              Expanded(
                child: _Button(
                  icon: CupertinoIcons.person,
                  title: 'Members',
                  onTap: () async => await Provider.of<CardDisplayProvider>(
                          context,
                          listen: false)
                      .onAssignTo(context),
                ),
              ),
              const SizedBox(width: 8),
              const Expanded(child: SizedBox()),
            ],
          ),
        ],
      ),
    );
  }
}

class _Button extends StatelessWidget {
  const _Button({
    required this.icon,
    required this.title,
    required this.onTap,
  });
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Theme.of(context).disabledColor,
        ),
        child: Row(
          children: <Widget>[
            Icon(icon),
            const SizedBox(width: 12),
            Text(title),
          ],
        ),
      ),
    );
  }
}
