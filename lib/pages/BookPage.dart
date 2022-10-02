import 'package:flutter/material.dart';
import 'package:fuzzy/fuzzy.dart';
import '../shared.dart';

class BookPage extends StatelessWidget {
  const BookPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (sharedState.selectedBook == null) {
      Navigator.pushNamed(context, '/books');
    }

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
          child: FutureBuilder(
            future: sharedState.fetchCharacters(context),
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
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)));
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
  State<CharacterList> createState() =>
      _CharacterListState(characters: characters);
}

class _CharacterListState extends State<CharacterList> {
  String query = '';
  TextEditingController searchController = TextEditingController();

  final List<Character> characters;
  Fuzzy<Character>? _fuse;

  _CharacterListState({required this.characters});

  Fuzzy<Character> getFuse() {
    return _fuse ??= Fuzzy(
      characters,
      options: FuzzyOptions(
        distance: 2,
        keys: [
          WeightedKey(
            name: 'name',
            getter: (c) => c.name,
            weight: 0.1,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<ListTile> characterListTiles = getFuse()
        .search(query)
        .map(
          (result) => ListTile(
              title: Text(result.item.name),
              onTap: () {
                sharedState.setCharacter(result.item);
                Navigator.pushNamed(context, '/character');
              }),
        )
        .toList();

    if (characterListTiles.isEmpty) {
      characterListTiles.add(ListTile(
        title: Text('No characters found matching "${query}"',
            style: TextStyle(fontStyle: FontStyle.italic)),
      ));
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: searchField(),
        ),
        Expanded(
          child: ListView(shrinkWrap: true, children: characterListTiles),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: ElevatedButton.icon(
              icon: const Icon(Icons.arrow_back),
              label: const Text('Back to Book List'),
              onPressed: () {
                sharedState.setCharacter(null).setBook(null);
                Navigator.pushNamed(context, '/books');
              }),
        ),
      ],
    );
  }

  Widget searchField() {
    Widget? clearIcon = query != null && query.length > 0
        ? IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              searchController.clear();
              setState(() => query = '');
            },
            hoverColor: Colors.transparent,
            focusColor: Colors.transparent,
            splashColor: Colors.transparent,
          )
        : null;

    return TextField(
      restorationId: 'characterSearch',
      maxLines: 1,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.search),
        suffixIcon: clearIcon,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32)),
        hintText: 'Search for a Character',
        hintMaxLines: 1,
        errorMaxLines: 1,
        helperMaxLines: 1,
      ),
      onChanged: (value) => setState(() => query = value),
      controller: searchController,
    );
  }
}
