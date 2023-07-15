enum MyHiveType {
  user(1, 'dm-users'),
  agency(2, 'dm-agencies'),
  project(3, 'dm-projects'),
  chat(4, 'dm-chats'),
  message(5, 'dm-messages'),
  unseenMessage(5, 'dm-unseen-messages'),
  board(6, 'dm-boards');

  const MyHiveType(this.hiveTypeNumber, this.database);
  final int hiveTypeNumber;
  final String database;
}
