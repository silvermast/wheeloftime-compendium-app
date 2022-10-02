import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../shared.dart';

const String markdownContent = '## Special thanks:\n'
    '- [Karl Hammond\'s Compendium of Wheel of Time Characters](https://hammonkd.github.io/WoT-compendium)\n'
    '- [The /r/wot Subreddit](https://reddit.com/r/wot)\n'
    '- Everyone who has reported a spoiler\n'
    '\n'
    '## Found a spoiler?\n'
    'If you find a spoiler, I\'d love to know! Please report it to [jason@silvermast.io](mailto:jason@silvermast.io).\n';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Information'),
        centerTitle: true,
      ),
      body: Container(
        padding: bodyPadding,
        // TODO: Add markdown or richtext formatting
        child: Markdown(
          data: markdownContent,
          onTapLink: (text, href, title) => openLink(href),
        ),
      ),
    );
  }

  void openLink(String? href) {
    if (href == null) {
      return null;
    }
    launchUrlString(href);
  }
}
