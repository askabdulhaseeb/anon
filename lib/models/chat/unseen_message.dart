import 'package:hive_flutter/hive_flutter.dart';
import 'message.dart';
part 'unseen_message.g.dart';

@HiveType(typeId: 46)
class UnseenMessage extends HiveObject {
  UnseenMessage({
    required this.projectID,
    required this.chatID,
    required this.lastMessageAdded,
    required this.unseenMessages,
  });

  @HiveField(0)
  final String projectID;
  @HiveField(1)
  final String chatID;
  @HiveField(2)
  DateTime lastMessageAdded;
  @HiveField(3)
  final List<Message> unseenMessages;

  addMessge(Message value) {
    unseenMessages.add(value);
    unseenMessages
        .sort((Message a, Message b) => a.timestamp.compareTo(b.timestamp));
    lastMessageAdded = DateTime.now();
  }
}
