import 'package:flutter/material.dart';

const bodyPadding = EdgeInsets.all(16.0);

class Book {
  String id;
  String title;
  Book(this.id, this.title);

  String get subTitle {
    if (id == '00') {
      return 'Prequel';
    } else {
      return 'Book ${id.replaceAll(RegExp('^0'), '')}';
    }
  }

}

class Character {
  final String id;
  final String name;
  final String chapter;
  final String info;
  final Book book;

  Character({required this.id, required this.name, required this.chapter, required this.info, required this.book});
}

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