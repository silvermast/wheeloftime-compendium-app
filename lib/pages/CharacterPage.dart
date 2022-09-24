import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../shared.dart';

class CharacterPage extends StatefulWidget {
  const CharacterPage({Key? key}) : super(key: key);

  @override
  State<CharacterPage> createState() => _CharacterPageState();
}

class _CharacterPageState extends State<CharacterPage> {
  @override
  Widget build(BuildContext context) {
    if (sharedState.selectedBook == null) {
      Navigator.pushNamed(context, '/books');
    }
    if (sharedState.selectedCharacter == null) {
      Navigator.pushNamed(context, '/book');
    }

    Character character = sharedState.selectedCharacter as Character;
    Book book = sharedState.selectedBook as Book;

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(book.title),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.settings),
              tooltip: 'Settings',
              onPressed: () => Navigator.pushNamed(context, '/settings'),
            ),
          ],
        ),
        body: Container(
            padding: bodyPadding,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0, top: 16.0),
                  child: Text(
                    character.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                ),
                Expanded(
                  child: Markdown(
                      shrinkWrap: true,
                      data: character.info,
                      selectable: true,
                      styleSheet: MarkdownStyleSheet(
                        p: const TextStyle(
                          fontSize: 16.0,
                          height: 1.8,
                        ),
                      ),
                      onTapLink: (text, String? href, title) {
                        sharedState.setCharacterFromLink(href);
                        Navigator.pushNamed(context, '/character');
                      }),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: ElevatedButton.icon(
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('Back to Character List'),
                      onPressed: () {
                        sharedState.setCharacter(null);
                        Navigator.pushNamed(context, '/book');
                      }),
                ),
              ],
            )));
  }

  // Character? findCharacter(Book book, String? href) {
  //   if (href == null) {
  //     return null;
  //   }
  //   return book.
  // }
}
