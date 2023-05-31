class Agency {
  Agency({
    required this.agencyID,
    required this.name,
    required this.username,
    required this.shortID,
    required this.websiteURL,
  });

  final String agencyID;
  final String name;
  final String username;
  final String shortID;
  final String websiteURL;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'agency_id': agencyID,
      'name': name,
      'username': username,
      'short_id': shortID,
      'website_url': websiteURL,
    };
  }

  // ignore: sort_constructors_first
  factory Agency.fromMap(Map<String, dynamic> map) {
    return Agency(
      agencyID: map['agency_id'] as String,
      name: map['name'] as String,
      username: map['username'] as String,
      shortID: map['short_id'] as String,
      websiteURL: map['website_url'] as String,
    );
  }
}
