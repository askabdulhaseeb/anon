import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../functions/helping_funcation.dart';
import '../../models/user/app_user.dart';

class CustomProfilePhoto extends StatelessWidget {
  const CustomProfilePhoto(
    this.user, {
    this.fit = BoxFit.cover,
    this.size = 22,
    super.key,
  });
  final AppUser user;
  final double size;
  final BoxFit? fit;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: size,
      backgroundColor: Color(user.defaultColor),
      backgroundImage: user.imageURL.isEmpty
          ? null
          : CachedNetworkImageProvider(user.imageURL),
      child: user.imageURL.isEmpty ? _placeholder() : null,
    );
  }

  Widget _placeholder() {
    return SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: FittedBox(
          child: Text(
            HelpingFuncation().photoPlaceholder(user.name.toUpperCase()),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
