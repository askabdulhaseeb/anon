enum MyHiveType {
  user(1, 'dm-users'),
  agency(2, 'dm-agencies');

  const MyHiveType(this.hiveTypeNumber, this.database);
  final int hiveTypeNumber;
  final String database;
}
