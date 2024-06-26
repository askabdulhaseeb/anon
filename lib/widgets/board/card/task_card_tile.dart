import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/board/check_item.dart';
import '../../../models/board/check_list.dart';
import '../../../models/board/task_card.dart';
import '../../../providers/card_display_provider.dart';
import '../../../views/board_screens/card/task_card_detail_screen.dart';
import '../../custom/custom_network_image.dart';
import '../../user/multi_user_display_widget.dart';

class TaskCardTile extends StatelessWidget {
  const TaskCardTile(this.card, {super.key});
  final TaskCard card;

  @override
  Widget build(BuildContext context) {
    return Draggable<TaskCard>(
      childWhenDragging: const SizedBox(),
      feedback: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Material(
          child: SizedBox(
            width: 300,
            child: Opacity(opacity: 0.8, child: _Card(card: card)),
          ),
        ),
      ),
      child: InkWell(
        onTap: () {
          Provider.of<CardDisplayProvider>(context, listen: false)
              .setCard(card);
          Navigator.of(context).pushNamed(TaskCardDetailScreen.routeName);
        },
        child: _Card(card: card),
      ),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.card});
  final TaskCard card;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (card.attachments.isNotEmpty)
            AspectRatio(
              aspectRatio: 1 / 1,
              child: CustomNetworkImage(imageURL: card.attachments[0].url),
            ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  card.title,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                Row(
                  children: <Widget>[
                    if (card.description.isNotEmpty)
                      const _IconAndCount(
                        icon: Icons.format_align_left_outlined,
                        count: '',
                      ),
                    if (card.attachments.isNotEmpty)
                      _IconAndCount(
                        icon: Icons.attachment,
                        count: card.attachments.length.toString(),
                      ),
                    if (card.checklists.isNotEmpty)
                      _IconAndCount(
                        icon: Icons.playlist_add_check_sharp,
                        count: _checklistCount(),
                      ),
                    const Spacer(),
                    if (card.assignTo.isNotEmpty)
                      MultiUserDisplayWidget(
                        card.assignTo,
                        maxWidth: 100,
                        size: 16,
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _checklistCount() {
    int total = 0;
    int checked = 0;
    for (CheckList list in card.checklists) {
      total += list.items.length;
      checked += list.items.where((CheckItem e) => e.isChecked).length;
    }
    return '$checked/$total';
  }
}

class _IconAndCount extends StatelessWidget {
  const _IconAndCount({
    required this.icon,
    required this.count,
  });

  final IconData icon;
  final String count;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Icon(icon, color: Colors.grey, size: 20),
        const SizedBox(width: 4),
        Text(
          count,
          style: const TextStyle(color: Colors.grey),
        ),
        const SizedBox(width: 8),
      ],
    );
  }
}
