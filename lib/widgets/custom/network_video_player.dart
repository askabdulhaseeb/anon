import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import 'show_loading.dart';

class NetworkVideoPlayer extends StatefulWidget {
  const NetworkVideoPlayer({
    required this.url,
    this.isPlay = false,
    this.isMute = true,
    this.isOnLoop = false,
    Key? key,
  }) : super(key: key);
  final String url;
  final bool isPlay;
  final bool isMute;
  final bool isOnLoop;
  @override
  State<NetworkVideoPlayer> createState() => _NetworkVideoPlayerState();
}

class _NetworkVideoPlayerState extends State<NetworkVideoPlayer> {
  late VideoPlayerController controller;
  @override
  void initState() {
    super.initState();
    _init();
  }

  _init() async {
    controller = VideoPlayerController.network(widget.url);
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