import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'show_loading.dart';

class CustomNetworkImage extends StatelessWidget {
  const CustomNetworkImage({
    required this.imageURL,
    this.placeholder,
    this.placeholderBgColor,
    this.size,
    this.fit = BoxFit.cover,
    this.timeLimit = const Duration(days: 2),
    Key? key,
  }) : super(key: key);
  final String imageURL;
  final double? size;
  final BoxFit? fit;
  final String? placeholder;
  final Color? placeholderBgColor;
  final Duration? timeLimit;

  @override
  Widget build(BuildContext context) {
    Container container = Container(
      color: placeholderBgColor ?? Theme.of(context).primaryColor,
      padding: const EdgeInsets.all(12),
      child: FittedBox(
        child: Text(
          placeholder!.substring(0, 2).toUpperCase(),
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
    return imageURL.isEmpty
        ? SizedBox(
            height: size,
            width: size,
            child: container,
          )
        : CachedNetworkImage(
            height: size,
            width: size,
            imageUrl: imageURL,
            fit: fit,
            placeholder: (BuildContext context, String url) =>
                const ShowLoading(),
            errorWidget: (BuildContext context, String url, _) {
              return placeholder != null ? container : const Icon(Icons.error);
            },
          );
  }
}
