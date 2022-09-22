import 'package:url_launcher/url_launcher.dart';

import 'package:flutter/material.dart';
import '../shared.dart';

class BookListPage extends StatelessWidget {
  const BookListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
        child: ListView(children: bookList(context))
      ),
    );
  }

  List<Widget> bookList(BuildContext context) {
    return books
        .map((book) => ListTile(
              title: Text(book.title,
                  style: const TextStyle(
                    // fontWeight: FontWeight.bold,
                    // fontSize: 18.0,
                  )),
              subtitle: Text(book.subTitle),
              onTap: () => Navigator.pushNamed(context, '/book', arguments: book),
            ))
        .toList();
  }
}
