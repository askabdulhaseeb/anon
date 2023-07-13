import 'package:flutter/material.dart';
import 'package:flutter_parsed_text/flutter_parsed_text.dart';
import 'package:url_launcher/url_launcher.dart';

class ParsedTextWidget extends StatelessWidget {
  const ParsedTextWidget(this.text, {super.key});
  final String text;

  @override
  Widget build(BuildContext context) {
    return ParsedText(
      text: text,
      parse: <MatchText>[
        MatchText(
          type: ParsedType.EMAIL,
          style: const TextStyle(color: Colors.red),
          onTap: (String url) => _launchUrl(url, type: ParsedType.EMAIL),
        ),
        MatchText(
          type: ParsedType.URL,
          style: const TextStyle(
            color: Colors.blue,
            decoration: TextDecoration.underline,
          ),
          onTap: (String url) => _launchUrl(url, type: ParsedType.URL),
        ),
        MatchText(
          type: ParsedType.PHONE,
          style: const TextStyle(color: Colors.blue),
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
