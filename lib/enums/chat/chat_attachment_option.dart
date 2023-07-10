import 'package:flutter/cupertino.dart';

import '../../utilities/app_images.dart';

enum ChatAttachmentOption {
  camera('Camera', Color(0xffF0ECF8), AppImages.cameraIcon),
  gallery('Gallery', Color(0xffEAF7F0), AppImages.galleryIcon),
  document('NULL', Color(0xffEAF6FC), AppImages.documentIcon);

  const ChatAttachmentOption(this.title, this.bgColor, this.path);
  final String title;
  final Color bgColor;
  final String path;
}
