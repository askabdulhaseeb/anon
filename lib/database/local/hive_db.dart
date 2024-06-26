import 'dart:io';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

import '../../enums/attachment_type.dart';
import '../../enums/chat/chat_member_role.dart';
import '../../enums/chat/message_type.dart';
import '../../enums/project/milestone_history_type.dart';
import '../../enums/project/milestone_status.dart';
import '../../enums/user/auth_type.dart';
import '../../enums/user/user_designation.dart';
import '../../enums/user/user_type.dart';
import '../../models/agency/agency.dart';
import '../../models/agency/member_detail.dart';
import '../../models/board/board.dart';
import '../../models/board/board_member.dart';
import '../../models/board/check_item.dart';
import '../../models/board/check_list.dart';
import '../../models/board/task_card.dart';
import '../../models/board/task_list.dart';
import '../../models/chat/chat.dart';
import '../../models/chat/chat_group_member.dart';
import '../../models/chat/message.dart';
import '../../models/chat/message_read_info.dart';
import '../../models/chat/unseen_message.dart';
import '../../models/project/attachment.dart';
import '../../models/project/milestone.dart';
import '../../models/project/milestone_history.dart';
import '../../models/project/note.dart';
import '../../models/project/project.dart';
import '../../models/user/app_user.dart';
import '../../models/user/device_token.dart';
import '../../models/user/number_detail.dart';
import 'board/local_board.dart';
import 'board/local_task_card.dart';
import 'board/local_task_list.dart';
import 'local_agency.dart';
import 'local_chat.dart';
import 'local_data.dart';
import 'local_message.dart';
import 'local_project.dart';
import 'local_unseen_message.dart';
import 'local_user.dart';

class HiveDB {
  Future<void> init() async {
    Directory directory = await getApplicationDocumentsDirectory();
    Hive.init(directory.path);
    await LocalData.init();
    await Hive.initFlutter(directory.path);
    //
    // Type: User 1
    Hive.registerAdapter(AppUserAdapter()); // 1
    Hive.registerAdapter(UserTypeAdapter()); // 12
    Hive.registerAdapter(AuthTypeAdapter()); // 13
    Hive.registerAdapter(NumberDetailsAdapter()); // 14
    Hive.registerAdapter(MyDeviceTokenAdapter()); // 15
    //
    // Type: Agency 2
    Hive.registerAdapter(AgencyAdapter()); // 2
    Hive.registerAdapter(MemberDetailAdapter()); // 20
    Hive.registerAdapter(UserDesignationAdapter()); // 200
    //
    // Type: Project 3
    Hive.registerAdapter(ProjectAdapter()); // 3
    Hive.registerAdapter(NoteAdapter()); // 31
    Hive.registerAdapter(AttachmentAdapter()); // 32
    Hive.registerAdapter(AttachmentTypeAdapter()); // 33
    Hive.registerAdapter(MilestoneAdapter()); // 34
    Hive.registerAdapter(MilestoneHistoryAdapter()); // 35
    Hive.registerAdapter(MilestoneHistoryTypeAdapter()); // 36
    Hive.registerAdapter(MilestoneStatusAdapter()); // 37
    //
    // Type: Chat 4
    Hive.registerAdapter(ChatAdapter()); // 4
    Hive.registerAdapter(ChatMemberAdapter()); // 41
    Hive.registerAdapter(MessageAdapter()); // 42
    Hive.registerAdapter(ChatMemberRoleAdapter()); // 43
    Hive.registerAdapter(MessageTypeAdapter()); // 44
    Hive.registerAdapter(MessageReadInfoAdapter()); // 45
    Hive.registerAdapter(UnseenMessageAdapter()); // 46
    //
    // Type: Chat 6
    Hive.registerAdapter(BoardAdapter()); // 60
    Hive.registerAdapter(BoardMemberAdapter()); // 61
    Hive.registerAdapter(TaskListAdapter()); // 62
    Hive.registerAdapter(TaskCardAdapter()); // 63
    Hive.registerAdapter(CheckListAdapter()); // 64
    Hive.registerAdapter(CheckItemAdapter()); // 65

    //
    // Open Boxes
    await LocalUser.openBox;
    await LocalAgency.openBox;
    await LocalProject.openBox;
    await LocalChat.openBox;
    await LocalMessage.openBox;
    await LocalUnseenMessage.openBox;
    await LocalBoard.openBox;
    await LocalTaskList.openBox;
    await LocalTaskCard.openBox;
  }

  Future<void> signOut() async {
    await LocalData.signout();
    await LocalUser().signOut();
    await LocalAgency().signOut();
    await LocalProject().signOut();
    await LocalChat().signOut();
    await LocalMessage().signOut();
    await LocalUnseenMessage().signOut();
    await LocalBoard().signOut();
    await LocalTaskList().signOut();
    await LocalTaskCard().signOut();
  }
}
