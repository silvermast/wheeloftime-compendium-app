import 'package:flutter/material.dart';
import 'types.dart';

void main() {
  runApp(MaterialApp(
    title: 'Wheel of Time Character Compendium',
    theme: ThemeData(
      primarySwatch: Colors.red,
      fontFamily: 'Nunito',
    ),
    routes: {
      '/information': (_) => const InformationScreen(),
    },
    home: BookSelector(),
  ));
}

class InformationScreen extends StatelessWidget {
  const InformationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Information'),
      ),
    );
  }
}

class BookSelector extends StatefulWidget {
  const BookSelector({Key? key}) : super(key: key);

  @override
  State<BookSelector> createState() => _BookSelectorState();
}

class _BookSelectorState extends State<BookSelector> {

  final List<Book> books = [
    Book("book-00", "Book 00 - New Spring"),
    Book("book-01", "Book 01 - The Eye of the World"),
    Book("book-02", "Book 02 - The Great Hunt"),
    Book("book-03", "Book 03 - The Dragon Reborn"),
    Book("book-04", "Book 04 - The Shadow Rising"),
    Book("book-05", "Book 05 - The Fires of Heaven"),
    Book("book-06", "Book 06 - Lord of Chaos"),
    Book("book-07", "Book 07 - A Crown of Swords"),
    Book("book-08", "Book 08 - The Path of Daggers"),
    Book("book-09", "Book 09 - Winter's Heart"),
    Book("book-10", "Book 10 - Crossroads of Twilight"),
    Book("book-11", "Book 11 - Knife of Dreams"),
    Book("book-12", "Book 12 - The Gathering Storm"),
    Book("book-13", "Book 13 - Towers of Midnight"),
    Book("book-14", "Book 14 - A Memory of Light"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            const Icon(Icons.book_sharp),
            Container(
              padding: const EdgeInsets.only(left: 8.0),
              child: const Text('Select the book you\'re reading.'),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.info),
        onPressed: () => Navigator.pushNamed(context, '/information')
      ),
      body: Container(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: bookList()
        )
      ),
    );
  }

  List<Widget> bookList() {
    return books.map((book) => Column(
      children: <Widget>[
        Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.fromLTRB(16.0, 8.0, 8.0, 8.0),
          child: Text(book.title, style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18.0,
          ))
        ),
        const Divider(),
      ]
    )).toList();
  }
}

class CharacterExplorer extends StatefulWidget {
  final Book book;

  const CharacterExplorer({super.key, book});

  @override
  State<CharacterExplorer> createState() => _CharacterExplorer();
}

class _CharacterExplorer extends State<CharacterExplorer> {
  Book? book;
  final List<Book> books = [
    Book("book-00", "Book 00 - New Spring"),
    Book("book-01", "Book 01 - The Eye of the World"),
    Book("book-02", "Book 02 - The Great Hunt"),
    Book("book-03", "Book 03 - The Dragon Reborn"),
    Book("book-04", "Book 04 - The Shadow Rising"),
    Book("book-05", "Book 05 - The Fires of Heaven"),
    Book("book-06", "Book 06 - Lord of Chaos"),
    Book("book-07", "Book 07 - A Crown of Swords"),
    Book("book-08", "Book 08 - The Path of Daggers"),
    Book("book-09", "Book 09 - Winter's Heart"),
    Book("book-10", "Book 10 - Crossroads of Twilight"),
    Book("book-11", "Book 11 - Knife of Dreams"),
    Book("book-12", "Book 12 - The Gathering Storm"),
    Book("book-13", "Book 13 - Towers of Midnight"),
    Book("book-14", "Book 14 - A Memory of Light"),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: books.map((b) => Text(b.title)).toList(),
      ),
    );
  }
}
