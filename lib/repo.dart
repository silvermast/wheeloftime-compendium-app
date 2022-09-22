import 'dart:convert';
import 'dart:js';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'shared.dart';

class Repo {
  static Future<List<Character>> fetchCharacters(BuildContext context, Book book) async {
    String bookId = book.id.padLeft(2, '0');
    String remoteUrl = 'https://wheeloftime.silvermast.io/data/book-${bookId}.json';
    String localUrl = 'assets/data/book-${bookId}.json';

    String data = await DefaultAssetBundle.of(context).loadString(localUrl);
    List<Character> characters = [];

    jsonDecode(data).forEach((item) {
      characters.add(Character(
        id: item['id'],
        name: item['name'],
        chapter: item['chapter'],
        info: item['info'],
        book: book,
      ));
    });

    return characters;
  }
}
