import 'package:flutter/material.dart';
import 'package:flutter_parsed_text/flutter_parsed_text.dart';
import 'package:url_launcher/url_launcher.dart';

class ParsedTextWidget extends StatelessWidget {
  const ParsedTextWidget(this.text, {this.isMe = false, super.key});
  final String text;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return ParsedText(
      text: text,
      selectable: true,
      textWidthBasis: TextWidthBasis.parent,
      style: isMe ? const TextStyle(color: Colors.black) : null,
      textScaleFactor: 0.5,
      parse: <MatchText>[
        MatchText(
          type: ParsedType.EMAIL,
          style: const TextStyle(color: Color(0xFF3866FF)),
          onTap: (String url) => _launchUrl(url, type: ParsedType.EMAIL),
        ),
        MatchText(
          type: ParsedType.URL,
          style: const TextStyle(color: Color(0xFF3866FF)),
          onTap: (String url) => _launchUrl(url, type: ParsedType.URL),
        ),
        MatchText(
          type: ParsedType.PHONE,
          style: const TextStyle(color: Color(0xFF3866FF)),
          onTap: (String url) => _launchUrl(url, type: ParsedType.PHONE),
        ),
      ],
    );
  }
}

Future<void> _launchUrl(String url, {required ParsedType type}) async {
  switch (type) {
    case ParsedType.EMAIL:
      url = 'mailto:$url?subject=News&body=New';
      break;
    case ParsedType.PHONE:
      url = 'tel:$url';
      break;
    default:
  }
  if (!await launchUrl(Uri.parse(url))) {
    throw Exception('Could not launch $url');
  }
}
