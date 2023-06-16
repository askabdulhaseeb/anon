import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../functions/helping_funcation.dart';

class CustomProfilePhoto extends StatelessWidget {
  const CustomProfilePhoto(
    this.url, {
    required this.name,
    this.fit = BoxFit.cover,
    this.size = 22,
    super.key,
  });
  final String? url;
  final String name;
  final double size;
  final BoxFit? fit;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: size,
      backgroundColor: Theme.of(context).disabledColor,
      backgroundImage: url == null || (url?.isEmpty ?? true)
          ? null
          : CachedNetworkImageProvider(url!),
      child: url == null || (url?.isEmpty ?? true) ? _placeholder() : null,
    );
  }

  Widget _placeholder() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: FittedBox(
        child: Text(
          HelpingFuncation().photoPlaceholder(name.toUpperCase()),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
