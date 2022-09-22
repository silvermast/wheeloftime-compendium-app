import 'dart:html';
import 'dart:io';
import 'dart:ui';
import 'package:url_launcher/url_launcher.dart';

import 'package:flutter/material.dart';
import 'shared.dart';
import 'pages/CharacterPage.dart';
import 'pages/SettingsPage.dart';
import 'pages/BookListPage.dart';
import 'pages/BookPage.dart';

void main() {
  runApp(MaterialApp(
    title: 'Wheel of Time Character Compendium',
    theme: ThemeData(
      primarySwatch: Colors.grey,
      // fontFamily: 'Cormorant',
      textTheme: const TextTheme(
        // headline1: TextStyle(fontFamily: 'Cinzel'),
        // headline6: TextStyle(fontFamily: 'Cinzel'),
        // bodyText1: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
        // bodyText2: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
      ),
    ),
    initialRoute: '/books',
    routes: {
      '/settings': (_) => const SettingsPage(),
      '/books': (_) => const BookListPage(),
      '/book': (_) => const BookPage(),
      '/character': (_) => const CharacterPage(),
    },
  ));
}
