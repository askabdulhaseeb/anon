import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import 'show_loading.dart';

class CustomVideoPlayer extends StatefulWidget {
  const CustomVideoPlayer({
    required this.path,
    this.isFileVideo = false,
    this.isPlay = false,
    this.isMute = true,
    this.isOnLoop = false,
    Key? key,
  }) : super(key: key);
  final String path;
  final bool isFileVideo;
  final bool isPlay;
  final bool isMute;
  final bool isOnLoop;
  @override
  State<CustomVideoPlayer> createState() => _CustomVideoPlayerState();
}

class _CustomVideoPlayerState extends State<CustomVideoPlayer> {
  late VideoPlayerController controller;
  @override
  void initState() {
    super.initState();
    _init();
  }

  _init() async {
    controller = widget.isFileVideo
        ? VideoPlayerController.file(File(widget.path))
        : VideoPlayerController.network(widget.path);
    await controller.initialize().then((_) {
      widget.isPlay ? controller.play() : controller.pause();
      controller.setVolume(widget.isMute ? 0 : 1);
      controller.setLooping(widget.isOnLoop);
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: controller.value.aspectRatio,
      child: controller.value.isInitialized
          ? VideoPlayer(controller)
          : const ShowLoading(),
    );
  }
}
