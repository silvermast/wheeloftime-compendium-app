import 'package:flutter_markdown/flutter_markdown.dart';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../shared.dart';
import '../settingsService.dart';

const String markdownSpecialThanks = '''
## Special thanks
- [Karl Hammond's Compendium of Wheel of Time Characters](https://hammondkd.github.io/WoT-compendium/)
- [The /r/wot Subreddit](https://reddit.com/r/wot)
- Everyone who has reported a spoiler
''';

const String markdownFoundASpoiler = '''
## Found a spoiler?
If you find a spoiler, I'd love to know! Please report it to [wot-spoilers@silvermast.io](mailto:wot-spoilers@silvermast.io).
''';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final SettingsService settings = SettingsService.instance;
  bool _rememberLastSelectedBook = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: ListView(
        padding: bodyPadding,
        children: [
          _buildCard(
            child: CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Remember last selected book'),
              subtitle: const Text(
                'When opening the app you will automatically jump to the last book you selected.',
              ),
              value: _rememberLastSelectedBook,
              onChanged: (bool? rememberLastBook) {
                setState(() => _rememberLastSelectedBook = rememberLastBook ?? false);
                settings.setRememberLastSelectedBook(rememberLastBook ?? false);
              },
            ),
          ),

          // TODO: Add markdown or richtext formatting
          const SizedBox(height: 24),
          _buildCard(child: MarkdownBody(
            data: markdownSpecialThanks,
            onTapLink: (text, href, title) => _openLink(href),
          )),

          const SizedBox(height: 24),
          _buildCard(child: MarkdownBody(
            data: markdownFoundASpoiler,
            onTapLink: (text, href, title) => _openLink(href),
          )),
        ],
      ),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: child,
      ),
    );
  }

  Future<void> _loadSettings() async {
    bool remember = await settings.getRememberLastSelectedBook();
    setState(() {
      _rememberLastSelectedBook = remember;
    });
  }

  void _openLink(String? href) {
    if (href == null) {
      return null;
    }
    launchUrlString(href);
  }
}
