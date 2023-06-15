import 'package:flutter/material.dart';

import '../../models/project/attachment.dart';
import '../../widgets/custom/custom_network_image.dart';

class MessageMediaFullScreen extends StatelessWidget {
  const MessageMediaFullScreen({Key? key}) : super(key: key);
  static const String routeName = 'message-media-full-display';
  @override
  Widget build(BuildContext context) {
    final List<Attachment> attachments =
        ModalRoute.of(context)!.settings.arguments as List<Attachment>;
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Attachment', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.black26,
        elevation: 0,
      ),
      body: Center(
        child: ListView.builder(
          shrinkWrap: true,
          primary: false,
          scrollDirection: Axis.horizontal,
          itemCount: attachments.length,
          itemBuilder: (BuildContext context, int index) {
            return SizedBox(
              width: size.width,
              height: size.height,
              child: CustomNetworkImage(
                imageURL: attachments[index].url,
                fit: BoxFit.contain,
              ),
            );
          },
        ),
      ),
    );
  }
}
