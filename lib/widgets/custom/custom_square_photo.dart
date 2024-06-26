import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../functions/helping_funcation.dart';
import 'show_loading.dart';

class CustomSquarePhoto extends StatelessWidget {
  const CustomSquarePhoto(
    this.url, {
    required this.name,
    required this.defaultColor,
    this.fit = BoxFit.cover,
    this.size = 44,
    super.key,
  });
  final String? url;
  final String name;
  final int defaultColor;
  final double size;
  final BoxFit? fit;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: Container(
        height: size + 2,
        width: size + 2,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: Color(defaultColor),
        ),
        child: url == null || (url?.isEmpty ?? true)
            ? _placeholder()
            : CachedNetworkImage(
                height: size,
                width: size,
                imageUrl: url!,
                fit: fit,
                placeholder: (BuildContext context, String url) =>
                    const ShowLoading(),
                errorWidget: (BuildContext context, String url, _) =>
                    _placeholder(),
              ),
      ),
    );
  }

  Container _placeholder() {
    return Container(
      height: size,
      width: size,
      padding: EdgeInsets.all(size / 8),
      color: Color(defaultColor),
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
