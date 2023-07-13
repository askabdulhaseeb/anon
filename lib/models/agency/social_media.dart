import '../../enums/social_type.dart';

class SocialMedia {
  SocialMedia({required this.type, required this.link});

  final SocialMediaType type;
  final String link;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'type': type,
      'link': link,
    };
  }

  // ignore: sort_constructors_first
  factory SocialMedia.fromMap(Map<String, dynamic> map) {
    return SocialMedia(
      type: SocialMediaTypeCovertor()
          .toEnum(map['type'] ?? SocialMediaType.website.json),
      link: map['link'] ?? '',
    );
  }
}
