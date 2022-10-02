import 'package:flutter/material.dart';
import 'pages/CharacterPage.dart';
import 'pages/SettingsPage.dart';
import 'pages/BookListPage.dart';
import 'pages/BookPage.dart';

void main() {
  runApp(MaterialApp(
    title: 'Wheel of Time Character Compendium',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      brightness: Brightness.dark,
      primarySwatch: Colors.red,
      fontFamily: 'NotoSans',
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.all(16.0),
          shape: StadiumBorder(),
        ),
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
