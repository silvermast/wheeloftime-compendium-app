import 'package:url_launcher/url_launcher.dart';

import 'package:flutter/material.dart';
import '../shared.dart';

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
        child: Flexible(
            child: Row(children: [
          const Text('Special thanks to '),
          InkWell(
              child: const Text(
                  'Karl Hammond\'s Compendium of Wheel of Time Characters'),
              onTap: () => launchUrl(
                  Uri.https('hammondkd.github.io', '/WoT-compendium'))),
          const Text(' and the /r/wot subreddit!')
        ])),
      ),
    );
  }
}