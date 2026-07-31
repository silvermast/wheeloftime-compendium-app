import 'package:flutter/material.dart';

import '../settingsService.dart';
import '../shared.dart';

class BookListPage extends StatefulWidget {

  const BookListPage({super.key});

  @override
  State<BookListPage> createState() => BookListPageState();
}

class BookListPageState extends State<BookListPage> {
  final SettingsService settings = SettingsService.instance;

  @override
  void initState() {
    super.initState();
    settings.setLastSelectedBookId(null);
  }

  @override
  Widget build(BuildContext context) {
    sharedState.reset();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select the book you\'re reading'),
        centerTitle: true,
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
        child: ListView(children: bookList(context)),
      ),
    );
  }

  List<Widget> bookList(BuildContext context) {
    return sharedState.books
        .map((book) => ListTile(
              title: Text(book.title),
              subtitle: Text(book.subTitle),
              onTap: () {
                sharedState.setBook(book);
                Navigator.pushNamed(context, '/book');
                settings.setLastSelectedBookId(book.id);
              },
            ))
        .toList();
  }
}
