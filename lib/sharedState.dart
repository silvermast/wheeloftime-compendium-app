import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/widgets.dart';
import 'shared.dart';

class SharedState {
  BuildContext? context;
  Book? selectedBook;
  Character? selectedCharacter;
  List<Character> characters = [];
  final List<Book> books = [
    Book('00', "New Spring"),
    Book('01', "The Eye of the World"),
    Book('02', "The Great Hunt"),
    Book('03', "The Dragon Reborn"),
    Book('04', "The Shadow Rising"),
    Book('05', "The Fires of Heaven"),
    Book('06', "Lord of Chaos"),
    Book('07', "A Crown of Swords"),
    Book('08', "The Path of Daggers"),
    Book('09', "Winter's Heart"),
    Book('10', "Crossroads of Twilight"),
    Book('11', "Knife of Dreams"),
    Book('12', "The Gathering Storm"),
    Book('13', "Towers of Midnight"),
    Book('14', "A Memory of Light"),
  ];

  SharedState reset() {
    characters = [];
    selectedBook = null;
    selectedCharacter = null;
    return this;
  }

  SharedState setBook(Book? book) {
    selectedBook = book;
    characters = [];
    return this;
  }

  SharedState setCharacter(Character? character) {
    selectedCharacter = character;
    return this;
  }

  SharedState setCharacterFromLink(String? href) {
    if (href == null) {
      throw Error();
    }
    String? characterId = href.replaceFirst('#', '');
    selectedCharacter = characters.firstWhere((c) => c.id == characterId);
    return this;
  }

  Future<List<Character>> fetchCharacters(BuildContext context) async {
    if (selectedBook == null) {
      throw Error();
    }
    if (characters.isNotEmpty) {
      return characters;
    }

    String? bookId = selectedBook?.id.padLeft(2, '0');
    String remoteUrl = 'https://wheeloftime.silvermast.io/v2/data/book-${bookId}.json';
    String localUrl = 'assets/data/book-${bookId}.json';
    String data;

    try {
      print('HTTPS GET $remoteUrl');
      var response = await http.get(Uri.parse(remoteUrl));
      print('HTTPS Status: ${response.statusCode}');
      if (response.statusCode != 200) {
        throw new Exception('Failed to pull $remoteUrl: ${response.statusCode}');
      }
      data = utf8.decode(response.bodyBytes);
    } catch (error) {
      print(error.toString());
      print('Loading data from $localUrl');
      data = await DefaultAssetBundle.of(context).loadString(localUrl, cache: false);
    }

    characters = [];
    jsonDecode(data).forEach((item) {
      characters.add(Character(
        id: item['id'],
        name: item['name'],
        chapter: item['chapter'],
        info: item['info'],
      ));
    });

    characters.sort((a, b) => a.name.compareTo(b.name));

    return characters;
  }
}
