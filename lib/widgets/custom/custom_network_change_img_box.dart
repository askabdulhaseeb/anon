import 'dart:io';

import 'package:flutter/material.dart';

import '../../utilities/app_images.dart';

class CustomNetworkChangeImageBox extends StatelessWidget {
  const CustomNetworkChangeImageBox({
    required this.onTap,
    this.isDisable = false,
    this.file,
    this.url,
    this.title = 'Upload Image',
    this.size = 40,
    Key? key,
  }) : super(key: key);
  final String? url;
  final File? file;
  final bool isDisable;
  final String title;
  final VoidCallback onTap;
  final double size;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isDisable ? null : onTap,
      child: Center(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 80,
              width: 80,
              child: file != null
                  ? Image.file(file!)
                  : url == null || url == ''
                      ? Image.asset(AppImages.uploadImageIcon)
                      : Image.network(url!, fit: BoxFit.cover),
            ),
            TextButton(
              onPressed: isDisable ? null : onTap,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.all(0),
              ),
              child: Text(title, style: const TextStyle(height: 1)),
            ),
          ],
        ),
      ),
    );
  }
}
