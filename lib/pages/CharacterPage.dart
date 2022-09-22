import 'dart:convert';

import 'package:flutter/material.dart';
import '../shared.dart';
import '../repo.dart';

class CharacterPage extends StatefulWidget {
  const CharacterPage({Key? key}) : super(key: key);

  @override
  State<CharacterPage> createState() => _CharacterPageState();
}

class _CharacterPageState extends State<CharacterPage> {
  @override
  Widget build(BuildContext context) {
    Character character;
    try {
      character = ModalRoute.of(context)!.settings.arguments as Character;
    } catch (e) {
      Navigator.pushNamed(context, '/books');
      return ErrorWidget(e);
    }
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(character.name),
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
        child: Text(character.info),
      )
    );
  }
}
