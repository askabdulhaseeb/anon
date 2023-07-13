import '../utilities/app_images.dart';

enum SocialMediaType {
  behance('behance', 'Behance', AppImages.behance),
  facebook('facebook', 'Facebook', AppImages.facebook),
  google('google', 'Google', AppImages.google),
  instagram('instagram', 'Instagram', AppImages.instagram),
  linkedIn('linkedIn', 'LinkedIn', AppImages.linkedIn),
  website('website', 'Website', AppImages.website),
  whatsapp('whatsapp', 'Whatsapp', AppImages.whatsapp);

  const SocialMediaType(this.json, this.title, this.path);
  final String json;
  final String title;
  final String path;
}

class SocialMediaTypeCovertor {
  SocialMediaType toEnum(String type) {
    switch (type) {
      case 'behance':
        return SocialMediaType.behance;
      case 'facebook':
        return SocialMediaType.facebook;
      case 'google':
        return SocialMediaType.google;
      case 'instagram':
        return SocialMediaType.instagram;
      case 'linkedIn':
        return SocialMediaType.linkedIn;
      case 'website':
        return SocialMediaType.website;
      case 'whatsapp':
        return SocialMediaType.whatsapp;
      default:
        return SocialMediaType.website;
    }
  }
}
