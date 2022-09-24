import 'package:flutter/material.dart';
import 'sharedState.dart';

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

  Character(
      {required this.id,
      required this.name,
      required this.chapter,
      required this.info});
}

SharedState sharedState = SharedState();
