import 'package:flutter/material.dart';
import 'pages/CharacterPage.dart';
import 'pages/SettingsPage.dart';
import 'pages/BookListPage.dart';
import 'pages/BookPage.dart';
import 'settingsService.dart';
import 'shared.dart';

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
    initialRoute: '/',
    routes: {
      '/': (_) => const AppInitializer(),
      '/settings': (_) => const SettingsPage(),
      '/books': (_) => const BookListPage(),
      '/book': (_) => const BookPage(),
      '/character': (_) => const CharacterPage(),
    },
  ));
}

class AppInitializer extends StatefulWidget {
  const AppInitializer({super.key});

  @override
  State<AppInitializer> createState() => AppInitializerState();
}

class AppInitializerState extends State<AppInitializer> {
  final SettingsService _settings = SettingsService.instance;

  @override
  void initState() {
    super.initState();
    _determineInitialScreen();
  }

  Future<void> _determineInitialScreen() async {
    bool rememberBook = await _settings.getRememberLastSelectedBook();
    String? bookId = await _settings.getLastSelectedBookId();

    if (!mounted) {
      return;
    }

    if (rememberBook && bookId != null) {
      final Book? matchingBook = sharedState.books
          .where((b) => b.id == bookId)
          .firstOrNull;
      if (matchingBook != null) {
        sharedState.setBook(matchingBook);
        Navigator.pushReplacementNamed(context, '/book');
      }
    } else {
      Navigator.pushReplacementNamed(context, '/books');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}