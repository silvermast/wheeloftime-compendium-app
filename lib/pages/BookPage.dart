import 'dart:convert';
import 'dart:html';

import 'package:flutter/material.dart';
import '../shared.dart';
import '../repo.dart';

class BookPage extends StatelessWidget {
  const BookPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Book book;
    try {
      book = ModalRoute.of(context)!.settings.arguments as Book;
    } catch (e) {
      return renderError(context, 'No book selected.');
    }
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
          child: FutureBuilder(
            future: Repo.fetchCharacters(context, book),
            builder: (BuildContext context,
                AsyncSnapshot<List<Character>> snapshot) {
              if (snapshot.hasError) {
                return renderError(
                    context, 'Failed to load data: ${snapshot.error}');
              } else if (snapshot.hasData) {
                return renderData(context, snapshot.data);
              } else {
                return renderLoader(context);
              }
            },
          ),
        ));
  }

  Widget renderLoader(BuildContext context) {
    return Center(
      child: Text('Loading book. Please wait.'),
    );
  }

  Widget renderError(BuildContext context, String errorText) {
    return Center(
      child: Text(errorText,
        style: TextStyle(
          color: Colors.red, fontWeight: FontWeight.bold
        )
      )
    );
  }

  Widget renderData(BuildContext context, List<Character>? characters) {
    if (characters == null) {
      return renderError(context, 'Failed to parse data');
    }
    return CharacterList(characters: characters);
  }
}

class CharacterList extends StatefulWidget {
  final List<Character> characters;
  const CharacterList({Key? key, required this.characters}) : super(key: key);

  @override
  State<CharacterList> createState() => _CharacterListState(characters: characters);
}

class _CharacterListState extends State<CharacterList> {
  String query = '';
  final List<Character> characters;
  _CharacterListState({required this.characters});

  @override
  Widget build(BuildContext context) {
    
    String queryLower = query.toLowerCase();

    List<ListTile> characterListTiles = characters
        .where((character) => character.name.toLowerCase().contains(queryLower))
        .map((character) => ListTile(
          title: Text(character.name),
          onTap: () => Navigator.pushNamed(context, '/character', arguments: character),
        ))
        .toList();

    return Column(
      children: [
        TextField(
          maxLines: 1,
          decoration: InputDecoration(
            label: Icon(Icons.search),
            hintText: 'Search for a Character',
            hintMaxLines: 1,
            errorMaxLines: 1,
            helperMaxLines: 1,
          ),
          onChanged: (value) => setState(() => query = value),
        ),
        Expanded(
          child: ListView(
            shrinkWrap: true,
            children: characterListTiles
          ),
        ),
      ],
    );
  }
}