import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/board/check_item.dart';
import '../../../models/board/check_list.dart';
import '../../../models/board/task_card.dart';
import '../../../providers/card_display_provider.dart';
import '../../../widgets/board/card/checklist/checklist_lists_display_widget.dart';
import '../../../widgets/board/card/task_card_detail_app_bar.dart';
import '../../../widgets/board/card/task_card_list_info_widget.dart';
import '../../../widgets/board/card/task_card_quick_action_buttons.dart';
import '../../../widgets/custom/parsed_text_widget.dart';

class TaskCardDetailScreen extends StatelessWidget {
  const TaskCardDetailScreen({Key? key}) : super(key: key);
  static const String routeName = '/task-card-detail';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Theme.of(context).disabledColor,
        elevation: 1,
        leading: Consumer<CardDisplayProvider>(
            builder: (BuildContext context, CardDisplayProvider cardPro, _) {
          final bool needUpdate = cardPro.needUpdate;
          return Row(
            children: needUpdate
                ? <Widget>[
                    TextButton(
                      onPressed: () async =>
                          await cardPro.onSaveChanges(context),
                      child: const Text(
                        'Save',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () async => await cardPro.reset(context),
                      child: const Text(
                        '''Don't Save''',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ]
                : <Widget>[
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(CupertinoIcons.clear),
                    ),
                  ],
          );
        }),
        leadingWidth: double.infinity,
      ),
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Consumer<CardDisplayProvider>(
            builder: (BuildContext context, CardDisplayProvider cardPro, _) {
          final TaskCard card = cardPro.card;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TaskCardDetailAppBar(card),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: InkWell(
                  onTap: () async => await cardPro.onTitleUpdate(context),
                  child: Text(
                    card.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              TaskCardListInfoWidget(card: card),
              const Divider(height: 16, thickness: 0.1),
              const TaskCardQuickActionButtonsWidget(),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                margin: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: Theme.of(context).disabledColor,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        const Text(
                          'Description',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton.icon(
                            onPressed: () =>
                                cardPro.onDescriptionUpdate(context),
                            icon: const Icon(Icons.format_align_left_rounded),
                            label: const Text('Edit'),
                          ),
                        ),
                      ],
                    ),
                    ParsedTextWidget(card.description),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: () => cardPro.onCreateChecklist(context),
                  icon: const Icon(Icons.playlist_add_check_sharp),
                  label: const Text('Add Checklist'),
                ),
              ),
              ChecklistListsDisplayWidget(
                card,
                onChange: (
                  CheckList v,
                  CheckItem item,
                  DocumentChangeType type,
                ) =>
                    cardPro.onChecklistItemUpdate(v, item, type),
              ),
              const SizedBox(height: 200),
            ],
          );
        }),
      ),
    );
  }
}
